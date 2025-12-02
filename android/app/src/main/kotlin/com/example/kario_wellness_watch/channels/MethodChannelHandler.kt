package com.example.kario_wellness_watch.channels

import android.util.Log
import com.example.kario_wellness_watch.starmax.StarmaxManager
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.util.Calendar

class MethodChannelHandler(private val starmaxManager: StarmaxManager) : MethodChannel.MethodCallHandler {

    companion object {
        private const val TAG = "MethodChannel"
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        Log.d(TAG, "Method called: ${call.method}")

        try {
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
                        result.error("INVALID_ARGUMENT", "Address is required", null)
                    }
                }
                "disconnect" -> {
                    starmaxManager.disconnect()
                    result.success(true)
                }
                "isConnected" -> {
                    result.success(starmaxManager.isConnected())
                }

                // ==================== INITIALIZATION ====================
                "initializeWatch" -> {
                    starmaxManager.initializeWatch()
                    result.success(true)
                }

                // ==================== DEVICE INFO ====================
                "getBattery" -> {
                    starmaxManager.getBattery()
                    result.success(true)
                }
                "getVersion" -> {
                    starmaxManager.getVersion()
                    result.success(true)
                }
                "getDeviceState" -> {
                    starmaxManager.getDeviceState()
                    result.success(true)
                }
                "setDeviceState" -> {
                    val timeFormat = call.argument<Int>("timeFormat") ?: 0
                    val unit = call.argument<Int>("unit") ?: 0
                    val tempUnit = call.argument<Int>("tempUnit") ?: 0
                    val language = call.argument<Int>("language") ?: 0
                    val wristUp = call.argument<Int>("wristUp") ?: 1
                    val backlightTime = call.argument<Int>("backlightTime") ?: 5
                    val brightness = call.argument<Int>("brightness") ?: 50
                    starmaxManager.setDeviceState(timeFormat, unit, tempUnit, language, wristUp, backlightTime, brightness)
                    result.success(true)
                }

                // ==================== USER INFO ====================
                "getUserInfo" -> {
                    starmaxManager.getUserInfo()
                    result.success(true)
                }
                "setUserInfo" -> {
                    val sex = call.argument<Int>("sex") ?: 0
                    val age = call.argument<Int>("age") ?: 25
                    val height = call.argument<Int>("height") ?: 170
                    val weight = call.argument<Double>("weight") ?: 70.0
                    starmaxManager.setUserInfo(sex, age, height, weight)
                    result.success(true)
                }

                // ==================== GOALS ====================
                "getGoals" -> {
                    starmaxManager.getGoals()
                    result.success(true)
                }
                "setGoals" -> {
                    val steps = call.argument<Int>("steps") ?: 10000
                    val calories = call.argument<Int>("calories") ?: 300
                    val distance = call.argument<Double>("distance") ?: 5.0
                    starmaxManager.setGoals(steps, calories, distance)
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

                // ==================== HEALTH MONITORING SETTINGS ====================
                "getHealthOpen" -> {
                    starmaxManager.getHealthOpen()
                    result.success(true)
                }
                "setHealthOpen" -> {
                    val heartRate = call.argument<Boolean>("heartRate") ?: true
                    val bloodPressure = call.argument<Boolean>("bloodPressure") ?: true
                    val bloodOxygen = call.argument<Boolean>("bloodOxygen") ?: true
                    val pressure = call.argument<Boolean>("pressure") ?: false
                    val temperature = call.argument<Boolean>("temperature") ?: false
                    val bloodSugar = call.argument<Boolean>("bloodSugar") ?: false
                    starmaxManager.setHealthOpen(heartRate, bloodPressure, bloodOxygen, pressure, temperature, bloodSugar)
                    result.success(true)
                }

                // ==================== HISTORY DATA ====================
                "getStepHistory" -> {
                    val calendar = parseCalendar(call)
                    starmaxManager.getStepHistory(calendar)
                    result.success(true)
                }
                "getHeartRateHistory" -> {
                    val calendar = parseCalendar(call)
                    starmaxManager.getHeartRateHistory(calendar)
                    result.success(true)
                }
                "getBloodPressureHistory" -> {
                    val calendar = parseCalendar(call)
                    starmaxManager.getBloodPressureHistory(calendar)
                    result.success(true)
                }
                "getBloodOxygenHistory" -> {
                    val calendar = parseCalendar(call)
                    starmaxManager.getBloodOxygenHistory(calendar)
                    result.success(true)
                }
                "getSleepHistory" -> {
                    val calendar = parseCalendar(call)
                    starmaxManager.getSleepHistory(calendar)
                    result.success(true)
                }
                "getSportHistory" -> {
                    val calendar = parseCalendar(call)
                    starmaxManager.getSportHistory(calendar)
                    result.success(true)
                }

                // ==================== DEVICE CONTROL ====================
                "findDevice" -> {
                    val enable = call.argument<Boolean>("enable") ?: true
                    starmaxManager.findDevice(enable)
                    result.success(true)
                }
                "cameraControl" -> {
                    val enter = call.argument<Boolean>("enter") ?: true
                    starmaxManager.cameraControl(enter)
                    result.success(true)
                }
                "takePhoto" -> {
                    starmaxManager.takePhoto()
                    result.success(true)
                }
                "setTime" -> {
                    starmaxManager.setTime()
                    result.success(true)
                }
                "factoryReset" -> {
                    starmaxManager.factoryReset()
                    result.success(true)
                }

                // ==================== UNKNOWN ====================
                else -> {
                    Log.w(TAG, "Unknown method: ${call.method}")
                    result.notImplemented()
                }
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error handling method ${call.method}: ${e.message}")
            result.error("ERROR", e.message, null)
        }
    }

    private fun parseCalendar(call: MethodCall): Calendar {
        val year = call.argument<Int>("year") ?: Calendar.getInstance().get(Calendar.YEAR)
        val month = call.argument<Int>("month") ?: (Calendar.getInstance().get(Calendar.MONTH) + 1)
        val day = call.argument<Int>("day") ?: Calendar.getInstance().get(Calendar.DAY_OF_MONTH)

        return Calendar.getInstance().apply {
            set(Calendar.YEAR, year)
            set(Calendar.MONTH, month - 1)  // Calendar months are 0-indexed
            set(Calendar.DAY_OF_MONTH, day)
        }
    }
}