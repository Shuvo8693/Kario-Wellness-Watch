import 'dart:async';
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
  final int totalSteps;
  final int totalCalories;
  final int totalDistance;
  final int heartRate;
  final int bloodOxygen;
  final int systolicBP;
  final int diastolicBP;
  final bool isWearing;

  HealthData({
    this.totalSteps = 0,
    this.totalCalories = 0,
    this.totalDistance = 0,
    this.heartRate = 0,
    this.bloodOxygen = 0,
    this.systolicBP = 0,
    this.diastolicBP = 0,
    this.isWearing = false,
  });

  factory HealthData.fromMap(Map<String, dynamic> map) {
    return HealthData(
      totalSteps: map['steps'] ?? map['total_steps'] ?? 0,
      totalCalories: map['calories'] ?? map['total_heat'] ?? 0,
      totalDistance: map['distance'] ?? map['total_distance'] ?? 0,
      heartRate: map['heartRate'] ?? map['current_heart_rate'] ?? 0,
      bloodOxygen: map['bloodOxygen'] ?? map['current_blood_oxygen'] ?? 0,
      systolicBP: map['bloodPressureHigh'] ?? map['current_ss'] ?? 0,
      diastolicBP: map['bloodPressureLow'] ?? map['current_fz'] ?? 0,
      isWearing: (map['heartRate'] ?? 0) > 0, // If HR > 0, watch is being worn
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
      power: map['level'] ?? map['power'] ?? 0,
      isCharging: map['isCharging'] ?? map['is_charge'] ?? false,
    );
  }
}

/// Device version information
class DeviceVersion {
  final String version;

  DeviceVersion({required this.version});

