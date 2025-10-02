
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kario_wellness_watch/common/app_text_style/google_app_style.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

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
              _buildLegendItem('Reduced', Colors.red),
              SizedBox(width: 24.w),
              _buildLegendItem('Normal', Colors.green),
              SizedBox(width: 24.w),
              _buildLegendItem('Elevated', Colors.orange),
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