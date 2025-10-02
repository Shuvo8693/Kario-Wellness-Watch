
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kario_wellness_watch/app/modules/blood_glucose/widgets/glucose_chart.dart';
import 'package:kario_wellness_watch/app/modules/blood_glucose/widgets/glucose_meter_gauge.dart';
import 'package:kario_wellness_watch/app/modules/blood_glucose/widgets/manual_recording.dart';
import 'package:kario_wellness_watch/app/modules/blood_glucose/widgets/periodic_selector.dart';
import 'package:kario_wellness_watch/common/app_text_style/google_app_style.dart';
import 'package:kario_wellness_watch/common/custom_appbar/custom_appbar.dart';
import 'package:kario_wellness_watch/common/widgets/custom_button.dart';

class BloodGlucoseView extends StatefulWidget {
  const BloodGlucoseView({super.key});

  @override
  State<BloodGlucoseView> createState() => _BloodGlucoseViewState();
}

class _BloodGlucoseViewState extends State<BloodGlucoseView> {
  final String _selectedPeriod = 'Day';
  double _currentGlucose = 60;

  final List<ChartData> _glucoseData = [
    ChartData('00:00', 0),
    ChartData('06:00', 0),
    ChartData('12:00', 0),
    ChartData('18:00', 97),
    ChartData('24:00', 0),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: CustomAppBar(title: 'Blood Glucose',),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Period Selector
              PeriodSelector(selectedPeriod: _selectedPeriod),
              // Glucose Meter Gauge
              GlucoseMeterGauge(currentGlucose: _currentGlucose),

              SizedBox(height: 16.h),

              // Blood Glucose Level Chart
              GlucoseChart(currentGlucose: _currentGlucose, glucoseData: _glucoseData),

              SizedBox(height: 16.h),

              // Historical Data
              GestureDetector(
                onTap: () {
                  // Navigate to historical data
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 16.w),
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Historical data',
                        style: GoogleFontStyles.h4(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Spacer(),
                      Icon(Icons.arrow_forward_ios, size: 16.sp, color: Colors.black54),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 16.h),

              // About Blood Glucose
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
                      'About Blood Glucose',
                      style: GoogleFontStyles.h4(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      'To track your sleep patterns, simply wear your device to bed.\n\nOnce synced with your device, the app will record and analyze your sleep stages to help you improve your sleep quality and ensure adequate rest.\n\nNote: This device focuses on tracking nighttime sleep, to irregular sleep schedules who tend to sleep less accurate sleep data.',
                      style: GoogleFontStyles.h6(
                        color: Colors.black54,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16.h),

              // Manual Recording Button
              Padding(
                padding: EdgeInsets.all(16.w),
                child: CustomButton(
                  text: 'Manual recording',
                  onTap: () {
                    _showManualRecordingDialog();
                  },
                ),
              ),

              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }



  void _showManualRecordingDialog() {
    showDialog(
      context: context,
      builder: (context) => ManualRecordingDialog(
        onSave: (value) {
          setState(() {
            _currentGlucose = value;
          });
        },
      ),
    );
  }
}