  factory DeviceVersion.fromMap(Map<String, dynamic> map) {
    return DeviceVersion(
      version: map['version'] ?? '',
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
  final _servicesDiscoveredController = StreamController<bool>.broadcast();

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
  Stream<bool> get onServicesDiscovered => _servicesDiscoveredController.stream;

  /// Initialize the service and start listening to events
  Future<void> initialize() async {
    if (_isInitialized) return;

    _eventSubscription = _eventChannel.receiveBroadcastStream().listen(
      _handleEvent,
      onError: (error) {
        print('Event stream error: $error');
        _errorController.add('Event stream error: $error');
      },
    );

    _isInitialized = true;
    print('StarmaxService initialized');
  }

  /// Handle events from the native side
  /// New format: { "event": "eventName", "data": { ... } }
  void _handleEvent(dynamic event) {
    if (event is! Map) {
      print('Invalid event format: $event');
      return;
    }

    final Map<String, dynamic> eventMap = Map<String, dynamic>.from(event);
    final String eventName = eventMap['event'] ?? '';
    final Map<String, dynamic> data = eventMap['data'] != null
        ? Map<String, dynamic>.from(eventMap['data'])
        : {};

    print('📥 Event: $eventName - $data');

    switch (eventName) {
      case 'deviceFound':
        final device = BleDevice.fromMap(data);
        _deviceFoundController.add(device);
        break;

      case 'connectionState':
        final isConnected = data['connected'] ?? false;
        _connectionStatusController.add(isConnected);
        break;

      case 'servicesDiscovered':
        final ready = data['ready'] ?? false;
        _servicesDiscoveredController.add(ready);
        break;

      case 'healthData':
        final healthData = HealthData.fromMap(data);
        print('📊 Health: steps=${healthData.totalSteps}, hr=${healthData.heartRate}');
        _healthDataController.add(healthData);
        break;

      case 'batteryInfo':
        final batteryInfo = BatteryInfo.fromMap(data);
        print('🔋 Battery: ${batteryInfo.power}%');
        _batteryController.add(batteryInfo);
        break;

      case 'version':
        final version = DeviceVersion.fromMap(data);
        _versionController.add(version);
        break;

      case 'pairResult':
        print('🔐 Pair result: ${data['success']}');
        _rawDataController.add({'type': 'pairResult', ...data});
        break;

      case 'initializationComplete':
        print('✅ Watch initialization complete: ${data['success']}');
        _rawDataController.add({'type': 'initializationComplete', ...data});
        break;

      case 'deviceState':
        _rawDataController.add({'type': 'deviceState', ...data});
        break;

      case 'commandReply':
        print('📤 Command reply: ${data['success']}');
        break;

      case 'goals':
        _rawDataController.add({'type': 'goals', ...data});
        break;

      case 'userInfo':
        _rawDataController.add({'type': 'userInfo', ...data});
        break;

      case 'alarms':
        _rawDataController.add({'type': 'alarms', ...data});
        break;

      case 'healthMonitoringSettings':
        _rawDataController.add({'type': 'healthMonitoringSettings', ...data});
        break;

      case 'heartRateHistory':
      case 'stepHistory':
      case 'bloodOxygenHistory':
      case 'bloodPressureHistory':
      case 'sleepHistory':
      case 'sportHistory':
        _rawDataController.add({'type': eventName, ...data});
        break;

      case 'realTimeMeasure':
        _rawDataController.add({'type': 'realTimeMeasure', ...data});
        break;

      case 'heartRateControl':
        _rawDataController.add({'type': 'heartRateControl', ...data});
        break;

      case 'findPhone':
        print('📱 Watch is trying to find phone!');
        _rawDataController.add({'type': 'findPhone', ...data});
        break;

      case 'cameraControl':
        print('📷 Camera control: ${data['action']}');
        _rawDataController.add({'type': 'cameraControl', ...data});
        break;

      case 'musicControl':
        print('🎵 Music control: ${data['action']}');
        _rawDataController.add({'type': 'musicControl', ...data});
        break;

      case 'rawData':
        print('📦 Raw data: $data');
        _rawDataController.add(data);
        break;

      case 'error':
        final message = data['message'] ?? 'Unknown error';
        print('❌ Error: $message');
        _errorController.add(message);
        break;

      default:
        print('❓ Unknown event: $eventName');
        _rawDataController.add({'type': eventName, ...data});
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

  // ==================== INITIALIZATION ====================

  /// Full initialization sequence - matches RunmeFit app exactly
  /// Call this AFTER connection to properly pair with watch
  Future<void> initializeWatch() async {
    try {
      await _methodChannel.invokeMethod('initializeWatch');
    } catch (e) {
      _errorController.add('Initialize watch failed: $e');
    }
  }

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

  /// Get user info
  Future<void> getUserInfo() async {
    try {
      await _methodChannel.invokeMethod('getUserInfo');
    } catch (e) {
      _errorController.add('Get user info failed: $e');
    }
  }

  /// Set user info
  Future<void> setUserInfo({
    int sex = 1, // 0: Female, 1: Male
    int age = 30,
    int height = 170, // in cm
    int weight = 70, // in kg
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

  /// Set daily goals
  Future<void> setGoals({
    int steps = 10000,
    int calories = 500,
    int distance = 10, // in km
  }) async {
    try {
      await _methodChannel.invokeMethod('setGoals', {
        'steps': steps,
        'calories': calories,
        'distance': distance,
      });
    } catch (e) {
      _errorController.add('Set goals failed: $e');
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
    int wristUp = 1, // 1: enabled, 0: disabled
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
  Future<void> cameraControl({bool enter = true}) async {
    try {
      await _methodChannel.invokeMethod('cameraControl', {
        'enter': enter,
      });
    } catch (e) {
      _errorController.add('Camera control failed: $e');
    }
  }

  /// Send notification to watch
  Future<void> sendNotification({
    required String title,
    required String content,
    int type = 0, // 0: SMS, 1: Call, 2: WhatsApp, etc.
  }) async {
    try {
      await _methodChannel.invokeMethod('sendNotification', {
        'title': title,
        'content': content,
        'type': type,
      });
    } catch (e) {
      _errorController.add('Send notification failed: $e');
    }
  }

  /// Reset device
  Future<void> resetDevice() async {
    try {
      await _methodChannel.invokeMethod('resetDevice');
    } catch (e) {
      _errorController.add('Reset device failed: $e');
    }
  }

  // ==================== HEALTH MONITORING ====================

  /// Get health monitoring settings
  Future<void> getHealthMonitoring() async {
    try {
      await _methodChannel.invokeMethod('getHealthMonitoring');
    } catch (e) {
      _errorController.add('Get health monitoring failed: $e');
    }
  }

  /// Set health monitoring settings
  Future<void> setHealthMonitoring({
    bool heartRate = true,
    bool bloodPressure = true,
    bool bloodOxygen = true,
  }) async {
    try {
      await _methodChannel.invokeMethod('setHealthMonitoring', {
        'heartRate': heartRate,
        'bloodPressure': bloodPressure,
        'bloodOxygen': bloodOxygen,
      });
    } catch (e) {
      _errorController.add('Set health monitoring failed: $e');
    }
  }

  // ==================== REAL-TIME MEASUREMENTS ====================

  /// Start real-time heart rate measurement
  Future<void> startHeartRateMeasurement() async {
    try {
      await _methodChannel.invokeMethod('startHeartRateMeasurement');
    } catch (e) {
      _errorController.add('Start HR measurement failed: $e');
    }
  }

  /// Stop real-time heart rate measurement
  Future<void> stopHeartRateMeasurement() async {
    try {
      await _methodChannel.invokeMethod('stopHeartRateMeasurement');
    } catch (e) {
      _errorController.add('Stop HR measurement failed: $e');
    }
  }

  /// Start blood pressure measurement
  Future<void> startBloodPressureMeasurement() async {
    try {
      await _methodChannel.invokeMethod('startBloodPressureMeasurement');
    } catch (e) {
      _errorController.add('Start BP measurement failed: $e');
    }
  }

  /// Stop blood pressure measurement
  Future<void> stopBloodPressureMeasurement() async {
    try {
      await _methodChannel.invokeMethod('stopBloodPressureMeasurement');
    } catch (e) {
      _errorController.add('Stop BP measurement failed: $e');
    }
  }

  /// Start blood oxygen measurement
  Future<void> startBloodOxygenMeasurement() async {
    try {
      await _methodChannel.invokeMethod('startBloodOxygenMeasurement');
    } catch (e) {
      _errorController.add('Start SpO2 measurement failed: $e');
    }
  }

  /// Stop blood oxygen measurement
  Future<void> stopBloodOxygenMeasurement() async {
    try {
      await _methodChannel.invokeMethod('stopBloodOxygenMeasurement');
    } catch (e) {
      _errorController.add('Stop SpO2 measurement failed: $e');
    }
  }

  // ==================== HISTORY ====================

  /// Get heart rate history for a specific date
  Future<void> getHeartRateHistory({
    required int year,
    required int month,
    required int day,
  }) async {
    try {
      await _methodChannel.invokeMethod('getHeartRateHistory', {
        'year': year,
        'month': month,
        'day': day,
      });
    } catch (e) {
      _errorController.add('Get HR history failed: $e');
    }
  }

  /// Get step history for a specific date
  Future<void> getStepHistory({
    required int year,
    required int month,
    required int day,
  }) async {
    try {
      await _methodChannel.invokeMethod('getStepHistory', {
        'year': year,
        'month': month,
        'day': day,
      });
    } catch (e) {
      _errorController.add('Get step history failed: $e');
    }
  }

  /// Get sleep history for a specific date
  Future<void> getSleepHistory({
    required int year,
    required int month,
    required int day,
  }) async {
    try {
      await _methodChannel.invokeMethod('getSleepHistory', {
        'year': year,
        'month': month,
        'day': day,
      });
    } catch (e) {
      _errorController.add('Get sleep history failed: $e');
    }
  }

  // ==================== ALARMS ====================

  /// Get alarms
  Future<void> getAlarms() async {
    try {
      await _methodChannel.invokeMethod('getAlarms');
    } catch (e) {
      _errorController.add('Get alarms failed: $e');
    }
  }

  /// Set alarms
  Future<void> setAlarms(List<Map<String, dynamic>> alarms) async {
    try {
      await _methodChannel.invokeMethod('setAlarms', {'alarms': alarms});
    } catch (e) {
      _errorController.add('Set alarms failed: $e');
    }
  }

  // ==================== TESTING/DEBUGGING ====================

  /// Send raw hex command for testing
  Future<void> sendRawCommand(String hex) async {
    try {
      await _methodChannel.invokeMethod('sendRawCommand', {'hex': hex});
    } catch (e) {
      _errorController.add('Send raw command failed: $e');
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
    _servicesDiscoveredController.close();
    _isInitialized = false;
  }
}