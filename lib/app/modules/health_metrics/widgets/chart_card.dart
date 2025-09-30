import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kario_wellness_watch/app/modules/health_metrics/model/healths_metris_model.dart';
import 'package:kario_wellness_watch/common/app_text_style/google_app_style.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartCard extends StatelessWidget {
  const ChartCard({
    super.key,
    required this.config,
  });

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
          Text(config.totalLabel,
            style: GoogleFontStyles.h5(color: Colors.black54),
          ),
          SizedBox(height: 4.h),
          Text('${config.totalValue} ${config.unit}',
            style: GoogleFontStyles.h2(
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 20.h),

          // Syncfusion Chart
          SizedBox(
            height: 180.h,
            child: SfCartesianChart(
              plotAreaBorderWidth: 0,
              primaryXAxis: CategoryAxis(
                majorGridLines: MajorGridLines(width: 0),
                axisLine: AxisLine(width: 1,dashArray: [2]),
              ),
              primaryYAxis: NumericAxis(
                isVisible: false,
              ),
              series: [
                SplineSeries<ChartData, String>(
                  dataSource: config.chartData,
                  xValueMapper: (ChartData data, _) => data.label,
                  yValueMapper: (ChartData data, _) => data.value,
                  color: Colors.cyan,
                  width: 2,
                  markerSettings: MarkerSettings(
                    isVisible: true,
                    color: Colors.cyan,
                    borderColor: Colors.cyan,
                    borderWidth: 2,
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