import 'package:get/get.dart';

import '../controllers/sports_records_controller.dart';

class SportsRecordsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SportsRecordsController>(
      () => SportsRecordsController(),
    );
  }
}
