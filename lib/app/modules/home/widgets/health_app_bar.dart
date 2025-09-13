import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kario_wellness_watch/common/app_text_style/google_app_style.dart';

class HealthAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onMenuTap;
  final VoidCallback? onAddTap;

  const HealthAppBar({
    super.key,
    this.onMenuTap,
    this.onAddTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.grey[50],
      elevation: 0,
      automaticallyImplyLeading: false,
      toolbarHeight: 60.h,
      title: Text(
        'Health',
        style: GoogleFontStyles.h1(
          fontWeight: FontWeight.w700,
          color: Colors.black,
          fontSize: 28.sp,
        ),
      ),
      actions: [
        // Menu icon button
        IconButton(
          onPressed: onMenuTap ?? () {
            // Default menu action
            print('Menu tapped');
          },
          icon: Icon(
            Icons.qr_code_scanner,
            color: Colors.grey[600],
            size: 24.sp,
          ),
          padding: EdgeInsets.all(8.w),
        ),

        SizedBox(width: 4.w),

        // Add icon button
        IconButton(
          onPressed: onAddTap ?? () {
            // Default add action
            print('Add tapped');
          },
          icon: Icon(
            Icons.add,
            color: Colors.grey[600],
            size: 24.sp,
          ),
          padding: EdgeInsets.all(8.w),
        ),

        SizedBox(width: 8.w),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(60.h);
}