import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kario_wellness_watch/common/app_text_style/google_app_style.dart';

class AllHealthFeatures extends StatelessWidget {
  const AllHealthFeatures({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildHealthMetricCard(
                title: 'Heart rate',
                value: '84',
                unit: 'bpm',
                icon: Icons.favorite,
                iconColor: Colors.red,
                backgroundColor: Colors.red.withOpacity(0.3),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildHealthMetricCard(
                title: 'Sleep',
                value: '08 h 10',
                unit: 'Min',
                icon: Icons.bedtime,
                iconColor: Color(0xFF9C27B0),
                backgroundColor: Color(0xFF9C27B0).withOpacity(0.3),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: _buildHealthMetricCard(
                title: 'Sports records',
                value: '0.04 vs 2',
                unit: 'kcal',
                icon: Icons.sports_gymnastics,
                iconColor: Color(0xFFFF9800),
                backgroundColor: Color(0xFFFF9800).withOpacity(0.3),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildHealthMetricCard(
                title: 'Mood tracking',
                value: 'Very pleasant',
                unit: '',
                icon: Icons.sentiment_very_satisfied,
                iconColor: Color(0xFF3F51B5),
                backgroundColor: Color(0xFF3F51B5).withOpacity(0.3),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: _buildHealthMetricCard(
                title: 'Weight',
                value: '145.5',
                unit: 'lb',
                icon: Icons.monitor_weight,
                iconColor: Color(0xFF00BCD4),
                backgroundColor: Color(0xFF00BCD4).withOpacity(0.3),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildHealthMetricCard(
                title: 'Blood oxygen',
                value: '97',
                unit: '%',
                icon: Icons.bubble_chart,
                iconColor: Color(0xFFF44336),
                backgroundColor: Color(0xFFF44336).withOpacity(0.3),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: _buildHealthMetricCard(
                title: 'Blood Glucose',
                value: '60',
                unit: '',
                icon: Icons.water_drop,
                iconColor: Color(0xFFFFEB3B),
                backgroundColor: Color(0xFFFFEB3B).withOpacity(0.3),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildHealthMetricCard(
                title: 'Skin temperature',
                value: '60°',
                unit: 'C',
                icon: Icons.thermostat,
                iconColor: Color(0xFFE91E63),
                backgroundColor: Color(0xFFE91E63).withOpacity(0.3),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: _buildHealthMetricCard(
                title: 'HRV',
                value: '40',
                unit: 'Normal',
                icon: Icons.monitor_heart,
                iconColor: Color(0xFFFF5722),
                backgroundColor: Color(0xFFFF5722).withOpacity(0.3),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(child: Container()), // Empty space to maintain layout
          ],
        ),
      ],
    );
  }

  Widget _buildHealthMetricCard({
    required String title,
    required String value,
    required String unit,
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: GoogleFontStyles.h6(color: Colors.grey[600]),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 18.sp),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          RichText(
            text: TextSpan(
              text: value,
              style: GoogleFontStyles.h4(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              children: [
                if (unit.isNotEmpty) ...[
                  TextSpan(text: ' '),
                  TextSpan(
                    text: unit,
                    style: GoogleFontStyles.h6(color: Colors.grey[600]),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
