import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:kario_wellness_watch/common/app_string/app_string.dart';

import 'custom_button.dart';

class ShowStatusOnChangePassItem extends StatelessWidget {
  final VoidCallback  onTap;
  const ShowStatusOnChangePassItem({
    super.key, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        top: 16.0,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 20.h),
          SizedBox(
            height: 170.h,
            child: Lottie.asset('assets/lotti/success_lotti.json'),
          ),
          SizedBox(height: 20.h),
          // Text
          Text(
            AppString.passwordChangedText,
            style:
            const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 10.h),
          Text(
            AppString.returnToTheLoginPageText,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 20.h),
          // Elevated Button
          Padding(
            padding: EdgeInsets.only(bottom: 20.h),
            child: CustomButton(
                onTap: onTap,
                text: 'Ok'),
          )
        ],
      ),
    );
  }
}