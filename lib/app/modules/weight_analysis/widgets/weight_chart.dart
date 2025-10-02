import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kario_wellness_watch/common/app_text_style/google_app_style.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../blood_glucose/widgets/manual_recording.dart';


class WeightChart extends StatelessWidget {
  const WeightChart({
    super.key,
    required List<ChartData> weightTrendData,
  }) : _weightTrendData = weightTrendData;

  final List<ChartData> _weightTrendData;

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
            'Trend',
            style: GoogleFontStyles.h4(
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Your average weight over the past year 145lb',
            style: GoogleFontStyles.h6(
              color: Colors.black54,
            ),
          ),
          SizedBox(height: 20.h),

          // Weight Trend Chart
          SizedBox(
            height: 180.h,
            child: SfCartesianChart(
              plotAreaBorderWidth: 0,
              primaryXAxis: CategoryAxis(
                majorGridLines: MajorGridLines(width: 0),
                axisLine: AxisLine(width: 0),
                labelStyle: TextStyle(fontSize: 10.sp),
              ),
              primaryYAxis: NumericAxis(
                minimum: 140,
                maximum: 151,
                interval: 6,
                majorGridLines: MajorGridLines(
                  width: 1,
                  color: Colors.grey[200],
                ),
                axisLine: AxisLine(width: 0),
              ),
              series: [
                SplineSeries<ChartData, String>(
                  dataSource: _weightTrendData,
                  xValueMapper: (ChartData data, _) => data.label,
                  yValueMapper: (ChartData data, _) => data.value,
                  color: Colors.orange,
                  width: 2,
                  markerSettings: MarkerSettings(
                    isVisible: true,
                    color: Colors.orange,
                    borderColor: Colors.orange,
                    borderWidth: 2,
                    height: 8,
                    width: 8,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8.h),

          // Date Range and Weight Display
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '2024/7/20',
                style: GoogleFontStyles.h6(color: Colors.black54),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  '145 lb',
                  style: GoogleFontStyles.h6(
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Text(
                '2025/03/01',
                style: GoogleFontStyles.h6(color: Colors.black54),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            'Since the first data entry: 7days',
            style: GoogleFontStyles.h6(color: Colors.black54),
          ),
          SizedBox(height: 8.h),
          Text(
            'Most data saves within two targets',
            style: GoogleFontStyles.h6(color: Colors.black54),
          ),
        ],
      ),
    );
  }
}