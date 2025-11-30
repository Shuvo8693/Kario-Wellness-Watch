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
)