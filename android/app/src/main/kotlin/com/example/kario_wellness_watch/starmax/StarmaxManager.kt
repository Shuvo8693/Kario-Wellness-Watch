package com.example.kario_wellness_watch.starmax

import android.content.Context
import android.os.Handler
import android.os.Looper
import android.util.Log
import io.flutter.plugin.common.EventChannel
import java.util.Calendar

// Import Starmax SDK classes
import com.starmax.bluetoothsdk.StarmaxSend
import com.starmax.bluetoothsdk.MapStarmaxNotify
import com.starmax.bluetoothsdk.data.NotifyType
import com.starmax.bluetoothsdk.data.CameraControlType
import com.starmax.bluetoothsdk.data.CallControlType

class StarmaxManager(private val context: Context) {

    private val TAG = "StarmaxManager"
    private val bleManager = StarmaxBleManager(context)
    private val mainHandler = Handler(Looper.getMainLooper())

    private var eventSink: EventChannel.EventSink? = null

    // Starmax SDK instances
    private val starmaxSend = StarmaxSend()
    private val mapStarmaxNotify = MapStarmaxNotify()

    init {
        setupBleCallbacks()
    }

    // ==================== PUBLIC API ====================

    fun setEventSink(sink: EventChannel.EventSink?) {
        this.eventSink = sink
    }

    fun startScan(): Boolean {
        return bleManager.startScan()
    }

    fun stopScan() {
        bleManager.stopScan()
    }

    fun connect(deviceAddress: String): Boolean {
        return bleManager.connectToDevice(deviceAddress)
    }

    fun disconnect() {
        bleManager.disconnect()
    }

    fun isConnected(): Boolean {
        return bleManager.isDeviceConnected()
    }

    /**
     * Send raw bytes for testing - useful for debugging communication
     */
    fun sendRawCommand(hexString: String) {
        try {
            val bytes = hexString.replace(" ", "").chunked(2).map { it.toInt(16).toByte() }.toByteArray()
            Log.d(TAG, "Sending raw command: ${bytes.toHexString()}")
            val success = bleManager.writeData(bytes)
            Log.d(TAG, "Raw command write success: $success")
            sendEvent("command", mapOf("type" to "rawCommand", "hex" to hexString, "status" to if (success) "sent" else "failed"))
        } catch (e: Exception) {
            Log.e(TAG, "Raw command error", e)
            sendEvent("error", mapOf("message" to "Raw command failed: ${e.message}"))
        }
    }

    // ==================== STARMAX SDK COMMANDS ====================

    fun pair() {
        try {
            val data = starmaxSend.pair()
            Log.d(TAG, "Sending pair command: ${data.toHexString()}")
            val success = bleManager.writeData(data)
            Log.d(TAG, "Pair command write success: $success")
            sendEvent("command", mapOf("type" to "pair", "status" to if (success) "sent" else "failed"))
        } catch (e: Exception) {
            Log.e(TAG, "Pair error", e)
            sendEvent("error", mapOf("message" to "Pair failed: ${e.message}"))
        }
    }

    fun getDeviceState() {
        try {
            val data = starmaxSend.getState()
            Log.d(TAG, "Sending getState command: ${data.toHexString()}")
            val success = bleManager.writeData(data)
            Log.d(TAG, "GetState command write success: $success")
            sendEvent("command", mapOf("type" to "getState", "status" to if (success) "sent" else "failed"))
        } catch (e: Exception) {
            Log.e(TAG, "Get state error", e)
            sendEvent("error", mapOf("message" to "Get state failed: ${e.message}"))
        }
    }

    fun setDeviceState(
        timeFormat: Int,
        unitFormat: Int,
        tempFormat: Int,
        language: Int,
        backlighting: Int,
        screen: Int,
        wristUp: Boolean
    ) {
        val data = starmaxSend.setState(
            timeFormat, unitFormat, tempFormat,
            language, backlighting, screen, wristUp
        )
        bleManager.writeData(data)
        sendEvent("command", mapOf("type" to "setState", "status" to "sent"))
    }

    fun findDevice(isFind: Boolean) {
        try {
            // According to SDK doc section 6.3, use findPhone for find device functionality
            val data = starmaxSend.findPhone(isFind)
            bleManager.writeData(data)
            sendEvent("command", mapOf("type" to "findDevice", "status" to "sent", "isFind" to isFind))
        } catch (e: Exception) {
            Log.e(TAG, "Find device error", e)
            sendEvent("error", mapOf("message" to "Find device failed: ${e.message}"))
        }
    }

