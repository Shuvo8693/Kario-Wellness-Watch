import 'dart:async';
import 'package:flutter/services.dart';

/// StarmaxService - Flutter service for communicating with Starmax smartwatch
///
/// Uses platform channels to communicate with native Android code:
/// - MethodChannel: For sending commands to the watch
/// - EventChannel: For receiving data/events from the watch
class StarmaxService {
  // Channel names (must match Android side)
  static const MethodChannel _methodChannel = MethodChannel('com.kario.wellness/methods');
  static const EventChannel _eventChannel = EventChannel('com.kario.wellness/events');

  // Stream subscription
  StreamSubscription? _eventSubscription;

  // Stream controllers for different event types
  final _connectionController = StreamController<bool>.broadcast();
  final _deviceFoundController = StreamController<BluetoothDevice>.broadcast();
  final _batteryController = StreamController<BatteryInfo>.broadcast();
  final _healthController = StreamController<HealthData>.broadcast();
  final _versionController = StreamController<VersionInfo>.broadcast();
  final _userInfoController = StreamController<UserInfo>.broadcast();
  final _goalsController = StreamController<GoalsInfo>.broadcast();
  final _stateController = StreamController<DeviceState>.broadcast();
  final _errorController = StreamController<String>.broadcast();
  final _initProgressController = StreamController<InitProgress>.broadcast();
  final _bondStateController = StreamController<int>.broadcast();
  final _rawDataController = StreamController<Map<String, dynamic>>.broadcast();

  // Public streams
  Stream<bool> get onConnectionChanged => _connectionController.stream;
  Stream<BluetoothDevice> get onDeviceFound => _deviceFoundController.stream;
  Stream<BatteryInfo> get onBatteryUpdate => _batteryController.stream;
  Stream<HealthData> get onHealthData => _healthController.stream;
  Stream<VersionInfo> get onVersionInfo => _versionController.stream;
  Stream<UserInfo> get onUserInfo => _userInfoController.stream;
  Stream<GoalsInfo> get onGoalsInfo => _goalsController.stream;
  Stream<DeviceState> get onDeviceState => _stateController.stream;
  Stream<String> get onError => _errorController.stream;
  Stream<InitProgress> get onInitProgress => _initProgressController.stream;
  Stream<int> get onBondStateChanged => _bondStateController.stream;
  Stream<Map<String, dynamic>> get onRawData => _rawDataController.stream;

  // Connection state
  bool _isConnected = false;
  bool get isConnected => _isConnected;

  /// Initialize the service and start listening to events
  Future<void> initialize() async {
    print('📱 StarmaxService: Initializing...');

    _eventSubscription = _eventChannel.receiveBroadcastStream().listen(
      _handleEvent,
      onError: (error) {
        print('❌ StarmaxService: Event stream error: $error');
        _errorController.add(error.toString());
      },
    );

    print('✅ StarmaxService: Initialized');
  }

