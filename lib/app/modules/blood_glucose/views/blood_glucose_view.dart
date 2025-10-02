
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kario_wellness_watch/app/modules/blood_glucose/widgets/glucose_chart.dart';
import 'package:kario_wellness_watch/app/modules/blood_glucose/widgets/manual_recording.dart';
import 'package:kario_wellness_watch/app/modules/blood_glucose/widgets/periodic_selector.dart';
import 'package:kario_wellness_watch/common/app_text_style/google_app_style.dart';
import 'package:kario_wellness_watch/common/custom_appbar/custom_appbar.dart';
import 'package:kario_wellness_watch/common/widgets/custom_button.dart';
import 'package:kario_wellness_watch/common/widgets/custom_text_field.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

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

class GlucoseMeterGauge extends StatelessWidget {
  const GlucoseMeterGauge({
    super.key,
    required double currentGlucose,
  }) : _currentGlucose = currentGlucose;

  final double _currentGlucose;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 220.h,
            child: SfRadialGauge(
              axes: <RadialAxis>[
                RadialAxis(
                  minimum: 0,
                  maximum: 200,
                  startAngle: 180,
                  endAngle: 0,
                  showLabels: true,
                  showTicks: true,
                  axisLineStyle: AxisLineStyle(
                    thickness: 0.15,
                    thicknessUnit: GaugeSizeUnit.factor,
                    color: Colors.transparent,
                  ),
                  pointers: <GaugePointer>[
                    NeedlePointer(
                      value: _currentGlucose,
                      needleColor: Colors.black,
                      needleStartWidth: 1,
                      needleEndWidth: 4,
                      needleLength: 0.7,
                      knobStyle: KnobStyle(
                        color: Colors.black,
                        borderColor: Colors.black,
                        borderWidth: 0.02,
                        knobRadius: 0.05,
                      ),
                    ),
                  ],
                  ranges: <GaugeRange>[
                    GaugeRange(
                      startValue: 0,
                      endValue: 40,
                      color: Colors.red,
                      startWidth: 20,
                      endWidth: 20,
                    ),
                    GaugeRange(
                      startValue: 40,
                      endValue: 100,
                      color: Colors.green,
                      startWidth: 20,
                      endWidth: 20,
                    ),
                    GaugeRange(
                      startValue: 100,
                      endValue: 200,
                      color: Colors.orange,
                      startWidth: 20,
                      endWidth: 20,
                    ),
                  ],
                  annotations: <GaugeAnnotation>[
                    GaugeAnnotation(
                      widget: Container(
                        width: 100.w,
                        height: 100.h,
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            _currentGlucose.toInt().toString(),
                            style: GoogleFontStyles.h1(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 40.sp,
                            ),
                          ),
                        ),
                      ),
                      angle: 90,
                      positionFactor: 0.5,
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            "Today's blood glucose assessment",
            style: GoogleFontStyles.h6(
              color: Colors.black54,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // _buildLegendItem('Reduced', Colors.red),
              SizedBox(width: 24.w),
              // _buildLegendItem('Normal', Colors.green),
              SizedBox(width: 24.w),
              // _buildLegendItem('Elevated', Colors.orange),
            ],
          ),
        ],
      ),
    );
  }
  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12.w,
          height: 12.h,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 6.w),
        Text(
          label,
          style: GoogleFontStyles.h6(
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}