    fun cameraControl(controlType: String) {
        try {
            val type = when(controlType) {
                "cameraIn" -> CameraControlType.CameraIn
                "cameraExit" -> CameraControlType.CameraExit
                "takePhoto" -> CameraControlType.TakePhoto
                else -> {
                    sendEvent("error", mapOf("message" to "Unknown camera control type: $controlType"))
                    return
                }
            }
            val data = starmaxSend.cameraControl(type)
            bleManager.writeData(data)
            sendEvent("command", mapOf("type" to "cameraControl", "controlType" to controlType, "status" to "sent"))
        } catch (e: Exception) {
            Log.e(TAG, "Camera control error", e)
            sendEvent("error", mapOf("message" to "Camera control failed: ${e.message}"))
        }
    }

    fun phoneControl(controlType: String, number: String, isNumber: Boolean) {
        try {
            val type = when(controlType) {
                "hangUp" -> CallControlType.HangUp
                "answer" -> CallControlType.Answer
                "incoming" -> CallControlType.Incoming
                "exit" -> CallControlType.Exit
                else -> {
                    sendEvent("error", mapOf("message" to "Unknown call control type: $controlType"))
                    return
                }
            }
            val data = starmaxSend.phoneControl(type, number, isNumber)
            bleManager.writeData(data)
            sendEvent("command", mapOf(
                "type" to "phoneControl",
                "controlType" to controlType,
                "number" to number,
                "status" to "sent"
            ))
        } catch (e: Exception) {
            Log.e(TAG, "Phone control error", e)
            sendEvent("error", mapOf("message" to "Phone control failed: ${e.message}"))
        }
    }

    fun getBattery() {
        try {
            val data = starmaxSend.getPower()
            Log.d(TAG, "Sending getBattery command: ${data.toHexString()}")
            val success = bleManager.writeData(data)
            Log.d(TAG, "GetBattery command write success: $success")
            sendEvent("command", mapOf("type" to "getPower", "status" to if (success) "sent" else "failed"))
        } catch (e: Exception) {
            Log.e(TAG, "Get battery error", e)
            sendEvent("error", mapOf("message" to "Get battery failed: ${e.message}"))
        }
    }

    fun getVersion() {
        try {
            val data = starmaxSend.getVersion()
            bleManager.writeData(data)
            sendEvent("command", mapOf("type" to "getVersion", "status" to "sent"))
        } catch (e: Exception) {
            Log.e(TAG, "Get version error", e)
            sendEvent("error", mapOf("message" to "Get version failed: ${e.message}"))
        }
    }

    fun setTime() {
        try {
            val data = starmaxSend.setTime()
            bleManager.writeData(data)
            sendEvent("command", mapOf("type" to "setTime", "status" to "sent"))
        } catch (e: Exception) {
            Log.e(TAG, "Set time error", e)
            sendEvent("error", mapOf("message" to "Set time failed: ${e.message}"))
        }
    }

    fun setUserInfo(sex: Int, age: Int, height: Int, weight: Int) {
        try {
            val data = starmaxSend.setUserInfo(sex, age, height, weight)
            bleManager.writeData(data)
            sendEvent("command", mapOf(
                "type" to "setUserInfo",
                "sex" to sex,
                "age" to age,
                "height" to height,
                "weight" to weight,
                "status" to "sent"
            ))
        } catch (e: Exception) {
            Log.e(TAG, "Set user info error", e)
            sendEvent("error", mapOf("message" to "Set user info failed: ${e.message}"))
        }
    }

    fun getGoals() {
        try {
            val data = starmaxSend.getGoals()
            bleManager.writeData(data)
            sendEvent("command", mapOf("type" to "getGoals", "status" to "sent"))
        } catch (e: Exception) {
            Log.e(TAG, "Get goals error", e)
            sendEvent("error", mapOf("message" to "Get goals failed: ${e.message}"))
        }
    }

    // ==================== HEALTH DATA ====================

    /**
     * Get current health detail from device
     * This includes: steps, calories, distance, sleep, heart rate, blood pressure,
     * blood oxygen, pressure, MET, MAI, temperature, blood sugar, and wear status
     * SDK Section 6.11
     */
    fun getHealthDetail() {
        try {
            val data = starmaxSend.getHealthDetail()
            Log.d(TAG, "Sending getHealthDetail command: ${data.toHexString()}")
            val success = bleManager.writeData(data)
            Log.d(TAG, "GetHealthDetail command write success: $success")
            sendEvent("command", mapOf("type" to "getHealthDetail", "status" to if (success) "sent" else "failed"))
        } catch (e: Exception) {
            Log.e(TAG, "Get health detail error", e)
            sendEvent("error", mapOf("message" to "Get health detail failed: ${e.message}"))
        }
    }

