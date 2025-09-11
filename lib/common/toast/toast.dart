import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Toast {
  static void showMaterialToast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        padding: EdgeInsets.all(16.r),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        behavior: SnackBarBehavior.floating,
        // Makes it float with rounded corners
        margin: EdgeInsets.all(16.r), // Adds margin from screen edges
      ),
    );
  }
}