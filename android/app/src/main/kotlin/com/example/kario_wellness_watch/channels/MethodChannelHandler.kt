package com.example.kario_wellness_watch.channels

import com.example.kario_wellness_watch.starmax.StarmaxManager
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.util.Calendar

class MethodChannelHandler(
    private val starmaxManager: StarmaxManager
) : MethodChannel.MethodCallHandler {

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            // ==================== SCANNING ====================
            "startScan" -> {
                starmaxManager.startScan()
                result.success(true)
            }

            "stopScan" -> {
                starmaxManager.stopScan()
                result.success(true)
            }

            // ==================== CONNECTION ====================
            "connect" -> {
                val address = call.argument<String>("address")
                if (address != null) {
                    starmaxManager.connect(address)
                    result.success(true)
                } else {
                    result.error("INVALID_ARGS", "Device address required", null)
                }
            }

            "disconnect" -> {
                starmaxManager.disconnect()
                result.success(true)
            }

            "isConnected" -> {
                val connected = starmaxManager.isConnected()
                result.success(connected)
            }

            // ==================== INITIALIZATION ====================
            "initializeWatch" -> {
                starmaxManager.initializeWatch { success ->
                    // Callback handled via events
                }
                result.success(true)
            }

            // ==================== PAIRING ====================
            "pair" -> {
                starmaxManager.pair()
                result.success(true)
            }

            // ==================== DEVICE STATE ====================
            "getDeviceState" -> {
                starmaxManager.getDeviceState()
                result.success(true)
            }

            "setDeviceState" -> {
                try {
                    val timeFormat = call.argument<Int>("timeFormat") ?: 0
                    val unitFormat = call.argument<Int>("unitFormat") ?: 0
                    val tempFormat = call.argument<Int>("tempFormat") ?: 0
                    val language = call.argument<Int>("language") ?: 2
                    val backlighting = call.argument<Int>("backlighting") ?: 5
                    val screen = call.argument<Int>("screen") ?: 50
                    val wristUp = call.argument<Int>("wristUp") ?: 1

                    starmaxManager.setDeviceState(
                        timeFormat, unitFormat, tempFormat,
                        language, backlighting, screen, wristUp
                    )
                    result.success(true)
                } catch (e: Exception) {
                    result.error("INVALID_ARGS", "Invalid arguments: ${e.message}", null)
                }
            }

            // ==================== FIND DEVICE ====================
            "findDevice" -> {
                val isFind = call.argument<Boolean>("isFind") ?: true
                starmaxManager.findDevice(isFind)
                result.success(true)
            }

            // ==================== CAMERA CONTROL ====================
            "cameraControl" -> {
                val enter = call.argument<Boolean>("enter") ?: true
                starmaxManager.cameraControl(enter)
                result.success(true)
            }

            // ==================== PHONE CONTROL ====================
            "phoneControl" -> {
                val callerId = call.argument<String>("callerId")
                val callerName = call.argument<String>("callerName")
                val action = call.argument<Int>("action") ?: 0

                starmaxManager.phoneControl(callerId, callerName, action)
                result.success(true)
            }

            // ==================== NOTIFICATIONS ====================
            "sendNotification" -> {
                val title = call.argument<String>("title") ?: ""
                val content = call.argument<String>("content") ?: ""
                val type = call.argument<Int>("type") ?: 0

                starmaxManager.sendNotification(title, content, type)
                result.success(true)
            }

            // ==================== BATTERY ====================
            "getBattery" -> {
                starmaxManager.getBattery()
                result.success(true)
            }

            // ==================== VERSION ====================
            "getVersion" -> {
                starmaxManager.getVersion()
                result.success(true)
            }

            // ==================== TIME ====================
            "setTime" -> {
                starmaxManager.setTime()
                result.success(true)
            }

            // ==================== USER INFO ====================
            "getUserInfo" -> {
                starmaxManager.getUserInfo()
                result.success(true)
            }

            "setUserInfo" -> {
                try {
                    val sex = call.argument<Int>("sex") ?: 1
                    val age = call.argument<Int>("age") ?: 30
                    val height = call.argument<Int>("height") ?: 170
                    val weight = call.argument<Int>("weight") ?: 70

                    starmaxManager.setUserInfo(sex, age, height, weight)
                    result.success(true)
                } catch (e: Exception) {
                    result.error("INVALID_ARGS", "Invalid arguments: ${e.message}", null)
                }
            }

            // ==================== GOALS ====================
            "getGoals" -> {
                starmaxManager.getGoals()
                result.success(true)
            }

            "setGoals" -> {
                try {
                    val steps = call.argument<Int>("steps") ?: 10000
                    val calories = call.argument<Int>("calories") ?: 500
                    val distance = call.argument<Int>("distance") ?: 10

                    starmaxManager.setGoals(steps, calories, distance)
                    result.success(true)
                } catch (e: Exception) {
                    result.error("INVALID_ARGS", "Invalid arguments: ${e.message}", null)
                }
            }

            // ==================== HEALTH DATA ====================
            "getHealthDetail" -> {
                starmaxManager.getHealthDetail()
                result.success(true)
            }

            "getHeartRate" -> {
                starmaxManager.getHeartRate()
                result.success(true)
            }

            "getSteps" -> {
                starmaxManager.getSteps()
                result.success(true)
            }

            "getBloodOxygen" -> {
                starmaxManager.getBloodOxygen()
                result.success(true)
            }

            // ==================== HISTORICAL DATA ====================
            "getHeartRateHistory" -> {
                try {
                    val year = call.argument<Int>("year") ?: Calendar.getInstance().get(Calendar.YEAR)
                    val month = call.argument<Int>("month") ?: (Calendar.getInstance().get(Calendar.MONTH) + 1)
                    val day = call.argument<Int>("day") ?: Calendar.getInstance().get(Calendar.DAY_OF_MONTH)

                    val calendar = Calendar.getInstance().apply {
                        set(Calendar.YEAR, year)
                        set(Calendar.MONTH, month - 1)
                        set(Calendar.DAY_OF_MONTH, day)
                    }
                    starmaxManager.getHeartRateHistory(calendar)
                    result.success(true)
                } catch (e: Exception) {
                    result.error("INVALID_ARGS", "Invalid arguments: ${e.message}", null)
                }
            }

            "getStepHistory" -> {
                try {
                    val year = call.argument<Int>("year") ?: Calendar.getInstance().get(Calendar.YEAR)
                    val month = call.argument<Int>("month") ?: (Calendar.getInstance().get(Calendar.MONTH) + 1)
                    val day = call.argument<Int>("day") ?: Calendar.getInstance().get(Calendar.DAY_OF_MONTH)

                    val calendar = Calendar.getInstance().apply {
                        set(Calendar.YEAR, year)
                        set(Calendar.MONTH, month - 1)
                        set(Calendar.DAY_OF_MONTH, day)
                    }
                    starmaxManager.getStepHistory(calendar)
                    result.success(true)
                } catch (e: Exception) {
                    result.error("INVALID_ARGS", "Invalid arguments: ${e.message}", null)
                }
            }

            "getBloodOxygenHistory" -> {
                try {
                    val year = call.argument<Int>("year") ?: Calendar.getInstance().get(Calendar.YEAR)
                    val month = call.argument<Int>("month") ?: (Calendar.getInstance().get(Calendar.MONTH) + 1)
                    val day = call.argument<Int>("day") ?: Calendar.getInstance().get(Calendar.DAY_OF_MONTH)

                    val calendar = Calendar.getInstance().apply {
                        set(Calendar.YEAR, year)
                        set(Calendar.MONTH, month - 1)
                        set(Calendar.DAY_OF_MONTH, day)
                    }
                    starmaxManager.getBloodOxygenHistory(calendar)
                    result.success(true)
                } catch (e: Exception) {
                    result.error("INVALID_ARGS", "Invalid arguments: ${e.message}", null)
                }
            }

            "getBloodPressureHistory" -> {
                try {
                    val year = call.argument<Int>("year") ?: Calendar.getInstance().get(Calendar.YEAR)
                    val month = call.argument<Int>("month") ?: (Calendar.getInstance().get(Calendar.MONTH) + 1)
                    val day = call.argument<Int>("day") ?: Calendar.getInstance().get(Calendar.DAY_OF_MONTH)

                    val calendar = Calendar.getInstance().apply {
                        set(Calendar.YEAR, year)
                        set(Calendar.MONTH, month - 1)
                        set(Calendar.DAY_OF_MONTH, day)
                    }
                    starmaxManager.getBloodPressureHistory(calendar)
                    result.success(true)
                } catch (e: Exception) {
                    result.error("INVALID_ARGS", "Invalid arguments: ${e.message}", null)
                }
            }

            "getSleepHistory" -> {
                try {
                    val year = call.argument<Int>("year") ?: Calendar.getInstance().get(Calendar.YEAR)
                    val month = call.argument<Int>("month") ?: (Calendar.getInstance().get(Calendar.MONTH) + 1)
                    val day = call.argument<Int>("day") ?: Calendar.getInstance().get(Calendar.DAY_OF_MONTH)

                    val calendar = Calendar.getInstance().apply {
                        set(Calendar.YEAR, year)
                        set(Calendar.MONTH, month - 1)
                        set(Calendar.DAY_OF_MONTH, day)
                    }
                    starmaxManager.getSleepHistory(calendar)
                    result.success(true)
                } catch (e: Exception) {
                    result.error("INVALID_ARGS", "Invalid arguments: ${e.message}", null)
                }
            }

            "getSportHistory" -> {
                starmaxManager.getSportHistory()
                result.success(true)
            }

            // ==================== HEALTH MONITORING SETTINGS ====================
            "getHealthMonitoring" -> {
                starmaxManager.getHealthMonitoring()
                result.success(true)
            }

            "setHealthMonitoring" -> {
                try {
                    val heartRate = call.argument<Boolean>("heartRate") ?: true
                    val bloodPressure = call.argument<Boolean>("bloodPressure") ?: true
                    val bloodOxygen = call.argument<Boolean>("bloodOxygen") ?: true
                    val pressure = call.argument<Boolean>("pressure") ?: false
                    val temp = call.argument<Boolean>("temp") ?: false
                    val bloodSugar = call.argument<Boolean>("bloodSugar") ?: false
                    val respirationRate = call.argument<Boolean>("respirationRate") ?: false

                    starmaxManager.setHealthMonitoring(
                        heartRate, bloodPressure, bloodOxygen,
                        pressure, temp, bloodSugar, respirationRate
                    )
                    result.success(true)
                } catch (e: Exception) {
                    result.error("INVALID_ARGS", "Invalid arguments: ${e.message}", null)
                }
            }

            // Legacy names for backwards compatibility
            "getHealthOpen" -> {
                starmaxManager.getHealthMonitoring()
                result.success(true)
            }

            "setHealthOpen" -> {
                try {
                    val heartRate = call.argument<Boolean>("heartRate") ?: true
                    val bloodPressure = call.argument<Boolean>("bloodPressure") ?: true
                    val bloodOxygen = call.argument<Boolean>("bloodOxygen") ?: true
                    val pressure = call.argument<Boolean>("pressure") ?: false
                    val temp = call.argument<Boolean>("temp") ?: false
                    val bloodSugar = call.argument<Boolean>("bloodSugar") ?: false

                    starmaxManager.setHealthMonitoring(
                        heartRate, bloodPressure, bloodOxygen,
                        pressure, temp, bloodSugar
                    )
                    result.success(true)
                } catch (e: Exception) {
                    result.error("INVALID_ARGS", "Invalid arguments: ${e.message}", null)
                }
            }

            // ==================== HEART RATE CONTROL ====================
            "getHeartRateControl" -> {
                starmaxManager.getHeartRateControl()
                result.success(true)
            }

            "setHeartRateControl" -> {
                try {
                    val enabled = call.argument<Boolean>("enabled") ?: true
                    val interval = call.argument<Int>("interval") ?: 60

                    starmaxManager.setHeartRateControl(enabled, interval)
                    result.success(true)
                } catch (e: Exception) {
                    result.error("INVALID_ARGS", "Invalid arguments: ${e.message}", null)
                }
            }

            // ==================== REAL-TIME MEASUREMENTS ====================
            "startHeartRateMeasurement" -> {
                starmaxManager.startHeartRateMeasurement()
                result.success(true)
            }

            "stopHeartRateMeasurement" -> {
                starmaxManager.stopHeartRateMeasurement()
                result.success(true)
            }

            "startBloodPressureMeasurement" -> {
                starmaxManager.startBloodPressureMeasurement()
                result.success(true)
            }

            "stopBloodPressureMeasurement" -> {
                starmaxManager.stopBloodPressureMeasurement()
                result.success(true)
            }

            "startBloodOxygenMeasurement" -> {
                starmaxManager.startBloodOxygenMeasurement()
                result.success(true)
            }

            "stopBloodOxygenMeasurement" -> {
                starmaxManager.stopBloodOxygenMeasurement()
                result.success(true)
            }

            // ==================== ALARMS ====================
            "getAlarms" -> {
                starmaxManager.getAlarms()
                result.success(true)
            }

            "setAlarms" -> {
                try {
                    @Suppress("UNCHECKED_CAST")
                    val alarms = call.argument<List<Map<String, Any>>>("alarms") ?: listOf()
                    starmaxManager.setAlarms(alarms)
                    result.success(true)
                } catch (e: Exception) {
                    result.error("INVALID_ARGS", "Invalid arguments: ${e.message}", null)
                }
            }

            // ==================== DEVICE MANAGEMENT ====================
            "resetDevice" -> {
                starmaxManager.resetDevice()
                result.success(true)
            }

            // Legacy name
            "reset" -> {
                starmaxManager.resetDevice()
                result.success(true)
            }

            // ==================== RAW COMMAND ====================
            "sendRawCommand" -> {
                val hex = call.argument<String>("hex")
                if (hex != null) {
                    starmaxManager.sendRawCommand(hex)
                    result.success(true)
                } else {
                    result.error("INVALID_ARGS", "Hex string required", null)
                }
            }

            else -> result.notImplemented()
        }
    }
}