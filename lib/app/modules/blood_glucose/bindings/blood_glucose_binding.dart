import 'package:get/get.dart';

import '../controllers/boold_glucose_controller.dart';

class BloodGlucoseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BooldGlucoseController>(
      () => BooldGlucoseController(),
    );
  }
}
