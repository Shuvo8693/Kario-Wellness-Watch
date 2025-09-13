import 'package:flutter/material.dart';

class AppColors{

  static const primaryColor= Color(0xFF3ABA75);
  static final scaffoldBgColor= Colors.grey[50];
  static const seconderyAppColor= Color(0xFF241E2B);
  static const pictonBlueColor= Color(0xFF2ABEE5);
  static const melachiteColor= Color(0xFF08E331);
  static const pumpkinOrangeColor= Color(0xFFFD6A24);


  // Input field colors
  static const Color fillColor = Color(0xFF2A2535); // Dark input background
  static const Color inputBorderColor = Color(0x1AFFFFFF); // 10% white opacity
  static const Color inputFocusedBorderColor = Color(0x4DFFFFFF); // 30% white opacity

  // Text colors
  static const Color textColor = Colors.white;
  static const Color subTextColor = Color(0x99FFFFFF); // 60% white opacity
  static const Color hintColor = Color(0x4DFFFFFF); // 30% white opacity

  // Card and container colors
  static const Color cardColor = Color(0xFF2A2535);
  static const Color bottomBarColor = Color(0xFF1E1A24);

  // Other colors
  static const Color dividerColor = Color(0x1AFFFFFF); // 10% white opacity
  static const Color shadowColor = Color(0x40000000); // 25% black opacity
  static const Color errorColor = Color(0xFFDD3135);
  static const Color successColor = Color(0xFF4CAF50);
  static const Color warningColor = Color(0xFFFFA726);

  // Gradient colors (if needed)
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF6366F1),
      Color(0xFF8B5CF6),
    ],
  );


  //fixed color
  static const Color transparent = Colors.transparent;
  static const grayLight = Color(0xffE7E7E7);
  static const gray = Color(0xffa5a5a5);
  static const white = Color(0xffffffff);
  static const black = Color(0xff000000);
  static const green = Color(0xff00BA11);
  static const blue = Color(0xff1A63A6);
  static const greenLight = Color(0xffEDF8F7);
  static const whiteDark = Color(0xffBEBEBE);
  static const primary = Color(0xff4DB5AD);
  static const orange = Color(0xffff6200);
  static const failedColor = Color(0xffff3c00);

  static const backgroundColor= Color(0xFF010101);
  static const Color cardLightColor =  Color(0xFF555555);
  static const Color borderColor =  Color(0xFF2683EB);
  static const Color dark2Color =  Color(0xff565656);
  static const Color secendryColor =  Color(0xFFC4D3F6);
  static const Color greyColor =  Color(0xFFB5B5B5);

  static BoxShadow shadow=BoxShadow(
    blurRadius: 4,
    spreadRadius: 0,
    color: shadowColor,
    offset: const Offset(0, 2),
  );


}