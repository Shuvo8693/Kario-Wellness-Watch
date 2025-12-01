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
import android.os.ParcelUuid
import android.util.Log
import java.util.UUID

/**
 * StarmaxBleManager - Handles BLE communication with Starmax smartwatch
 *
 * CRITICAL: Uses Nordic UART Service (NUS) UUIDs - this is what the SDK Demo uses!
 * NOT the AE00 service that was used before.
 */
@SuppressLint("MissingPermission")
class StarmaxBleManager(private val context: Context) {

    companion object {
        private const val TAG = "StarmaxBLE"

        // ============================================================
        // NORDIC UART SERVICE (NUS) - CORRECT UUIDs from SDK Demo!
        // ============================================================
        private val NUS_SERVICE_UUID = UUID.fromString("6e400001-b5a3-f393-e0a9-e50e24dcca9d")
        private val NUS_WRITE_UUID = UUID.fromString("6e400002-b5a3-f393-e0a9-e50e24dcca9d")  // TX (write to device)
        private val NUS_NOTIFY_UUID = UUID.fromString("6e400003-b5a3-f393-e0a9-e50e24dcca9d") // RX (notify from device)

        // Fallback: AE00 Service (older watches may use this)
        private val AE00_SERVICE_UUID = UUID.fromString("0000ae00-0000-1000-8000-00805f9b34fb")
        private val AE00_WRITE_UUID = UUID.fromString("0000ae01-0000-1000-8000-00805f9b34fb")
        private val AE00_NOTIFY_UUID = UUID.fromString("0000ae02-0000-1000-8000-00805f9b34fb")

        // Client Characteristic Configuration Descriptor (for enabling notifications)
        private val CCCD_UUID = UUID.fromString("00002902-0000-1000-8000-00805f9b34fb")

        // Timing constants
        private const val SCAN_TIMEOUT_MS = 30000L
        private const val NOTIFY_DELAY_MS = 3000L  // Wait 3 seconds before enabling notifications (from SDK Demo)
        private const val MTU_SIZE = 247
    }

    // Bluetooth components
    private val bluetoothManager: BluetoothManager = context.getSystemService(Context.BLUETOOTH_SERVICE) as BluetoothManager
    private val bluetoothAdapter: BluetoothAdapter? = bluetoothManager.adapter
    private var bluetoothGatt: BluetoothGatt? = null
    private var bluetoothScanner: BluetoothLeScanner? = null

    // Active characteristics (set after service discovery)
    private var writeCharacteristic: BluetoothGattCharacteristic? = null
    private var notifyCharacteristic: BluetoothGattCharacteristic? = null
    private var activeServiceUUID: UUID? = null

    // Handlers
    private val mainHandler = Handler(Looper.getMainLooper())
    private var scanCallback: ScanCallback? = null
    private var isScanning = false

    // Callbacks
    private var onConnectionChanged: ((Boolean) -> Unit)? = null
    private var onServicesDiscovered: (() -> Unit)? = null
    private var onDataReceived: ((ByteArray) -> Unit)? = null
    private var onError: ((String) -> Unit)? = null
    private var onBondStateChanged: ((Int) -> Unit)? = null

