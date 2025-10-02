import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kario_wellness_watch/app/modules/blood_glucose/widgets/manual_recording.dart';
import 'package:kario_wellness_watch/app/modules/blood_glucose/widgets/periodic_selector.dart';
import 'package:kario_wellness_watch/common/app_text_style/google_app_style.dart';
import 'package:kario_wellness_watch/common/custom_appbar/custom_appbar.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HrvChart extends StatelessWidget {
  const HrvChart({
    super.key,
    required int currentStressLevel,
    required List<ChartData> stressData,
  }) : _currentStressLevel = currentStressLevel, _stressData = stressData;

  final int _currentStressLevel;
  final List<ChartData> _stressData;

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
            'Latest stress level: $_currentStressLevel',
            style: GoogleFontStyles.h4(
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 20.h),

          // Current Stress Value Display
          Center(
            child: Column(
              children: [
                Text(
                  _currentStressLevel.toString(),
                  style: GoogleFontStyles.h1(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 32.sp,
                  ),
                ),
                Text(
                  '06:00',
                  style: GoogleFontStyles.h6(
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 20.h),

          // Chart
          SizedBox(
            height: 180.h,
            child: SfCartesianChart(
              plotAreaBorderWidth: 0,
              primaryXAxis: CategoryAxis(
                majorGridLines: MajorGridLines(width: 0),
                axisLine: AxisLine(width: 0),
              ),
              primaryYAxis: NumericAxis(
                minimum: 0,
                maximum: 180,
                interval: 60,
                majorGridLines: MajorGridLines(
                  width: 1,
                  color: Colors.grey[200],
                ),
                axisLine: AxisLine(width: 0),
              ),
              series: [
                SplineSeries<ChartData, String>(
                  dataSource: _stressData,
                  xValueMapper: (ChartData data, _) => data.label,
                  yValueMapper: (ChartData data, _) => data.value,
                  color: Colors.cyan,
                  width: 2,
                  markerSettings: MarkerSettings(
                    isVisible: true,
                    color: Colors.cyan,
                    borderColor: Colors.cyan,
                    borderWidth: 2,
                    height: 8,
                    width: 8,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}