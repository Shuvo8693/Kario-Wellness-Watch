import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kario_wellness_watch/common/app_color/app_colors.dart';
import 'package:kario_wellness_watch/common/app_text_style/style.dart';

class CustomIconButtonWithText extends StatelessWidget {
  const CustomIconButtonWithText({
    super.key,
    this.color,
    this.textStyle,
    this.padding = EdgeInsets.zero,
    required this.onTap,
    required this.text,
    required this.icon,
    this.loading = false,
    this.width,
    this.height,
    this.iconAlignment = IconAlignment.start, // Default icon alignment
  });

  final Function() onTap;
  final String text;
  final Icon icon;
  final bool loading;
  final double? height;
  final double? width;
  final Color? color;
  final EdgeInsetsGeometry padding;
  final TextStyle? textStyle;
  final IconAlignment iconAlignment;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: ElevatedButton.icon(
        onPressed: loading ? null : onTap, // Disable button if loading
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
          backgroundColor: color ?? AppColors.primaryColor,
          minimumSize: Size(width ?? Get.width, height ?? 53.h),
        ),
        icon: loading
            ? SizedBox(
          height: 20.h,
          width: 20.h,
          child: const CircularProgressIndicator(
            color: Colors.white,
          ),
        )
            : icon,
        label: loading
            ? SizedBox.shrink()
            : Text(text,
          style: textStyle ??
              AppStyles.h4(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                family: "Schuyler",
                letterSpacing: 1,
              ),
        ),
        iconAlignment: iconAlignment,
      ),
    );
  }
}