    // Bond state receiver
    private val bondStateReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context?, intent: Intent?) {
            if (intent?.action == BluetoothDevice.ACTION_BOND_STATE_CHANGED) {
                val device = intent.getParcelableExtra<BluetoothDevice>(BluetoothDevice.EXTRA_DEVICE)
                val bondState = intent.getIntExtra(BluetoothDevice.EXTRA_BOND_STATE, BluetoothDevice.BOND_NONE)
                val prevState = intent.getIntExtra(BluetoothDevice.EXTRA_PREVIOUS_BOND_STATE, BluetoothDevice.BOND_NONE)

                Log.d(TAG, "Bond state changed: $prevState -> $bondState for ${device?.address}")
                onBondStateChanged?.invoke(bondState)

                if (bondState == BluetoothDevice.BOND_BONDED) {
                    Log.d(TAG, "Device bonded successfully!")
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
        onConnectionChanged: (Boolean) -> Unit,
        onServicesDiscovered: () -> Unit,
        onDataReceived: (ByteArray) -> Unit,
        onError: (String) -> Unit,
        onBondStateChanged: (Int) -> Unit
    ) {
        this.onConnectionChanged = onConnectionChanged
        this.onServicesDiscovered = onServicesDiscovered
        this.onDataReceived = onDataReceived
        this.onError = onError
        this.onBondStateChanged = onBondStateChanged
    }

    // ==================== SCANNING ====================

    data class ScannedDevice(
        val name: String?,
        val address: String,
        val rssi: Int
    )

    fun startScan(onDeviceFound: (ScannedDevice) -> Unit) {
        if (bluetoothAdapter == null || !bluetoothAdapter.isEnabled) {
            onError?.invoke("Bluetooth not available or not enabled")
            return
        }

        if (isScanning) {
            Log.d(TAG, "Already scanning")
            return
        }

        bluetoothScanner = bluetoothAdapter.bluetoothLeScanner
        if (bluetoothScanner == null) {
            onError?.invoke("BLE Scanner not available")
            return
        }

        val settings = ScanSettings.Builder()
            .setScanMode(ScanSettings.SCAN_MODE_LOW_LATENCY)
            .build()

        // Filter for Starmax devices (by name prefix)
        val filters = listOf<ScanFilter>()  // No filter - scan all devices

        scanCallback = object : ScanCallback() {
            private val foundDevices = mutableSetOf<String>()

            override fun onScanResult(callbackType: Int, result: ScanResult) {
                val device = result.device
                val address = device.address

                if (!foundDevices.contains(address)) {
                    foundDevices.add(address)
                    val name = device.name
                    Log.d(TAG, "Found device: $name ($address) RSSI: ${result.rssi}")
                    onDeviceFound(ScannedDevice(name, address, result.rssi))
                }
            }

            override fun onScanFailed(errorCode: Int) {
                Log.e(TAG, "Scan failed with error: $errorCode")
                onError?.invoke("Scan failed: $errorCode")
                isScanning = false
            }
        }

        try {
            bluetoothScanner?.startScan(filters, settings, scanCallback)
            isScanning = true
            Log.d(TAG, "Scan started")

            // Auto-stop after timeout
            mainHandler.postDelayed({
                stopScan()
            }, SCAN_TIMEOUT_MS)
        } catch (e: Exception) {
            Log.e(TAG, "Failed to start scan: ${e.message}")
            onError?.invoke("Failed to start scan: ${e.message}")
        }
    }

    fun stopScan() {
        if (isScanning && scanCallback != null) {
            try {
                bluetoothScanner?.stopScan(scanCallback)
                Log.d(TAG, "Scan stopped")
            } catch (e: Exception) {
                Log.e(TAG, "Error stopping scan: ${e.message}")
            }
            isScanning = false
            scanCallback = null
        }
    }

    // ==================== CONNECTION ====================

    private val gattCallback = object : BluetoothGattCallback() {
        override fun onConnectionStateChange(gatt: BluetoothGatt, status: Int, newState: Int) {
            Log.d(TAG, "Connection state changed: status=$status, newState=$newState")

            when (newState) {
                BluetoothProfile.STATE_CONNECTED -> {
                    Log.d(TAG, "✓ Connected to GATT server")
                    onConnectionChanged?.invoke(true)

                    // Request MTU first
                    mainHandler.postDelayed({
                        Log.d(TAG, "Requesting MTU: $MTU_SIZE")
                        gatt.requestMtu(MTU_SIZE)
                    }, 500)
                }
                BluetoothProfile.STATE_DISCONNECTED -> {
                    Log.d(TAG, "✗ Disconnected from GATT server")
                    onConnectionChanged?.invoke(false)
                    cleanup()
                }
            }
        }

        override fun onMtuChanged(gatt: BluetoothGatt, mtu: Int, status: Int) {
            Log.d(TAG, "MTU changed to $mtu (status: $status)")

            // Discover services after MTU negotiation
            mainHandler.postDelayed({
                Log.d(TAG, "Discovering services...")
                gatt.discoverServices()
            }, 300)
        }

        override fun onServicesDiscovered(gatt: BluetoothGatt, status: Int) {
            if (status == BluetoothGatt.GATT_SUCCESS) {
                Log.d(TAG, "Services discovered!")
                logAllServices(gatt)

                // Try to find our service (NUS for communication, but also enable AE00 notifications)
                val nusService = gatt.getService(NUS_SERVICE_UUID)
                val ae00Service = gatt.getService(AE00_SERVICE_UUID)

                // Enable notifications on AE00 if available (some watches send data here)
                if (ae00Service != null) {
                    val ae00Notify = ae00Service.getCharacteristic(AE00_NOTIFY_UUID)
                    if (ae00Notify != null) {
                        Log.d(TAG, "Also enabling notifications on AE00 service...")
                        gatt.setCharacteristicNotification(ae00Notify, true)
                        val descriptor = ae00Notify.getDescriptor(CCCD_UUID)
                        if (descriptor != null) {
                            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                                gatt.writeDescriptor(descriptor, BluetoothGattDescriptor.ENABLE_NOTIFICATION_VALUE)
                            } else {
                                @Suppress("DEPRECATION")
                                descriptor.value = BluetoothGattDescriptor.ENABLE_NOTIFICATION_VALUE
                                @Suppress("DEPRECATION")
                                gatt.writeDescriptor(descriptor)
                            }
                        }
                    }
                }

                when {
                    nusService != null -> {
                        Log.d(TAG, "✓ Found NUS service (Nordic UART) - PRIMARY!")
                        activeServiceUUID = NUS_SERVICE_UUID
                        writeCharacteristic = nusService.getCharacteristic(NUS_WRITE_UUID)
                        notifyCharacteristic = nusService.getCharacteristic(NUS_NOTIFY_UUID)
                    }
                    ae00Service != null -> {
                        Log.d(TAG, "✓ Found AE00 service (fallback)")
                        activeServiceUUID = AE00_SERVICE_UUID
                        writeCharacteristic = ae00Service.getCharacteristic(AE00_WRITE_UUID)
                        notifyCharacteristic = ae00Service.getCharacteristic(AE00_NOTIFY_UUID)
                    }
                    else -> {
                        Log.e(TAG, "✗ No compatible service found!")
                        onError?.invoke("No compatible Starmax service found")
                        return
                    }
                }

                if (writeCharacteristic == null) {
                    Log.e(TAG, "✗ Write characteristic not found!")
                    onError?.invoke("Write characteristic not found")
                    return
                }

                if (notifyCharacteristic == null) {
                    Log.e(TAG, "✗ Notify characteristic not found!")
                    onError?.invoke("Notify characteristic not found")
                    return
                }

                Log.d(TAG, "✓ Write characteristic: ${writeCharacteristic?.uuid}")
                Log.d(TAG, "✓ Notify characteristic: ${notifyCharacteristic?.uuid}")

                // IMPORTANT: Wait before enabling notifications (from SDK Demo)
                Log.d(TAG, "Waiting ${NOTIFY_DELAY_MS}ms before enabling notifications...")
                mainHandler.postDelayed({
                    enableNotifications()
                }, NOTIFY_DELAY_MS)
            } else {
                Log.e(TAG, "Service discovery failed: $status")
                onError?.invoke("Service discovery failed: $status")
            }
        }

        override fun onCharacteristicChanged(
            gatt: BluetoothGatt,
            characteristic: BluetoothGattCharacteristic,
            value: ByteArray
        ) {
            val hex = value.joinToString(" ") { String.format("%02X", it) }
            Log.d(TAG, "◀ Data received: $hex")
            onDataReceived?.invoke(value)
        }

        // For older Android versions
        @Deprecated("Deprecated in API 33")
        override fun onCharacteristicChanged(
            gatt: BluetoothGatt,
            characteristic: BluetoothGattCharacteristic
        ) {
            val value = characteristic.value ?: return
            val hex = value.joinToString(" ") { String.format("%02X", it) }
            Log.d(TAG, "◀ Data received (legacy): $hex")
            onDataReceived?.invoke(value)
        }

        override fun onCharacteristicWrite(
            gatt: BluetoothGatt,
            characteristic: BluetoothGattCharacteristic,
            status: Int
        ) {
            val success = status == BluetoothGatt.GATT_SUCCESS
            Log.d(TAG, "Write ${if (success) "success" else "failed"}: status=$status")
        }

        override fun onDescriptorWrite(
            gatt: BluetoothGatt,
            descriptor: BluetoothGattDescriptor,
            status: Int
        ) {
            if (status == BluetoothGatt.GATT_SUCCESS) {
                Log.d(TAG, "✓ Notifications enabled successfully!")
                mainHandler.post {
                    onServicesDiscovered?.invoke()
                }
            } else {
                Log.e(TAG, "✗ Failed to enable notifications: $status")
                onError?.invoke("Failed to enable notifications")
            }
        }
    }

    private fun logAllServices(gatt: BluetoothGatt) {
        Log.d(TAG, "=== Available Services ===")
        for (service in gatt.services) {
            Log.d(TAG, "Service: ${service.uuid}")
            for (char in service.characteristics) {
                Log.d(TAG, "  └ Characteristic: ${char.uuid}")
                Log.d(TAG, "      Properties: ${char.properties}")
            }
        }
        Log.d(TAG, "=========================")
    }

    fun connectToDevice(address: String) {
        val device = bluetoothAdapter?.getRemoteDevice(address)
        if (device == null) {
            onError?.invoke("Device not found: $address")
            return
        }

        Log.d(TAG, "Connecting to: $address (${device.name})")
        Log.d(TAG, "Bond state: ${device.bondState}")

        // Close existing connection
        bluetoothGatt?.close()
        bluetoothGatt = null

        // Try to bond if not already bonded
        if (device.bondState == BluetoothDevice.BOND_NONE) {
            Log.d(TAG, "Initiating bonding...")
            device.createBond()
        }

        // Connect
        bluetoothGatt = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            device.connectGatt(context, false, gattCallback, BluetoothDevice.TRANSPORT_LE)
        } else {
            device.connectGatt(context, false, gattCallback)
        }
    }

    private fun enableNotifications() {
        val gatt = bluetoothGatt
        val characteristic = notifyCharacteristic

        if (gatt == null || characteristic == null) {
            Log.e(TAG, "Cannot enable notifications: gatt or characteristic is null")
            onError?.invoke("Cannot enable notifications")
            return
        }

        Log.d(TAG, "Enabling notifications on: ${characteristic.uuid}")

        // Enable local notifications
        val success = gatt.setCharacteristicNotification(characteristic, true)
        Log.d(TAG, "setCharacteristicNotification: $success")

        // Write to CCCD to enable remote notifications
        val descriptor = characteristic.getDescriptor(CCCD_UUID)
        if (descriptor != null) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                gatt.writeDescriptor(descriptor, BluetoothGattDescriptor.ENABLE_NOTIFICATION_VALUE)
            } else {
                @Suppress("DEPRECATION")
                descriptor.value = BluetoothGattDescriptor.ENABLE_NOTIFICATION_VALUE
                @Suppress("DEPRECATION")
                gatt.writeDescriptor(descriptor)
            }
            Log.d(TAG, "CCCD write initiated")
        } else {
            Log.e(TAG, "CCCD descriptor not found!")
            // Still notify that services are ready
            mainHandler.post {
                onServicesDiscovered?.invoke()
            }
        }
    }

    fun disconnect() {
        Log.d(TAG, "Disconnecting...")
        bluetoothGatt?.disconnect()
    }

    private fun cleanup() {
        writeCharacteristic = null
        notifyCharacteristic = null
        activeServiceUUID = null
        bluetoothGatt?.close()
        bluetoothGatt = null
    }

    // ==================== DATA TRANSFER ====================

    fun writeData(data: ByteArray): Boolean {
        val gatt = bluetoothGatt
        val characteristic = writeCharacteristic

        if (gatt == null || characteristic == null) {
            Log.e(TAG, "Cannot write: gatt or characteristic is null")
            return false
        }

        val hex = data.joinToString(" ") { String.format("%02X", it) }
        Log.d(TAG, "▶ Writing: $hex")

        return try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                val result = gatt.writeCharacteristic(
                    characteristic,
                    data,
                    BluetoothGattCharacteristic.WRITE_TYPE_NO_RESPONSE
                )
                result == BluetoothStatusCodes.SUCCESS
            } else {
                @Suppress("DEPRECATION")
                characteristic.value = data
                @Suppress("DEPRECATION")
                characteristic.writeType = BluetoothGattCharacteristic.WRITE_TYPE_NO_RESPONSE
                @Suppress("DEPRECATION")
                gatt.writeCharacteristic(characteristic)
            }
        } catch (e: Exception) {
            Log.e(TAG, "Write error: ${e.message}")
            false
        }
    }

    fun dispose() {
        stopScan()
        disconnect()
        cleanup()
        try {
            context.unregisterReceiver(bondStateReceiver)
        } catch (e: Exception) {
            // Receiver might not be registered
        }
    }
}