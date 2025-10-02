import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kario_wellness_watch/common/app_text_style/google_app_style.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class WeightChangeGauge extends StatelessWidget {
  const WeightChangeGauge({
    super.key,
    required double currentWeight,
  }) : _currentWeight = currentWeight;

  final double _currentWeight;

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
    );
  }
}