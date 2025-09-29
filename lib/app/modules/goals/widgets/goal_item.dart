
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kario_wellness_watch/common/app_text_style/google_app_style.dart';

class GoalItem extends StatelessWidget {
  final String title;
  final String value;
  final VoidCallback? onTap;

  const GoalItem({
    super.key,
    required this.title,
    required this.value,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: GoogleFontStyles.h5(
                color: Colors.grey[400],
                fontSize: 15.sp,
              ),
            ),
            Row(
              children: [
                Text(
                  value,
                  style: GoogleFontStyles.h5(
                    color: Colors.grey[400],
                    fontSize: 15.sp,
                  ),
                ),
                SizedBox(width: 8.w),
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey[400],
                  size: 20.sp,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}