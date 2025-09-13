import 'package:get/get.dart';

import '../controllers/gender_selection_controller.dart';

class GenderSelectionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GenderSelectionController>(
      () => GenderSelectionController(),
    );
  }
}
