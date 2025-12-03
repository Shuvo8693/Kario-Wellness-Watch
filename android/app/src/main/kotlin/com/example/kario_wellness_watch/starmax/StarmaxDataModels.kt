/*
package com.example.kario_wellness_watch.starmax

// Enums matching SDK
enum class CameraControlType {
    CameraIn,
    CameraExit,
    TakePhoto
}

enum class CallControlType {
    HangUp,
    Answer,
    Incoming,
    Exit
}

enum class NotifyType {
    Pair,
    GetState,
    SetState,
    FindPhone,
    CameraControl,
    PhoneControl,
    Power,
    Version,
    SetTime,
    SetUserInfo,
    GetGoals,
    SetGoals,
    CrcFailure,
    Failure,
    Success
}

// Data classes for responses
data class DeviceState(
    val timeFormat: Int = 0,
    val unitFormat: Int = 0,
    val tempFormat: Int = 0,
    val language: Int = 0,
    val backlighting: Int = 0,
    val screen: Int = 0,
    val wristUp: Boolean = false
)

data class BatteryInfo(
    val power: Int,
    val isCharging: Boolean
)

data class VersionInfo(
    val version: String,
    val uiVersion: String,
    val bufferSize: String,
    val lcdWidth: String,
    val lcdHeight: String,
    val screenType: Int,
    val model: String,
    val uiForceUpdate: Boolean,
    val uiSupportDifferentialUpgrade: Boolean,
    val supportSugar: Boolean,
    val protocolVersion: String
)

data class DailyGoals(
    val steps: Int,
    val heat: Int,
    val distance: Int
)*/


package com.example.kario_wellness_watch.starmax


/**
 * Simple model for a scanned Starmax watch.
 */
data class StarmaxDevice(
    val name: String?,
    val address: String
)

/**
 * Health data model – map of what we read from MapStarmaxNotify.
 * Add/remove fields as needed.
 */
data class StarmaxHealthData(
    val totalSteps: Int = 0,
    val totalHeat: Int = 0,
    val totalDistance: Int = 0,   // km or 0.01km depending on SDK
    val totalSleepMinutes: Int = 0,
    val deepSleepMinutes: Int = 0,
    val lightSleepMinutes: Int = 0,
    val heartRate: Int = 0,
    val systolic: Int = 0,
    val diastolic: Int = 0,
    val bloodOxygen: Int = 0,
    val pressure: Int = 0,
    val met: Int = 0,
    val mai: Int = 0,
    val tempTenthC: Int = 0,
    val bloodSugarTenth: Int = 0,
    val isWear: Int = -1       // 1 = wearing, 0 = off wrist, -1/255 = invalid
)