    /**
     * Get heart rate - uses getHealthDetail which includes current_heart_rate
     * For real-time heart rate, use getHealthDetail()
     */
    fun getHeartRate() {
        try {
            // Use getHealthDetail which contains current_heart_rate field
            val data = starmaxSend.getHealthDetail()
            bleManager.writeData(data)
            sendEvent("command", mapOf("type" to "getHeartRate", "status" to "sent"))
        } catch (e: Exception) {
            Log.e(TAG, "Get heart rate error", e)
            sendEvent("error", mapOf("message" to "Get heart rate failed: ${e.message}"))
        }
    }

    /**
     * Get steps - uses getHealthDetail which includes total_steps
     * For real-time steps, use getHealthDetail()
     */
    fun getSteps() {
        try {
            // Use getHealthDetail which contains total_steps field
            val data = starmaxSend.getHealthDetail()
            bleManager.writeData(data)
            sendEvent("command", mapOf("type" to "getSteps", "status" to "sent"))
        } catch (e: Exception) {
            Log.e(TAG, "Get steps error", e)
            sendEvent("error", mapOf("message" to "Get steps failed: ${e.message}"))
        }
    }

    /**
     * Get blood oxygen - uses getHealthDetail which includes current_blood_oxygen
     * For real-time blood oxygen, use getHealthDetail()
     */
    fun getBloodOxygen() {
        try {
            // Use getHealthDetail which contains current_blood_oxygen field
            val data = starmaxSend.getHealthDetail()
            bleManager.writeData(data)
            sendEvent("command", mapOf("type" to "getBloodOxygen", "status" to "sent"))
        } catch (e: Exception) {
            Log.e(TAG, "Get blood oxygen error", e)
            sendEvent("error", mapOf("message" to "Get blood oxygen failed: ${e.message}"))
        }
    }

    // ==================== HISTORICAL DATA ====================

    /**
     * Get heart rate history for a specific date
     * SDK Section 6.27
     */
    fun getHeartRateHistory(year: Int, month: Int, day: Int) {
        try {
            val calendar = Calendar.getInstance().apply {
                set(Calendar.YEAR, year)
                set(Calendar.MONTH, month - 1) // Calendar months are 0-based
                set(Calendar.DAY_OF_MONTH, day)
            }
            val data = starmaxSend.getHeartRateHistory(calendar)
            bleManager.writeData(data)
            sendEvent("command", mapOf(
                "type" to "getHeartRateHistory",
                "year" to year,
                "month" to month,
                "day" to day,
                "status" to "sent"
            ))
        } catch (e: Exception) {
            Log.e(TAG, "Get heart rate history error", e)
            sendEvent("error", mapOf("message" to "Get heart rate history failed: ${e.message}"))
        }
    }

    /**
     * Get step history for a specific date
     * SDK Section 6.26
     */
    fun getStepHistory(year: Int, month: Int, day: Int) {
        try {
            val calendar = Calendar.getInstance().apply {
                set(Calendar.YEAR, year)
                set(Calendar.MONTH, month - 1)
                set(Calendar.DAY_OF_MONTH, day)
            }
            val data = starmaxSend.getStepHistory(calendar)
            bleManager.writeData(data)
            sendEvent("command", mapOf(
                "type" to "getStepHistory",
                "year" to year,
                "month" to month,
                "day" to day,
                "status" to "sent"
            ))
        } catch (e: Exception) {
            Log.e(TAG, "Get step history error", e)
            sendEvent("error", mapOf("message" to "Get step history failed: ${e.message}"))
        }
    }

    /**
     * Get blood oxygen history for a specific date
     * SDK Section 6.29
     */
    fun getBloodOxygenHistory(year: Int, month: Int, day: Int) {
        try {
            val calendar = Calendar.getInstance().apply {
                set(Calendar.YEAR, year)
                set(Calendar.MONTH, month - 1)
                set(Calendar.DAY_OF_MONTH, day)
            }
            val data = starmaxSend.getBloodOxygenHistory(calendar)
            bleManager.writeData(data)
            sendEvent("command", mapOf(
                "type" to "getBloodOxygenHistory",
                "year" to year,
                "month" to month,
                "day" to day,
                "status" to "sent"
            ))
        } catch (e: Exception) {
            Log.e(TAG, "Get blood oxygen history error", e)
            sendEvent("error", mapOf("message" to "Get blood oxygen history failed: ${e.message}"))
        }
    }

