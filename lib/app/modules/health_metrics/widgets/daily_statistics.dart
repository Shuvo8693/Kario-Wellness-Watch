import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kario_wellness_watch/app/modules/health_metrics/model/healths_metris_model.dart';
import 'package:kario_wellness_watch/common/app_text_style/google_app_style.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DailyStatistics extends StatelessWidget {
  const DailyStatistics({
    super.key,
    required String selectedPeriod,
    required this.config,
  }) : _selectedPeriod = selectedPeriod;

  final String _selectedPeriod;
  final HealthMetricConfig config;

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
            _selectedPeriod == 'Week' ? 'Weekly statistics' : 'Daily statistics',
            style: GoogleFontStyles.h4(
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(config.dailyStats!.value1, config.dailyStats!.label1, config.unit),
              if (config.dailyStats!.value2 != null)
                _buildStatItem(config.dailyStats!.value2!, config.dailyStats!.label2!, config.unit),
              if (config.dailyStats!.value3 != null)
                _buildStatItem(config.dailyStats!.value3!, config.dailyStats!.label3!, config.unit),
            ],
          ),
        ],
      ),
    );
  }
  Widget _buildStatItem(String value, String label, String unit) {
    return Column(
      children: [
        Text(
          '$value $unit',
          style: GoogleFontStyles.h3(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: GoogleFontStyles.h6(color: Colors.black54),
        ),
      ],
    );
  }
}