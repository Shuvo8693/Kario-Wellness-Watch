import 'package:geolocator/geolocator.dart';

class LocationService {
  /// 1# ============= Get the current location of the device =====================
 static Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    // Check location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied, we cannot request permissions.');
    }

    // Get current position
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );
  }

  /// 2# ====== Get current location with custom settings =================
  Future<Position> getCurrentLocationWithSettings({
    LocationAccuracy accuracy = LocationAccuracy.best,
    Duration? timeLimit,
  }) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied.');
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: accuracy,
      timeLimit: timeLimit,
    );
  }

  /// Check if location permissions are granted
  Future<bool> hasLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  /// Request location permissions
  Future<LocationPermission> requestLocationPermission() async {
    return await Geolocator.requestPermission();
  }

  /// Check if location services are enabled
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// Open location settings
  Future<bool> openLocationSettings() async {
    return await Geolocator.openLocationSettings();
  }

  /// Get distance between two positions in meters
  double getDistanceBetween(
      double startLatitude,
      double startLongitude,
      double endLatitude,
      double endLongitude,
      ) {
    return Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }
}

// Usage example:
/*
void main() async {
  LocationService locationService = LocationService();

  try {
    Position position = await locationService.getCurrentLocation();
    print('Current location: ${position.latitude}, ${position.longitude}');
    print('Accuracy: ${position.accuracy} meters');
    print('Altitude: ${position.altitude} meters');
    print('Speed: ${position.speed} m/s');
  } catch (e) {
    print('Error getting location: $e');
  }
}
*/