    /**
     * Get blood pressure history for a specific date
     * SDK Section 6.28
     */
    fun getBloodPressureHistory(year: Int, month: Int, day: Int) {
        try {
            val calendar = Calendar.getInstance().apply {
                set(Calendar.YEAR, year)
                set(Calendar.MONTH, month - 1)
                set(Calendar.DAY_OF_MONTH, day)
            }
            val data = starmaxSend.getBloodPressureHistory(calendar)
            bleManager.writeData(data)
            sendEvent("command", mapOf(
                "type" to "getBloodPressureHistory",
                "year" to year,
                "month" to month,
                "day" to day,
                "status" to "sent"
            ))
        } catch (e: Exception) {
            Log.e(TAG, "Get blood pressure history error", e)
            sendEvent("error", mapOf("message" to "Get blood pressure history failed: ${e.message}"))
        }
    }

    /**
     * Get sleep history for a specific date
     * SDK Section 6.41
     */
    fun getSleepHistory(year: Int, month: Int, day: Int) {
        try {
            val calendar = Calendar.getInstance().apply {
                set(Calendar.YEAR, year)
                set(Calendar.MONTH, month - 1)
                set(Calendar.DAY_OF_MONTH, day)
            }
            val data = starmaxSend.getSleepHistory(calendar)
            bleManager.writeData(data)
            sendEvent("command", mapOf(
                "type" to "getSleepHistory",
                "year" to year,
                "month" to month,
                "day" to day,
                "status" to "sent"
            ))
        } catch (e: Exception) {
            Log.e(TAG, "Get sleep history error", e)
            sendEvent("error", mapOf("message" to "Get sleep history failed: ${e.message}"))
        }
    }

    /**
     * Get sport/exercise history
     * SDK Section 6.25
     */
    fun getSportHistory() {
        try {
            val data = starmaxSend.getSportHistory()
            bleManager.writeData(data)
            sendEvent("command", mapOf("type" to "getSportHistory", "status" to "sent"))
        } catch (e: Exception) {
            Log.e(TAG, "Get sport history error", e)
            sendEvent("error", mapOf("message" to "Get sport history failed: ${e.message}"))
        }
    }

    // ==================== HEALTH SETTINGS ====================

    /**
     * Get health data detection switch status
     * SDK Section 6.12.1
     */
    fun getHealthOpen() {
        try {
            val data = starmaxSend.getHealthOpen()
            bleManager.writeData(data)
            sendEvent("command", mapOf("type" to "getHealthOpen", "status" to "sent"))
        } catch (e: Exception) {
            Log.e(TAG, "Get health open error", e)
            sendEvent("error", mapOf("message" to "Get health open failed: ${e.message}"))
        }
    }

    /**
     * Set health data detection switches
     * SDK Section 6.12.2
     */
    fun setHealthOpen(
        heartRate: Boolean,
        bloodPressure: Boolean,
        bloodOxygen: Boolean,
        pressure: Boolean,
        temp: Boolean,
        bloodSugar: Boolean
    ) {
        try {
            val data = starmaxSend.setHealthOpen(
                heartRate, bloodPressure, bloodOxygen,
                pressure, temp, bloodSugar
            )
            bleManager.writeData(data)
            sendEvent("command", mapOf(
                "type" to "setHealthOpen",
                "heartRate" to heartRate,
                "bloodPressure" to bloodPressure,
                "bloodOxygen" to bloodOxygen,
                "pressure" to pressure,
                "temp" to temp,
                "bloodSugar" to bloodSugar,
                "status" to "sent"
            ))
        } catch (e: Exception) {
            Log.e(TAG, "Set health open error", e)
            sendEvent("error", mapOf("message" to "Set health open failed: ${e.message}"))
        }
    }

    /**
     * Get heart rate detection interval and range
     * SDK Section 6.14.1
     */
    fun getHeartRateControl() {
        try {
            val data = starmaxSend.getHeartRateControl()
            bleManager.writeData(data)
            sendEvent("command", mapOf("type" to "getHeartRateControl", "status" to "sent"))
        } catch (e: Exception) {
            Log.e(TAG, "Get heart rate control error", e)
            sendEvent("error", mapOf("message" to "Get heart rate control failed: ${e.message}"))
        }
    }

