import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kario_wellness_watch/common/app_color/app_colors.dart';
import 'package:kario_wellness_watch/common/app_text_style/google_app_style.dart';

class AddDevice extends StatelessWidget {
  final VoidCallback addDeviceTab;
  const AddDevice({super.key, required this.addDeviceTab});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 85.h,
      child: Card(
        child: Center(
          child: GestureDetector(
            onTap: addDeviceTab,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Plus icon circle
                Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 24.sp,
                  ),
                ),

                SizedBox(width: 16.w),

                // Add Device text
                Text(
                  'Add Device',
                  style: GoogleFontStyles.h2(
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}