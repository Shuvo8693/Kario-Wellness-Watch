import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kario_wellness_watch/common/app_color/app_colors.dart';
import 'package:kario_wellness_watch/common/app_text_style/google_app_style.dart';

class NotificationToggleItem extends StatelessWidget {
  final IconData? icon;
  final Color? iconColor;
  final Widget? iconWidget;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const NotificationToggleItem({
    super.key,
    this.icon,
    this.iconColor,
    this.iconWidget,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
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
        children: [
          if (iconWidget != null)
            iconWidget!
          else if (icon != null)
            Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: iconColor?.withOpacity(0.1) ?? Colors.grey[200],
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                icon,
                color: iconColor ?? Colors.grey,
                size: 20.sp,
              ),
            ),

          if (icon != null || iconWidget != null) SizedBox(width: 16.w),

          Expanded(
            child: Text(
              title,
              style: GoogleFontStyles.h4(
                color: Colors.black,
              ),
            ),
          ),

          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: AppColors.primaryColor,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: Colors.grey[300],
          ),
        ],
      ),
    );
  }
}