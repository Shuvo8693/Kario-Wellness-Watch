import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kario_wellness_watch/common/app_color/app_colors.dart';



class AppStyles {
  static TextStyle h1(
      {Color? color, FontWeight? fontWeight,
        String? family,
        double? letterSpacing,double? fontSize}) {
    return TextStyle(
        color: color,
        fontSize: fontSize?.sp?? 24.sp,
        letterSpacing: letterSpacing,
        fontFamily: family ?? 'DMSans',
        fontWeight: fontWeight ?? FontWeight.w400);
  }

  static TextStyle h2(
      {Color? color, FontWeight? fontWeight,
        String? family,
        double? letterSpacing,double? height}) {
    return TextStyle(
        color: color,
        fontSize: 20.sp,
        fontFamily: family ?? 'DMSans',
        letterSpacing: letterSpacing,
        height: height,
        fontWeight: fontWeight ?? FontWeight.w400);
  }

  static TextStyle h3({
    Color? color,
    String? family,
    FontWeight? fontWeight,
    double? letterSpacing,

  }) {
    return TextStyle(
        color: color,
        fontSize: 18.sp,
        fontFamily: family ?? 'DMSans',
        letterSpacing: letterSpacing,
        fontWeight: fontWeight ?? FontWeight.w400);
  }

  static TextStyle h4(
      {Color? color,
        FontWeight? fontWeight,
        double? letterSpacing,
        String? family,
        double? height}) {
    return TextStyle(
        fontSize: 16.sp,
        color: color,
        fontFamily: family ?? 'DMSans',
        height: height,
        letterSpacing: letterSpacing,
        fontWeight: fontWeight ?? FontWeight.w500);
  }

  static TextStyle h5(
      {Color? color,
        FontWeight? fontWeight,
        double? letterSpacing,
        String? family,
        double? fontSize,
        double? height}) {
    return TextStyle(
        fontSize: fontSize?.sp??14.sp,
        fontFamily: family ?? 'DMSans',
        color: color,
        height: height,
        letterSpacing: letterSpacing,
        fontWeight: fontWeight ?? FontWeight.w400);
  }

  static TextStyle h6(
      {Color? color,
        FontWeight? fontWeight,
        double? letterSpacing,
        String? family,
        double? height}) {
    return TextStyle(
        fontSize: 12.sp,
        fontFamily: family ?? 'DMSans',
        color: color,
        height: height,
        letterSpacing: letterSpacing,
        fontWeight: fontWeight ?? FontWeight.w400);
  }

  static TextStyle customSize(
      {Color? color,
        required double size,
        String? family,
        double? letterSpacing,
        double? height,
        Color? underlineColor,
        TextDecoration? underline,
        FontWeight? fontWeight}) {
    return TextStyle(
        fontWeight: fontWeight ?? FontWeight.w400,
        color: color,
        fontSize: size,
        decoration: underline ?? TextDecoration.none,
        decorationColor: underlineColor??Colors.transparent,
        fontFamily: family ?? 'DMSans',

        height: height,
        letterSpacing: letterSpacing,
       );
  }

  static BoxShadow boxShadow = BoxShadow(
      blurRadius: 12,
      offset: const Offset(0,0),
      color:AppColors.primaryColor.withOpacity(0.2),
      spreadRadius:0);
}