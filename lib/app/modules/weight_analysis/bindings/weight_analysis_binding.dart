import 'package:get/get.dart';

import '../controllers/weight_analysis_controller.dart';

class WeightAnalysisBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WeightAnalysisController>(
      () => WeightAnalysisController(),
    );
  }
}
