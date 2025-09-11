class Distance{

static final Map<String, double> _speeds = {
    'walking': 5.0,      // km/h
    'cycling': 15.0,     // km/h
    'car': 40.0,         // km/h (city average)
    'motorcycle': 45.0,  // km/h
  };

 static double calculateDuration(double distanceKm, String mode) {
    double speed = _speeds[mode] ?? 40.0;
    return (distanceKm / speed) * 60; // returns minutes
  }
}
///===== info =======
// double distanceKm = 10.0;  // 10 kilometers to travel
// double speedKmh = 50.0;    // traveling at 50 km/hour
//
// double timeHours = distanceKm / speedKmh;  // 10 ÷ 50 = 0.2 hours
// double timeMinutes = timeHours * 60;       // 0.2 × 60 = 12 minutes