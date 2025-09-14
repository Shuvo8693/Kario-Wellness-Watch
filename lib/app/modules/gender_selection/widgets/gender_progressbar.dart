import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kario_wellness_watch/common/app_color/app_colors.dart';

class GenderProgressBar extends StatelessWidget {

  final List<ProgressModel> progressModel;

  const GenderProgressBar({
    super.key, required this.progressModel,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Inactive steps
        ...List.generate(progressModel.length, (index) {
        final progress = progressModel[index];
          return Row(
            children: [
              Container(
                height: 4.h,
                width: 40.w,
                decoration: BoxDecoration(
                  color: progress.isActive? progress.activeColor : Colors.grey[300],
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              if (index < 2) SizedBox(width: 8.w),
            ],
          );
        }),
      ],
    );
  }
}

class ProgressModel {
  final Color activeColor;
  final int activeCount;
  final bool isActive;

  ProgressModel(this.activeCount, this.isActive, {this.activeColor = AppColors.primaryColor});
}