
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kario_wellness_watch/app/routes/app_pages.dart';
import 'package:kario_wellness_watch/common/app_text_style/google_app_style.dart';

class AppCenter extends StatelessWidget {
  const AppCenter({super.key});

  @override
  Widget build(BuildContext context) {
    final appItems = [
      {'icon': Icons.notifications, 'label': 'Notifications', 'color': Colors.green},
      {'icon': Icons.settings, 'label': 'Device settings', 'color': Colors.grey},
      {'icon': Icons.alarm, 'label': 'Alarm Clock', 'color': Colors.grey},
      {'icon': Icons.cloud_queue, 'label': 'Weather', 'color': Colors.grey},
      {'icon': Icons.track_changes, 'label': 'Goals', 'color': Colors.grey},
      {'icon': Icons.camera_alt, 'label': 'Pictures taking', 'color': Colors.grey},
      {'icon': Icons.search, 'label': 'Find device', 'color': Colors.grey},
      {'icon': Icons.system_update, 'label': 'Upgrade', 'color': Colors.grey},
      {'icon': Icons.restart_alt, 'label': 'Factory reset', 'color': Colors.grey},
      {'icon': Icons.sports, 'label': 'Sports modes', 'color': Colors.grey},
    ];

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
                'App center',
                style: GoogleFontStyles.h3(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              Icon(
                Icons.chevron_right,
                size: 24.sp,
                color: Colors.grey[400],
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // App grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8.w,
              mainAxisSpacing: 3.h,
              childAspectRatio: 0.8,
            ),
            itemCount: appItems.length,
            itemBuilder: (context, index) {
              final item = appItems[index];
              return _buildAppItem(item);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAppItem(Map<String, dynamic> item) {
    return GestureDetector(
      onTap: () {
        // Handle app item tap
        switch(item['label']){
          case 'Notifications':
            Get.toNamed(Routes.NOTIFICATION);
            break;
            case 'Device settings':
            Get.toNamed(Routes.DEVICE_SETTINGS);
            break;
            case 'Alarm Clock':
            Get.toNamed(Routes.ALARM);
            break;
            case 'Goals':
            Get.toNamed(Routes.GOALS);
            break;
        }
      },
      child: Column(
        children: [
          Container(
            width: 48.w,
            height: 48.h,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              item['icon'] as IconData,
              size: 24.sp,
              color: item['color'] as Color,
            ),
          ),

          SizedBox(height: 8.h),

          Expanded(
            child: Text(
              item['label'] as String,
              textAlign: TextAlign.center,
              style: GoogleFontStyles.customSize(
                size: 10.sp,
                color: Colors.grey[700],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}