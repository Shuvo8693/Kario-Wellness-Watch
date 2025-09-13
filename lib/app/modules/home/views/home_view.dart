import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kario_wellness_watch/app/modules/home/widgets/all_health_features.dart';
import 'package:kario_wellness_watch/app/modules/home/widgets/custom_progress_indicator.dart';
import 'package:kario_wellness_watch/app/modules/home/widgets/health_app_bar.dart';
import 'package:kario_wellness_watch/app/modules/home/widgets/wellness_header_card.dart';
import 'package:kario_wellness_watch/common/app_color/app_colors.dart';
import 'package:kario_wellness_watch/common/app_images/app_svg.dart';
import 'package:kario_wellness_watch/common/app_text_style/google_app_style.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HealthAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.h),

              // Header Card
              WellnessHeaderCard(),

              SizedBox(height: 25.h),

              // Top Metrics Row
              _buildTopMetricsRow(),

              SizedBox(height: 20.h),

              // Health Metrics Grid
              AllHealthFeatures(),

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
