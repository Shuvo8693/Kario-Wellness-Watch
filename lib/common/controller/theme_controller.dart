import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:kario_wellness_watch/common/app_constant/app_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ThemeController extends GetxController implements GetxService {
  final SharedPreferences? sharedPreferences;

  ThemeController({ this.sharedPreferences}) {
    _loadCurrentTheme();
  }

  bool _darkTheme = false;


  bool get darkTheme => _darkTheme;


  void toggleTheme() {
    _darkTheme = !_darkTheme;
    sharedPreferences?.setBool(AppConstants.THEME, _darkTheme);
    update();
  }

  void changeTheme(Color lightColor, Color darkColor) {
    update();
  }

  void _loadCurrentTheme() async {
    _darkTheme = sharedPreferences?.getBool(AppConstants.THEME) ?? false;
    update();
  }
}