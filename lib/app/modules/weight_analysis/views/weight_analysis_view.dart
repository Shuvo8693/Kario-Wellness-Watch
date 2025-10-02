
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kario_wellness_watch/app/modules/blood_glucose/widgets/periodic_selector.dart';
import 'package:kario_wellness_watch/app/modules/weight_analysis/widgets/manual_weight_recording_dialouge.dart';
import 'package:kario_wellness_watch/app/modules/weight_analysis/widgets/weight_analysis_card.dart';
import 'package:kario_wellness_watch/common/app_text_style/google_app_style.dart';
import 'package:kario_wellness_watch/common/widgets/custom_button.dart';
import 'package:syncfusion_flutter_charts/charts.dart' hide CornerStyle;
import 'package:syncfusion_flutter_gauges/gauges.dart';

class WeightAnalysisView extends StatefulWidget {
  const WeightAnalysisView({super.key});

  @override
  State<WeightAnalysisView> createState() => _WeightAnalysisViewState();
}

class _WeightAnalysisViewState extends State<WeightAnalysisView> {
  final String _selectedPeriod = 'Day';
  double _currentWeight = 145.5;
  double _bmi = 22.1;
  final double _targetWeight = 138.1;

  final List<ChartData> _weightTrendData = [
    ChartData('2024/7/20', 148),
    ChartData('2025/03/01', 145.5),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Weight',
          style: GoogleFontStyles.h3(
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Period Selector
            PeriodSelector(selectedPeriod: _selectedPeriod),

            // Weight Analysis Card
            WeightAnalysisCard(bmi: _bmi, targetWeight: _targetWeight),

            // Weight Change Info
            Container(
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
                    'Decreased by 0.0 lb compared to the last record',
                    style: GoogleFontStyles.h5(
                      color: Colors.black87,
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // Weight Gauge
                  SizedBox(
                    height: 180.h,
                    child: SfRadialGauge(
                      axes: <RadialAxis>[
                        RadialAxis(
                          minimum: 0,
                          maximum: 100,
                          startAngle: 180,
                          endAngle: 0,
                          showLabels: true,
                          interval: 10,
                          labelOffset: 10,
                          axisLineStyle: AxisLineStyle(
                            thickness: 20,
                            color: Colors.grey[300],
                          ),
                          pointers: <GaugePointer>[
                            RangePointer(
                              value: 45,
                              width: 20,
                              color: Colors.orange,
                              cornerStyle: CornerStyle.bothCurve,
                            ),
                          ],
                          annotations: <GaugeAnnotation>[
                            GaugeAnnotation(
                              widget: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'lb',
                                    style: GoogleFontStyles.h6(
                                      color: Colors.black54,
                                    ),
                                  ),
                                  Text(
                                    _currentWeight.toString(),
                                    style: GoogleFontStyles.h1(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 36.sp,
                                    ),
                                  ),
                                ],
                              ),
                              angle: 90,
                              positionFactor: 0.7,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Trend Section
            Container(
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
            ),

            // Historical Data
            GestureDetector(
              onTap: () {
                // Navigate to historical data
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
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
    );
  }

  void _showManualRecordingDialog() {
    showDialog(
      context: context,
      builder: (context) => ManualWeightRecordingDialog(
        onSave: (value) {
          setState(() {
            _currentWeight = value;
            // Recalculate BMI (simplified formula)
            _bmi = (value / 2.205) / ((1.75 * 1.75));
          });
        },
      ),
    );
  }
}


class ChartData {
  final String label;
  final double value;

  ChartData(this.label, this.value);
}


