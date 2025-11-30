import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';

/// Represents a discovered BLE device
class BleDevice {
  final String name;
  final String address;
  final int rssi;

  BleDevice({
    required this.name,
    required this.address,
    required this.rssi,
  });

  factory BleDevice.fromMap(Map<String, dynamic> map) {
    return BleDevice(
      name: map['name'] ?? 'Unknown',
      address: map['address'] ?? '',
      rssi: map['rssi'] ?? 0,
    );
  }

  @override
  String toString() => 'BleDevice(name: $name, address: $address, rssi: $rssi)';
}

/// Health data from the watch
class HealthData {
  final int? totalSteps;
  final int? totalCalories;
  final int? totalDistance;
  final int? heartRate;
  final int? bloodOxygen;
  final int? systolicBP;
  final int? diastolicBP;
  final int? pressure;
  final int? temperature;
  final int? bloodSugar;
  final bool? isWearing;

  HealthData({
    this.totalSteps,
    this.totalCalories,
    this.totalDistance,
    this.heartRate,
    this.bloodOxygen,
    this.systolicBP,
    this.diastolicBP,
    this.pressure,
    this.temperature,
    this.bloodSugar,
    this.isWearing,
  });

  factory HealthData.fromMap(Map<String, dynamic> map) {
    return HealthData(
      totalSteps: map['total_steps'],
      totalCalories: map['total_heat'],
      totalDistance: map['total_distance'],
      heartRate: map['current_heart_rate'],
      bloodOxygen: map['current_blood_oxygen'],
      systolicBP: map['current_ss'],
      diastolicBP: map['current_fz'],
      pressure: map['current_pressure'],
      temperature: map['current_temp'],
      bloodSugar: map['current_blood_sugar'],
      isWearing: map['is_wear'] == 1,
    );
  }

  @override
  String toString() {
    return 'HealthData(steps: $totalSteps, heartRate: $heartRate, bloodOxygen: $bloodOxygen)';
  }
}

/// Battery information
class BatteryInfo {
  final int power;
  final bool isCharging;

  BatteryInfo({required this.power, required this.isCharging});

  factory BatteryInfo.fromMap(Map<String, dynamic> map) {
    return BatteryInfo(
      power: map['power'] ?? 0,
      isCharging: map['is_charge'] ?? false,
    );
  }
}

/// Device version information
class DeviceVersion {
  final String version;
  final String uiVersion;
  final String model;
  final int screenType;

  DeviceVersion({
    required this.version,
    required this.uiVersion,
    required this.model,
    required this.screenType,
  });

  factory DeviceVersion.fromMap(Map<String, dynamic> map) {
    return DeviceVersion(
      version: map['version'] ?? '',
      uiVersion: map['ui_version'] ?? '',
      model: map['model'] ?? '',
      screenType: map['screen_type'] ?? 0,
    );
  }
}

/// Main service class for Starmax watch communication
class StarmaxService {
  static const MethodChannel _methodChannel =
  MethodChannel('com.kario.wellness/methods');
  static const EventChannel _eventChannel =
  EventChannel('com.kario.wellness/events');

  // Stream controllers for different event types
  final _deviceFoundController = StreamController<BleDevice>.broadcast();
  final _connectionStatusController = StreamController<bool>.broadcast();
  final _healthDataController = StreamController<HealthData>.broadcast();
  final _batteryController = StreamController<BatteryInfo>.broadcast();
  final _versionController = StreamController<DeviceVersion>.broadcast();
  final _rawDataController = StreamController<Map<String, dynamic>>.broadcast();
  final _errorController = StreamController<String>.broadcast();

  StreamSubscription? _eventSubscription;
  bool _isInitialized = false;

  // Public streams
  Stream<BleDevice> get onDeviceFound => _deviceFoundController.stream;
  Stream<bool> get onConnectionChanged => _connectionStatusController.stream;
  Stream<HealthData> get onHealthData => _healthDataController.stream;
  Stream<BatteryInfo> get onBatteryInfo => _batteryController.stream;
  Stream<DeviceVersion> get onDeviceVersion => _versionController.stream;
  Stream<Map<String, dynamic>> get onRawData => _rawDataController.stream;
  Stream<String> get onError => _errorController.stream;

  /// Initialize the service and start listening to events
  Future<void> initialize() async {
    if (_isInitialized) return;

    _eventSubscription = _eventChannel.receiveBroadcastStream().listen(
      _handleEvent,
      onError: (error) {
        _errorController.add('Event stream error: $error');
      },
    );

    _isInitialized = true;
    print('StarmaxService initialized');
  }

