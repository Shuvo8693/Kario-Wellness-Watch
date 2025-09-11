import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../app_color/app_colors.dart';
import '../app_text_style/google_styles.dart';

class CustomSimpleTextField extends StatelessWidget {
  final double? horizontalPadding;
  final double? width;
  final TextEditingController? controller;
  final String? hintText;
  final Widget? sufIcon;
  final Widget? preIcon;
  final int? maxLines;
  const CustomSimpleTextField({
    super.key,
     this.hintText,
     this.width,
     this.controller,
      this.horizontalPadding,
     this.sufIcon,
     this.maxLines,
     this.preIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      width: width ?? Get.width,
      decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.borderColor)
      ),
      child:  Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            border: InputBorder.none,
            suffixIcon: sufIcon,
            prefixIcon: preIcon,
            hintText: hintText,
            hintStyle:  TextStyle(color: AppColors.hintColor,fontSize: 14),

          ),
          maxLines: maxLines ?? 1,
        ),
      ),
    );
  }
}