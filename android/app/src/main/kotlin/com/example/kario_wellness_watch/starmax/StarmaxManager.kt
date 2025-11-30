package com.example.kario_wellness_watch.starmax

import android.content.Context
import android.os.Handler
import android.os.Looper
import android.util.Log
import io.flutter.plugin.common.EventChannel
import java.util.Calendar

/**
 * StarmaxManager - Manages communication with Starmax smartwatch
 *
 * This version handles raw byte commands and responses directly,
 * without relying on SDK parsing classes that may have incompatible APIs.
 */
class StarmaxManager(private val context: Context) {

    private val TAG = "StarmaxManager"
    private val bleManager = StarmaxBleManager(context)
    private val mainHandler = Handler(Looper.getMainLooper())

    private var eventSink: EventChannel.EventSink? = null

    // Command constants
    private object Cmd {
        const val HEADER: Byte = 0xDA.toByte()

        // Command codes (send)
        const val PAIR: Byte = 0x01
        const val STATE: Byte = 0x02
        const val POWER: Byte = 0x06
        const val VERSION: Byte = 0x07
        const val SET_TIME: Byte = 0x08
        const val USER_INFO: Byte = 0x09
        const val GOALS: Byte = 0x0A
        const val HEALTH_DETAIL: Byte = 0x0D
        const val HEALTH_OPEN: Byte = 0x0E
        const val FIND_DEVICE: Byte = 0x10
        const val CAMERA: Byte = 0x12
        const val MESSAGE: Byte = 0x13
        const val CLOCK: Byte = 0x14
        const val STEP_HISTORY: Byte = 0x15
        const val SLEEP_HISTORY: Byte = 0x16
        const val HEART_RATE_HISTORY: Byte = 0x17
        const val BLOOD_PRESSURE_HISTORY: Byte = 0x19
        const val BLOOD_OXYGEN_HISTORY: Byte = 0x1B
        const val SPORT_HISTORY: Byte = 0x1C
        const val REAL_TIME_MEASURE: Byte = 0x26
        const val HEART_RATE_CONTROL: Byte = 0x27
        const val RESET: Byte = 0x22

        // Response codes (receive) - command + 0x80
        const val RESP_PAIR: Byte = 0x81.toByte()
        const val RESP_STATE: Byte = 0x82.toByte()
        const val RESP_POWER: Byte = 0x86.toByte()
        const val RESP_VERSION: Byte = 0x87.toByte()
        const val RESP_SET_TIME: Byte = 0x88.toByte()
        const val RESP_USER_INFO: Byte = 0x89.toByte()
        const val RESP_GOALS: Byte = 0x8A.toByte()
        const val RESP_HEALTH_DETAIL: Byte = 0x8D.toByte()
        const val RESP_HEALTH_OPEN: Byte = 0x8E.toByte()
        const val RESP_FIND_DEVICE: Byte = 0x90.toByte()
        const val RESP_CAMERA: Byte = 0x92.toByte()
        const val RESP_MESSAGE: Byte = 0x93.toByte()
        const val RESP_CLOCK: Byte = 0x94.toByte()
        const val RESP_STEP_HISTORY: Byte = 0x95.toByte()
        const val RESP_SLEEP_HISTORY: Byte = 0x96.toByte()
        const val RESP_HEART_RATE_HISTORY: Byte = 0x97.toByte()
        const val RESP_BLOOD_PRESSURE_HISTORY: Byte = 0x99.toByte()
        const val RESP_BLOOD_OXYGEN_HISTORY: Byte = 0x9B.toByte()
        const val RESP_SPORT_HISTORY: Byte = 0x9C.toByte()
        const val RESP_REAL_TIME_MEASURE: Byte = 0xA6.toByte()
        const val RESP_HEART_RATE_CONTROL: Byte = 0xA7.toByte()

        // Special watch-initiated commands
        const val FIND_PHONE: Byte = 0x11
        const val MUSIC_CONTROL: Byte = 0x18
        const val PHONE_CONTROL: Byte = 0x1A
    }

    init {
        setupBleCallbacks()
    }

    // ==================== BLE CALLBACKS ====================

    private fun setupBleCallbacks() {
        bleManager.setCallbacks(
            onDeviceFound = { name, address, rssi ->
                sendEvent("deviceFound", mapOf(
                    "name" to name,
                    "address" to address,
                    "rssi" to rssi
                ))
            },
            onConnectionChanged = { connected ->
                if (connected) {
                    Log.d(TAG, "Device connected")
                    sendEvent("connectionState", mapOf(
                        "connected" to true,
                        "address" to (bleManager.getConnectedDeviceAddress() ?: "")
                    ))
                    // Send servicesDiscovered event after a short delay
                    mainHandler.postDelayed({
                        sendEvent("servicesDiscovered", mapOf("ready" to true))
                    }, 500)
                } else {
                    Log.d(TAG, "Device disconnected")
                    sendEvent("connectionState", mapOf(
                        "connected" to false,
                        "address" to ""
                    ))
                }
            },
            onDataReceived = { byteArray ->
                handleReceivedData(byteArray)
            },
            onError = { errorMessage ->
                Log.e(TAG, "BLE Error: $errorMessage")
                sendEvent("error", mapOf("message" to errorMessage))
            }
        )
    }

