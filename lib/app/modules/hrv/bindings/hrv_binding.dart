import 'package:get/get.dart';

import '../controllers/hrv_controller.dart';

class HrvBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HrvController>(
      () => HrvController(),
    );
  }
}
