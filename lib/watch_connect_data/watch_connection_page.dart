import 'dart:async';
import 'package:flutter/material.dart';
import 'starmax_service.dart';

/// WatchDashboardPage - Main UI for watch connection and health data display
class WatchDashboardPage extends StatefulWidget {
  const WatchDashboardPage({super.key});

  @override
  State<WatchDashboardPage> createState() => _WatchDashboardPageState();
}

class _WatchDashboardPageState extends State<WatchDashboardPage> {
  final StarmaxService starmaxService = StarmaxService();

  // Subscriptions
  final List<StreamSubscription> _subscriptions = [];

  // State
  bool _isScanning = false;
  bool _isConnected = false;
  bool _isInitializing = false;
  int _initStep = 0;
  int _totalInitSteps = 16;

  // Connected device info
  String? _connectedDeviceName;
  String? _connectedDeviceAddress;

  // Discovered devices
  final List<BluetoothDevice> _devices = [];

  // Health data
  int _batteryLevel = 0;
  bool _isCharging = false;
  int _steps = 0;
  int _heartRate = 0;
  int _bloodOxygen = 0;
  int _calories = 0;
  int _systolic = 0;
  int _diastolic = 0;
  double _distance = 0.0;
  bool _isWearing = false;
  String _firmware = '';

  @override
  void initState() {
    super.initState();
    _initializeService();
  }

  Future<void> _initializeService() async {
    await starmaxService.initialize();
    _setupListeners();
  }

  void _setupListeners() {
    // Connection status
    _subscriptions.add(
      starmaxService.onConnectionChanged.listen((connected) {
        setState(() {
          _isConnected = connected;
          if (!connected) {
            _connectedDeviceName = null;
            _connectedDeviceAddress = null;
            _resetHealthData();
          }
        });
      }),
    );

    // Device found during scan
    _subscriptions.add(
      starmaxService.onDeviceFound.listen((device) {
        setState(() {
          // Avoid duplicates
          if (!_devices.any((d) => d.address == device.address)) {
            _devices.add(device);
          }
        });
      }),
    );

    // Battery updates
    _subscriptions.add(
      starmaxService.onBatteryUpdate.listen((battery) {
        setState(() {
          _batteryLevel = battery.level;
          _isCharging = battery.isCharging;
        });
      }),
    );

    // Health data updates
    _subscriptions.add(
      starmaxService.onHealthData.listen((health) {
        setState(() {
          _steps = health.steps;
          _heartRate = health.heartRate;
          _bloodOxygen = health.bloodOxygen;
          _calories = health.calories;
          _systolic = health.systolic;
          _diastolic = health.diastolic;
          _distance = health.distance;
          _isWearing = health.isWearing;
        });
      }),
    );

    // Version info
    _subscriptions.add(
      starmaxService.onVersionInfo.listen((version) {
        setState(() {
          _firmware = version.firmware;
        });
      }),
    );

    // Initialization progress
    _subscriptions.add(
      starmaxService.onInitProgress.listen((progress) {
        setState(() {
          _isInitializing = true;
          _initStep = progress.step;
          _totalInitSteps = progress.totalSteps;
        });

        // When complete, fetch data
        if (progress.step >= progress.totalSteps) {
          setState(() => _isInitializing = false);
          _fetchInitialData();
        }
      }),
    );

    // Errors
    _subscriptions.add(
      starmaxService.onError.listen((error) {
        _showSnackBar(error, isError: true);
      }),
    );
  }

  void _resetHealthData() {
    _batteryLevel = 0;
    _isCharging = false;
    _steps = 0;
    _heartRate = 0;
    _bloodOxygen = 0;
    _calories = 0;
    _systolic = 0;
    _diastolic = 0;
    _distance = 0.0;
    _isWearing = false;
    _firmware = '';
  }

