import 'package:get/get.dart';

import '../modules/alarm/bindings/alarm_binding.dart';
import '../modules/alarm/views/alarm_view.dart';
import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/views/sign_in_view.dart';
import '../modules/auth/views/signup_view.dart';
import '../modules/blood_glucose/bindings/blood_glucose_binding.dart';
import '../modules/blood_glucose/views/blood_glucose_view.dart';
import '../modules/device_settings/bindings/device_settings_binding.dart';
import '../modules/device_settings/views/device_settings_view.dart';
import '../modules/devices/bindings/devices_binding.dart';
import '../modules/devices/views/devices_view.dart';
import '../modules/exercise/bindings/exercise_binding.dart';
import '../modules/exercise/views/exercise_view.dart';
import '../modules/gender_selection/bindings/gender_selection_binding.dart';
import '../modules/gender_selection/views/age_input_view.dart';
import '../modules/gender_selection/views/gender_selection_view.dart';
import '../modules/gender_selection/views/height_input_view.dart';
import '../modules/gender_selection/views/weight_input_view.dart';
import '../modules/goals/bindings/goals_binding.dart';
import '../modules/goals/views/goals_view.dart';
import '../modules/health_metrics/bindings/health_metrics_binding.dart';
import '../modules/health_metrics/views/health_metrics_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/hrv/bindings/hrv_binding.dart';
import '../modules/hrv/views/hrv_view.dart';
import '../modules/my/bindings/my_binding.dart';
import '../modules/my/views/my_view.dart';
import '../modules/my/views/permission_screen.dart';
import '../modules/my/views/profile_edit_view.dart';
import '../modules/my/views/profile_view.dart';
import '../modules/notification/bindings/notification_binding.dart';
import '../modules/notification/views/notification_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/sports_mode/bindings/sports_mode_binding.dart';
import '../modules/sports_mode/views/sports_mode_view.dart';
import '../modules/sports_records/bindings/sports_records_binding.dart';
import '../modules/sports_records/views/sports_records_view.dart';
import '../modules/weight_analysis/bindings/weight_analysis_binding.dart';
import '../modules/weight_analysis/views/weight_analysis_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.GENDER_SELECTION,
      page: () => const GenderSelectionView(),
      binding: GenderSelectionBinding(),
    ),
    GetPage(
      name: _Paths.AGEINPUT,
      page: () => const AgeInputView(),
      binding: GenderSelectionBinding(),
    ),
    GetPage(
      name: _Paths.WEIGHTINPUT,
      page: () => WeightInputView(),
      binding: GenderSelectionBinding(),
    ),
    GetPage(
      name: _Paths.HEIGHTINPUT,
      page: () => HeightInputView(),
      binding: GenderSelectionBinding(),
    ),
    GetPage(
      name: _Paths.EXERCISE,
      page: () => const ExerciseView(),
      binding: ExerciseBinding(),
    ),
    GetPage(
      name: _Paths.DEVICES,
      page: () => const DevicesView(),
      binding: DevicesBinding(),
    ),
    GetPage(
      name: _Paths.MY,
      page: () => const MyView(),
      binding: MyBinding(),
    ),
    GetPage(
      name: _Paths.PROFILEEDIT,
      page: () => ProfileEditScreen(),
      binding: MyBinding(),
    ),
    GetPage(
      name: _Paths.PROFILESHOW,
      page: () => ProfileShowScreen(),
      binding: MyBinding(),
    ),
    GetPage(
      name: _Paths.PERMISSION,
      page: () => PermissionsScreen(),
      binding: MyBinding(),
    ),
    GetPage(
      name: _Paths.SIGNIN,
      page: () => const SignInView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.SIGNUP,
      page: () => SignUpScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.NOTIFICATION,
      page: () => const NotificationView(),
      binding: NotificationBinding(),
    ),
    GetPage(
      name: _Paths.DEVICE_SETTINGS,
      page: () => const DeviceSettingsView(),
      binding: DeviceSettingsBinding(),
    ),
    GetPage(
      name: _Paths.ALARM,
      page: () => const AlarmView(),
      binding: AlarmBinding(),
    ),
    GetPage(
      name: _Paths.GOALS,
      page: () => const GoalsView(),
      binding: GoalsBinding(),
    ),
    GetPage(
      name: _Paths.SPORTS_MODE,
      page: () => const SportsModeView(),
      binding: SportsModeBinding(),
    ),
    GetPage(
      name: _Paths.HEALTH_METRICS,
      page: () => HealthMetricsView(
        metricType: HealthMetricType.heartRate,
      ),
      binding: HealthMetricsBinding(),
    ),
    GetPage(
      name: _Paths.BLOOD_GLUCOSE,
      page: () => const BloodGlucoseView(),
      binding: BloodGlucoseBinding(),
    ),
    GetPage(
      name: _Paths.WEIGHT_ANALYSIS,
      page: () => const WeightAnalysisView(),
      binding: WeightAnalysisBinding(),
    ),
    GetPage(
      name: _Paths.HRV,
      page: () => const HrvView(),
      binding: HrvBinding(),
    ),
    GetPage(
      name: _Paths.SPORTS_RECORDS,
      page: () => const SportsRecordsView(),
      binding: SportsRecordsBinding(),
    ),
  ];
}
