
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kario_wellness_watch/app/modules/health_metrics/controllers/health_metrics_controller.dart';
import 'package:kario_wellness_watch/app/modules/health_metrics/model/healths_metris_model.dart';
import 'package:kario_wellness_watch/app/modules/health_metrics/widgets/about_section.dart';
import 'package:kario_wellness_watch/app/modules/health_metrics/widgets/chart_card.dart';
import 'package:kario_wellness_watch/app/modules/health_metrics/widgets/daily_statistics.dart';
import 'package:kario_wellness_watch/app/modules/health_metrics/widgets/goal_progress_widgets.dart';
import 'package:kario_wellness_watch/common/app_text_style/google_app_style.dart';
import 'package:kario_wellness_watch/common/custom_appbar/custom_appbar.dart';

enum HealthMetricType {
  heartRate,
  steps,
  distance,
  calories,
  sleep,
  bloodOxygen,
  skinTemperature,
}

class HealthMetricsView extends StatefulWidget {
  final HealthMetricType metricType;

  const HealthMetricsView({
    super.key,
    required this.metricType,
  });

  @override
  State<HealthMetricsView> createState() => _HealthMetricsViewState();
}

class _HealthMetricsViewState extends State<HealthMetricsView> {
  final _healthMetricsController = Get.put(HealthMetricsController());
  String _selectedPeriod = 'Day';
  String _selectedDate = '2025/7/26';

  HealthMetricConfig get config => _healthMetricsController.getConfig(widget.metricType);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: config.title,),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Period Selector
            Container(
              margin: EdgeInsets.all(16.w),
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                children: ['Day', 'Week', 'Month'].map((period) {
                  final isSelected = _selectedPeriod == period;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedPeriod = period),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.grey[300] : Colors.transparent,
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          period,
                          textAlign: TextAlign.center,
                          style: GoogleFontStyles.h5(
                            color: Colors.black87,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            // Chart Card
            ChartCard(config: config),

            SizedBox(height: 16.h),

            // Daily Statistics
            if (config.dailyStats != null)
              DailyStatistics(selectedPeriod: _selectedPeriod, config: config),

            // Goal Progress
            if (config.goalProgress != null)
              GoalProgressWidgets(config: config),

            // About Section
            if (config.aboutText != null)
              AboutSection(config: config),

            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}








