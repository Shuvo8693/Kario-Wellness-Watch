package com.example.kario_wellness_watch.starmax

import android.content.Context
import android.os.Handler
import android.os.Looper
import android.util.Log
import io.flutter.plugin.common.EventChannel
import jdk.internal.net.http.common.Log
import java.util.Calendar

/**
 * StarmaxManager - Manages communication with Starmax smartwatch
 *
 * IMPORTANT: Uses Nordic UART Service (NUS) UUIDs like the SDK Demo app:
 * - Service: 6e400001-b5a3-f393-e0a9-e50e24dcca9d
 * - Write: 6e400002-b5a3-f393-e0a9-e50e24dcca9d
 * - Notify: 6e400003-b5a3-f393-e0a9-e50e24dcca9d
 */
class StarmaxManager(
    private val context: Context
) {

    companion object {
        private const val TAG = "StarmaxManager"
    }

    // Command codes (from SDK documentation)
    private object Cmd {
        const val PAIR = 0x01
        const val STATE = 0x02
        const val FIND_DEVICE = 0x03
        const val CAMERA = 0x04
        const val PHONE = 0x05
        const val BATTERY = 0x06
        const val VERSION = 0x07
        const val TIME = 0x08
        const val USER_INFO = 0x09
        const val GOALS = 0x0A
        const val HEALTH_DETAIL = 0x0D
        const val HEALTH_OPEN = 0x0E
        const val RESET = 0x11
        const val STEP_HISTORY = 0x1E
        const val HR_HISTORY = 0x1F
        const val BP_HISTORY = 0x20
        const val SPO2_HISTORY = 0x21
        const val SLEEP_HISTORY = 0x2D
        const val SPORT_HISTORY = 0x1D
    }

    // BLE Manager
    private val bleManager: StarmaxBleManager

    // Event sink for Flutter
    private var eventSink: EventChannel.EventSink? = null
    private val mainHandler = Handler(Looper.getMainLooper())

    // Connection state
    private var isConnected = false
    private var connectedDeviceAddress: String? = null

    init {
        Log.d(TAG, "Initializing StarmaxManager...")
        bleManager = StarmaxBleManager(context)
        setupBleCallbacks()
        Log.d(TAG, "StarmaxManager initialized")
    }

    private fun setupBleCallbacks() {
        bleManager.setCallbacks(
            onConnectionChanged = { connected ->
                Log.d(TAG, "Connection changed: $connected")
                isConnected = connected

                if (connected) {
                    sendEvent("connectionStatus", mapOf("status" to "connected"))
                } else {
                    connectedDeviceAddress = null
                    sendEvent("connectionStatus", mapOf("status" to "disconnected"))
                }
            },
            onServicesDiscovered = {
                Log.d(TAG, "Services discovered, starting initialization...")
                sendEvent("servicesDiscovered", mapOf("success" to true))

                // Start initialization sequence
                mainHandler.postDelayed({
                    startInitialization()
                }, 500)
            },
            onDataReceived = { data ->
                handleReceivedData(data)
            },
            onError = { error ->
                Log.e(TAG, "BLE Error: $error")
                sendEvent("error", mapOf("message" to error))
            },
            onBondStateChanged = { state ->
                Log.d(TAG, "Bond state changed: $state")
                sendEvent("bondStateChanged", mapOf("state" to state))
            }
        )
    }

    // ==================== INITIALIZATION ====================

    private fun startInitialization() {
        Log.d(TAG, "Starting initialization...")
        sendEvent("initializationStarted", mapOf("message" to "Starting..."))

        // Step 1: Pair (important - must be first!)
        mainHandler.postDelayed({
            Log.d(TAG, "Init: Pair")
            sendCommand(Cmd.PAIR, intArrayOf(1))
        }, 0)

        // Step 2: Get Version (wait for pair response)
        mainHandler.postDelayed({
            Log.d(TAG, "Init: Version")
            sendCommand(Cmd.VERSION, intArrayOf())
        }, 1000)

        // Step 3: Set Time
        mainHandler.postDelayed({
            Log.d(TAG, "Init: Set Time")
            val cal = Calendar.getInstance()
            sendCommand(Cmd.TIME, intArrayOf(
                cal.get(Calendar.YEAR) - 2000,
                cal.get(Calendar.MONTH) + 1,
                cal.get(Calendar.DAY_OF_MONTH),
                cal.get(Calendar.HOUR_OF_DAY),
                cal.get(Calendar.MINUTE),
                cal.get(Calendar.SECOND),
                (cal.timeZone.rawOffset / 3600000)
            ))
        }, 2000)

        // Step 4: Get Battery
        mainHandler.postDelayed({
            Log.d(TAG, "Init: Battery")
            sendCommand(Cmd.BATTERY, intArrayOf())
        }, 3000)

        // Step 5: Get Health Detail
        mainHandler.postDelayed({
            Log.d(TAG, "Init: Health Detail")
            sendCommand(Cmd.HEALTH_DETAIL, intArrayOf())
        }, 4000)

        // Complete
        mainHandler.postDelayed({
            Log.d(TAG, "Initialization complete!")
            sendEvent("initializationComplete", mapOf("success" to true))
        }, 5000)
    }

    // ==================== COMMAND BUILDING ====================

    /**
     * Build command packet with CRC
     * Format: [0xDA] [CMD] [LEN_LOW] [LEN_HIGH] [DATA...] [CRC_HIGH] [CRC_LOW]
     */
    private fun buildCommand(cmd: Int, data: IntArray): ByteArray {
        val packet = ByteArray(data.size + 6)

        packet[0] = 0xDA.toByte()
        packet[1] = cmd.toByte()
        packet[2] = (data.size and 0xFF).toByte()
        packet[3] = ((data.size shr 8) and 0xFF).toByte()

        for (i in data.indices) {
            packet[4 + i] = data[i].toByte()
        }

        val crc = calculateCRC16(packet, packet.size - 2)

        // CRC bytes: HIGH byte first, then LOW byte (BIG ENDIAN)
        packet[packet.size - 2] = ((crc shr 8) and 0xFF).toByte()
        packet[packet.size - 1] = (crc and 0xFF).toByte()

        return packet
    }

    /**
     * CRC-16/ARC: poly=0x8005, init=0x0000, refin=true, refout=true
     */
    private fun calculateCRC16(data: ByteArray, length: Int): Int {
        var crc = 0x0000  // CRITICAL: init=0x0000 for CRC-16/ARC

        for (i in 0 until length) {
            crc = crc xor (data[i].toInt() and 0xFF)
            for (j in 0 until 8) {
                crc = if ((crc and 1) != 0) {
                    (crc shr 1) xor 0xA001
                } else {
                    crc shr 1
                }
            }
        }
        return crc and 0xFFFF
    }

    private fun sendCommand(cmd: Int, data: IntArray) {
        val packet = buildCommand(cmd, data)
        val hex = packet.joinToString(" ") { String.format("%02X", it) }
        Log.d(TAG, "Sending: $hex")
        bleManager.writeData(packet)
    }

    // ==================== RESPONSE HANDLING ====================

    private fun handleReceivedData(data: ByteArray) {
        if (data.isEmpty()) return

        val hex = data.joinToString(" ") { String.format("%02X", it) }
        Log.d(TAG, "Received: $hex (${data.size} bytes)")

        // Send raw data to Flutter
        sendEvent("rawData", mapOf(
            "hex" to hex,
            "bytes" to data.map { it.toInt() and 0xFF }
        ))

        // Check for DA header (Starmax protocol)
        if (data[0].toInt() and 0xFF == 0xDA) {
            parseStarmaxResponse(data)
        }
    }

    private fun parseStarmaxResponse(data: ByteArray) {
        if (data.size < 4) return

        val respCode = data[1].toInt() and 0xFF
        val dataLen = (data[2].toInt() and 0xFF) or ((data[3].toInt() and 0xFF) shl 8)

        Log.d(TAG, "Response: 0x${respCode.toString(16)}, dataLen: $dataLen")

        // Check for status-only response (1 byte data = status code)
        if (dataLen == 1 && data.size >= 5) {
            val status = data[4].toInt() and 0xFF
            Log.d(TAG, "Status response: $status")

            // Status 02 might mean "success" or "no data"
            when (respCode) {
                0x81 -> {
                    Log.d(TAG, "Pair response: status=$status")
                    sendEvent("pair", mapOf("success" to (status == 2 || status == 0)))
                }
                0x82 -> {
                    Log.d(TAG, "State response: status=$status")
                    sendEvent("deviceState", mapOf("status" to status))
                }
                0x83 -> {
                    Log.d(TAG, "Find device response: status=$status")
                    sendEvent("findDevice", mapOf("status" to status))
                }
                0x86 -> {
                    // Short battery response - status might be the level!
                    Log.d(TAG, "Battery (short): level=$status")
                    sendEvent("battery", mapOf("level" to status, "charging" to false))
                }
                0x87 -> {
                    Log.d(TAG, "Version response: status=$status")
                    sendEvent("version", mapOf("status" to status))
                }
                0x88 -> {
                    Log.d(TAG, "Time response: status=$status")
                    sendEvent("time", mapOf("status" to status))
                }
                0x8D -> {
                    Log.d(TAG, "Health detail response: status=$status (no data yet)")
                    sendEvent("healthDetail", mapOf(
                        "status" to status,
                        "message" to "No health data available. Wear the watch."
                    ))
                }
                else -> {
                    Log.d(TAG, "Unknown response: 0x${respCode.toString(16)}, status=$status")
                    sendEvent("response", mapOf("code" to respCode, "status" to status))
                }
            }
            return
        }

        // Full data response
        when (respCode) {
            0x81 -> { // Pair response
                Log.d(TAG, "Pair response (full)")
                sendEvent("pair", mapOf("success" to true))
            }
            0x86 -> { // Battery response (full format)
                if (data.size >= 6) {
                    val level = data[4].toInt() and 0xFF
                    val charging = if (data.size >= 7) (data[5].toInt() and 0xFF) == 1 else false
                    Log.d(TAG, "Battery: $level%, charging: $charging")
                    sendEvent("battery", mapOf("level" to level, "charging" to charging))
                }
            }
            0x87 -> { // Version response
                if (data.size >= 8) {
                    val firmware = "${data[4].toInt() and 0xFF}.${data[5].toInt() and 0xFF}.${data[6].toInt() and 0xFF}"
                    Log.d(TAG, "Version: $firmware")
                    sendEvent("version", mapOf("firmware" to firmware))
                }
            }
            0x8D -> { // Health detail response
                parseHealthDetail(data)
            }
            else -> {
                Log.d(TAG, "Unknown response: 0x${respCode.toString(16)}")
                sendEvent("response", mapOf("code" to respCode, "dataLen" to dataLen))
            }
        }
    }

    private fun parseHealthDetail(data: ByteArray) {
        if (data.size >= 20) {
            val health = mapOf(
                "steps" to ((data[4].toInt() and 0xFF) or
                        ((data[5].toInt() and 0xFF) shl 8) or
                        ((data[6].toInt() and 0xFF) shl 16) or
                        ((data[7].toInt() and 0xFF) shl 24)),
                "calories" to ((data[8].toInt() and 0xFF) or ((data[9].toInt() and 0xFF) shl 8)),
                "distance" to (((data[10].toInt() and 0xFF) or ((data[11].toInt() and 0xFF) shl 8)) / 10.0),
                "heartRate" to (data[12].toInt() and 0xFF),
                "bloodOxygen" to (data[13].toInt() and 0xFF),
                "systolic" to (data[14].toInt() and 0xFF),
                "diastolic" to (data[15].toInt() and 0xFF),
                "pressure" to (data[16].toInt() and 0xFF),
                "temperature" to (((data[17].toInt() and 0xFF) or ((data[18].toInt() and 0xFF) shl 8)) / 10.0),
                "isWearing" to ((data[19].toInt() and 0xFF) == 1)
            )
            Log.d(TAG, "Health: $health")
            sendEvent("healthDetail", health)
        }
    }

    // ==================== PUBLIC API ====================

    fun startScan() {
        Log.d(TAG, "Starting scan...")
        bleManager.startScan { device ->
            sendEvent("deviceFound", mapOf(
                "name" to (device.name ?: "Unknown"),
                "address" to device.address,
                "rssi" to device.rssi
            ))
        }
    }

    fun stopScan() {
        Log.d(TAG, "Stopping scan...")
        bleManager.stopScan()
    }

    fun connect(address: String) {
        Log.d(TAG, "Connecting to: $address")
        stopScan()
        connectedDeviceAddress = address
        bleManager.connectToDevice(address)
    }

    fun disconnect() {
        Log.d(TAG, "Disconnecting...")
        bleManager.disconnect()
        connectedDeviceAddress = null
        isConnected = false
    }

    fun isConnected(): Boolean = isConnected

    fun initializeWatch() {
        startInitialization()
    }

    fun getBattery() {
        Log.d(TAG, "Getting battery...")
        sendCommand(Cmd.BATTERY, intArrayOf())
    }

    fun getVersion() {
        Log.d(TAG, "Getting version...")
        sendCommand(Cmd.VERSION, intArrayOf())
    }

    fun getHealthDetail() {
        Log.d(TAG, "Getting health detail...")
        sendCommand(Cmd.HEALTH_DETAIL, intArrayOf())
    }

    fun getHeartRate() = getHealthDetail()
    fun getSteps() = getHealthDetail()
    fun getBloodOxygen() = getHealthDetail()

    fun getDeviceState() {
        Log.d(TAG, "Getting device state...")
        sendCommand(Cmd.STATE, intArrayOf())
    }

    fun setDeviceState(
        timeFormat: Int, unit: Int, tempUnit: Int,
        language: Int, wristUp: Int, backlightTime: Int, brightness: Int
    ) {
        Log.d(TAG, "Setting device state...")
        sendCommand(Cmd.STATE, intArrayOf(
            timeFormat, unit, tempUnit, language, wristUp, backlightTime, brightness
        ))
    }

    fun getUserInfo() {
        Log.d(TAG, "Getting user info...")
        sendCommand(Cmd.USER_INFO, intArrayOf())
    }

    fun setUserInfo(sex: Int, age: Int, height: Int, weight: Double) {
        Log.d(TAG, "Setting user info...")
        val w = (weight * 10).toInt()
        sendCommand(Cmd.USER_INFO, intArrayOf(sex, age, height, w and 0xFF, (w shr 8) and 0xFF))
    }

    fun getGoals() {
        Log.d(TAG, "Getting goals...")
        sendCommand(Cmd.GOALS, intArrayOf())
    }

    fun setGoals(steps: Int, calories: Int, distance: Double) {
        Log.d(TAG, "Setting goals...")
        val d = (distance * 10).toInt()
        sendCommand(Cmd.GOALS, intArrayOf(
            steps and 0xFF, (steps shr 8) and 0xFF, (steps shr 16) and 0xFF, (steps shr 24) and 0xFF,
            calories and 0xFF, (calories shr 8) and 0xFF,
            d and 0xFF, (d shr 8) and 0xFF
        ))
    }

    fun findDevice(enable: Boolean) {
        Log.d(TAG, "Find device: $enable")
        sendCommand(Cmd.FIND_DEVICE, intArrayOf(if (enable) 1 else 0))
    }

    fun cameraControl(enter: Boolean) {
        Log.d(TAG, "Camera: enter=$enter")
        sendCommand(Cmd.CAMERA, intArrayOf(if (enter) 1 else 0))
    }

    fun takePhoto() {
        Log.d(TAG, "Take photo")
        sendCommand(Cmd.CAMERA, intArrayOf(2))
    }

    fun setTime() {
        Log.d(TAG, "Setting time...")
        val cal = Calendar.getInstance()
        sendCommand(Cmd.TIME, intArrayOf(
            cal.get(Calendar.YEAR) - 2000,
            cal.get(Calendar.MONTH) + 1,
            cal.get(Calendar.DAY_OF_MONTH),
            cal.get(Calendar.HOUR_OF_DAY),
            cal.get(Calendar.MINUTE),
            cal.get(Calendar.SECOND),
            (cal.timeZone.rawOffset / 3600000)
        ))
    }

    fun getHealthOpen() {
        Log.d(TAG, "Getting health open...")
        sendCommand(Cmd.HEALTH_OPEN, intArrayOf())
    }

    fun setHealthOpen(
        heartRate: Boolean, bloodPressure: Boolean, bloodOxygen: Boolean,
        pressure: Boolean, temperature: Boolean, bloodSugar: Boolean
    ) {
        Log.d(TAG, "Setting health open...")
        sendCommand(Cmd.HEALTH_OPEN, intArrayOf(
            if (heartRate) 1 else 0,
            if (bloodPressure) 1 else 0,
            if (bloodOxygen) 1 else 0,
            if (pressure) 1 else 0,
            if (temperature) 1 else 0,
            if (bloodSugar) 1 else 0
        ))
    }

    fun factoryReset() {
        Log.d(TAG, "Factory reset...")
        sendCommand(Cmd.RESET, intArrayOf())
    }

    // History methods
    fun getStepHistory(calendar: Calendar) {
        sendCommand(Cmd.STEP_HISTORY, intArrayOf(
            calendar.get(Calendar.YEAR) - 2000,
            calendar.get(Calendar.MONTH) + 1,
            calendar.get(Calendar.DAY_OF_MONTH)
        ))
    }

    fun getHeartRateHistory(calendar: Calendar) {
        sendCommand(Cmd.HR_HISTORY, intArrayOf(
            calendar.get(Calendar.YEAR) - 2000,
            calendar.get(Calendar.MONTH) + 1,
            calendar.get(Calendar.DAY_OF_MONTH)
        ))
    }

    fun getBloodPressureHistory(calendar: Calendar) {
        sendCommand(Cmd.BP_HISTORY, intArrayOf(
            calendar.get(Calendar.YEAR) - 2000,
            calendar.get(Calendar.MONTH) + 1,
            calendar.get(Calendar.DAY_OF_MONTH)
        ))
    }

    fun getBloodOxygenHistory(calendar: Calendar) {
        sendCommand(Cmd.SPO2_HISTORY, intArrayOf(
            calendar.get(Calendar.YEAR) - 2000,
            calendar.get(Calendar.MONTH) + 1,
            calendar.get(Calendar.DAY_OF_MONTH)
        ))
    }

    fun getSleepHistory(calendar: Calendar) {
        sendCommand(Cmd.SLEEP_HISTORY, intArrayOf(
            calendar.get(Calendar.YEAR) - 2000,
            calendar.get(Calendar.MONTH) + 1,
            calendar.get(Calendar.DAY_OF_MONTH)
        ))
    }

    fun getSportHistory(calendar: Calendar) {
        sendCommand(Cmd.SPORT_HISTORY, intArrayOf(
            calendar.get(Calendar.YEAR) - 2000,
            calendar.get(Calendar.MONTH) + 1,
            calendar.get(Calendar.DAY_OF_MONTH)
        ))
    }

    // ==================== EVENT CHANNEL ====================

    fun setEventSink(sink: EventChannel.EventSink?) {
        Log.d(TAG, "EventSink ${if (sink != null) "set" else "cleared"}")
        eventSink = sink
    }

    private fun sendEvent(event: String, data: Map<String, Any?>) {
        mainHandler.post {
            eventSink?.success(mapOf("event" to event, "data" to data))
        }
    }

    fun cleanup() {
        Log.d(TAG, "Cleanup...")
        bleManager.dispose()
        eventSink = null
    }
}