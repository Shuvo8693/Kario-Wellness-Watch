import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class TestPlatformChannel extends StatefulWidget {
  const TestPlatformChannel({super.key});

  @override
  _TestPlatformChannelState createState() => _TestPlatformChannelState();
}

class _TestPlatformChannelState extends State<TestPlatformChannel> {
  static const MethodChannel _methodChannel = MethodChannel('com.kario.wellness/methods');
  static const EventChannel _eventChannel = EventChannel('com.kario.wellness/events');

  String _status = 'Not tested';
  bool _permissionsGranted = false;

  @override
  void initState() {
    super.initState();
    print('=== Flutter: TestPlatformChannel initState ===');
    _listenToEvents();
    _checkAndRequestPermissions();
  }

  Future<void> _checkAndRequestPermissions() async {
    print('=== Flutter: Checking permissions ===');

    // Check Android version
    if (await _isAndroid12OrHigher()) {
      // Android 12+ (API 31+) permissions
      Map<Permission, PermissionStatus> statuses = await [
        Permission.bluetoothScan,
        Permission.bluetoothConnect,
        Permission.bluetoothAdvertise,
        Permission.locationWhenInUse,
      ].request();

      _permissionsGranted = statuses.values.every((status) => status.isGranted);
    } else {
      // Android 6-11 permissions
      Map<Permission, PermissionStatus> statuses = await [
        Permission.bluetooth,
        Permission.locationWhenInUse,
      ].request();

      _permissionsGranted = statuses.values.every((status) => status.isGranted);
    }

    if (_permissionsGranted) {
      print('✅ All permissions granted');
      setState(() {
        _status = 'Permissions granted - Ready to scan';
      });
    } else {
      print('❌ Some permissions denied');
      setState(() {
        _status = 'Permissions denied - Cannot scan';
      });
    }
  }

  Future<bool> _isAndroid12OrHigher() async {
    // You can use device_info_plus package for this
    // For now, assume true for Android 12+
    return true;
  }

  void _listenToEvents() {
    print('=== Flutter: Starting to listen to event channel ===');
    _eventChannel.receiveBroadcastStream().listen(
          (event) {
        print('=== Flutter: Event received: $event ===');
        setState(() {
          _status = 'Event: $event';
        });
      },
      onError: (error) {
        print('=== Flutter: Event error: $error ===');
        setState(() {
          _status = 'Error: $error';
        });
      },
    );
  }

  Future<void> _testMethodChannel() async {
    if (!_permissionsGranted) {
      setState(() {
        _status = 'Please grant permissions first';
      });
      await _checkAndRequestPermissions();
      return;
    }

    print('=== Flutter: Testing method channel ===');
    try {
      final result = await _methodChannel.invokeMethod('startScan');
      print('=== Flutter: Method call result: $result ===');
      setState(() {
        _status = 'Success: $result';
      });
    } catch (e) {
      print('=== Flutter: Method call error: $e ===');
      setState(() {
        _status = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Platform Channel Test')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _status,
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _checkAndRequestPermissions,
              child: Text('Request Permissions'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _testMethodChannel,
              child: Text('Start BLE Scan'),
            ),
          ],
        ),
      ),
    );
  }
}