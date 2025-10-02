import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kario_wellness_watch/common/app_text_style/google_app_style.dart';

class AboutMetricSection extends StatelessWidget {
  const AboutMetricSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About heart rate',
            style: GoogleFontStyles.h4(
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            'Heart rate is the number of heartbeats per minute, usually expressed as "bpm". It\'s influenced by physical activity, emotions, and medications. Wearing the device to Monitor heart rate helps understand your current status.',
            style: GoogleFontStyles.h6(
              color: Colors.black54,
              height: 1.5,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            'Note: This product is not a medical device, measurement data are only for reference, not intended for medical diagnosis.',
            style: GoogleFontStyles.h6(
              color: Colors.black54,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}