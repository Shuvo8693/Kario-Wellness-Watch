import 'package:get/get.dart';

import '../controllers/health_metrics_controller.dart';

class HealthMetricsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HealthMetricsController>(
      () => HealthMetricsController(),
    );
  }
}
