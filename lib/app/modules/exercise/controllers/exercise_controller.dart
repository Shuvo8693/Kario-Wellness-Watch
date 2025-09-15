import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class ExerciseController extends GetxController {
  // Observable variables
  final selectedTab = 0.obs;
  final totalDistance = 0.0.obs;
  final isTracking = false.obs;
  final markers = <Marker>[].obs;
  final polylines = <Polyline>[].obs;
  final currentPosition = Rxn<LatLng>();

  // Private variables
  GoogleMapController? _mapController;
  Position? _currentPosition;
  Position? _currentLocationPosition;
  StreamSubscription<Position>? _positionStream;
  final List<LatLng> _routePoints = [];
  double _totalDistanceMeters = 0.0;

  // Add a global key for the map if you're using a ReusableMap widget
  final GlobalKey mapKey = GlobalKey();

  @override
  void onInit() {
    super.onInit();
    requestLocationPermission();
    getCurrentLocation();
  }

  @override
  void onClose() {
    _positionStream?.cancel();
    _mapController?.dispose();
    super.onClose();
  }

  // Tab management
  void changeTab(int index) {
    selectedTab.value = index;
    // Reset distance for new activity type
    totalDistance.value = 0.0;
    _totalDistanceMeters = 0.0;
    _routePoints.clear();
    polylines.clear();
    if (isTracking.value) {
      stopTracking();
    }
  }

  // Google Maps
  void onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    if (_currentPosition != null) {
      _moveToCurrentLocation();
    }
  }

  // Location services
  Future<void> requestLocationPermission() async {
    final status = await Permission.location.request();
    if (status.isDenied || status.isPermanentlyDenied) {
      Get.snackbar(
        'Permission Required',
        'Location permission is required for tracking exercises',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Get.snackbar(
          'Location Services Disabled',
          'Please enable location services to use this feature',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar(
            'Location Permission Denied',
            'Location permissions are denied',
            snackPosition: SnackPosition.BOTTOM,
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        Get.snackbar(
          'Location Permission Denied Forever',
          'Location permissions are permanently denied, please enable in settings',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      _currentPosition = position;
      _currentLocationPosition = position; // Update this as well
      currentPosition.value = LatLng(position.latitude, position.longitude); // Update observable

      // Add marker for current location
      _addCurrentLocationMarker(position);

      // Move camera to current location
      if (_mapController != null) {
        _moveToCurrentLocation();
      }
    } catch (e) {
      Get.snackbar(
        'Location Error',
        'Failed to get current location: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void _addCurrentLocationMarker(Position position) {
    final marker = Marker(
      markerId: const MarkerId('current_location'),
      position: LatLng(position.latitude, position.longitude),
      infoWindow: const InfoWindow(title: 'Current Location'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    );

    markers.clear();
    markers.add(marker);
  }

  void _moveToCurrentLocation() {
    if (_currentPosition != null && _mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          17.0, // Added zoom level for better view
        ),
      );
    }
  }

  // Map controls
  void zoomIn() {
    _mapController?.animateCamera(CameraUpdate.zoomIn());
  }

  void zoomOut() {
    _mapController?.animateCamera(CameraUpdate.zoomOut());
  }

  void goToCurrentLocation() {
    getCurrentLocation();
  }

  // Exercise tracking
  void startTracking() {
    if (_currentPosition == null) {
      Get.snackbar(
        'Location Not Found',
        'Please wait for location to be determined',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isTracking.value = true;
    _routePoints.clear();
    _totalDistanceMeters = 0.0;
    totalDistance.value = 0.0;

    // Add starting point
    _routePoints.add(LatLng(_currentPosition!.latitude, _currentPosition!.longitude));

    // Start listening to location changes
    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5, // Update every 5 meters
      ),
    ).listen(_onLocationUpdate);

    Get.snackbar(
      'Tracking Started',
      _getTrackingMessage(),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  void stopTracking() {
    isTracking.value = false;
    _positionStream?.cancel();

    Get.snackbar(
      'Tracking Stopped',
      'Total distance: ${totalDistance.value.toStringAsFixed(2)} miles',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  void _onLocationUpdate(Position position) {
    if (!isTracking.value) return;

    _currentLocationPosition = position;
    currentPosition.value = LatLng(position.latitude, position.longitude);
    final newPoint = LatLng(position.latitude, position.longitude);

    // Calculate distance from last point
    if (_routePoints.isNotEmpty) {
      final lastPoint = _routePoints.last;
      final distance = Geolocator.distanceBetween(
        lastPoint.latitude,
        lastPoint.longitude,
        newPoint.latitude,
        newPoint.longitude,
      );

      // Add distance if movement is significant (more than 2 meters)
      if (distance > 2) {
        _totalDistanceMeters += distance;
        totalDistance.value = _totalDistanceMeters * 0.000621371; // Convert to miles

        _routePoints.add(newPoint);
        _updatePolyline();
      }
    }

    // Update current location marker
    _addCurrentLocationMarker(position);

    // Move camera to follow user - Fixed to use standard GoogleMapController
    if (_mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(newPoint, 17.0),
      );
    }
  }

  void _updatePolyline() {
    if (_routePoints.length < 2) return;

    final polyline = Polyline(
      polylineId: const PolylineId('exercise_route'),
      points: _routePoints,
      color: _getTrackingColor(),
      width: 4,
      patterns: [],
    );

    polylines.clear();
    polylines.add(polyline);
  }

  // Helper methods
  String _getTrackingMessage() {
    switch (selectedTab.value) {
      case 0:
        return 'Running tracking started';
      case 1:
        return 'Walking tracking started';
      case 2:
        return 'Cycling tracking started';
      default:
        return 'Tracking started';
    }
  }

  Color _getTrackingColor() {
    switch (selectedTab.value) {
      case 0:
        return Colors.orange;
      case 1:
        return Colors.blue;
      case 2:
        return Colors.green;
      default:
        return Colors.orange;
    }
  }

  // Additional helper methods you might need
  String get formattedDistance => totalDistance.value.toStringAsFixed(2);

  String get currentActivity {
    switch (selectedTab.value) {
      case 0:
        return 'Running';
      case 1:
        return 'Walking';
      case 2:
        return 'Cycling';
      default:
        return 'Unknown';
    }
  }
}