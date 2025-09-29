import 'package:get/get.dart';

import '../controllers/device_settings_controller.dart';

class DeviceSettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DeviceSettingsController>(
      () => DeviceSettingsController(),
    );
  }
}
