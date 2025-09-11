import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kario_wellness_watch/common/app_color/app_colors.dart';
import 'package:kario_wellness_watch/common/app_text_style/style.dart';

class CustomOutlineButton extends StatelessWidget {
  const CustomOutlineButton(
      {super.key,
      this.color,
      this.textStyle,
      this.padding = EdgeInsets.zero,
      required this.onTap,
      required this.text,
      this.loading = false,
      this.width,
      this.height,
      this.foregroundColor,
        this.borderSideColor});

  final Function() onTap;
  final String text;
  final bool loading;
  final double? height;
  final double? width;
  final Color? color;
  final EdgeInsetsGeometry padding;
  final TextStyle? textStyle;
  final Color? foregroundColor;
  final Color? borderSideColor;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: OutlinedButton(
        onPressed: loading ? () {} : onTap,
        style: ElevatedButton.styleFrom(
          foregroundColor: foregroundColor??AppColors.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
            side: BorderSide(
              color: borderSideColor?? AppColors.primaryColor,
              width: 2.0, // You can adjust the border width
            ),
          ),
          backgroundColor: color ?? Colors.transparent,
          minimumSize: Size(width ?? Get.width, height ?? 53.h),
        ),
        child: loading
            ? SizedBox(
                height: 20.h,
                width: 20.h,
                child: const CircularProgressIndicator(
                  color: Colors.white,
                ),
              )
            : Text(text, style: textStyle ??
                    AppStyles.h3(
                        fontWeight: FontWeight.w500,
                        color: AppColors.primaryColor),
              ),
      ),
    );
  }
}