  Future<void> _fetchInitialData() async {
    // Wait a bit for watch to be ready
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      await starmaxService.getBattery();
      await Future.delayed(const Duration(milliseconds: 300));
      await starmaxService.getHealthData();
      await Future.delayed(const Duration(milliseconds: 300));
      await starmaxService.getVersion();
    } catch (e) {
      print('Error fetching initial data: $e');
    }
  }

  // ==================== ACTIONS ====================

  Future<void> _startScan() async {
    setState(() {
      _isScanning = true;
      _devices.clear();
    });

    await starmaxService.startScan();

    // Auto-stop after 15 seconds
    Future.delayed(const Duration(seconds: 15), () {
      if (_isScanning) {
        _stopScan();
      }
    });
  }

  Future<void> _stopScan() async {
    await starmaxService.stopScan();
    setState(() => _isScanning = false);
  }

  Future<void> _connectToDevice(BluetoothDevice device) async {
    setState(() {
      _connectedDeviceName = device.name;
      _connectedDeviceAddress = device.address;
    });

    await _stopScan();
    await starmaxService.connect(device.address);
  }

  Future<void> _disconnect() async {
    await starmaxService.disconnect();
  }

  Future<void> _syncData() async {
    _showSnackBar('Syncing data...');
    await starmaxService.getHealthData();
    await Future.delayed(const Duration(milliseconds: 300));
    await starmaxService.getBattery();
  }

  Future<void> _findDevice() async {
    _showSnackBar('Finding device...');
    await starmaxService.findDevice(enable: true);

    // Stop after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      starmaxService.findDevice(enable: false);
    });
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : null,
        duration: Duration(seconds: isError ? 4 : 2),
      ),
    );
  }

  @override
  void dispose() {
    for (var sub in _subscriptions) {
      sub.cancel();
    }
    starmaxService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: _isConnected ? _buildDashboard() : _buildScanView(),
      ),
    );
  }

  // ==================== SCAN VIEW ====================

  Widget _buildScanView() {
    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade600, Colors.blue.shade800],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            children: [
              const Icon(Icons.watch, size: 64, color: Colors.white),
              const SizedBox(height: 16),
              const Text(
                'Connect Your Watch',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _isScanning ? 'Scanning for devices...' : 'Tap scan to find your watch',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _isScanning ? _stopScan : _startScan,
                icon: Icon(_isScanning ? Icons.stop : Icons.bluetooth_searching),
                label: Text(_isScanning ? 'Stop Scan' : 'Scan for Watches'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blue.shade700,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
              ),
            ],
          ),
        ),

        // Device list
        Expanded(
          child: _devices.isEmpty
              ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _isScanning ? Icons.bluetooth_searching : Icons.watch_off,
                  size: 64,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  _isScanning ? 'Searching...' : 'No devices found',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          )
              : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _devices.length,
            itemBuilder: (context, index) {
              final device = _devices[index];
              final isStarmax = device.name.contains('S5') ||
                  device.name.contains('Starmax') ||
                  device.name.contains('GTS');

              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: isStarmax ? Colors.blue : Colors.grey.shade300,
                    child: Icon(
                      Icons.watch,
                      color: isStarmax ? Colors.white : Colors.grey.shade600,
                    ),
                  ),
                  title: Text(
                    device.name,
                    style: TextStyle(
                      fontWeight: isStarmax ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  subtitle: Text(device.address),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildSignalIcon(device.rssi),
                      const SizedBox(width: 8),
                      if (isStarmax)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Recommended',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.green,
                            ),
                          ),
                        ),
                    ],
                  ),
                  onTap: () => _connectToDevice(device),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSignalIcon(int rssi) {
    final strength = rssi > -50 ? 3 : (rssi > -70 ? 2 : 1);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return Container(
          width: 4,
          height: 8.0 + (index * 4),
          margin: const EdgeInsets.symmetric(horizontal: 1),
          decoration: BoxDecoration(
            color: index < strength ? Colors.green : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(2),
          ),
        );
      }),
    );
  }

  // ==================== DASHBOARD VIEW ====================

  Widget _buildDashboard() {
    return RefreshIndicator(
      onRefresh: _syncData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            // Connected header
            _buildConnectedHeader(),

            // Initialization progress
            if (_isInitializing) _buildInitProgress(),

            // Quick actions
            _buildQuickActions(),

            // Health cards
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Health Data',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Steps & Heart Rate row
                  Row(
                    children: [
                      Expanded(child: _buildHealthCard(
                        icon: Icons.directions_walk,
                        label: 'Steps',
                        value: _steps.toString(),
                        color: Colors.orange,
                      )),
                      const SizedBox(width: 12),
                      Expanded(child: _buildHealthCard(
                        icon: Icons.favorite,
                        label: 'Heart Rate',
                        value: '$_heartRate BPM',
                        color: Colors.red,
                      )),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // SpO2 & Calories row
                  Row(
                    children: [
                      Expanded(child: _buildHealthCard(
                        icon: Icons.water_drop,
                        label: 'Blood Oxygen',
                        value: '$_bloodOxygen%',
                        color: Colors.blue,
                      )),
                      const SizedBox(width: 12),
                      Expanded(child: _buildHealthCard(
                        icon: Icons.local_fire_department,
                        label: 'Calories',
                        value: '$_calories kcal',
                        color: Colors.deepOrange,
                      )),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Blood Pressure card
                  _buildHealthCard(
                    icon: Icons.speed,
                    label: 'Blood Pressure',
                    value: '$_systolic / $_diastolic mmHg',
                    color: Colors.purple,
                    fullWidth: true,
                  ),
                  const SizedBox(height: 12),

                  // Distance & Wearing status
                  Row(
                    children: [
                      Expanded(child: _buildHealthCard(
                        icon: Icons.straighten,
                        label: 'Distance',
                        value: '${_distance.toStringAsFixed(2)} km',
                        color: Colors.green,
                      )),
                      const SizedBox(width: 12),
                      Expanded(child: _buildHealthCard(
                        icon: _isWearing ? Icons.watch : Icons.watch_off,
                        label: 'Status',
                        value: _isWearing ? 'Wearing' : 'Not Wearing',
                        color: _isWearing ? Colors.teal : Colors.grey,
                      )),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectedHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade500, Colors.green.shade700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 28,
                backgroundColor: Colors.white24,
                child: Icon(Icons.watch, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _connectedDeviceName ?? 'Watch',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.greenAccent,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          'Connected',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Battery
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _isCharging ? Icons.battery_charging_full : Icons.battery_full,
                      color: Colors.white,
                      size: 18,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$_batteryLevel%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          if (_firmware.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'Firmware: $_firmware',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInitProgress() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.blue.shade50,
      child: Row(
        children: [
          const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Initializing watch... ($_initStep/$_totalInitSteps)',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: _initStep / _totalInitSteps,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _buildActionButton(
              icon: Icons.phone_android,
              label: 'Find Watch',
              onTap: _findDevice,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildActionButton(
              icon: Icons.sync,
              label: 'Sync',
              onTap: _syncData,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildActionButton(
              icon: Icons.bluetooth_disabled,
              label: 'Disconnect',
              onTap: _disconnect,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? color,
  }) {
    return Material(
      color: color?.withOpacity(0.1) ?? Colors.blue.withOpacity(0.1),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              Icon(icon, color: color ?? Colors.blue),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  color: color ?? Colors.blue,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHealthCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    bool fullWidth = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}