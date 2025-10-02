
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kario_wellness_watch/app/modules/blood_glucose/widgets/manual_recording.dart';
import 'package:kario_wellness_watch/common/app_text_style/google_app_style.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GlucoseChart extends StatelessWidget {
  const GlucoseChart({
    super.key,
    required double currentGlucose,
    required List<ChartData> glucoseData,
  }) : _currentGlucose = currentGlucose, _glucoseData = glucoseData;

  final double _currentGlucose;
  final List<ChartData> _glucoseData;

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
            'Blood glucose level: ${_currentGlucose.toInt()}',
            style: GoogleFontStyles.h4(
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'mg/dL',
            style: GoogleFontStyles.h6(
              color: Colors.black54,
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
                  dataSource: _glucoseData,
                  xValueMapper: (ChartData data, _) => data.label,
                  yValueMapper: (ChartData data, _) => data.value,
                  color: Colors.green,
                  width: 2,
                  markerSettings: MarkerSettings(
                    isVisible: true,
                    color: Colors.green,
                    borderColor: Colors.green,
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