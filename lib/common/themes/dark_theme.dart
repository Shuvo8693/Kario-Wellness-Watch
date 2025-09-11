import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kario_wellness_watch/common/app_color/app_colors.dart';

// Helper functions for border styles
OutlineInputBorder _defaultBorder({Color? borderColor, double width = 1}) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(80.r),
    borderSide: BorderSide(
      color: borderColor ?? Colors.white.withValues(alpha: 0.1),
      width: width,
    ),
  );
}

ThemeData dark({Color color = AppColors.primaryColor, BuildContext? context}) => ThemeData(
  fontFamily: GoogleFonts.inder.toString(),
  textTheme: context != null
      ? GoogleFonts.interTextTheme(Theme.of(context).textTheme).apply(
    bodyColor: Colors.white, // Set default text color to white
    displayColor: Colors.white, // Set display text color to white
  )
      : ThemeData.dark().textTheme.apply(
    bodyColor: Colors.white, // Set default text color to white
    displayColor: Colors.white, // Set display text color to white
  ),
  primaryColor: color,
  scaffoldBackgroundColor: AppColors.backgroundColor,
  secondaryHeaderColor: color.withValues(alpha: 0.4),
  disabledColor: AppColors.subTextColor,
  brightness: Brightness.dark,
  hintColor: AppColors.hintColor,
  cardColor: AppColors.cardColor,
  dividerColor: AppColors.dividerColor,
  shadowColor: AppColors.shadowColor,
  canvasColor: AppColors.bottomBarColor,

  // Updated Input Decoration Theme
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.fillColor, // Using AppColors constant
    hintStyle: TextStyle(
      color: AppColors.hintColor,
      fontSize: 16.sp,
      fontFamily: GoogleFonts.inter().fontFamily,
    ),
    labelStyle: TextStyle(
      color: Colors.white.withValues(alpha: 0.8),
      fontSize: 14.sp,
      fontFamily: GoogleFonts.inter().fontFamily,
    ),
    floatingLabelStyle: TextStyle(
      color: Colors.white.withOpacity(0.8),
      fontSize: 14.sp,
      fontFamily: GoogleFonts.inter().fontFamily,
    ),
    errorStyle: TextStyle(
      color: AppColors.errorColor,
      fontSize: 12.sp,
      fontFamily: GoogleFonts.inter().fontFamily,
    ),
    isDense: false,
    contentPadding: EdgeInsets.symmetric(
      horizontal: 16.w,
      vertical: 14.h,
    ),
    // Border styles using helper function
    enabledBorder: _defaultBorder(),
    focusedBorder: _defaultBorder(borderColor: Colors.white.withOpacity(0.3)),
    errorBorder: _defaultBorder(borderColor: AppColors.errorColor),
    focusedErrorBorder: _defaultBorder(borderColor: AppColors.errorColor, width: 1.5),
    disabledBorder: _defaultBorder(borderColor: Colors.white.withOpacity(0.05)),
  ),

  // Text selection theme for better visibility
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: Colors.white,
    selectionColor: Colors.white.withOpacity(0.3),
    selectionHandleColor: Colors.white,
  ),

  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: AppColors.bottomBarColor,
    selectedLabelStyle: TextStyle(color: color),
    unselectedLabelStyle: TextStyle(color: AppColors.subTextColor),
  ),
  textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: color)),
  colorScheme: ColorScheme.dark(primary: color, secondary: color)
      .copyWith(surface: AppColors.cardColor)
      .copyWith(error: AppColors.errorColor),
);