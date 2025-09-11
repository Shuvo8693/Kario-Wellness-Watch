import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kario_wellness_watch/common/app_color/app_colors.dart';

ThemeData light({Color color = const Color(0xFF4361EE)}) => ThemeData(
  fontFamily: GoogleFonts.poppins().fontFamily,
  primaryColor: color,
  secondaryHeaderColor: Color(0xFF1ED7AA),
  disabledColor: Color(0xFFBABFC4),
  brightness: Brightness.light,

  hintColor: Color(0xFF9F9F9F),
  cardColor: AppColors.primaryColor,
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
    elevation: 5,
  ),
  inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.fillColor,
      hintStyle: TextStyle(color:AppColors.hintColor,fontSize:16.sp),
      isDense: true,
      contentPadding:EdgeInsets.symmetric(
          horizontal:12.w,
          vertical: 16.h
      ),
      enabledBorder: enableBorder(),
      focusedBorder: focusedBorder(),
      errorBorder:errorBorder()

  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      side: BorderSide(color: AppColors.primaryColor), // Border color

    ),
  ),


  textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: color)),
  colorScheme: ColorScheme.light(primary: color, secondary: color).copyWith(background: const Color(0xFFF3F3F3)).copyWith(error: Color(0xFFE84D4F)),

);

OutlineInputBorder enableBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(15.r),
    borderSide: BorderSide(
      color: AppColors.primaryColor.withOpacity(0.1),
    ),


  );
}
OutlineInputBorder focusedBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(15.r),
    borderSide:BorderSide(
      color: AppColors.primaryColor,
    ),
  );
}

OutlineInputBorder errorBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(8.r),
    borderSide:const BorderSide(
      color: Colors.red,
    ),
  );
}