  /// Handle events from native code with model class
  void _handleEvent(dynamic eventData) {
    if (eventData == null || eventData is! Map) {
      print('⚠️ StarmaxService: Invalid event data: $eventData');
      return;
    }

    final event = eventData['event'] as String?;
    final data = eventData['data'] as Map<dynamic, dynamic>?;

    if (event == null || event.isEmpty) {
      print('⚠️ StarmaxService: Empty event received');
      return;
    }

    print('📥 Event: $event');

    switch (event) {
      case 'connectionStatus':
        final status = data?['status'] as String?;
        _isConnected = status == 'connected';
        _connectionController.add(_isConnected);
        print('🔗 Connection: $_isConnected');
        break;

      case 'deviceFound':
        final device = BluetoothDevice(
          name: data?['name'] as String? ?? 'Unknown',
          address: data?['address'] as String? ?? '',
          rssi: data?['rssi'] as int? ?? 0,
        );
        _deviceFoundController.add(device);
        break;

      case 'battery':
        final battery = BatteryInfo(
          level: data?['level'] as int? ?? 0,
          isCharging: data?['charging'] as bool? ?? false,
        );
        _batteryController.add(battery);
        print('🔋 Battery: ${battery.level}%');
        break;

      case 'healthDetail':
        final health = HealthData(
          steps: data?['steps'] as int? ?? 0,
          calories: data?['calories'] as int? ?? 0,
          distance: (data?['distance'] as num?)?.toDouble() ?? 0.0,
          heartRate: data?['heartRate'] as int? ?? 0,
          bloodOxygen: data?['bloodOxygen'] as int? ?? 0,
          systolic: data?['systolic'] as int? ?? 0,
          diastolic: data?['diastolic'] as int? ?? 0,
          pressure: data?['pressure'] as int? ?? 0,
          temperature: (data?['temperature'] as num?)?.toDouble() ?? 0.0,
          isWearing: data?['isWearing'] as bool? ?? false,
        );
        _healthController.add(health);
        print('❤️ Health: HR=${health.heartRate}, Steps=${health.steps}');
        break;

      case 'version':
        final version = VersionInfo(
          firmware: data?['firmware'] as String? ?? '',
          protocol: data?['protocol'] as int? ?? 0,
        );
        _versionController.add(version);
        print('📱 Version: ${version.firmware}');
        break;

      case 'userInfo':
        final userInfo = UserInfo(
          sex: data?['sex'] as int? ?? 0,
          age: data?['age'] as int? ?? 0,
          height: data?['height'] as int? ?? 0,
          weight: (data?['weight'] as num?)?.toDouble() ?? 0.0,
        );
        _userInfoController.add(userInfo);
        break;

      case 'goals':
        final goals = GoalsInfo(
          steps: data?['steps'] as int? ?? 0,
          calories: data?['calories'] as int? ?? 0,
          distance: (data?['distance'] as num?)?.toDouble() ?? 0.0,
        );
        _goalsController.add(goals);
        break;

      case 'state':
        final state = DeviceState(
          timeFormat: data?['timeFormat'] as int? ?? 0,
          unit: data?['unit'] as int? ?? 0,
          tempUnit: data?['tempUnit'] as int? ?? 0,
          language: data?['language'] as int? ?? 0,
          wristUp: data?['wristUp'] as int? ?? 0,
          backlightTime: data?['backlightTime'] as int? ?? 0,
          brightness: data?['brightness'] as int? ?? 0,
        );
        _stateController.add(state);
        break;

      case 'initializationProgress':
        final progress = InitProgress(
          step: data?['step'] as int? ?? 0,
          totalSteps: data?['totalSteps'] as int? ?? 16,
        );
        _initProgressController.add(progress);
        break;

      case 'initializationComplete':
        print('✅ Watch initialization complete!');
        break;

      case 'servicesDiscovered':
        print('✅ BLE services discovered');
        break;

      case 'bondStateChanged':
        final state = data?['state'] as int? ?? 10;
        _bondStateController.add(state);
        print('🔐 Bond state: $state');
        break;

      case 'error':
        final message = data?['message'] as String? ?? 'Unknown error';
        _errorController.add(message);
        print('❌ Error: $message');
        break;

      case 'rawData':
        _rawDataController.add(Map<String, dynamic>.from(data ?? {}));
        break;

      default:
        print('❓ Unknown event: $event');
    }
  }

  // ==================== CONNECTION ====================

  /// Start scanning for Bluetooth devices
  Future<void> startScan() async {
    print('🔍 Starting BLE scan...');
    await _methodChannel.invokeMethod('startScan');
  }

  /// Stop scanning
  Future<void> stopScan() async {
    print('⏹️ Stopping BLE scan...');
    await _methodChannel.invokeMethod('stopScan');
  }

  /// Connect to a device by address
  Future<void> connect(String address) async {
    print('🔗 Connecting to $address...');
    await _methodChannel.invokeMethod('connect', {'address': address});
  }

  /// Disconnect from the current device
  Future<void> disconnect() async {
    print('🔌 Disconnecting...');
    await _methodChannel.invokeMethod('disconnect');
    _isConnected = false;
  }

  /// Check if connected
  Future<bool> checkConnected() async {
    final result = await _methodChannel.invokeMethod<bool>('isConnected');
    _isConnected = result ?? false;
    return _isConnected;
  }

  /// Initialize watch (send initialization sequence)
  Future<void> initializeWatch() async {
    print('🚀 Initializing watch...');
    await _methodChannel.invokeMethod('initializeWatch');
  }

  // ==================== DEVICE INFO ====================

  /// Get battery level
  Future<void> getBattery() async {
    await _methodChannel.invokeMethod('getBattery');
  }

  /// Get firmware version
  Future<void> getVersion() async {
    await _methodChannel.invokeMethod('getVersion');
  }

  /// Get device state
  Future<void> getDeviceState() async {
    await _methodChannel.invokeMethod('getDeviceState');
  }

