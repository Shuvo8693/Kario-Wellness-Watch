import 'dart:async';
import 'package:flutter/material.dart';
import 'starmax_service.dart';

// ==================== MAIN WATCH PAGE ====================

class WatchDashboardPage extends StatefulWidget {
  const WatchDashboardPage({Key? key}) : super(key: key);

  @override
  State<WatchDashboardPage> createState() => _WatchDashboardPageState();
}

class _WatchDashboardPageState extends State<WatchDashboardPage>
    with SingleTickerProviderStateMixin {
  final StarmaxService _starmaxService = StarmaxService();

  // State
  bool _isScanning = false;
  bool _isConnected = false;
  bool _isConnecting = false;
  List<BleDevice> _discoveredDevices = [];
  String? _connectedDeviceName;
  String? _connectedDeviceAddress;

  // Health data
  HealthData? _healthData;
  BatteryInfo? _batteryInfo;
  DeviceVersion? _deviceVersion;

  // Animation
  late AnimationController _pulseController;

  // Subscriptions
  final List<StreamSubscription> _subscriptions = [];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
    _initializeService();
  }

  Future<void> _initializeService() async {
    await _starmaxService.initialize();

    // Listen to device discovery
    _subscriptions.add(
      _starmaxService.onDeviceFound.listen((device) {
        setState(() {
          if (!_discoveredDevices.any((d) => d.address == device.address)) {
            _discoveredDevices.add(device);
            // Sort by signal strength
            _discoveredDevices.sort((a, b) => b.rssi.compareTo(a.rssi));
          }
        });
      }),
    );

    // Listen to connection status
    _subscriptions.add(
      _starmaxService.onConnectionChanged.listen((connected) {
        setState(() {
          _isConnected = connected;
          _isConnecting = false;
          if (!connected) {
            _connectedDeviceName = null;
            _connectedDeviceAddress = null;
            _healthData = null;
            _batteryInfo = null;
          }
        });

        if (connected) {
          _showSnackBar('✓ Connected successfully!', Colors.green);
          _onConnected();
        } else {
          _showSnackBar('Disconnected from watch', Colors.orange);
        }
      }),
    );

    // Listen to health data
    _subscriptions.add(
      _starmaxService.onHealthData.listen((data) {
        setState(() {
          _healthData = data;
        });
      }),
    );

    // Listen to battery info
    _subscriptions.add(
      _starmaxService.onBatteryInfo.listen((info) {
        setState(() {
          _batteryInfo = info;
        });
      }),
    );

    // Listen to version info
    _subscriptions.add(
      _starmaxService.onDeviceVersion.listen((version) {
        setState(() {
          _deviceVersion = version;
        });
      }),
    );

    // Listen to errors
    _subscriptions.add(
      _starmaxService.onError.listen((error) {
        _showSnackBar('Error: $error', Colors.red);
        setState(() {
          _isConnecting = false;
        });
      }),
    );
  }

  void _onConnected() async {
    // Wait for the watch to be fully ready
    await Future.delayed(const Duration(milliseconds: 1000));

    _showSnackBar('Syncing with watch...', Colors.blue);

    // Send pair command first
    await _starmaxService.pair();
    await Future.delayed(const Duration(milliseconds: 800));

    // Sync time
    await _starmaxService.setTime();
    await Future.delayed(const Duration(milliseconds: 800));

    // Get battery
    await _starmaxService.getBattery();
    await Future.delayed(const Duration(milliseconds: 800));

    // Get version
    await _starmaxService.getVersion();
    await Future.delayed(const Duration(milliseconds: 800));

    // Get health data
    await _starmaxService.getHealthData();
  }

  void _startScan() async {
    setState(() {
      _isScanning = true;
      _discoveredDevices.clear();
    });

    final success = await _starmaxService.startScan();

    if (!success) {
      setState(() => _isScanning = false);
      _showSnackBar('Failed to start scan. Check permissions.', Colors.red);
    } else {
      Future.delayed(const Duration(seconds: 10), () {
        if (_isScanning && mounted) {
          _stopScan();
        }
      });
    }
  }

  void _stopScan() async {
    await _starmaxService.stopScan();
    setState(() => _isScanning = false);
  }

  void _connectToDevice(BleDevice device) async {
    _stopScan();

    setState(() {
      _isConnecting = true;
      _connectedDeviceName = device.name;
      _connectedDeviceAddress = device.address;
    });

    final success = await _starmaxService.connect(device.address);

    if (!success) {
      setState(() {
        _isConnecting = false;
        _connectedDeviceName = null;
        _connectedDeviceAddress = null;
      });
      _showSnackBar('Failed to connect', Colors.red);
    }
  }

  void _disconnect() async {
    await _starmaxService.disconnect();
  }

  void _refreshHealthData() async {
    _showSnackBar('Refreshing data...', Colors.blue);
    await _starmaxService.getBattery();
    await Future.delayed(const Duration(milliseconds: 200));
    await _starmaxService.getHealthData();
  }

  void _findWatch() async {
    await _starmaxService.findDevice(isFind: true);
    _showSnackBar('📳 Watch should vibrate now!', Colors.blue);
  }

  void _showSnackBar(String message, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    for (var sub in _subscriptions) {
      sub.cancel();
    }
    _starmaxService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: _isConnected ? _buildConnectedView() : _buildScanView(),
      ),
    );
  }

  // ==================== SCAN VIEW ====================

  Widget _buildScanView() {
    return Column(
      children: [
        _buildScanHeader(),
        Expanded(
          child: _discoveredDevices.isEmpty
              ? _buildEmptyState()
              : _buildDeviceList(),
        ),
      ],
    );
  }

  Widget _buildScanHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withOpacity(0.8),
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.watch,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Connect Your Watch',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _isScanning
                          ? 'Scanning for devices...'
                          : 'Tap scan to find nearby watches',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: _isScanning ? _stopScan : _startScan,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              icon: _isScanning
                  ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
                  : const Icon(Icons.bluetooth_searching),
              label: Text(
                _isScanning ? 'Stop Scanning' : 'Scan for Watches',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Transform.scale(
                scale: 1.0 + (_pulseController.value * 0.1),
                child: Icon(
                  _isScanning ? Icons.bluetooth_searching : Icons.watch_off,
                  size: 80,
                  color: Colors.grey[300],
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          Text(
            _isScanning ? 'Looking for watches...' : 'No watches found',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _isScanning
                ? 'Make sure your watch is nearby and awake'
                : 'Tap the scan button to search',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _discoveredDevices.length,
      itemBuilder: (context, index) {
        final device = _discoveredDevices[index];
        return _buildDeviceCard(device);
      },
    );
  }

  Widget _buildDeviceCard(BleDevice device) {
    final isConnecting =
        _isConnecting && _connectedDeviceAddress == device.address;
    final isLikelyWatch = _isLikelyWatchDevice(device.name);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: isLikelyWatch ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isLikelyWatch
            ? BorderSide(color: Theme.of(context).primaryColor, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: isConnecting ? null : () => _connectToDevice(device),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isLikelyWatch
                      ? Theme.of(context).primaryColor.withOpacity(0.1)
                      : Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.watch,
                  color: isLikelyWatch
                      ? Theme.of(context).primaryColor
                      : Colors.grey,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            device.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        if (isLikelyWatch)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green[50],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Recommended',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.green[700],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      device.address,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                children: [
                  _buildSignalIndicator(device.rssi),
                  const SizedBox(height: 4),
                  Text(
                    '${device.rssi} dBm',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              if (isConnecting)
                const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey[400],
                ),
            ],
          ),
        ),
      ),
    );
  }

  bool _isLikelyWatchDevice(String name) {
    final lowerName = name.toLowerCase();
    return lowerName.contains('starmax') ||
        lowerName.contains('runmefit') ||
        lowerName.contains('gts') ||
        lowerName.contains('watch') ||
        lowerName.contains('band') ||
        lowerName.contains('fit');
  }

  Widget _buildSignalIndicator(int rssi) {
    final strength = rssi >= -50
        ? 3
        : rssi >= -70
        ? 2
        : 1;
    final color = rssi >= -50
        ? Colors.green
        : rssi >= -70
        ? Colors.orange
        : Colors.red;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return Container(
          width: 4,
          height: 8.0 + (index * 4),
          margin: const EdgeInsets.symmetric(horizontal: 1),
          decoration: BoxDecoration(
            color: index < strength ? color : Colors.grey[300],
            borderRadius: BorderRadius.circular(2),
          ),
        );
      }),
    );
  }

  // ==================== CONNECTED VIEW ====================

  Widget _buildConnectedView() {
    return RefreshIndicator(
      onRefresh: () async => _refreshHealthData(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            _buildConnectedHeader(),
            const SizedBox(height: 16),
            _buildHealthCards(),
            const SizedBox(height: 16),
            _buildQuickActions(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectedHeader() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.watch,
                  color: Colors.white,
                  size: 40,
                ),
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
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
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
                        Text(
                          'Connected',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (_batteryInfo != null) _buildBatteryIndicator(),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildHeaderButton(
                  icon: Icons.vibration,
                  label: 'Find',
                  onTap: _findWatch,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildHeaderButton(
                  icon: Icons.refresh,
                  label: 'Sync',
                  onTap: _refreshHealthData,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildHeaderButton(
                  icon: Icons.link_off,
                  label: 'Disconnect',
                  onTap: _disconnect,
                  isDestructive: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBatteryIndicator() {
    final battery = _batteryInfo!;
    final color = battery.power > 50
        ? Colors.greenAccent
        : battery.power > 20
        ? Colors.orangeAccent
        : Colors.redAccent;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            battery.isCharging
                ? Icons.battery_charging_full
                : battery.power > 50
                ? Icons.battery_full
                : battery.power > 20
                ? Icons.battery_3_bar
                : Icons.battery_1_bar,
            color: color,
            size: 20,
          ),
          const SizedBox(width: 4),
          Text(
            '${battery.power}%',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Material(
      color: isDestructive
          ? Colors.red.withOpacity(0.2)
          : Colors.white.withOpacity(0.2),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            children: [
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHealthCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Health Overview',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildHealthCard(
                  icon: Icons.directions_walk,
                  label: 'Steps',
                  value: '${_healthData?.totalSteps ?? 0}',
                  unit: 'steps',
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildHealthCard(
                  icon: Icons.favorite,
                  label: 'Heart Rate',
                  value: '${_healthData?.heartRate ?? '--'}',
                  unit: 'bpm',
                  color: Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildHealthCard(
                  icon: Icons.water_drop,
                  label: 'Blood Oxygen',
                  value: '${_healthData?.bloodOxygen ?? '--'}',
                  unit: '%',
                  color: Colors.cyan,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildHealthCard(
                  icon: Icons.local_fire_department,
                  label: 'Calories',
                  value: '${_healthData?.totalCalories ?? 0}',
                  unit: 'kcal',
                  color: Colors.orange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildBloodPressureCard(),
          const SizedBox(height: 12),
          _buildWearingStatusCard(),
        ],
      ),
    );
  }

  Widget _buildHealthCard({
    required IconData icon,
    required String label,
    required String value,
    required String unit,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  unit,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBloodPressureCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.purple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.speed,
              color: Colors.purple,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Blood Pressure',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '${_healthData?.systolicBP ?? '--'}',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      ' / ',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      '${_healthData?.diastolicBP ?? '--'}',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'mmHg',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWearingStatusCard() {
    final isWearing = _healthData?.isWearing ?? false;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isWearing ? Colors.green[50] : Colors.orange[50],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isWearing ? Colors.green[200]! : Colors.orange[200]!,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isWearing ? Icons.check_circle : Icons.watch_off,
            color: isWearing ? Colors.green : Colors.orange,
            size: 24,
          ),
          const SizedBox(width: 12),
          Text(
            isWearing ? 'Watch is being worn' : 'Watch is not on wrist',
            style: TextStyle(
              color: isWearing ? Colors.green[700] : Colors.orange[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  icon: Icons.camera_alt,
                  label: 'Camera',
                  onTap: () => _starmaxService.cameraControl('cameraIn'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionButton(
                  icon: Icons.alarm,
                  label: 'Set Time',
                  onTap: () => _starmaxService.setTime(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionButton(
                  icon: Icons.person,
                  label: 'User Info',
                  onTap: () => _showUserInfoDialog(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Icon(icon, size: 28, color: Theme.of(context).primaryColor),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showUserInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Set User Info'),
        content: const Text('This will sync your user information to the watch.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              _starmaxService.setUserInfo(
                sex: 1,
                age: 30,
                height: 170,
                weight: 700,
              );
              Navigator.pop(context);
              _showSnackBar('User info sent to watch', Colors.green);
            },
            child: const Text('Sync'),
          ),
        ],
      ),
    );
  }
}