    // ==================== DATA HANDLING ====================

    private fun handleReceivedData(data: ByteArray) {
        Log.d(TAG, ">>> Data received: ${data.toHexString()}")

        if (data.size < 4) {
            Log.w(TAG, "Data too short")
            sendEvent("rawData", mapOf("data" to data.toHexString()))
            return
        }

        // Check header
        if (data[0] != Cmd.HEADER) {
            Log.w(TAG, "Invalid header: ${data[0]}")
            sendEvent("rawData", mapOf("data" to data.toHexString()))
            return
        }

        val cmdByte = data[1]
        val dataLen = (data[2].toInt() and 0xFF) or ((data[3].toInt() and 0xFF) shl 8)

        Log.d(TAG, "Command: ${String.format("%02X", cmdByte)}, DataLen: $dataLen")

        // Parse based on command type
        when (cmdByte) {
            Cmd.RESP_POWER -> parsePowerResponse(data)
            Cmd.RESP_HEALTH_DETAIL -> parseHealthDetailResponse(data)
            Cmd.RESP_PAIR -> parsePairResponse(data)
            Cmd.RESP_VERSION -> parseVersionResponse(data)
            Cmd.RESP_STATE -> parseStateResponse(data)
            Cmd.RESP_SET_TIME, Cmd.RESP_MESSAGE -> parseReplyResponse(data)
            Cmd.RESP_GOALS -> parseGoalsResponse(data)
            Cmd.RESP_USER_INFO -> parseUserInfoResponse(data)
            Cmd.RESP_CLOCK -> parseClockResponse(data)
            Cmd.RESP_HEALTH_OPEN -> parseHealthOpenResponse(data)
            Cmd.RESP_HEART_RATE_HISTORY -> parseHeartRateHistoryResponse(data)
            Cmd.RESP_STEP_HISTORY -> parseStepHistoryResponse(data)
            Cmd.RESP_BLOOD_OXYGEN_HISTORY -> parseBloodOxygenHistoryResponse(data)
            Cmd.RESP_BLOOD_PRESSURE_HISTORY -> parseBloodPressureHistoryResponse(data)
            Cmd.RESP_SLEEP_HISTORY -> parseSleepHistoryResponse(data)
            Cmd.RESP_SPORT_HISTORY -> parseSportHistoryResponse(data)
            Cmd.RESP_REAL_TIME_MEASURE -> parseRealTimeMeasureResponse(data)
            Cmd.RESP_HEART_RATE_CONTROL -> parseHeartRateControlResponse(data)
            Cmd.FIND_PHONE -> handleFindPhone(data)
            Cmd.RESP_CAMERA, Cmd.CAMERA.toByte() -> parseCameraControl(data)
            Cmd.MUSIC_CONTROL -> parseMusicControl(data)
            else -> {
                Log.d(TAG, "Unhandled command: ${String.format("%02X", cmdByte)}")
                sendEvent("rawData", mapOf(
                    "command" to String.format("%02X", cmdByte),
                    "data" to data.toHexString()
                ))
            }
        }
    }

    // ==================== RESPONSE PARSERS ====================