  /// Set device state
  Future<void> setDeviceState({
    int timeFormat = 0,
    int unit = 0,
    int tempUnit = 0,
    int language = 1,
    int wristUp = 1,
    int backlightTime = 5,
    int brightness = 100,
  }) async {
    await _methodChannel.invokeMethod('setDeviceState', {
      'timeFormat': timeFormat,
      'unit': unit,
      'tempUnit': tempUnit,
      'language': language,
      'wristUp': wristUp,
      'backlightTime': backlightTime,
      'brightness': brightness,
    });
  }

  // ==================== USER INFO ====================

  /// Get user info
  Future<void> getUserInfo() async {
    await _methodChannel.invokeMethod('getUserInfo');
  }

  /// Set user info
  Future<void> setUserInfo({
    required int sex,
    required int age,
    required int height,
    required double weight,
  }) async {
    await _methodChannel.invokeMethod('setUserInfo', {
      'sex': sex,
      'age': age,
      'height': height,
      'weight': weight,
    });
  }

  // ==================== GOALS ====================

  /// Get daily goals
  Future<void> getGoals() async {
    await _methodChannel.invokeMethod('getGoals');
  }

  /// Set daily goals
  Future<void> setGoals({
    required int steps,
    required int calories,
    required double distance,
  }) async {
    await _methodChannel.invokeMethod('setGoals', {
      'steps': steps,
      'calories': calories,
      'distance': distance,
    });
  }

  // ==================== HEALTH DATA ====================

  /// Get current health data (steps, heart rate, etc.)
  Future<void> getHealthData() async {
    await _methodChannel.invokeMethod('getHealthDetail');
  }

  /// Alias for getHealthData
  Future<void> getHealthDetail() => getHealthData();

  /// Get heart rate (calls getHealthDetail)
  Future<void> getHeartRate() async {
    await _methodChannel.invokeMethod('getHeartRate');
  }

  /// Get steps (calls getHealthDetail)
  Future<void> getSteps() async {
    await _methodChannel.invokeMethod('getSteps');
  }

  /// Get blood oxygen (calls getHealthDetail)
  Future<void> getBloodOxygen() async {
    await _methodChannel.invokeMethod('getBloodOxygen');
  }

  /// Get health monitoring switches
  Future<void> getHealthOpen() async {
    await _methodChannel.invokeMethod('getHealthOpen');
  }

  /// Set health monitoring switches
  Future<void> setHealthOpen({
    bool heartRate = true,
    bool bloodPressure = true,
    bool bloodOxygen = true,
    bool pressure = true,
    bool temperature = true,
    bool bloodSugar = false,
  }) async {
    await _methodChannel.invokeMethod('setHealthOpen', {
      'heartRate': heartRate,
      'bloodPressure': bloodPressure,
      'bloodOxygen': bloodOxygen,
      'pressure': pressure,
      'temperature': temperature,
      'bloodSugar': bloodSugar,
    });
  }

  // ==================== HISTORY DATA ====================

  /// Get step history for a specific date
  Future<void> getStepHistory({DateTime? date}) async {
    final d = date ?? DateTime.now();
    await _methodChannel.invokeMethod('getStepHistory', {
      'year': d.year,
      'month': d.month,
      'day': d.day,
    });
  }

  /// Get heart rate history for a specific date
  Future<void> getHeartRateHistory({DateTime? date}) async {
    final d = date ?? DateTime.now();
    await _methodChannel.invokeMethod('getHeartRateHistory', {
      'year': d.year,
      'month': d.month,
      'day': d.day,
    });
  }

  /// Get blood pressure history for a specific date
  Future<void> getBloodPressureHistory({DateTime? date}) async {
    final d = date ?? DateTime.now();
    await _methodChannel.invokeMethod('getBloodPressureHistory', {
      'year': d.year,
      'month': d.month,
      'day': d.day,
    });
  }

  /// Get blood oxygen history for a specific date
  Future<void> getBloodOxygenHistory({DateTime? date}) async {
    final d = date ?? DateTime.now();
    await _methodChannel.invokeMethod('getBloodOxygenHistory', {
      'year': d.year,
      'month': d.month,
      'day': d.day,
    });
  }

  /// Get sleep history for a specific date
  Future<void> getSleepHistory({DateTime? date}) async {
    final d = date ?? DateTime.now();
    await _methodChannel.invokeMethod('getSleepHistory', {
      'year': d.year,
      'month': d.month,
      'day': d.day,
    });
  }

