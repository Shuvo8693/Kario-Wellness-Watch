
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kario_wellness_watch/common/themes/light_theme.dart';

import 'app/routes/app_pages.dart';
import 'common/app_constant/app_constant.dart';
import 'common/controller/theme_controller.dart';
import 'common/themes/dark_theme.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(ThemeController());

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then((_){
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return GetBuilder<ThemeController>(
        builder: (themeController) {
          return ScreenUtilInit(
              designSize: const Size(393, 852),
              minTextAdapt: true,
              splitScreenMode: true,
              builder: (_, child) {
                return GetMaterialApp(
                  title: AppConstants.APP_NAME,
                  debugShowCheckedModeBanner: false,
                  navigatorKey: Get.key,
                  theme: light(),
                  defaultTransition: Transition.topLevel,
                  transitionDuration: const Duration(milliseconds: 300),
                  initialRoute: AppPages.INITIAL,
                  getPages: AppPages.routes,
                );
              }
          );
        }
    );
  }
}