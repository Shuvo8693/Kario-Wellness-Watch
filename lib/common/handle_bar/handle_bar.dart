import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HandleBar extends StatelessWidget {
  final double? width;
  final double? height;
  final Color? color;
  final double? borderRadius;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  const HandleBar({
    super.key,
    this.width,
    this.height,
    this.color,
    this.borderRadius,
    this.margin,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? EdgeInsets.only(top: 8.h),
      padding: padding,
      width: width ?? 40.w,
      height: height ?? 4.h,
      decoration: BoxDecoration(
        color: color ?? Colors.grey[600],
        borderRadius: BorderRadius.circular(borderRadius ?? 2.r),
      ),
    );
  }
}

