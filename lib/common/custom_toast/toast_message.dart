import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../app_color/app_colors.dart';

class CustomToast {
  static void show({
    required String message,
    Color backgroundColor = AppColors.primaryColor,
    Color textColor = Colors.white,
    int durationInSeconds = 3,
  }) {
    Get.snackbar(
      '',
      '',
      titleText: SizedBox.shrink(),
      messageText: Center(
        child: Text(
          message,
          style: GoogleFonts.urbanist(
            color: textColor,
            fontSize: 14,
          ),
        ),
      ),
      backgroundColor: backgroundColor,
      snackPosition: SnackPosition.TOP,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      borderRadius: 8,
      duration: Duration(seconds: durationInSeconds),
      isDismissible: true,
      maxWidth: 300,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      colorText: textColor,
    );
  }
}
