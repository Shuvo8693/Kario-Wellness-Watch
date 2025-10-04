
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kario_wellness_watch/app/modules/blood_glucose/widgets/manual_recording.dart';
import 'package:kario_wellness_watch/app/modules/blood_glucose/widgets/periodic_selector.dart';
import 'package:kario_wellness_watch/app/modules/health_metrics/widgets/about_section.dart';
import 'package:kario_wellness_watch/app/modules/hrv/widgets/about_section.dart';
import 'package:kario_wellness_watch/app/modules/hrv/widgets/hrv_cart.dart';
import 'package:kario_wellness_watch/app/modules/hrv/widgets/stress_detection_card.dart';
import 'package:kario_wellness_watch/app/modules/hrv/widgets/stressdetectionheader_card.dart';
import 'package:kario_wellness_watch/common/app_text_style/google_app_style.dart';
import 'package:kario_wellness_watch/common/custom_appbar/custom_appbar.dart';

class HrvView extends StatefulWidget {
  const HrvView({super.key});

  @override
  State<HrvView> createState() => _HrvViewState();
}

class _HrvViewState extends State<HrvView> {
  final String _selectedPeriod = 'Day';
  final int _currentStressLevel = 40;
  final bool _isExpanded = false;

  final List<ChartData> _stressData = [
    ChartData('00:00', 0),
    ChartData('06:00', 40),
    ChartData('12:00', 0),
    ChartData('18:00', 0),
    ChartData('24:00', 0),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'HRV',),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.h),

              //--- Stress Detection Header Card ----
              StressDetectionHeaderCard(),

              SizedBox(height: 8.h),

              // Latest Stress Level
              Center(
                child: Text(
                  'Latest stress level: $_currentStressLevel',
                  style: GoogleFontStyles.h6(
                    color: Colors.black54,
                  ),
                ),
              ),

              SizedBox(height: 16.h),

              // Stress Detection Expandable Section
              StressDetectionCard(isExpanded: _isExpanded),

              SizedBox(height: 16.h),

              // Period Selector
              PeriodSelector(selectedPeriod: _selectedPeriod),

              SizedBox(height: 16.h),

              // Stress Level Chart
              HrvChart(currentStressLevel: _currentStressLevel, stressData: _stressData),

              SizedBox(height: 16.h),

              // Stress Analysis
              Container(
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
                      'Stress analysis',
                      style: GoogleFontStyles.h4(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      'Latest stress level: $_currentStressLevel',
                      style: GoogleFontStyles.h5(
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16.h),

              // About Heart Rate
              AboutMetricSection(),

              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}






