import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:kario_wellness_watch/app/routes/app_pages.dart';
import 'package:kario_wellness_watch/common/app_color/app_colors.dart';
import 'package:kario_wellness_watch/common/app_icons/app_icons.dart';
import 'package:kario_wellness_watch/common/widgets/custom_button.dart';
import 'package:kario_wellness_watch/common/widgets/custom_outlinebutton.dart';

class ThankYouDialog {

  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevents dismissing by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Starburst Checkmark Icon
              SvgPicture.asset('====Give====',height: 90.h,colorFilter: ColorFilter.mode(AppColors.primaryColor, BlendMode.srcIn) ,),
              SizedBox(height: 16.h),
              // Thank You Title
              Text(
                'Thank You!',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8.h),
              // Subtitle
              Text(
                "Thank you for your order! We're thrilled to have you with us.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 20.h),
              // Buttons Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Go Home Button (Outlined)
                  CustomOutlineButton(
                    width: 80.w,
                    onTap: () {
                      Get.offAllNamed(Routes.HOME); // Navigate to Home screen
                    },
                    text: 'Go Home',
                  ),
                  // Track Booking Button (Filled)
                  CustomButton(
                    paddingInner: EdgeInsets.symmetric(horizontal: 8.w),
                    width: 80.w,
                    onTap: () {
                      Get.back(); // Close dialog
                     // Get.toNamed(Routes.ORDERTRACKING); // Navigate to Track Booking screen
                    },
                    text: 'Track Booking',
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}