import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CustomTextButtonWithIcon extends StatelessWidget {
  const CustomTextButtonWithIcon({
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
      child: TextButton.icon(
        onPressed: loading ? null : onTap, // Disable button if loading
        style: TextButton.styleFrom(
          foregroundColor:  Colors.white,
          minimumSize: Size(width ?? Get.width, height ?? 53.h),
          backgroundColor: color ?? Colors.transparent, // You can customize this
        ),
        icon: loading
                ? SizedBox(
                  height: 20.h,
                  width: 20.h,
                  child: const CircularProgressIndicator(color: Colors.white),
                )
                : icon,
        label: loading
                ? SizedBox.shrink()
                : Text(
                  text,
                  style:
                      textStyle ??
                      TextStyle(
                        fontWeight: FontWeight.w500,
                       color: Colors.white,
                        letterSpacing: 1,
                      ),
                ),
      ),
    );
  }
}