    /**
     * Set heart rate detection interval and range
     * SDK Section 6.14.2
     */
    fun setHeartRateControl(
        startHour: Int,
        startMinute: Int,
        endHour: Int,
        endMinute: Int,
        period: Int,
        alarmThreshold: Int
    ) {
        try {
            val data = starmaxSend.setHeartRateControl(
                startHour, startMinute, endHour, endMinute, period, alarmThreshold
            )
            bleManager.writeData(data)
            sendEvent("command", mapOf(
                "type" to "setHeartRateControl",
                "status" to "sent"
            ))
        } catch (e: Exception) {
            Log.e(TAG, "Set heart rate control error", e)
            sendEvent("error", mapOf("message" to "Set heart rate control failed: ${e.message}"))
        }
    }

    // ==================== DEVICE MANAGEMENT ====================

    /**
     * Reset device to factory settings
     * SDK Section 6.13
     */
    fun reset() {
        try {
            val data = starmaxSend.reset()
            bleManager.writeData(data)
            sendEvent("command", mapOf("type" to "reset", "status" to "sent"))
        } catch (e: Exception) {
            Log.e(TAG, "Reset error", e)
            sendEvent("error", mapOf("message" to "Reset failed: ${e.message}"))
        }
    }

    fun cleanup() {
        bleManager.cleanup()
        eventSink = null
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
                sendEvent("connectionStatus", mapOf(
                    "status" to if (connected) "connected" else "disconnected"
                ))
            },
            onDataReceived = { data ->
                handleReceivedData(data)
            },
            onError = { message ->
                sendEvent("error", mapOf("message" to message))
            }
        )
    }

    private fun handleReceivedData(byteArray: ByteArray) {
        Log.d(TAG, "Received data: ${byteArray.toHexString()} (${byteArray.size} bytes)")

        try {
            // Parse the response using the SDK
            val response = mapStarmaxNotify.notify(byteArray)

            Log.d(TAG, "Parsed response type: ${response.type}, obj: ${response.obj}")

            // Check for errors first
            when (response.type) {
                NotifyType.CrcFailure -> {
                    Log.e(TAG, "CRC check error")
                    sendEvent("error", mapOf("message" to "CRC check error"))
                    return
                }
                NotifyType.Failure -> {
                    Log.e(TAG, "Command failed")
                    sendEvent("error", mapOf("message" to "Command failed"))
                    return
                }
                else -> {
                    // Process the response based on type
                    val responseData = mutableMapOf<String, Any?>(
                        "notifyType" to response.type.name
                    )

                    // Add the parsed object data if available
                    response.obj?.let { obj ->
                        Log.d(TAG, "Response obj class: ${obj::class.java.name}")
                        when (obj) {
                            is Map<*, *> -> {
                                @Suppress("UNCHECKED_CAST")
                                responseData.putAll(obj as Map<String, Any?>)
                                Log.d(TAG, "Response map data: $obj")
                            }
                            else -> {
                                responseData["rawObj"] = obj.toString()
                                Log.d(TAG, "Response raw obj: $obj")
                            }
                        }
                    }

                    // Send specific events based on notify type
                    when (response.type) {
                        NotifyType.Power -> {
                            sendEvent("batteryInfo", responseData)
                        }
                        NotifyType.Version -> {
                            sendEvent("versionInfo", responseData)
                        }
                        NotifyType.HealthDetail -> {
                            sendEvent("healthData", responseData)
                        }
                        NotifyType.Pair -> {
                            sendEvent("pairResult", responseData)
                        }
                        NotifyType.HeartRateHistory,
                        NotifyType.StepHistory,
                        NotifyType.BloodOxygenHistory,
                        NotifyType.BloodPressureHistory,
                        NotifyType.SleepHistory -> {
                            sendEvent("historyData", responseData)
                        }
                        else -> {
                            sendEvent("dataReceived", responseData)
                        }
                    }
                }
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error parsing received data: ${e.message}", e)
            // Send raw data if parsing fails
            sendEvent("rawData", mapOf(
                "size" to byteArray.size,
                "hex" to byteArray.toHexString(),
                "parseError" to e.message
            ))
        }
    }

    // ==================== HELPER METHODS ====================

    private fun sendEvent(type: String, data: Map<String, Any?>?) {
        mainHandler.post {
            val eventData = mutableMapOf<String, Any?>("type" to type)
            data?.let { eventData.putAll(it) }
            eventSink?.success(eventData)
        }
    }

    private fun ByteArray.toHexString(): String {
        return joinToString("") { "%02x".format(it) }
    }
}