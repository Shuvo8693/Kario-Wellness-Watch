package com.example.kario_wellness_watch.starmax

import android.annotation.SuppressLint
import android.bluetooth.*
import android.bluetooth.le.*
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.util.Log
import java.util.*
import java.util.concurrent.ConcurrentHashMap

@SuppressLint("MissingPermission")
class StarmaxBleManager(private val context: Context) {

    private val TAG = "StarmaxBLE"

    // Bluetooth components
    private val bluetoothAdapter: BluetoothAdapter? by lazy {
        val bluetoothManager = context.getSystemService(Context.BLUETOOTH_SERVICE) as BluetoothManager
        bluetoothManager.adapter
    }

    private var bluetoothLeScanner: BluetoothLeScanner? = null
    private var bluetoothGatt: BluetoothGatt? = null
    private var notifyCharacteristic: BluetoothGattCharacteristic? = null
    private var writeCharacteristic: BluetoothGattCharacteristic? = null

    // Connection state
    private var isScanning = false
    private var isConnected = false
    private var mtuSize = 23
    private var connectionRetryCount = 0
    private var currentDeviceAddress: String? = null

    // Store discovered devices (address -> device)
    private val discoveredDevices = ConcurrentHashMap<String, BluetoothDevice>()

    // Callbacks
    private var onDeviceFound: ((String, String, Int) -> Unit)? = null
    private var onConnectionChanged: ((Boolean) -> Unit)? = null
    private var onDataReceived: ((ByteArray) -> Unit)? = null
    private var onError: ((String) -> Unit)? = null

    private val mainHandler = Handler(Looper.getMainLooper())

    companion object {
        // Multiple service UUID options - will try each until one works
        // Option 1: Standard Starmax UUIDs (older devices)
        val SERVICE_UUID_FFF0: UUID = UUID.fromString("0000FFF0-0000-1000-8000-00805F9B34FB")
        val NOTIFY_CHAR_FFF1: UUID = UUID.fromString("0000FFF1-0000-1000-8000-00805F9B34FB")
        val WRITE_CHAR_FFF2: UUID = UUID.fromString("0000FFF2-0000-1000-8000-00805F9B34FB")

        // Option 2: Custom Starmax service (your device uses this!)
        // IMPORTANT: On this device, AE01 is WRITE and AE02 is NOTIFY (opposite of usual!)
        val SERVICE_UUID_AE00: UUID = UUID.fromString("0000AE00-0000-1000-8000-00805F9B34FB")
        val WRITE_CHAR_AE01: UUID = UUID.fromString("0000AE01-0000-1000-8000-00805F9B34FB")  // Write characteristic
        val NOTIFY_CHAR_AE02: UUID = UUID.fromString("0000AE02-0000-1000-8000-00805F9B34FB") // Notify characteristic

        // Option 3: Nordic UART Service (NUS) - variant 1
        val SERVICE_UUID_NUS1: UUID = UUID.fromString("6e400001-b5a3-f393-e0a9-e50e24dcca9d")
        val NOTIFY_CHAR_NUS1: UUID = UUID.fromString("6e400003-b5a3-f393-e0a9-e50e24dcca9d") // TX (notify)
        val WRITE_CHAR_NUS1: UUID = UUID.fromString("6e400002-b5a3-f393-e0a9-e50e24dcca9d")  // RX (write)

        // Option 4: Nordic UART Service (NUS) - variant 2
        val SERVICE_UUID_NUS2: UUID = UUID.fromString("6e400001-b5a3-f393-e0a9-e50e24dcca9e")
        val NOTIFY_CHAR_NUS2: UUID = UUID.fromString("6e400003-b5a3-f393-e0a9-e50e24dcca9e")
        val WRITE_CHAR_NUS2: UUID = UUID.fromString("6e400002-b5a3-f393-e0a9-e50e24dcca9e")

        // Notification descriptor (same for all)
        val DESCRIPTOR_UUID: UUID = UUID.fromString("00002902-0000-1000-8000-00805f9b34fb")

        const val SCAN_PERIOD: Long = 15000 // 15 seconds
        const val REQUEST_MTU_SIZE = 247 // More compatible MTU size
        const val MAX_CONNECTION_RETRY = 3
        const val CONNECTION_TIMEOUT = 15000L // 15 seconds

        // GATT Status codes
        const val GATT_ERROR = 133
        const val GATT_AUTH_FAIL = 137
    }

