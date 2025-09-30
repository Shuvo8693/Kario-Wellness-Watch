import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kario_wellness_watch/app/modules/health_metrics/model/healths_metris_model.dart';
import 'package:kario_wellness_watch/common/app_text_style/google_app_style.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GoalProgressWidgets extends StatelessWidget {
  const GoalProgressWidgets({
    super.key,
    required this.config,
  });

  final HealthMetricConfig config;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Goal progress',
            style: GoogleFontStyles.h4(
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            '${config.goalProgress!.current} ${config.goalProgress!.unit}',
            style: GoogleFontStyles.h2(
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Only ${config.goalProgress!.goal - config.goalProgress!.current} ${config.goalProgress!.unit} to reach the goal',
            style: GoogleFontStyles.h6(color: Colors.black54),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 16.sp),
              SizedBox(width: 8.w),
              Text(
                'Days to reach goal',
                style: GoogleFontStyles.h6(color: Colors.black54),
              ),
              Spacer(),
              Text(
                '${config.goalProgress!.achieved}/${config.goalProgress!.total}',
                style: GoogleFontStyles.h5(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
