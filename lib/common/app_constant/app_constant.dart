

import 'package:kario_wellness_watch/common/app_icons/app_icons.dart';
import 'package:kario_wellness_watch/common/model/language_model.dart';

class AppConstants {


  static const token = 'token';
  static const company = 'company';
  static const tempId = 'tempId';
  static const userId = 'userId';
  static const resetPasswordToken = 'resetPasswordToken';



  static const demoImage = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTw_HeSzHfBorKS4muw4IIeVvvRgnhyO8Gn8w&s';
  static const mechanicImage = 'https://media.istockphoto.com/id/2093786313/photo/mechanic-technician-holding-a-drill-for-the-wheel-screw-smiling-for-the-camera.webp?a=1&b=1&s=612x612&w=0&k=20&c=WzFsLW-95CA1q9b8A5DZ4HX5Zp-pNncjND-XIvQjCos=';
  static const demoPersonImage = 'https://media.istockphoto.com/id/1416037924/photo/bearded-man-standing-showing-his-smart-watch-and-looking-at-camera-with-toothy-smile.jpg?s=612x612&w=0&k=20&c=IOiqa1N8UR4CMIdfYJJ76qBoH5DyjGxudI9Beegiw5w=';
  static const golfDemoImage = 'https://images.unsplash.com/photo-1514480573427-1f96cbed6a27?q=80&w=2065&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D';

  static String APP_NAME="Golf Game";
  static String bearerToken="bearerToken";
  static String userID="userID";


  // share preference Key
  static String THEME ="theme";

  static const String LANGUAGE_CODE = 'language_code';
  static const String COUNTRY_CODE = 'country_code';

  static RegExp emailValidator = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  static RegExp passwordValidator = RegExp(
      r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$"
  );
  static List<LanguageModel> languages = [
    LanguageModel( languageName: 'English', countryCode: 'US', languageCode: 'en'),
    LanguageModel( languageName: 'عربى', countryCode: 'SA', languageCode: 'ar'),
    LanguageModel( languageName: 'Spanish', countryCode: 'ES', languageCode: 'es'),
  ];
}