    private fun parsePowerResponse(data: ByteArray) {
        try {
            if (data.size >= 6) {
                val level = data[4].toInt() and 0xFF
                val charging = if (data.size >= 7) (data[5].toInt() and 0xFF) == 1 else false

                Log.d(TAG, "Battery: $level%, Charging: $charging")
                sendEvent("batteryInfo", mapOf(
                    "level" to level,
                    "isCharging" to charging
                ))
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error parsing power response", e)
        }
    }

    private fun parseHealthDetailResponse(data: ByteArray) {
        try {
            if (data.size >= 20) {
                // Parse health detail data
                // Format: DA 8D [len_lo] [len_hi] [step 4 bytes] [distance 4 bytes] [calories 4 bytes] [heart_rate] [blood_oxygen] [bp_high] [bp_low] ...
                val steps = readInt32(data, 4)
                val distance = readInt32(data, 8)
                val calories = readInt32(data, 12)
                val heartRate = if (data.size > 16) data[16].toInt() and 0xFF else 0
                val bloodOxygen = if (data.size > 17) data[17].toInt() and 0xFF else 0
                val bpHigh = if (data.size > 18) data[18].toInt() and 0xFF else 0
                val bpLow = if (data.size > 19) data[19].toInt() and 0xFF else 0

                Log.d(TAG, "Health: Steps=$steps, HR=$heartRate, SpO2=$bloodOxygen, BP=$bpHigh/$bpLow")

                sendEvent("healthData", mapOf(
                    "steps" to steps,
                    "calories" to calories,
                    "heartRate" to heartRate,
                    "bloodOxygen" to bloodOxygen,
                    "bloodPressureHigh" to bpHigh,
                    "bloodPressureLow" to bpLow,
                    "distance" to distance
                ))
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error parsing health detail response", e)
        }
    }

    private fun parsePairResponse(data: ByteArray) {
        try {
            val success = data.size >= 5 && (data[4].toInt() and 0xFF) == 1
            Log.d(TAG, "Pair result: $success")
            sendEvent("pairResult", mapOf("success" to success))
        } catch (e: Exception) {
            Log.e(TAG, "Error parsing pair response", e)
        }
    }

    private fun parseVersionResponse(data: ByteArray) {
        try {
            if (data.size >= 8) {
                val major = data[4].toInt() and 0xFF
                val minor = data[5].toInt() and 0xFF
                val patch = data[6].toInt() and 0xFF
                val version = "$major.$minor.$patch"

                Log.d(TAG, "Version: $version")
                sendEvent("version", mapOf("version" to version))
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error parsing version response", e)
        }
    }

    private fun parseStateResponse(data: ByteArray) {
        try {
            if (data.size >= 10) {
                val timeFormat = data[4].toInt() and 0xFF
                val unitFormat = data[5].toInt() and 0xFF
                val tempFormat = data[6].toInt() and 0xFF
                val language = data[7].toInt() and 0xFF

                Log.d(TAG, "State: timeFormat=$timeFormat, unitFormat=$unitFormat")
                sendEvent("deviceState", mapOf(
                    "timeFormat" to timeFormat,
                    "unitFormat" to unitFormat,
                    "tempFormat" to tempFormat,
                    "language" to language
                ))
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error parsing state response", e)
        }
    }

    private fun parseReplyResponse(data: ByteArray) {
        try {
            val success = data.size >= 5 && (data[4].toInt() and 0xFF) == 0
            Log.d(TAG, "Command reply: success=$success")
            sendEvent("commandReply", mapOf("success" to success))
        } catch (e: Exception) {
            Log.e(TAG, "Error parsing reply response", e)
        }
    }

    private fun parseGoalsResponse(data: ByteArray) {
        try {
            if (data.size >= 12) {
                val steps = readInt32(data, 4)
                val calories = readInt16(data, 8)
                val distance = readInt16(data, 10)

                Log.d(TAG, "Goals: steps=$steps, calories=$calories, distance=$distance")
                sendEvent("goals", mapOf(
                    "steps" to steps,
                    "calories" to calories,
                    "distance" to distance
                ))
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error parsing goals response", e)
        }
    }

    private fun parseUserInfoResponse(data: ByteArray) {
        try {
            if (data.size >= 10) {
                val sex = data[4].toInt() and 0xFF
                val age = data[5].toInt() and 0xFF
                val height = data[6].toInt() and 0xFF
                val weight = data[7].toInt() and 0xFF

                Log.d(TAG, "User info: sex=$sex, age=$age, height=$height, weight=$weight")
                sendEvent("userInfo", mapOf(
                    "sex" to sex,
                    "age" to age,
                    "height" to height,
                    "weight" to weight
                ))
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error parsing user info response", e)
        }
    }

    private fun parseClockResponse(data: ByteArray) {
        try {
            Log.d(TAG, "Clock/Alarm response received")
            sendEvent("alarms", mapOf("data" to data.toHexString()))
        } catch (e: Exception) {
            Log.e(TAG, "Error parsing clock response", e)
        }
    }

    private fun parseHealthOpenResponse(data: ByteArray) {
        try {
            if (data.size >= 8) {
                val heartRate = (data[4].toInt() and 0xFF) == 1
                val bloodPressure = (data[5].toInt() and 0xFF) == 1
                val bloodOxygen = (data[6].toInt() and 0xFF) == 1

                Log.d(TAG, "Health monitoring: HR=$heartRate, BP=$bloodPressure, SpO2=$bloodOxygen")
                sendEvent("healthMonitoringSettings", mapOf(
                    "heartRate" to heartRate,
                    "bloodPressure" to bloodPressure,
                    "bloodOxygen" to bloodOxygen
                ))
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error parsing health open response", e)
        }
    }

    private fun parseHeartRateHistoryResponse(data: ByteArray) {
        Log.d(TAG, "Heart rate history received: ${data.size} bytes")
        sendEvent("heartRateHistory", mapOf("data" to data.toHexString()))
    }

    private fun parseStepHistoryResponse(data: ByteArray) {
        Log.d(TAG, "Step history received: ${data.size} bytes")
        sendEvent("stepHistory", mapOf("data" to data.toHexString()))
    }

    private fun parseBloodOxygenHistoryResponse(data: ByteArray) {
        Log.d(TAG, "Blood oxygen history received: ${data.size} bytes")
        sendEvent("bloodOxygenHistory", mapOf("data" to data.toHexString()))
    }

    private fun parseBloodPressureHistoryResponse(data: ByteArray) {
        Log.d(TAG, "Blood pressure history received: ${data.size} bytes")
        sendEvent("bloodPressureHistory", mapOf("data" to data.toHexString()))
    }

    private fun parseSleepHistoryResponse(data: ByteArray) {
        Log.d(TAG, "Sleep history received: ${data.size} bytes")
        sendEvent("sleepHistory", mapOf("data" to data.toHexString()))
    }

    private fun parseSportHistoryResponse(data: ByteArray) {
        Log.d(TAG, "Sport history received: ${data.size} bytes")
        sendEvent("sportHistory", mapOf("data" to data.toHexString()))
    }

    private fun parseRealTimeMeasureResponse(data: ByteArray) {
        try {
            if (data.size >= 6) {
                val measureType = data[4].toInt() and 0xFF
                val value = data[5].toInt() and 0xFF

                Log.d(TAG, "Real-time measure: type=$measureType, value=$value")
                sendEvent("realTimeMeasure", mapOf(
                    "type" to measureType,
                    "value" to value
                ))
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error parsing real-time measure response", e)
        }
    }

    private fun parseHeartRateControlResponse(data: ByteArray) {
        try {
            if (data.size >= 6) {
                val enabled = (data[4].toInt() and 0xFF) == 1
                val interval = data[5].toInt() and 0xFF

                Log.d(TAG, "HR control: enabled=$enabled, interval=$interval min")
                sendEvent("heartRateControl", mapOf(
                    "enabled" to enabled,
                    "interval" to interval
                ))
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error parsing heart rate control response", e)
        }
    }

    private fun handleFindPhone(data: ByteArray) {
        Log.d(TAG, "Find phone triggered by watch")
        sendEvent("findPhone", mapOf("active" to true))
    }

    private fun parseCameraControl(data: ByteArray) {
        try {
            val action = if (data.size >= 5) data[4].toInt() and 0xFF else 0
            Log.d(TAG, "Camera control: action=$action")
            sendEvent("cameraControl", mapOf("action" to action))
        } catch (e: Exception) {
            Log.e(TAG, "Error parsing camera control", e)
        }
    }

    private fun parseMusicControl(data: ByteArray) {
        try {
            val action = if (data.size >= 5) data[4].toInt() and 0xFF else 0
            Log.d(TAG, "Music control: action=$action")
            sendEvent("musicControl", mapOf("action" to action))
        } catch (e: Exception) {
            Log.e(TAG, "Error parsing music control", e)
        }
    }

    // ==================== HELPER METHODS ====================

    private fun readInt16(data: ByteArray, offset: Int): Int {
        return (data[offset].toInt() and 0xFF) or
                ((data[offset + 1].toInt() and 0xFF) shl 8)
    }

    private fun readInt32(data: ByteArray, offset: Int): Int {
        return (data[offset].toInt() and 0xFF) or
                ((data[offset + 1].toInt() and 0xFF) shl 8) or
                ((data[offset + 2].toInt() and 0xFF) shl 16) or
                ((data[offset + 3].toInt() and 0xFF) shl 24)
    }

    // ==================== COMMAND BUILDERS ====================

    private fun buildCommand(cmd: Byte, data: ByteArray = byteArrayOf()): ByteArray {
        val len = data.size
        val packet = ByteArray(4 + len + 2) // header + cmd + len(2) + data + crc(2)

        packet[0] = Cmd.HEADER
        packet[1] = cmd
        packet[2] = (len and 0xFF).toByte()
        packet[3] = ((len shr 8) and 0xFF).toByte()

        data.copyInto(packet, 4)

        // Calculate CRC
        val crc = calculateCrc(packet.copyOf(4 + len))
        packet[4 + len] = (crc and 0xFF).toByte()
        packet[5 + len] = ((crc shr 8) and 0xFF).toByte()

        return packet
    }

    private fun calculateCrc(data: ByteArray): Int {
        var crc = 0xFFFF
        for (byte in data) {
            crc = crc xor (byte.toInt() and 0xFF)
            for (i in 0 until 8) {
                crc = if (crc and 1 != 0) {
                    (crc shr 1) xor 0xA001
                } else {
                    crc shr 1
                }
            }
        }
        return crc
    }

    // ==================== WATCH INITIALIZATION ====================

    fun initializeWatch(callback: ((Boolean) -> Unit)? = null) {
        Log.d(TAG, "Starting watch initialization sequence...")

        Thread {
            try {
                // Step 1: Get State
                Log.d(TAG, "Init Step 1: Get State")
                sendCommand(buildCommand(Cmd.STATE))
                Thread.sleep(300)

                // Step 2: Get Device Info again
                Log.d(TAG, "Init Step 2: Get Device Info")
                sendCommand(buildCommand(Cmd.STATE))
                Thread.sleep(300)

                // Step 3: Set Device Info (from RunmeFit capture)
                Log.d(TAG, "Init Step 3: Set Device Info")
                val setInfoData = byteArrayOf(0x01, 0x01, 0x00, 0x02, 0x05, 0x28, 0x01)
                sendCommand(buildCommand(Cmd.STATE, setInfoData))
                Thread.sleep(300)

                // Step 4: Pair
                Log.d(TAG, "Init Step 4: Pair")
                sendCommand(buildCommand(Cmd.PAIR, byteArrayOf(0x01)))
                Thread.sleep(500)

                // Step 5: Get State again
                Log.d(TAG, "Init Step 5: Get State")
                sendCommand(buildCommand(Cmd.STATE))
                Thread.sleep(300)

                // Step 6: Set Time
                Log.d(TAG, "Init Step 6: Set Time")
                val calendar = Calendar.getInstance()
                val year = calendar.get(Calendar.YEAR)
                val month = calendar.get(Calendar.MONTH) + 1
                val day = calendar.get(Calendar.DAY_OF_MONTH)
                val hour = calendar.get(Calendar.HOUR_OF_DAY)
                val minute = calendar.get(Calendar.MINUTE)
                val second = calendar.get(Calendar.SECOND)
                val timezone = calendar.get(Calendar.ZONE_OFFSET) / 3600000

                val timeData = byteArrayOf(
                    (year and 0xFF).toByte(),
                    ((year shr 8) and 0xFF).toByte(),
                    month.toByte(),
                    day.toByte(),
                    hour.toByte(),
                    minute.toByte(),
                    second.toByte(),
                    timezone.toByte()
                )
                sendCommand(buildCommand(Cmd.SET_TIME, timeData))
                Thread.sleep(300)

                // Step 7: Command 0x28 (from RunmeFit)
                Log.d(TAG, "Init Step 7: Command 0x28")
                val cmd28 = byteArrayOf(
                    0xDA.toByte(), 0x28, 0x01, 0x00, 0x01,
                    0xC0.toByte(), 0x73
                )
                bleManager.writeData(cmd28)
                Thread.sleep(300)

                // Step 8: Get Device Info
                Log.d(TAG, "Init Step 8: Get Device Info")
                sendCommand(buildCommand(Cmd.STATE))
                Thread.sleep(300)

                // Step 9: Set User Info (sex=1, age=30, height=175, weight=70)
                Log.d(TAG, "Init Step 9: Set User Info")
                val userInfoData = byteArrayOf(0x01, 30, 175.toByte(), 70)
                sendCommand(buildCommand(Cmd.USER_INFO, userInfoData))
                Thread.sleep(300)

                // Step 10: Command 0x3E (from RunmeFit)
                Log.d(TAG, "Init Step 10: Command 0x3E")
                val cmd3E = byteArrayOf(
                    0xDA.toByte(), 0x3E, 0x00, 0x00,
                    0x5A, 0xD4.toByte()
                )
                bleManager.writeData(cmd3E)
                Thread.sleep(300)

                // Step 11: Get Goals
                Log.d(TAG, "Init Step 11: Get Goals")
                sendCommand(buildCommand(Cmd.GOALS))
                Thread.sleep(300)

                // Step 12: Set Goals (10000 steps, 500 calories, 10km)
                Log.d(TAG, "Init Step 12: Set Goals")
                val goalsData = byteArrayOf(
                    0x10, 0x27, 0x00, 0x00,  // 10000 steps
                    0xF4.toByte(), 0x01,      // 500 calories
                    0x0A, 0x00               // 10 km
                )
                sendCommand(buildCommand(Cmd.GOALS, goalsData))
                Thread.sleep(300)

                Log.d(TAG, "Watch initialization sequence complete")

                mainHandler.post {
                    sendEvent("initializationComplete", mapOf("success" to true))
                    callback?.invoke(true)
                }

            } catch (e: Exception) {
                Log.e(TAG, "Error during watch initialization", e)
                mainHandler.post {
                    sendEvent("error", mapOf("message" to "Initialization failed: ${e.message}"))
                    callback?.invoke(false)
                }
            }
        }.start()
    }

    private fun sendCommand(cmd: ByteArray) {
        Log.d(TAG, "Sending: ${cmd.toHexString()}")
        bleManager.writeData(cmd)
    }

    // ==================== SCAN METHODS ====================

    fun startScan() {
        Log.d(TAG, "Starting BLE scan...")
        bleManager.startScan()
    }

    fun stopScan() {
        Log.d(TAG, "Stopping BLE scan...")
        bleManager.stopScan()
    }

    // ==================== CONNECTION METHODS ====================

    fun connect(address: String) {
        Log.d(TAG, "Connecting to device: $address")
        bleManager.connectToDevice(address)
    }

    fun disconnect() {
        Log.d(TAG, "Disconnecting from device")
        bleManager.disconnect()
    }

    fun isConnected(): Boolean = bleManager.isDeviceConnected()

    fun getConnectedDeviceAddress(): String? = bleManager.getConnectedDeviceAddress()

    // ==================== BATTERY ====================

    fun getBattery() {
        Log.d(TAG, "Getting battery info...")
        sendCommand(buildCommand(Cmd.POWER))
    }

    // ==================== HEALTH DATA ====================

    fun getHealthDetail() {
        Log.d(TAG, "Getting health detail...")
        sendCommand(buildCommand(Cmd.HEALTH_DETAIL))
    }

    fun getDeviceState() {
        Log.d(TAG, "Getting device state...")
        sendCommand(buildCommand(Cmd.STATE))
    }

    fun setDeviceState(
        timeFormat: Int,
        unitFormat: Int,
        tempFormat: Int,
        language: Int,
        backlighting: Int,
        screen: Int,
        wristUp: Int
    ) {
        Log.d(TAG, "Setting device state...")
        val data = byteArrayOf(
            timeFormat.toByte(),
            unitFormat.toByte(),
            tempFormat.toByte(),
            language.toByte(),
            backlighting.toByte(),
            screen.toByte(),
            wristUp.toByte()
        )
        sendCommand(buildCommand(Cmd.STATE, data))
    }

    // ==================== DEVICE INFO ====================

    fun getVersion() {
        Log.d(TAG, "Getting version...")
        sendCommand(buildCommand(Cmd.VERSION))
    }

    fun pair() {
        Log.d(TAG, "Sending pair command...")
        sendCommand(buildCommand(Cmd.PAIR, byteArrayOf(0x01)))
    }

    // ==================== TIME ====================

    fun setTime() {
        Log.d(TAG, "Setting time to current...")
        val calendar = Calendar.getInstance()
        val year = calendar.get(Calendar.YEAR)
        val month = calendar.get(Calendar.MONTH) + 1
        val day = calendar.get(Calendar.DAY_OF_MONTH)
        val hour = calendar.get(Calendar.HOUR_OF_DAY)
        val minute = calendar.get(Calendar.MINUTE)
        val second = calendar.get(Calendar.SECOND)
        val timezone = calendar.get(Calendar.ZONE_OFFSET) / 3600000

        val data = byteArrayOf(
            (year and 0xFF).toByte(),
            ((year shr 8) and 0xFF).toByte(),
            month.toByte(),
            day.toByte(),
            hour.toByte(),
            minute.toByte(),
            second.toByte(),
            timezone.toByte()
        )
        sendCommand(buildCommand(Cmd.SET_TIME, data))
    }

    // ==================== USER INFO ====================

    fun getUserInfo() {
        Log.d(TAG, "Getting user info...")
        sendCommand(buildCommand(Cmd.USER_INFO))
    }

    fun setUserInfo(sex: Int, age: Int, height: Int, weight: Int) {
        Log.d(TAG, "Setting user info: sex=$sex, age=$age, height=$height, weight=$weight")
        val data = byteArrayOf(sex.toByte(), age.toByte(), height.toByte(), weight.toByte())
        sendCommand(buildCommand(Cmd.USER_INFO, data))
    }

    // ==================== GOALS ====================

    fun getGoals() {
        Log.d(TAG, "Getting goals...")
        sendCommand(buildCommand(Cmd.GOALS))
    }

    fun setGoals(steps: Int, calories: Int, distance: Int) {
        Log.d(TAG, "Setting goals: steps=$steps, calories=$calories, distance=$distance")
        val data = byteArrayOf(
            (steps and 0xFF).toByte(),
            ((steps shr 8) and 0xFF).toByte(),
            ((steps shr 16) and 0xFF).toByte(),
            ((steps shr 24) and 0xFF).toByte(),
            (calories and 0xFF).toByte(),
            ((calories shr 8) and 0xFF).toByte(),
            (distance and 0xFF).toByte(),
            ((distance shr 8) and 0xFF).toByte()
        )
        sendCommand(buildCommand(Cmd.GOALS, data))
    }

    // ==================== HEALTH MONITORING ====================

    fun getHealthMonitoring() {
        Log.d(TAG, "Getting health monitoring settings...")
        sendCommand(buildCommand(Cmd.HEALTH_OPEN))
    }

    fun setHealthMonitoring(
        heartRate: Boolean,
        bloodPressure: Boolean,
        bloodOxygen: Boolean,
        pressure: Boolean = false,
        temp: Boolean = false,
        bloodSugar: Boolean = false,
        respirationRate: Boolean = false
    ) {
        Log.d(TAG, "Setting health monitoring: HR=$heartRate, BP=$bloodPressure, SpO2=$bloodOxygen")
        val data = byteArrayOf(
            if (heartRate) 1 else 0,
            if (bloodPressure) 1 else 0,
            if (bloodOxygen) 1 else 0,
            if (pressure) 1 else 0,
            if (temp) 1 else 0,
            if (bloodSugar) 1 else 0,
            0, // hasSugar
            if (respirationRate) 1 else 0,
            0  // hasRespirationRate
        )
        sendCommand(buildCommand(Cmd.HEALTH_OPEN, data))
    }

    // ==================== HISTORY DATA ====================

    private fun getHistoryCommand(cmd: Byte, date: Calendar): ByteArray {
        val year = date.get(Calendar.YEAR)
        val month = date.get(Calendar.MONTH) + 1
        val day = date.get(Calendar.DAY_OF_MONTH)

        val data = byteArrayOf(
            (year and 0xFF).toByte(),
            ((year shr 8) and 0xFF).toByte(),
            month.toByte(),
            day.toByte()
        )
        return buildCommand(cmd, data)
    }

    fun getHeartRateHistory(date: Calendar) {
        Log.d(TAG, "Getting heart rate history...")
        sendCommand(getHistoryCommand(Cmd.HEART_RATE_HISTORY, date))
    }

    fun getStepHistory(date: Calendar) {
        Log.d(TAG, "Getting step history...")
        sendCommand(getHistoryCommand(Cmd.STEP_HISTORY, date))
    }

    fun getBloodOxygenHistory(date: Calendar) {
        Log.d(TAG, "Getting blood oxygen history...")
        sendCommand(getHistoryCommand(Cmd.BLOOD_OXYGEN_HISTORY, date))
    }

    fun getBloodPressureHistory(date: Calendar) {
        Log.d(TAG, "Getting blood pressure history...")
        sendCommand(getHistoryCommand(Cmd.BLOOD_PRESSURE_HISTORY, date))
    }

    fun getSleepHistory(date: Calendar) {
        Log.d(TAG, "Getting sleep history...")
        sendCommand(getHistoryCommand(Cmd.SLEEP_HISTORY, date))
    }

    fun getSportHistory() {
        Log.d(TAG, "Getting sport history...")
        sendCommand(buildCommand(Cmd.SPORT_HISTORY))
    }

    // ==================== ALARMS ====================

    fun getAlarms() {
        Log.d(TAG, "Getting alarms...")
        sendCommand(buildCommand(Cmd.CLOCK))
    }

    fun setAlarms(alarms: List<Map<String, Any>>) {
        Log.d(TAG, "Setting alarms: ${alarms.size} alarms")
        // Build alarm data
        val alarmBytes = mutableListOf<Byte>()
        for (alarm in alarms.take(5)) { // Max 5 alarms
            val hour = (alarm["hour"] as? Number)?.toInt() ?: 0
            val minute = (alarm["minute"] as? Number)?.toInt() ?: 0
            val enabled = (alarm["enabled"] as? Boolean) ?: false
            val repeats = (alarm["repeats"] as? List<*>)?.sumOf {
                1 shl ((it as? Number)?.toInt() ?: 0)
            } ?: 0

            alarmBytes.add(hour.toByte())
            alarmBytes.add(minute.toByte())
            alarmBytes.add(if (enabled) 1 else 0)
            alarmBytes.add(repeats.toByte())
        }
        sendCommand(buildCommand(Cmd.CLOCK, alarmBytes.toByteArray()))
    }

    // ==================== DEVICE CONTROL ====================

    fun findDevice(start: Boolean) {
        Log.d(TAG, "Find device: $start")
        sendCommand(buildCommand(Cmd.FIND_DEVICE, byteArrayOf(if (start) 1 else 0)))
    }

    fun cameraControl(enter: Boolean) {
        Log.d(TAG, "Camera control: enter=$enter")
        sendCommand(buildCommand(Cmd.CAMERA, byteArrayOf(if (enter) 1 else 0)))
    }

    fun phoneControl(callerId: String?, callerName: String?, action: Int) {
        Log.d(TAG, "Phone control: action=$action, caller=$callerName")
        if (action == 0 && callerName != null) {
            // Incoming call
            val titleBytes = callerName.toByteArray(Charsets.UTF_8).take(20).toByteArray()
            val contentBytes = (callerId ?: "").toByteArray(Charsets.UTF_8).take(20).toByteArray()

            val data = byteArrayOf(1) + // type = call
                    byteArrayOf(titleBytes.size.toByte()) +
                    titleBytes +
                    byteArrayOf(contentBytes.size.toByte()) +
                    contentBytes

            sendCommand(buildCommand(Cmd.MESSAGE, data))
        }
    }

    fun sendNotification(title: String, content: String, type: Int) {
        Log.d(TAG, "Sending notification: type=$type, title=$title")
        val titleBytes = title.toByteArray(Charsets.UTF_8).take(30).toByteArray()
        val contentBytes = content.toByteArray(Charsets.UTF_8).take(100).toByteArray()

        val data = byteArrayOf(type.toByte()) +
                byteArrayOf(titleBytes.size.toByte()) +
                titleBytes +
                byteArrayOf(contentBytes.size.toByte()) +
                contentBytes

        sendCommand(buildCommand(Cmd.MESSAGE, data))
    }

    fun resetDevice() {
        Log.d(TAG, "Resetting device...")
        sendCommand(buildCommand(Cmd.RESET))
    }

    // ==================== REAL-TIME MEASUREMENT ====================

    fun startHeartRateMeasurement() {
        Log.d(TAG, "Starting heart rate measurement...")
        sendCommand(buildCommand(Cmd.REAL_TIME_MEASURE, byteArrayOf(0x01))) // 1 = heart rate
    }

    fun stopHeartRateMeasurement() {
        Log.d(TAG, "Stopping heart rate measurement...")
        sendCommand(buildCommand(Cmd.REAL_TIME_MEASURE, byteArrayOf(0x00)))
    }

    fun startBloodPressureMeasurement() {
        Log.d(TAG, "Starting blood pressure measurement...")
        sendCommand(buildCommand(Cmd.REAL_TIME_MEASURE, byteArrayOf(0x02))) // 2 = blood pressure
    }

    fun stopBloodPressureMeasurement() {
        Log.d(TAG, "Stopping blood pressure measurement...")
        sendCommand(buildCommand(Cmd.REAL_TIME_MEASURE, byteArrayOf(0x00)))
    }

    fun startBloodOxygenMeasurement() {
        Log.d(TAG, "Starting blood oxygen measurement...")
        sendCommand(buildCommand(Cmd.REAL_TIME_MEASURE, byteArrayOf(0x03))) // 3 = blood oxygen
    }

    fun stopBloodOxygenMeasurement() {
        Log.d(TAG, "Stopping blood oxygen measurement...")
        sendCommand(buildCommand(Cmd.REAL_TIME_MEASURE, byteArrayOf(0x00)))
    }

    // ==================== HEART RATE CONTROL (AUTO MONITORING) ====================

    fun getHeartRateControl() {
        Log.d(TAG, "Getting heart rate control settings...")
        sendCommand(buildCommand(Cmd.HEART_RATE_CONTROL))
    }

    fun setHeartRateControl(enabled: Boolean, interval: Int) {
        Log.d(TAG, "Setting heart rate control: enabled=$enabled, interval=$interval min")
        sendCommand(buildCommand(Cmd.HEART_RATE_CONTROL, byteArrayOf(
            if (enabled) 1 else 0,
            interval.toByte()
        )))
    }

    // ==================== WRAPPER METHODS FOR MethodChannelHandler ====================

    fun getHeartRate() = getHealthDetail()
    fun getSteps() = getHealthDetail()
    fun getBloodOxygen() = getHealthDetail()

    // ==================== RAW COMMAND ====================

    fun sendRawCommand(hexCommand: String) {
        Log.d(TAG, "Sending raw command: $hexCommand")
        try {
            val bytes = hexCommand.replace(" ", "").chunked(2)
                .map { it.toInt(16).toByte() }.toByteArray()
            bleManager.writeData(bytes)
        } catch (e: Exception) {
            Log.e(TAG, "Error parsing raw command", e)
            sendEvent("error", mapOf("message" to "Invalid hex command: ${e.message}"))
        }
    }

    // ==================== EVENT HANDLING ====================

    fun setEventSink(sink: EventChannel.EventSink?) {
        eventSink = sink
    }

    private fun sendEvent(eventName: String, data: Map<String, Any?>) {
        mainHandler.post {
            try {
                eventSink?.success(mapOf(
                    "event" to eventName,
                    "data" to data
                ))
            } catch (e: Exception) {
                Log.e(TAG, "Error sending event: $eventName", e)
            }
        }
    }

    // ==================== CLEANUP ====================

    fun cleanup() {
        bleManager.cleanup()
        eventSink = null
    }

    // ==================== UTILITY ====================

    private fun ByteArray.toHexString(): String = joinToString(" ") { "%02X".format(it) }
}