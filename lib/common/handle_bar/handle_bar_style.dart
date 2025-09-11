// Predefined variations for common use cases
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'handle_bar.dart';

class HandleBarStyle {
  // Default handle bar
  static Widget defaultHandle({EdgeInsetsGeometry? margin}) => HandleBar(
    margin: margin,
  );

  // Large handle bar
  static Widget large({Color? color, EdgeInsetsGeometry? margin}) => HandleBar(
    width: 60.w,
    height: 5.h,
    color: color,
    margin: margin,
  );

  // Small handle bar
  static Widget small({Color? color, EdgeInsetsGeometry? margin}) => HandleBar(
    width: 30.w,
    height: 3.h,
    color: color,
    margin: margin,
  );

  // Thick handle bar
  static Widget thick({Color? color, EdgeInsetsGeometry? margin}) => HandleBar(
    width: 50.w,
    height: 6.h,
    borderRadius: 3.r,
    color: color,
    margin: margin,
  );

  // Custom colored handle bars
  static Widget primary({EdgeInsetsGeometry? margin}) => HandleBar(
    color: Colors.blue,
    margin: margin,
  );

  static Widget accent({EdgeInsetsGeometry? margin}) => HandleBar(
    color: Colors.orange,
    margin: margin,
  );

  // Light theme handle bar
  static Widget light({EdgeInsetsGeometry? margin}) => HandleBar(
    color: Colors.grey[400],
    margin: margin,
  );

  // Dark theme handle bar (your current default)
  static Widget dark({EdgeInsetsGeometry? margin}) => HandleBar(
    color: Colors.grey[600],
    margin: margin,
  );
}