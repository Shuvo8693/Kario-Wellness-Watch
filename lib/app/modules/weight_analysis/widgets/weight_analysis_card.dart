import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kario_wellness_watch/common/app_text_style/google_app_style.dart';

class WeightAnalysisCard extends StatelessWidget {
  const WeightAnalysisCard({
    super.key,
    required double bmi,
    required double targetWeight,
  }) : _bmi = bmi, _targetWeight = targetWeight;

  final double _bmi;
  final double _targetWeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Weight analysis',
            style: GoogleFontStyles.h4(
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              // BMI Section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _bmi.toString(),
                    style: GoogleFontStyles.h1(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 28.sp,
                    ),
                  ),
                  Text(
                    'BMI ↓',
                    style: GoogleFontStyles.h6(
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
              SizedBox(width: 40.w),
              // Target Weight Section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$_targetWeight lb',
                    style: GoogleFontStyles.h1(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 28.sp,
                    ),
                  ),
                  Text(
                    'Should be below',
                    style: GoogleFontStyles.h6(
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}