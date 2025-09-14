import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kario_wellness_watch/common/app_color/app_colors.dart';

class ProgressStep extends StatelessWidget {
  final bool isActive;

  const ProgressStep({
    super.key,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36.w,
      height: 4.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2.r),
        color: isActive ? AppColors.primaryColor : Colors.grey.shade300,
      ),
    );
  }
}