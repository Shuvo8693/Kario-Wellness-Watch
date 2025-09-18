import 'package:get/get.dart';
import 'package:kario_wellness_watch/app/modules/auth/views/signup_view.dart';
import 'package:kario_wellness_watch/app/modules/my/views/profile_edit_view.dart';
import 'package:kario_wellness_watch/app/modules/my/views/profile_view.dart';

import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/views/sign_in_view.dart';
import '../modules/devices/bindings/devices_binding.dart';
import '../modules/devices/views/devices_view.dart';
import '../modules/exercise/bindings/exercise_binding.dart';
import '../modules/exercise/views/exercise_view.dart';
import '../modules/gender_selection/bindings/gender_selection_binding.dart';
import '../modules/gender_selection/views/age_input_view.dart';
import '../modules/gender_selection/views/gender_selection_view.dart';
import '../modules/gender_selection/views/height_input_view.dart';
import '../modules/gender_selection/views/weight_input_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/my/bindings/my_binding.dart';
import '../modules/my/views/my_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';

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
      name: _Paths.SIGNIN,
      page: () => const SignInView(),
      binding: AuthBinding(),
    ),

    GetPage(
      name: _Paths.SIGNUP,
      page: () =>  SignUpScreen(),
      binding: AuthBinding(),
    ),
  ];
}
