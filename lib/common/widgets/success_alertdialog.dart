import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kario_wellness_watch/common/app_text_style/style.dart';

class SuccessDialog extends StatelessWidget {
  const SuccessDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.w),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Success Icon
          Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green.withOpacity(0.1),
            ),
            child: Icon(
              Icons.check_circle_outline,
              size: 48.0,
              color: Colors.green,
            ),
          ),
          SizedBox(height: 16.h),

          // Title
          Text(
            "Request sent successfully",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),

          // Subtitle
          Text(
            "The Mentorship Requests is on review. You can use it after the admin approval.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 24.h),

          // Got it Button
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey.shade100,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              elevation: 0,
            ),
            child: Text(
              "Got it",
              style: AppStyles.h3(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}