import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kario_wellness_watch/common/app_color/app_colors.dart';


class GoogleFontStyles {
  static TextStyle h1({
    Color? color,
    FontWeight? fontWeight,
    String? family,
    double? letterSpacing,
    double? fontSize,
    TextStyle? textStyle
  }) {
    return GoogleFonts.inter(
      fontWeight: fontWeight ?? FontWeight.w400,
      fontSize: fontSize ?? 24.sp,
      color: color,
      letterSpacing: letterSpacing,
        textStyle: textStyle
    );
  }

  static TextStyle h2({
    Color? color,
    FontWeight? fontWeight,
    String? family,
    double? letterSpacing,
    double? height,
    TextStyle? textStyle
  }) {
    return GoogleFonts.inter(
      fontWeight: fontWeight ?? FontWeight.w400,
      fontSize: 20.sp,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
        textStyle: textStyle
    );
  }

  static TextStyle h3({
    Color? color,
    String? family,
    FontWeight? fontWeight,
    double? letterSpacing,
    TextStyle? textStyle
  }) {
    return GoogleFonts.inter(
      fontWeight: fontWeight ?? FontWeight.w400,
      fontSize: 18.sp,
      color: color,
      letterSpacing: letterSpacing,
        textStyle: textStyle
    );
  }

  static TextStyle h4({
    Color? color,
    FontWeight? fontWeight,
    double? letterSpacing,
    String? family,
    double? height,
    TextStyle? textStyle
  }) {
    return GoogleFonts.inter(
      fontWeight: fontWeight ?? FontWeight.w500,
      fontSize: 16.sp,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
        textStyle: textStyle
    );
  }

  static TextStyle h5({
    Color? color,
    FontWeight? fontWeight,
    double? letterSpacing,
    String? family,
    double? fontSize,
    double? height,
    TextStyle? textStyle,
  }) {
    return GoogleFonts.inter(
      fontWeight: fontWeight ?? FontWeight.w400,
      fontSize: fontSize ?? 14.sp,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
      textStyle: textStyle
    );
  }

  static TextStyle h6({
    Color? color,
    FontWeight? fontWeight,
    double? letterSpacing,
    String? family,
    double? height,
    TextStyle? textStyle
  }) {
    return GoogleFonts.inter(
      fontWeight: fontWeight ?? FontWeight.w400,
      fontSize: 12.sp,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
        textStyle: textStyle
    );
  }

  static TextStyle customSize({
    Color? color,
    required double size,
    String? family,
    double? letterSpacing,
    double? height,
    Color? underlineColor,
    TextDecoration? underline,
    FontWeight? fontWeight,
    TextStyle? textStyle
  }) {
    return GoogleFonts.inter(
      fontWeight: fontWeight ?? FontWeight.w400,
      color: color,
      fontSize: size,
      decoration: underline ?? TextDecoration.none,
      decorationColor: underlineColor ?? Colors.transparent,
      height: height,
      letterSpacing: letterSpacing,
        textStyle: textStyle
    );
  }

  static BoxShadow boxShadow = BoxShadow(
    blurRadius: 12,
    offset: const Offset(0, 0),
    color: AppColors.primaryColor.withValues(alpha: 0.2),
    spreadRadius: 0,
  );
}