  /// Handle events from the native side
  void _handleEvent(dynamic event) {
    if (event is! Map) return;

    final Map<String, dynamic> data = Map<String, dynamic>.from(event);
    final String type = data['type'] ?? '';

    print('Received event: $type - $data');

    switch (type) {
      case 'initialized':
        print('Starmax SDK initialized');
        break;

      case 'deviceFound':
        final device = BleDevice.fromMap(data);
        _deviceFoundController.add(device);
        break;

      case 'connectionStatus':
        final isConnected = data['status'] == 'connected';
        _connectionStatusController.add(isConnected);
        break;

    // Handle specific data types from Kotlin
      case 'healthData':
        final healthData = HealthData.fromMap(data);
        _healthDataController.add(healthData);
        break;

      case 'batteryInfo':
        final batteryInfo = BatteryInfo.fromMap(data);
        _batteryController.add(batteryInfo);
        break;

      case 'versionInfo':
        final version = DeviceVersion.fromMap(data);
        _versionController.add(version);
        break;

      case 'pairResult':
        print('Pairing response: ${data['pair_status']}');
        _rawDataController.add(data);
        break;

      case 'historyData':
        _rawDataController.add(data);
        break;

      case 'dataReceived':
        _handleDataReceived(data);
        break;

      case 'rawData':
        print('Raw data received: $data');
        _rawDataController.add(data);
        break;

      case 'error':
        final message = data['message'] ?? 'Unknown error';
        _errorController.add(message);
        break;

      case 'command':
      // Command acknowledgment
        print('Command sent: ${data['type']}');
        break;

      default:
        print('Unknown event type: $type');
        _rawDataController.add(data);
    }
  }

  /// Handle data received from watch
  void _handleDataReceived(Map<String, dynamic> data) {
    final notifyType = data['notifyType'] ?? '';

    switch (notifyType) {
      case 'HealthDetail':
        final healthData = HealthData.fromMap(data);
        _healthDataController.add(healthData);
        break;

      case 'Power':
        final batteryInfo = BatteryInfo.fromMap(data);
        _batteryController.add(batteryInfo);
        break;

      case 'Version':
        final version = DeviceVersion.fromMap(data);
        _versionController.add(version);
        break;

      case 'Pair':
        print('Pairing response: ${data['pair_status']}');
        _rawDataController.add(data);
        break;

      case 'GetState':
      case 'SetState':
        _rawDataController.add(data);
        break;

      default:
      // Forward unknown data types
        _rawDataController.add(data);
    }
  }

  // ==================== SCANNING ====================

  /// Start scanning for BLE devices
  Future<bool> startScan() async {
    try {
      final result = await _methodChannel.invokeMethod<bool>('startScan');
      return result ?? false;
    } catch (e) {
      _errorController.add('Start scan failed: $e');
      return false;
    }
  }

  /// Stop scanning for BLE devices
  Future<void> stopScan() async {
    try {
      await _methodChannel.invokeMethod('stopScan');
    } catch (e) {
      _errorController.add('Stop scan failed: $e');
    }
  }

  // ==================== CONNECTION ====================

  /// Connect to a device by address
  Future<bool> connect(String address) async {
    try {
      final result = await _methodChannel.invokeMethod<bool>(
        'connect',
        {'address': address},
      );
      return result ?? false;
    } catch (e) {
      _errorController.add('Connect failed: $e');
      return false;
    }
  }

  /// Disconnect from current device
  Future<void> disconnect() async {
    try {
      await _methodChannel.invokeMethod('disconnect');
    } catch (e) {
      _errorController.add('Disconnect failed: $e');
    }
  }

  /// Check if connected to a device
  Future<bool> isConnected() async {
    try {
      final result = await _methodChannel.invokeMethod<bool>('isConnected');
      return result ?? false;
    } catch (e) {
      return false;
    }
  }

  // ==================== PAIRING ====================

  /// Send pair command to device
  Future<void> pair() async {
    try {
      await _methodChannel.invokeMethod('pair');
    } catch (e) {
      _errorController.add('Pair failed: $e');
    }
  }

  // ==================== DEVICE INFO ====================

  /// Get battery level
  Future<void> getBattery() async {
    try {
      await _methodChannel.invokeMethod('getBattery');
    } catch (e) {
      _errorController.add('Get battery failed: $e');
    }
  }

  /// Get device version
  Future<void> getVersion() async {
    try {
      await _methodChannel.invokeMethod('getVersion');
    } catch (e) {
      _errorController.add('Get version failed: $e');
    }
  }

