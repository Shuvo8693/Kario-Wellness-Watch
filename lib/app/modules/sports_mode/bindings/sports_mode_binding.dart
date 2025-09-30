import 'package:get/get.dart';

import '../controllers/sports_mode_controller.dart';

class SportsModeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SportsModeController>(
      () => SportsModeController(),
    );
  }
}
