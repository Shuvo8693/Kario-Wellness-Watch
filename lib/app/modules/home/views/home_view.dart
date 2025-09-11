import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kario_wellness_watch/app/modules/home/widgets/custom_progress_indicator.dart';
import 'package:kario_wellness_watch/common/app_color/app_colors.dart';
import 'package:kario_wellness_watch/common/app_images/app_svg.dart';
import 'package:kario_wellness_watch/common/app_text_style/google_app_style.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),

              // Header Card
              _buildHeaderCard(),

              SizedBox(height: 20.h),

              // Top Metrics Row
              _buildTopMetricsRow(),

              SizedBox(height: 20.h),

              // Health Metrics Grid
              _buildHealthMetricsGrid(),

              SizedBox(height: 20.h),

              // Edit Button
              _buildEditButton(),

              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
 // Header card
  Widget _buildHeaderCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF4CAF50).withOpacity(0.1),
            Color(0xFF81C784).withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Color(0xFF4CAF50).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'KARIO WELLNESS WATCH',
            style: GoogleFontStyles.h5(
              fontWeight: FontWeight.w600,
              color: Color(0xFF4CAF50),
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Wear 2 more nights for Runmefit AI to learn your sleep pattern',
            style: GoogleFontStyles.h6(color: Colors.grey[600], height: 1.3),
          ),
        ],
      ),
    );
  }
 // Metric row
  Widget _buildTopMetricsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        //=== Step===
        CustomProgressIndicator(
          progress: 0.5,
          size: 80,
          strokeWidth: 10.0,
          progressColor: AppColors.melachiteColor,
          centerWidget: SvgPicture.asset(AppSvg.footprintSvg,height: 26.h,),
          bottomWidgets: Column(mainAxisSize: MainAxisSize.min,
              children: [
                Text('29', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
                Text('steps', style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
              ]),
        ),
        //=== Miles ====
        SizedBox(width: 12.w),
        CustomProgressIndicator(
          progress: 0.35,
          size: 80,
          strokeWidth: 10.0,
          progressColor: AppColors.pictonBlueColor,
          centerWidget: Icon(Icons.location_on,color: AppColors.pictonBlueColor,size: 26.h ,),
          bottomWidgets: Column(mainAxisSize: MainAxisSize.min,
              children: [
                Text('0.01', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
                Text('miles', style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
              ]),
        ),
        //===== Kcal =====
        SizedBox(width: 12.w),
        CustomProgressIndicator(
          progress: 0.2,
          size: 80,
          strokeWidth: 10.0,
          progressColor: AppColors.pumpkinOrangeColor,
          centerWidget: Icon(Icons.local_fire_department,color: AppColors.pumpkinOrangeColor,size: 26.h ,),
          bottomWidgets: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('5', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
                Text('kcal', style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
              ]
          ),
        ),
      ],
    );
  }


  Widget _buildHealthMetricsGrid() {
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
                iconColor: Color(0xFFE91E63),
                backgroundColor: Color(0xFFE91E63).withOpacity(0.1),
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
                backgroundColor: Color(0xFF9C27B0).withOpacity(0.1),
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
                backgroundColor: Color(0xFFFF9800).withOpacity(0.1),
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
                backgroundColor: Color(0xFF3F51B5).withOpacity(0.1),
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
                backgroundColor: Color(0xFF00BCD4).withOpacity(0.1),
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
                backgroundColor: Color(0xFFF44336).withOpacity(0.1),
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
                backgroundColor: Color(0xFFFFEB3B).withOpacity(0.1),
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
                backgroundColor: Color(0xFFE91E63).withOpacity(0.1),
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
                backgroundColor: Color(0xFFFF5722).withOpacity(0.1),
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
                child: Icon(icon, color: iconColor, size: 16.sp),
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

  Widget _buildEditButton() {
    return Center(
      child: TextButton(
        onPressed: () {
          // Handle edit action
        },
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
        ),
        child: Text(
          'Edit data card',
          style: GoogleFontStyles.h5(
            color: Color(0xFF4CAF50),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