  // ==================== HEALTH DATA ====================

  /// Get current health data (steps, heart rate, blood oxygen, etc.)
  Future<void> getHealthData() async {
    try {
      await _methodChannel.invokeMethod('getHealthDetail');
    } catch (e) {
      _errorController.add('Get health data failed: $e');
    }
  }

  /// Get heart rate (uses getHealthDetail internally)
  Future<void> getHeartRate() async {
    try {
      await _methodChannel.invokeMethod('getHeartRate');
    } catch (e) {
      _errorController.add('Get heart rate failed: $e');
    }
  }

  /// Get steps (uses getHealthDetail internally)
  Future<void> getSteps() async {
    try {
      await _methodChannel.invokeMethod('getSteps');
    } catch (e) {
      _errorController.add('Get steps failed: $e');
    }
  }

  /// Get blood oxygen (uses getHealthDetail internally)
  Future<void> getBloodOxygen() async {
    try {
      await _methodChannel.invokeMethod('getBloodOxygen');
    } catch (e) {
      _errorController.add('Get blood oxygen failed: $e');
    }
  }

  // ==================== SETTINGS ====================

  /// Set time on watch (syncs with phone time)
  Future<void> setTime() async {
    try {
      await _methodChannel.invokeMethod('setTime');
    } catch (e) {
      _errorController.add('Set time failed: $e');
    }
  }

  /// Set user info
  Future<void> setUserInfo({
    int sex = 1, // 0: Female, 1: Male
    int age = 30,
    int height = 170, // in cm
    int weight = 700, // in 0.1kg (700 = 70.0kg)
  }) async {
    try {
      await _methodChannel.invokeMethod('setUserInfo', {
        'sex': sex,
        'age': age,
        'height': height,
        'weight': weight,
      });
    } catch (e) {
      _errorController.add('Set user info failed: $e');
    }
  }

  /// Get daily goals
  Future<void> getGoals() async {
    try {
      await _methodChannel.invokeMethod('getGoals');
    } catch (e) {
      _errorController.add('Get goals failed: $e');
    }
  }

  /// Get device state
  Future<void> getDeviceState() async {
    try {
      await _methodChannel.invokeMethod('getDeviceState');
    } catch (e) {
      _errorController.add('Get device state failed: $e');
    }
  }

  /// Set device state
  Future<void> setDeviceState({
    int timeFormat = 0, // 0: 24h, 1: 12h
    int unitFormat = 0, // 0: Metric, 1: Imperial
    int tempFormat = 0, // 0: Celsius, 1: Fahrenheit
    int language = 2, // 2: English
    int backlighting = 5, // seconds
    int screen = 50, // brightness percentage
    bool wristUp = true, // raise to wake
  }) async {
    try {
      await _methodChannel.invokeMethod('setDeviceState', {
        'timeFormat': timeFormat,
        'unitFormat': unitFormat,
        'tempFormat': tempFormat,
        'language': language,
        'backlighting': backlighting,
        'screen': screen,
        'wristUp': wristUp,
      });
    } catch (e) {
      _errorController.add('Set device state failed: $e');
    }
  }

  // ==================== FEATURES ====================

  /// Find device (makes watch vibrate)
  Future<void> findDevice({bool isFind = true}) async {
    try {
      await _methodChannel.invokeMethod('findDevice', {'isFind': isFind});
    } catch (e) {
      _errorController.add('Find device failed: $e');
    }
  }

  /// Camera control
  Future<void> cameraControl(String controlType) async {
    // controlType: "cameraIn", "cameraExit", "takePhoto"
    try {
      await _methodChannel.invokeMethod('cameraControl', {
        'controlType': controlType,
      });
    } catch (e) {
      _errorController.add('Camera control failed: $e');
    }
  }

  /// Phone control (for incoming calls)
  Future<void> phoneControl({
    required String controlType, // "hangUp", "answer", "incoming", "exit"
    String number = '',
    bool isNumber = true,
  }) async {
    try {
      await _methodChannel.invokeMethod('phoneControl', {
        'controlType': controlType,
        'number': number,
        'isNumber': isNumber,
      });
    } catch (e) {
      _errorController.add('Phone control failed: $e');
    }
  }

  // ==================== CLEANUP ====================

  /// Dispose the service
  void dispose() {
    _eventSubscription?.cancel();
    _deviceFoundController.close();
    _connectionStatusController.close();
    _healthDataController.close();
    _batteryController.close();
    _versionController.close();
    _rawDataController.close();
    _errorController.close();
    _isInitialized = false;
  }
}