  /// Get sport history for a specific date
  Future<void> getSportHistory({DateTime? date}) async {
    final d = date ?? DateTime.now();
    await _methodChannel.invokeMethod('getSportHistory', {
      'year': d.year,
      'month': d.month,
      'day': d.day,
    });
  }

  // ==================== DEVICE CONTROL ====================

  /// Find device (make watch vibrate)
  Future<void> findDevice({bool enable = true}) async {
    await _methodChannel.invokeMethod('findDevice', {'enable': enable});
  }

  /// Camera control
  Future<void> cameraControl({required bool enter}) async {
    await _methodChannel.invokeMethod('cameraControl', {'enter': enter});
  }

  /// Take photo (when in camera mode)
  Future<void> takePhoto() async {
    await _methodChannel.invokeMethod('takePhoto');
  }

  /// Set time on watch
  Future<void> setTime() async {
    await _methodChannel.invokeMethod('setTime');
  }

  /// Factory reset the watch
  Future<void> factoryReset() async {
    await _methodChannel.invokeMethod('factoryReset');
  }

  // ==================== CLEANUP ====================

  /// Dispose of resources
  void dispose() {
    print('🗑️ StarmaxService: Disposing...');
    _eventSubscription?.cancel();
    _connectionController.close();
    _deviceFoundController.close();
    _batteryController.close();
    _healthController.close();
    _versionController.close();
    _userInfoController.close();
    _goalsController.close();
    _stateController.close();
    _errorController.close();
    _initProgressController.close();
    _bondStateController.close();
    _rawDataController.close();
  }
}

// ==================== DATA CLASSES ====================

class BluetoothDevice {
  final String name;
  final String address;
  final int rssi;

  BluetoothDevice({
    required this.name,
    required this.address,
    required this.rssi,
  });

  @override
  String toString() => 'BluetoothDevice($name, $address, RSSI: $rssi)';
}

class BatteryInfo {
  final int level;
  final bool isCharging;

  BatteryInfo({
    required this.level,
    required this.isCharging,
  });

  @override
  String toString() => 'BatteryInfo($level%, charging: $isCharging)';
}

class HealthData {
  final int steps;
  final int calories;
  final double distance;
  final int heartRate;
  final int bloodOxygen;
  final int systolic;
  final int diastolic;
  final int pressure;
  final double temperature;
  final bool isWearing;

  HealthData({
    required this.steps,
    required this.calories,
    required this.distance,
    required this.heartRate,
    required this.bloodOxygen,
    required this.systolic,
    required this.diastolic,
    required this.pressure,
    required this.temperature,
    required this.isWearing,
  });

  @override
  String toString() =>
      'HealthData(steps: $steps, HR: $heartRate, SpO2: $bloodOxygen)';
}

class VersionInfo {
  final String firmware;
  final int protocol;

  VersionInfo({
    required this.firmware,
    required this.protocol,
  });

  @override
  String toString() => 'VersionInfo($firmware, protocol: $protocol)';
}

class UserInfo {
  final int sex; // 0 = male, 1 = female
  final int age;
  final int height; // cm
  final double weight; // kg

  UserInfo({
    required this.sex,
    required this.age,
    required this.height,
    required this.weight,
  });

  @override
  String toString() =>
      'UserInfo(sex: $sex, age: $age, height: $height, weight: $weight)';
}

class GoalsInfo {
  final int steps;
  final int calories;
  final double distance; // km

  GoalsInfo({
    required this.steps,
    required this.calories,
    required this.distance,
  });

  @override
  String toString() =>
      'GoalsInfo(steps: $steps, cal: $calories, dist: $distance)';
}

class DeviceState {
  final int timeFormat; // 0 = 24h, 1 = 12h
  final int unit; // 0 = metric, 1 = imperial
  final int tempUnit; // 0 = Celsius, 1 = Fahrenheit
  final int language;
  final int wristUp; // 1 = enabled
  final int backlightTime;
  final int brightness;

  DeviceState({
    required this.timeFormat,
    required this.unit,
    required this.tempUnit,
    required this.language,
    required this.wristUp,
    required this.backlightTime,
    required this.brightness,
  });

  @override
  String toString() =>
      'DeviceState(timeFormat: $timeFormat, unit: $unit, brightness: $brightness)';
}

class InitProgress {
  final int step;
  final int totalSteps;

  InitProgress({
    required this.step,
    required this.totalSteps,
  });

  double get progress => step / totalSteps;

  @override
  String toString() => 'InitProgress($step/$totalSteps)';
}