    // Bond state receiver for pairing
    private val bondStateReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context?, intent: Intent?) {
            if (intent?.action == BluetoothDevice.ACTION_BOND_STATE_CHANGED) {
                val device = intent.getParcelableExtra<BluetoothDevice>(BluetoothDevice.EXTRA_DEVICE)
                val bondState = intent.getIntExtra(BluetoothDevice.EXTRA_BOND_STATE, BluetoothDevice.BOND_NONE)
                val prevBondState = intent.getIntExtra(BluetoothDevice.EXTRA_PREVIOUS_BOND_STATE, BluetoothDevice.BOND_NONE)

                Log.d(TAG, "Bond state changed: $prevBondState -> $bondState for ${device?.address}")

                when (bondState) {
                    BluetoothDevice.BOND_BONDED -> {
                        Log.d(TAG, "Device bonded successfully")
                        // Try to connect after bonding
                        device?.address?.let { address ->
                            if (address == currentDeviceAddress) {
                                mainHandler.postDelayed({
                                    connectToDeviceInternal(address)
                                }, 500)
                            }
                        }
                    }
                    BluetoothDevice.BOND_NONE -> {
                        if (prevBondState == BluetoothDevice.BOND_BONDING) {
                            Log.e(TAG, "Bonding failed")
                            onError?.invoke("Pairing failed. Please try again.")
                        }
                    }
                }
            }
        }
    }

    init {
        // Register bond state receiver
        val filter = IntentFilter(BluetoothDevice.ACTION_BOND_STATE_CHANGED)
        context.registerReceiver(bondStateReceiver, filter)
    }

    fun setCallbacks(
        onDeviceFound: ((String, String, Int) -> Unit)?,
        onConnectionChanged: ((Boolean) -> Unit)?,
        onDataReceived: ((ByteArray) -> Unit)?,
        onError: ((String) -> Unit)?
    ) {
        this.onDeviceFound = onDeviceFound
        this.onConnectionChanged = onConnectionChanged
        this.onDataReceived = onDataReceived
        this.onError = onError
    }

    fun startScan(): Boolean {
        if (!isBluetoothEnabled()) {
            onError?.invoke("Bluetooth is not enabled")
            return false
        }

        if (isScanning) {
            Log.w(TAG, "Already scanning")
            return true
        }

        // Clear previous discovered devices
        discoveredDevices.clear()

        bluetoothLeScanner = bluetoothAdapter?.bluetoothLeScanner
        if (bluetoothLeScanner == null) {
            onError?.invoke("Bluetooth LE Scanner not available")
            return false
        }

        val scanSettings = ScanSettings.Builder()
            .setScanMode(ScanSettings.SCAN_MODE_LOW_LATENCY)
            .setReportDelay(0) // Report immediately
            .build()

        try {
            bluetoothLeScanner?.startScan(null, scanSettings, scanCallback)
            isScanning = true

            // Auto stop after SCAN_PERIOD
            mainHandler.postDelayed({
                if (isScanning) {
                    stopScan()
                }
            }, SCAN_PERIOD)

            Log.d(TAG, "BLE scan started")
            return true

        } catch (e: SecurityException) {
            Log.e(TAG, "Permission denied for BLE scan", e)
            onError?.invoke("Bluetooth permission denied")
            return false
        } catch (e: Exception) {
            Log.e(TAG, "Error starting scan", e)
            onError?.invoke("Failed to start scan: ${e.message}")
            return false
        }
    }

    fun stopScan() {
        if (!isScanning) return

        try {
            bluetoothLeScanner?.stopScan(scanCallback)
            isScanning = false
            Log.d(TAG, "BLE scan stopped. Found ${discoveredDevices.size} devices")
        } catch (e: SecurityException) {
            Log.e(TAG, "Error stopping scan", e)
        } catch (e: Exception) {
            Log.e(TAG, "Error stopping scan", e)
        }
    }

    fun connectToDevice(deviceAddress: String): Boolean {
        // First check if device was discovered
        var device = discoveredDevices[deviceAddress]

        if (device == null) {
            // Try to get device from adapter (might be bonded already)
            device = bluetoothAdapter?.getRemoteDevice(deviceAddress)
            if (device == null) {
                Log.e(TAG, "Device not found: $deviceAddress")
                onError?.invoke("Device not found. Please scan again.")
                return false
            }
            Log.w(TAG, "Device $deviceAddress not in scan results, trying direct connection")
        }

        // Stop scanning before connecting
        stopScan()

        currentDeviceAddress = deviceAddress
        connectionRetryCount = 0

        // Close any existing connection
        closeGatt()

        return connectToDeviceInternal(deviceAddress)
    }

    private fun connectToDeviceInternal(deviceAddress: String): Boolean {
        val device = discoveredDevices[deviceAddress]
            ?: bluetoothAdapter?.getRemoteDevice(deviceAddress)
            ?: run {
                onError?.invoke("Device not found")
                return false
            }

        try {
            Log.d(TAG, "Connecting to device: $deviceAddress (attempt ${connectionRetryCount + 1})")

            // Check bond state
            val bondState = device.bondState
            Log.d(TAG, "Device bond state: $bondState")

            // Use TRANSPORT_LE for BLE devices
            bluetoothGatt = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                device.connectGatt(context, false, gattCallback, BluetoothDevice.TRANSPORT_LE)
            } else {
                device.connectGatt(context, false, gattCallback)
            }

            // Set connection timeout
            mainHandler.postDelayed({
                if (!isConnected && bluetoothGatt != null) {
                    Log.e(TAG, "Connection timeout")
                    handleConnectionFailure("Connection timeout")
                }
            }, CONNECTION_TIMEOUT)

            return true

        } catch (e: SecurityException) {
            Log.e(TAG, "Permission denied for connection", e)
            onError?.invoke("Bluetooth permission denied")
            return false
        } catch (e: Exception) {
            Log.e(TAG, "Error connecting to device", e)
            onError?.invoke("Connection failed: ${e.message}")
            return false
        }
    }

    private fun handleConnectionFailure(reason: String) {
        Log.e(TAG, "Connection failed: $reason (retry ${connectionRetryCount}/$MAX_CONNECTION_RETRY)")

        closeGatt()

        if (connectionRetryCount < MAX_CONNECTION_RETRY) {
            connectionRetryCount++

            // Wait before retry
            val delay = (connectionRetryCount * 1000).toLong()
            Log.d(TAG, "Retrying connection in ${delay}ms...")

            mainHandler.postDelayed({
                currentDeviceAddress?.let { address ->
                    connectToDeviceInternal(address)
                }
            }, delay)
        } else {
            Log.e(TAG, "Max connection retries reached")
            currentDeviceAddress = null
            connectionRetryCount = 0
            onError?.invoke("Failed to connect after $MAX_CONNECTION_RETRY attempts. Make sure the watch is awake and nearby.")
            onConnectionChanged?.invoke(false)
        }
    }

    private fun closeGatt() {
        try {
            bluetoothGatt?.disconnect()
        } catch (e: Exception) {
            Log.e(TAG, "Error disconnecting", e)
        }

        try {
            bluetoothGatt?.close()
        } catch (e: Exception) {
            Log.e(TAG, "Error closing gatt", e)
        }

        bluetoothGatt = null
        notifyCharacteristic = null
        writeCharacteristic = null
    }

    fun disconnect() {
        mainHandler.removeCallbacksAndMessages(null)
        currentDeviceAddress = null
        connectionRetryCount = 0

        closeGatt()

        isConnected = false
        onConnectionChanged?.invoke(false)
        Log.d(TAG, "Disconnected from device")
    }

    fun writeData(data: ByteArray): Boolean {
        if (!isConnected) {
            Log.e(TAG, "Not connected - cannot write data")
            onError?.invoke("Not connected to device")
            return false
        }

        val characteristic = writeCharacteristic
        val gatt = bluetoothGatt

        if (characteristic == null) {
            Log.e(TAG, "Write characteristic not available")
            onError?.invoke("Write characteristic not found")
            return false
        }

        if (gatt == null) {
            Log.e(TAG, "GATT not available")
            onError?.invoke("GATT not available")
            return false
        }

        try {
            val maxDataSize = mtuSize - 3
            Log.d(TAG, "Writing data: ${data.toHexString()}, size: ${data.size}, maxChunk: $maxDataSize")

            // Check characteristic properties
            val props = characteristic.properties
            Log.d(TAG, "Write characteristic properties: $props")

            // Set write type based on properties
            val writeType = when {
                props and BluetoothGattCharacteristic.PROPERTY_WRITE_NO_RESPONSE != 0 -> {
                    Log.d(TAG, "Using WRITE_TYPE_NO_RESPONSE")
                    BluetoothGattCharacteristic.WRITE_TYPE_NO_RESPONSE
                }
                props and BluetoothGattCharacteristic.PROPERTY_WRITE != 0 -> {
                    Log.d(TAG, "Using WRITE_TYPE_DEFAULT")
                    BluetoothGattCharacteristic.WRITE_TYPE_DEFAULT
                }
                else -> {
                    Log.w(TAG, "Characteristic doesn't support standard write, trying WRITE_TYPE_DEFAULT")
                    BluetoothGattCharacteristic.WRITE_TYPE_DEFAULT
                }
            }

            if (data.size <= maxDataSize) {
                characteristic.value = data
                characteristic.writeType = writeType
                val success = gatt.writeCharacteristic(characteristic)
                Log.d(TAG, "Write ${data.size} bytes - success: $success")
                return success
            } else {
                // Send in chunks
                var offset = 0
                var allSuccess = true
                while (offset < data.size) {
                    val chunkSize = minOf(maxDataSize, data.size - offset)
                    val chunk = data.copyOfRange(offset, offset + chunkSize)

                    characteristic.value = chunk
                    characteristic.writeType = writeType
                    val success = gatt.writeCharacteristic(characteristic)
                    Log.d(TAG, "Write chunk at offset $offset, size $chunkSize - success: $success")

                    if (!success) allSuccess = false

                    offset += chunkSize
                    Thread.sleep(50) // Small delay between chunks
                }
                Log.d(TAG, "Sent ${data.size} bytes in multiple packets, allSuccess: $allSuccess")
                return allSuccess
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error writing data", e)
            onError?.invoke("Failed to write data: ${e.message}")
            return false
        }
    }

    fun isDeviceConnected(): Boolean = isConnected

    fun getConnectedDeviceAddress(): String? = if (isConnected) currentDeviceAddress else null

    fun cleanup() {
        try {
            context.unregisterReceiver(bondStateReceiver)
        } catch (e: Exception) {
            Log.e(TAG, "Error unregistering receiver", e)
        }

        mainHandler.removeCallbacksAndMessages(null)
        stopScan()
        disconnect()
        discoveredDevices.clear()
    }

    // ==================== BLE CALLBACKS ====================

    private val scanCallback = object : ScanCallback() {
        override fun onScanResult(callbackType: Int, result: ScanResult) {
            try {
                val device = result.device
                val deviceName = device.name ?: "Unknown"
                val deviceAddress = device.address
                val rssi = result.rssi

                // Store discovered device for later connection
                if (!discoveredDevices.containsKey(deviceAddress)) {
                    discoveredDevices[deviceAddress] = device
                    Log.d(TAG, "Device found: $deviceName ($deviceAddress) RSSI: $rssi")
                }

                // Always report to callback (for UI update with RSSI changes)
                mainHandler.post {
                    onDeviceFound?.invoke(deviceName, deviceAddress, rssi)
                }

            } catch (e: SecurityException) {
                Log.e(TAG, "Permission error in scan result", e)
            } catch (e: Exception) {
                Log.e(TAG, "Error processing scan result", e)
            }
        }

        override fun onBatchScanResults(results: MutableList<ScanResult>) {
            results.forEach { result ->
                onScanResult(ScanSettings.CALLBACK_TYPE_ALL_MATCHES, result)
            }
        }

        override fun onScanFailed(errorCode: Int) {
            val errorMsg = when (errorCode) {
                SCAN_FAILED_ALREADY_STARTED -> "Scan already started"
                SCAN_FAILED_APPLICATION_REGISTRATION_FAILED -> "App registration failed"
                SCAN_FAILED_FEATURE_UNSUPPORTED -> "BLE not supported"
                SCAN_FAILED_INTERNAL_ERROR -> "Internal error"
                else -> "Unknown error: $errorCode"
            }
            onError?.invoke("Scan failed: $errorMsg")
            isScanning = false
            Log.e(TAG, "Scan failed: $errorMsg")
        }
    }

    private val gattCallback = object : BluetoothGattCallback() {

        override fun onConnectionStateChange(gatt: BluetoothGatt, status: Int, newState: Int) {
            Log.d(TAG, "onConnectionStateChange - status: $status, newState: $newState")

            // Remove connection timeout
            mainHandler.removeCallbacksAndMessages(null)

            when {
                status == BluetoothGatt.GATT_SUCCESS && newState == BluetoothProfile.STATE_CONNECTED -> {
                    Log.d(TAG, "Connected to GATT server successfully")
                    connectionRetryCount = 0 // Reset retry count on success

                    // Small delay before MTU request for stability
                    mainHandler.postDelayed({
                        try {
                            gatt.requestMtu(REQUEST_MTU_SIZE)
                        } catch (e: Exception) {
                            Log.e(TAG, "Error requesting MTU", e)
                            // Continue with service discovery anyway
                            gatt.discoverServices()
                        }
                    }, 500)
                }

                status == GATT_ERROR || status == GATT_AUTH_FAIL -> {
                    // Status 133 or 137 - common connection errors
                    Log.e(TAG, "GATT Error: $status")
                    handleConnectionFailure("GATT error $status")
                }

                newState == BluetoothProfile.STATE_DISCONNECTED -> {
                    Log.d(TAG, "Disconnected from GATT server")

                    if (isConnected) {
                        // Unexpected disconnect
                        isConnected = false
                        mainHandler.post {
                            onConnectionChanged?.invoke(false)
                        }
                    } else if (status != BluetoothGatt.GATT_SUCCESS) {
                        // Connection failed
                        handleConnectionFailure("Disconnected with status $status")
                    }
                }
            }
        }

        override fun onMtuChanged(gatt: BluetoothGatt, mtu: Int, status: Int) {
            if (status == BluetoothGatt.GATT_SUCCESS) {
                mtuSize = mtu
                Log.d(TAG, "MTU changed to: $mtu")
            } else {
                Log.w(TAG, "MTU change failed, using default")
            }

            // Discover services after MTU negotiation
            try {
                mainHandler.postDelayed({
                    gatt.discoverServices()
                }, 200)
            } catch (e: Exception) {
                Log.e(TAG, "Error discovering services", e)
                handleConnectionFailure("Service discovery failed")
            }
        }

        override fun onServicesDiscovered(gatt: BluetoothGatt, status: Int) {
            if (status == BluetoothGatt.GATT_SUCCESS) {
                Log.d(TAG, "Services discovered")

                // Log all services and their characteristic properties for debugging
                gatt.services.forEach { service ->
                    Log.d(TAG, "Service: ${service.uuid}")
                    service.characteristics.forEach { char ->
                        val props = char.properties
                        val propsStr = mutableListOf<String>()
                        if (props and BluetoothGattCharacteristic.PROPERTY_READ != 0) propsStr.add("READ")
                        if (props and BluetoothGattCharacteristic.PROPERTY_WRITE != 0) propsStr.add("WRITE")
                        if (props and BluetoothGattCharacteristic.PROPERTY_WRITE_NO_RESPONSE != 0) propsStr.add("WRITE_NO_RESP")
                        if (props and BluetoothGattCharacteristic.PROPERTY_NOTIFY != 0) propsStr.add("NOTIFY")
                        if (props and BluetoothGattCharacteristic.PROPERTY_INDICATE != 0) propsStr.add("INDICATE")
                        Log.d(TAG, "  Characteristic: ${char.uuid} [${propsStr.joinToString(", ")}]")
                    }
                }

                // Try to find compatible service in order of preference
                var service: BluetoothGattService? = null
                var notifyChar: BluetoothGattCharacteristic? = null
                var writeChar: BluetoothGattCharacteristic? = null
                var serviceName = ""

                // Try AE00 service FIRST (Starmax SDK commands are designed for this!)
                // Note: AE01 is WRITE, AE02 is NOTIFY on this device
                service = gatt.getService(SERVICE_UUID_AE00)
                if (service != null) {
                    Log.d(TAG, "Found AE00 service")
                    writeChar = service.getCharacteristic(WRITE_CHAR_AE01)  // AE01 for write
                    notifyChar = service.getCharacteristic(NOTIFY_CHAR_AE02) // AE02 for notify
                    serviceName = "AE00"
                }

                // Try FFF0 service (standard Starmax for older devices)
                if (notifyChar == null || writeChar == null) {
                    service = gatt.getService(SERVICE_UUID_FFF0)
                    if (service != null) {
                        Log.d(TAG, "Found FFF0 service")
                        notifyChar = service.getCharacteristic(NOTIFY_CHAR_FFF1)
                        writeChar = service.getCharacteristic(WRITE_CHAR_FFF2)
                        serviceName = "FFF0"
                    }
                }

                // Try Nordic UART Service variant 2 (6e400001...9e)
                if (notifyChar == null || writeChar == null) {
                    service = gatt.getService(SERVICE_UUID_NUS2)
                    if (service != null) {
                        Log.d(TAG, "Found NUS2 service")
                        notifyChar = service.getCharacteristic(NOTIFY_CHAR_NUS2)
                        writeChar = service.getCharacteristic(WRITE_CHAR_NUS2)
                        serviceName = "NUS2"
                    }
                }

                // Try Nordic UART Service variant 1 (6e400001...9d)
                if (notifyChar == null || writeChar == null) {
                    service = gatt.getService(SERVICE_UUID_NUS1)
                    if (service != null) {
                        Log.d(TAG, "Found NUS1 service")
                        notifyChar = service.getCharacteristic(NOTIFY_CHAR_NUS1)
                        writeChar = service.getCharacteristic(WRITE_CHAR_NUS1)
                        serviceName = "NUS1"
                    }
                }

                if (service != null && notifyChar != null && writeChar != null) {
                    notifyCharacteristic = notifyChar
                    writeCharacteristic = writeChar

                    // Log characteristic properties
                    val notifyProps = notifyChar.properties
                    val writeProps = writeChar.properties
                    Log.d(TAG, "Using $serviceName service")
                    Log.d(TAG, "Notify characteristic properties: $notifyProps")
                    Log.d(TAG, "Write characteristic properties: $writeProps")

                    // Determine correct write type based on properties
                    if (writeProps and BluetoothGattCharacteristic.PROPERTY_WRITE_NO_RESPONSE != 0) {
                        writeChar.writeType = BluetoothGattCharacteristic.WRITE_TYPE_NO_RESPONSE
                        Log.d(TAG, "Using WRITE_TYPE_NO_RESPONSE")
                    } else {
                        writeChar.writeType = BluetoothGattCharacteristic.WRITE_TYPE_DEFAULT
                        Log.d(TAG, "Using WRITE_TYPE_DEFAULT")
                    }

                    Log.d(TAG, "Found required characteristics - Notify: ${notifyChar.uuid}, Write: ${writeChar.uuid}")
                    enableNotification(gatt, notifyChar)
                } else {
                    Log.e(TAG, "Characteristics not found. Notify: $notifyChar, Write: $writeChar")
                    mainHandler.post {
                        onError?.invoke("Watch characteristics not found. Is this the correct device?")
                    }
                    handleConnectionFailure("Characteristics not found")
                }
            } else {
                Log.e(TAG, "Service discovery failed with status: $status")
                handleConnectionFailure("Service discovery failed")
            }
        }

        override fun onDescriptorWrite(gatt: BluetoothGatt, descriptor: BluetoothGattDescriptor, status: Int) {
            Log.d(TAG, "onDescriptorWrite - status: $status, descriptor: ${descriptor.uuid}")
            if (status == BluetoothGatt.GATT_SUCCESS) {
                Log.d(TAG, "Descriptor write successful - notifications enabled")

                // Try to read the device name to verify communication works
                val deviceNameChar = gatt.getService(
                    UUID.fromString("00001800-0000-1000-8000-00805f9b34fb")
                )?.getCharacteristic(
                    UUID.fromString("00002a00-0000-1000-8000-00805f9b34fb")
                )
                if (deviceNameChar != null) {
                    Log.d(TAG, "Reading device name characteristic to test communication...")
                    gatt.readCharacteristic(deviceNameChar)
                }

                // Add a small delay to ensure the watch is ready
                mainHandler.postDelayed({
                    isConnected = true
                    Log.d(TAG, "Connection fully ready - notifying Flutter")
                    onConnectionChanged?.invoke(true)
                }, 500) // 500ms delay
            } else {
                Log.e(TAG, "Failed to write descriptor: $status")
                // Try to proceed anyway
                isConnected = true
                mainHandler.post {
                    onConnectionChanged?.invoke(true)
                }
            }
        }

        override fun onCharacteristicRead(
            gatt: BluetoothGatt,
            characteristic: BluetoothGattCharacteristic,
            status: Int
        ) {
            if (status == BluetoothGatt.GATT_SUCCESS) {
                val data = characteristic.value
                Log.d(TAG, "Read characteristic ${characteristic.uuid}: ${data?.let { String(it) } ?: "null"}")
                Log.d(TAG, "Read raw bytes: ${data?.toHexString()}")
            } else {
                Log.e(TAG, "Read characteristic failed: $status")
            }
        }

        override fun onCharacteristicChanged(
            gatt: BluetoothGatt,
            characteristic: BluetoothGattCharacteristic
        ) {
            Log.d(TAG, ">>> onCharacteristicChanged called! <<<")
            Log.d(TAG, "Characteristic UUID: ${characteristic.uuid}")
            val data = characteristic.value
            if (data != null && data.isNotEmpty()) {
                Log.d(TAG, "Received ${data.size} bytes: ${data.toHexString()}")
                mainHandler.post {
                    onDataReceived?.invoke(data)
                }
            } else {
                Log.w(TAG, "Received empty or null data")
            }
        }

        // For Android 13+ (API 33+), there's a new callback signature
        override fun onCharacteristicChanged(
            gatt: BluetoothGatt,
            characteristic: BluetoothGattCharacteristic,
            value: ByteArray
        ) {
            Log.d(TAG, ">>> onCharacteristicChanged (new API) called! <<<")
            Log.d(TAG, "Characteristic UUID: ${characteristic.uuid}")
            Log.d(TAG, "Received ${value.size} bytes: ${value.toHexString()}")
            mainHandler.post {
                onDataReceived?.invoke(value)
            }
        }

        override fun onCharacteristicWrite(
            gatt: BluetoothGatt,
            characteristic: BluetoothGattCharacteristic,
            status: Int
        ) {
            if (status == BluetoothGatt.GATT_SUCCESS) {
                Log.d(TAG, "Write successful")
            } else {
                Log.e(TAG, "Write failed with status: $status")
                mainHandler.post {
                    onError?.invoke("Write failed: $status")
                }
            }
        }
    }

    private fun enableNotification(gatt: BluetoothGatt, characteristic: BluetoothGattCharacteristic) {
        try {
            val props = characteristic.properties
            Log.d(TAG, "Enabling notification for ${characteristic.uuid}, properties: $props")

            // Check if characteristic supports notifications or indications
            val supportsNotify = props and BluetoothGattCharacteristic.PROPERTY_NOTIFY != 0
            val supportsIndicate = props and BluetoothGattCharacteristic.PROPERTY_INDICATE != 0

            Log.d(TAG, "Supports NOTIFY: $supportsNotify, Supports INDICATE: $supportsIndicate")

            if (!supportsNotify && !supportsIndicate) {
                Log.w(TAG, "Characteristic doesn't support notifications or indications")
                // Still try to proceed - some devices work anyway
            }

            val success = gatt.setCharacteristicNotification(characteristic, true)
            Log.d(TAG, "setCharacteristicNotification: $success")

            val descriptor = characteristic.getDescriptor(DESCRIPTOR_UUID)
            if (descriptor != null) {
                // Use INDICATE if supported and NOTIFY is not, otherwise use NOTIFY
                val value = if (supportsIndicate && !supportsNotify) {
                    Log.d(TAG, "Using ENABLE_INDICATION_VALUE")
                    BluetoothGattDescriptor.ENABLE_INDICATION_VALUE
                } else {
                    Log.d(TAG, "Using ENABLE_NOTIFICATION_VALUE")
                    BluetoothGattDescriptor.ENABLE_NOTIFICATION_VALUE
                }

                descriptor.value = value
                val writeResult = gatt.writeDescriptor(descriptor)
                Log.d(TAG, "Writing notification descriptor, result: $writeResult")
            } else {
                Log.w(TAG, "Notification descriptor not found - proceeding without it")
                // Some devices work without descriptor write
                // Mark as connected and ready
                isConnected = true
                mainHandler.post {
                    onConnectionChanged?.invoke(true)
                }
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error enabling notification", e)
            // Still try to mark as connected
            isConnected = true
            mainHandler.post {
                onConnectionChanged?.invoke(true)
            }
        }
    }

    private fun isBluetoothEnabled(): Boolean {
        return bluetoothAdapter?.isEnabled == true
    }

    // Helper extension function
    private fun ByteArray.toHexString(): String {
        return joinToString(" ") { "%02X".format(it) }
    }
}