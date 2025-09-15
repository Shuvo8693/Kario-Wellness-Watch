
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kario_wellness_watch/app/modules/devices/widgets/app_center.dart';
import 'package:kario_wellness_watch/app/modules/devices/widgets/device_header.dart';
import 'package:kario_wellness_watch/app/modules/home/widgets/health_app_bar.dart';
import 'package:kario_wellness_watch/common/app_text_style/google_app_style.dart';
import 'package:kario_wellness_watch/common/bottom_menu/bottom_menu..dart';

class DevicesView extends StatelessWidget {
  const DevicesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: KarioAppBar(title: 'Devices',isUnpairActionActive: true,),
      bottomNavigationBar: SafeArea(child: BottomMenu(2)),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Device Header Section
              DeviceHeader(),

              SizedBox(height: 8.h),

              // Watch Face Gallery Section
              _buildWatchFaceGallery(),

              SizedBox(height: 8.h),

              // App Center Section
              AppCenter(),

              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }



  Widget _buildWatchFaceGallery() {

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Watch face gallery',
                style: GoogleFontStyles.h3(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              Row(
                children: [
                  Text(
                    'More',
                    style: GoogleFontStyles.h5(
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Icon(
                    Icons.chevron_right,
                    size: 20.sp,
                    color: Colors.grey[600],
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // Watch faces
          SizedBox(
            height: 100.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              separatorBuilder: (context, index) => SizedBox(width: 16.w),
              itemBuilder: (context, index) {
                return Container(height: 80.h,width: 50,decoration: BoxDecoration(color: Colors.black,borderRadius: BorderRadius.all(Radius.circular(8.r))),);
              },
            ),
          ),
        ],
      ),
    );
  }
}

