/*package com.example.kario_wellness_watch.starmax

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
import java.util.UUID*/

/**
 * StarmaxBleManager - Handles BLE communication with Starmax smartwatch
 *
 * CRITICAL: Uses Nordic UART Service (NUS) UUIDs - this is what the SDK Demo uses!
 * NOT the AE00 service that was used before.
 */

/*@SuppressLint("MissingPermission")
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
                mainHandler.postDelayed({ enableNotifications() }, NOTIFY_DELAY_MS)
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
}*/

package com.example.kario_wellness_watch.starmax

import android.Manifest
import android.annotation.SuppressLint
import android.bluetooth.*
import android.bluetooth.le.BluetoothLeScanner
import android.bluetooth.le.ScanCallback
import android.bluetooth.le.ScanResult
import android.content.Context
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.util.Log
import androidx.annotation.RequiresPermission
import com.starmax.bluetoothsdk.MapStarmaxNotify
import com.starmax.bluetoothsdk.StarmaxSend
import com.starmax.bluetoothsdk.data.NotifyType
import java.util.UUID

interface StarmaxBleListener {
    fun onScanResult(device: StarmaxDevice)
    fun onScanStopped()
    fun onConnectionStateChanged(connected: Boolean)
    fun onHealthDataUpdated(data: StarmaxHealthData)
    fun onError(message: String, throwable: Throwable? = null)
}

