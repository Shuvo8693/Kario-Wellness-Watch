import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kario_wellness_watch/common/app_color/app_colors.dart';
import 'package:kario_wellness_watch/common/app_text_style/google_app_style.dart';



class SportModeItem extends StatelessWidget {
  final SportMode sport;
  final bool isSelected;
  final VoidCallback onTap;

  const SportModeItem({
    super.key,
    required this.sport,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Sport Icon
            Icon(
              sport.icon,
              color: AppColors.primaryColor,
              size: 24.sp,
            ),
            SizedBox(width: 16.w),

            // Sport Name
            Expanded(
              child: Text(
                sport.name,
                style: GoogleFontStyles.h5(
                  color: Colors.black87,
                  fontSize: 16.sp,
                ),
              ),
            ),

            // Selection Indicator
            Container(
              width: 24.w,
              height: 24.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.primaryColor : Colors.grey[300],
                border: Border.all(
                  color: isSelected ? AppColors.primaryColor : Colors.grey[400]!,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Icon(
                Icons.check,
                color: Colors.white,
                size: 16.sp,
              )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class SportMode {
  final IconData icon;
  final String name;

  SportMode({
    required this.icon,
    required this.name,
  });
}