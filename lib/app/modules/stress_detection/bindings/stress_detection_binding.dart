import 'package:get/get.dart';

import '../controllers/stress_detection_controller.dart';

class StressDetectionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StressDetectionController>(
      () => StressDetectionController(),
    );
  }
}