class StarmaxBleManager(
    private val context: Context,
    private val listener: StarmaxBleListener
) {

    companion object {
        private const val TAG = "StarmaxBleManager"
        private const val SCAN_TIMEOUT_MS = 15_000L
        private const val REQUESTED_MTU = 247
        private val CCCD_UUID: UUID =
            UUID.fromString("00002902-0000-1000-8000-00805f9b34fb")
    }

    private val bluetoothManager =
        context.getSystemService(Context.BLUETOOTH_SERVICE) as BluetoothManager
    private val bluetoothAdapter: BluetoothAdapter? = bluetoothManager.adapter
    private val mainHandler = Handler(Looper.getMainLooper())

    private var scanner: BluetoothLeScanner? = null
    private var isScanning = false

    private var gatt: BluetoothGatt? = null
    private var writeChar: BluetoothGattCharacteristic? = null
    private var notifyChar: BluetoothGattCharacteristic? = null

    // *** MUST use vendor SDK ***
    private val sender = StarmaxSend()
    private val mapNotify = MapStarmaxNotify()   // as in PDF sample

    private var connected = false
    fun isConnected(): Boolean = connected

    // ------------------------------------------------------------------ Scan

    @SuppressLint("MissingPermission")
    fun startScan() {
        if (isScanning) return

        val adapter = bluetoothAdapter
        if (adapter == null || !adapter.isEnabled) {
            listener.onError("Bluetooth disabled")
            return
        }

        scanner = adapter.bluetoothLeScanner
        if (scanner == null) {
            listener.onError("BluetoothLeScanner not available")
            return
        }

        isScanning = true
        scanner?.startScan(scanCallback)
        Log.d(TAG, "=== Scan started ===")

        mainHandler.postDelayed({ stopScan() }, SCAN_TIMEOUT_MS)
    }

    @SuppressLint("MissingPermission")
    fun stopScan() {
        if (!isScanning) return
        isScanning = false
        scanner?.stopScan(scanCallback)
        Log.d(TAG, "=== Scan stopped ===")
        listener.onScanStopped()
    }

    private val scanCallback = object : ScanCallback() {
        @SuppressLint("MissingPermission")
        override fun onScanResult(callbackType: Int, result: ScanResult?) {
            val d = result?.device ?: return
            listener.onScanResult(StarmaxDevice(d.name, d.address))
        }

        override fun onScanFailed(errorCode: Int) {
            listener.onError("Scan failed: $errorCode")
        }
    }

    // ------------------------------------------------------------------ Connect

    @SuppressLint("MissingPermission")
    fun connect(address: String) {
        stopScan()

        val adapter = bluetoothAdapter
        val device = adapter?.getRemoteDevice(address)
        if (device == null) {
            listener.onError("Device not found for $address")
            return
        }

        Log.d(TAG, "Connecting to $address")
        gatt?.close()
        gatt = device.connectGatt(context, false, gattCallback)
    }

    @SuppressLint("MissingPermission")
    fun disconnect() {
        try {
            gatt?.disconnect()
            gatt?.close()
        } catch (e: Exception) {
            Log.w(TAG, "disconnect error", e)
        } finally {
            gatt = null
            writeChar = null
            notifyChar = null
            if (connected) {
                connected = false
                listener.onConnectionStateChanged(false)
            }
        }
    }

    fun cleanup() {
        disconnect()
        stopScan()
    }

    // ------------------------------------------------------------------ Send commands (from StarmaxManager)

    fun sendCommand(bytes: ByteArray) {
        sendToDevice(bytes)
    }

    @SuppressLint("MissingPermission")
    private fun sendToDevice(bytes: ByteArray) {
        val g = gatt
        val c = writeChar

        if (g == null || c == null) {
            listener.onError("Not connected to device")
            return
        }

        c.value = bytes
        val ok = g.writeCharacteristic(c)
        if (!ok) {
            listener.onError("writeCharacteristic failed")
        }
    }

    // ------------------------------------------------------------------ GATT callback

    private val gattCallback = object : BluetoothGattCallback() {

        @SuppressLint("MissingPermission")
        override fun onConnectionStateChange(gatt: BluetoothGatt, status: Int, newState: Int) {
            if (status != BluetoothGatt.GATT_SUCCESS) {
                listener.onError("GATT error $status")
                disconnect()
                return
            }

            if (newState == BluetoothProfile.STATE_CONNECTED) {
                Log.d(TAG, "Connected, requesting MTU / discovering")
                this@StarmaxBleManager.gatt = gatt
                connected = true
                listener.onConnectionStateChanged(true)

                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                    gatt.requestMtu(REQUESTED_MTU)
                } else {
                    gatt.discoverServices()
                }
            } else if (newState == BluetoothProfile.STATE_DISCONNECTED) {
                Log.d(TAG, "Disconnected")
                disconnect()
            }
        }

        @RequiresPermission(Manifest.permission.BLUETOOTH_CONNECT)
        override fun onMtuChanged(gatt: BluetoothGatt, mtu: Int, status: Int) {
            Log.d(TAG, "MTU=$mtu status=$status")
            gatt.discoverServices()
        }

        @SuppressLint("MissingPermission")
        override fun onServicesDiscovered(gatt: BluetoothGatt, status: Int) {
            if (status != BluetoothGatt.GATT_SUCCESS) {
                listener.onError("Service discovery failed: $status")
                return
            }

            var w: BluetoothGattCharacteristic? = null
            var n: BluetoothGattCharacteristic? = null

            for (svc in gatt.services) {
                for (ch in svc.characteristics) {
                    val p = ch.properties
                    if (w == null &&
                        (p and (BluetoothGattCharacteristic.PROPERTY_WRITE or
                                BluetoothGattCharacteristic.PROPERTY_WRITE_NO_RESPONSE)) != 0
                    ) {
                        w = ch
                    }
                    if (n == null &&
                        (p and BluetoothGattCharacteristic.PROPERTY_NOTIFY) != 0
                    ) {
                        n = ch
                    }
                }
            }

            if (w == null || n == null) {
                listener.onError("Write/notify characteristics not found")
                return
            }

            writeChar = w
            notifyChar = n
            Log.d(TAG, "writeChar=${w.uuid}, notifyChar=${n.uuid}")

            // Enable notifications
            gatt.setCharacteristicNotification(n, true)
            val cccd = n.getDescriptor(CCCD_UUID)
            if (cccd != null) {
                cccd.value = BluetoothGattDescriptor.ENABLE_NOTIFICATION_VALUE
                gatt.writeDescriptor(cccd)
            } else {
                // If there is no CCCD, just start using it
                onChannelReady()
            }
        }

        override fun onDescriptorWrite(
            gatt: BluetoothGatt,
            descriptor: BluetoothGattDescriptor,
            status: Int
        ) {
            if (descriptor.uuid == CCCD_UUID && status == BluetoothGatt.GATT_SUCCESS) {
                Log.d(TAG, "Notifications enabled, channel ready")
                onChannelReady()
            }
        }

        // After notifications ready – follow vendor example: pair() then other commands.
        private fun onChannelReady() {
            // 1) Pair
            Log.d(TAG, "Sending pair()")
            sendToDevice(sender.pair())

            // 2) Optionally sync time
            Log.d(TAG, "Sending setTime()")
            sendToDevice(sender.setTime())

            // 3) Ask for current health data (this feeds your watch data screen)
            Log.d(TAG, "Sending getHealthDetail()")
            sendToDevice(sender.getHealthDetail())
        }

        @Deprecated("Deprecated in Java")
        override fun onCharacteristicChanged(
            gatt: BluetoothGatt,
            characteristic: BluetoothGattCharacteristic
        ) {
            val value = characteristic.value ?: return

            try {
                // EXACTLY like the PDF:
                // val response = MapStarmaxNotify.instance.notify(byteArray)
                val response = mapNotify.notify(value)
                val type = response.type
                val obj = response.obj

                Log.d(TAG, "Notify type=$type obj=$obj")

                // Handle CRC / generic failure
                if (type == NotifyType.Failure || type == NotifyType.CrcFailure) {
                    listener.onError("Device returned error: $type")
                    return
                }

                // HealthDetail / Health / RealTime carry the “watch data” map
                if ((type == NotifyType.HealthDetail ||
                            type == NotifyType.RealTimeData) && obj is Map<*, *>
                ) {
                    val health = parseHealthDetail(obj)
                    listener.onHealthDataUpdated(health)
                }

                // Pair reply etc. are ignored for now but you can log them:
                // if (type == NotifyType.Pair) { ... }

            } catch (t: Throwable) {
                listener.onError("Notify parse failed", t)
            }
        }
    }

    // ------------------------------------------------------------------ Map -> model

    private fun parseHealthDetail(map: Map<*, *>): StarmaxHealthData {
        fun intValue(key: String): Int =
            (map[key] as? Number)?.toInt() ?: 0

        val isWear = when (val v = map["is_wear"]) {
            is Number -> v.toInt()
            else -> -1
        }

        return StarmaxHealthData(
            totalSteps        = intValue("total_steps"),
            totalHeat         = intValue("total_heat"),
            totalDistance     = intValue("total_distance"),
            totalSleepMinutes = intValue("total_sleep"),
            deepSleepMinutes  = intValue("total_deep_sleep"),
            lightSleepMinutes = intValue("total_light_sleep"),
            heartRate         = intValue("current_heart_rate"),
            systolic          = intValue("current_ss"),
            diastolic         = intValue("current_fz"),
            bloodOxygen       = intValue("current_blood_oxygen"),
            pressure          = intValue("current_pressure"),
            met               = intValue("current_met"),
            mai               = intValue("current_mai"),
            tempTenthC        = intValue("current_temp"),
            bloodSugarTenth   = intValue("current_blood_sugar"),
            isWear            = isWear
        )
    }
}
