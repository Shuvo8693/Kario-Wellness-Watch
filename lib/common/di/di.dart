
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kario_wellness_watch/common/app_constant/app_constant.dart';
import 'package:kario_wellness_watch/common/controller/localization_controller.dart';
import 'package:kario_wellness_watch/common/controller/theme_controller.dart';
import 'package:kario_wellness_watch/common/model/language_model.dart';
import 'package:shared_preferences/shared_preferences.dart';



Future<Map<String, Map<String, String>>>  init() async {
  // Core
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.lazyPut(() => sharedPreferences);

  // Repository

  Get.lazyPut(() => ThemeController(sharedPreferences: Get.find()));
  Get.lazyPut(() => LocalizationController(sharedPreferences: Get.find()));





  //Retrieving localized data
  Map<String, Map<String, String>> _languages = {};
  for(LanguageModel languageModel in AppConstants.languages) {
    String jsonStringValues =  await rootBundle.loadString('assets/language/${languageModel.languageCode}.json');
    Map<String, dynamic> _mappedJson = json.decode(jsonStringValues);
    Map<String, String> _json = Map();
    _mappedJson.forEach((key, value) {
      _json[key] = value.toString();
    });
    _languages['${languageModel.languageCode}_${languageModel.countryCode}'] = _json;
  }
  return _languages;
}