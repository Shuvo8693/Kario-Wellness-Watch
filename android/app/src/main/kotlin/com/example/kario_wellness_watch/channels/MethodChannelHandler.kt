package com.example.kario_wellness_watch.channels

import com.example.kario_wellness_watch.starmax.StarmaxManager
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MethodChannelHandler(
    private val starmaxManager: StarmaxManager
) : MethodChannel.MethodCallHandler {

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            // ==================== SCANNING ====================
            "startScan" -> {
                val success = starmaxManager.startScan()
                result.success(success)
            }

            "stopScan" -> {
                starmaxManager.stopScan()
                result.success(true)
            }

            // ==================== CONNECTION ====================
            "connect" -> {
                val address = call.argument<String>("address")
                if (address != null) {
                    val success = starmaxManager.connect(address)
                    result.success(success)
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
                    val wristUp = call.argument<Boolean>("wristUp") ?: false

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
                val controlType = call.argument<String>("controlType")
                if (controlType != null) {
                    starmaxManager.cameraControl(controlType)
                    result.success(true)
                } else {
                    result.error("INVALID_ARGS", "Control type required", null)
                }
            }

            // ==================== PHONE CONTROL ====================
            "phoneControl" -> {
                val controlType = call.argument<String>("controlType")
                val number = call.argument<String>("number") ?: ""
                val isNumber = call.argument<Boolean>("isNumber") ?: true

                if (controlType != null) {
                    starmaxManager.phoneControl(controlType, number, isNumber)
                    result.success(true)
                } else {
                    result.error("INVALID_ARGS", "Control type required", null)
                }
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
            "setUserInfo" -> {
                try {
                    val sex = call.argument<Int>("sex") ?: 1
                    val age = call.argument<Int>("age") ?: 30
                    val height = call.argument<Int>("height") ?: 170
                    val weight = call.argument<Int>("weight") ?: 700

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
                    val year = call.argument<Int>("year") ?: 2024
                    val month = call.argument<Int>("month") ?: 1
                    val day = call.argument<Int>("day") ?: 1
                    starmaxManager.getHeartRateHistory(year, month, day)
                    result.success(true)
                } catch (e: Exception) {
                    result.error("INVALID_ARGS", "Invalid arguments: ${e.message}", null)
                }
            }

            "getStepHistory" -> {
                try {
                    val year = call.argument<Int>("year") ?: 2024
                    val month = call.argument<Int>("month") ?: 1
                    val day = call.argument<Int>("day") ?: 1
                    starmaxManager.getStepHistory(year, month, day)
                    result.success(true)
                } catch (e: Exception) {
                    result.error("INVALID_ARGS", "Invalid arguments: ${e.message}", null)
                }
            }

            "getBloodOxygenHistory" -> {
                try {
                    val year = call.argument<Int>("year") ?: 2024
                    val month = call.argument<Int>("month") ?: 1
                    val day = call.argument<Int>("day") ?: 1
                    starmaxManager.getBloodOxygenHistory(year, month, day)
                    result.success(true)
                } catch (e: Exception) {
                    result.error("INVALID_ARGS", "Invalid arguments: ${e.message}", null)
                }
            }

            "getBloodPressureHistory" -> {
                try {
                    val year = call.argument<Int>("year") ?: 2024
                    val month = call.argument<Int>("month") ?: 1
                    val day = call.argument<Int>("day") ?: 1
                    starmaxManager.getBloodPressureHistory(year, month, day)
                    result.success(true)
                } catch (e: Exception) {
                    result.error("INVALID_ARGS", "Invalid arguments: ${e.message}", null)
                }
            }

            "getSleepHistory" -> {
                try {
                    val year = call.argument<Int>("year") ?: 2024
                    val month = call.argument<Int>("month") ?: 1
                    val day = call.argument<Int>("day") ?: 1
                    starmaxManager.getSleepHistory(year, month, day)
                    result.success(true)
                } catch (e: Exception) {
                    result.error("INVALID_ARGS", "Invalid arguments: ${e.message}", null)
                }
            }

            "getSportHistory" -> {
                starmaxManager.getSportHistory()
                result.success(true)
            }

            // ==================== HEALTH SETTINGS ====================
            "getHealthOpen" -> {
                starmaxManager.getHealthOpen()
                result.success(true)
            }

            "setHealthOpen" -> {
                try {
                    val heartRate = call.argument<Boolean>("heartRate") ?: true
                    val bloodPressure = call.argument<Boolean>("bloodPressure") ?: true
                    val bloodOxygen = call.argument<Boolean>("bloodOxygen") ?: true
                    val pressure = call.argument<Boolean>("pressure") ?: true
                    val temp = call.argument<Boolean>("temp") ?: true
                    val bloodSugar = call.argument<Boolean>("bloodSugar") ?: true

                    starmaxManager.setHealthOpen(
                        heartRate, bloodPressure, bloodOxygen,
                        pressure, temp, bloodSugar
                    )
                    result.success(true)
                } catch (e: Exception) {
                    result.error("INVALID_ARGS", "Invalid arguments: ${e.message}", null)
                }
            }

            "getHeartRateControl" -> {
                starmaxManager.getHeartRateControl()
                result.success(true)
            }

            "setHeartRateControl" -> {
                try {
                    val startHour = call.argument<Int>("startHour") ?: 0
                    val startMinute = call.argument<Int>("startMinute") ?: 0
                    val endHour = call.argument<Int>("endHour") ?: 23
                    val endMinute = call.argument<Int>("endMinute") ?: 59
                    val period = call.argument<Int>("period") ?: 60
                    val alarmThreshold = call.argument<Int>("alarmThreshold") ?: 100

                    starmaxManager.setHeartRateControl(
                        startHour, startMinute, endHour,
                        endMinute, period, alarmThreshold
                    )
                    result.success(true)
                } catch (e: Exception) {
                    result.error("INVALID_ARGS", "Invalid arguments: ${e.message}", null)
                }
            }

            // ==================== DEVICE MANAGEMENT ====================
            "reset" -> {
                starmaxManager.reset()
                result.success(true)
            }

            else -> result.notImplemented()
        }
    }
}