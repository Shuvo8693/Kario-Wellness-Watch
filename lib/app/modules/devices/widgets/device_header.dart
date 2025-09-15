
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kario_wellness_watch/common/app_images/app_svg.dart';
import 'package:kario_wellness_watch/common/app_text_style/google_app_style.dart';
import 'package:kario_wellness_watch/common/svg_base64/ExtractionBase64Image.dart';


class DeviceHeader extends StatelessWidget {
  const DeviceHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
      child: Row(
        children: [
          // Watch Device Image
          ExtractBase64ImageWidget(svgAssetPath: AppSvg.kario_watchSvg,height: 100.h),

          // Device Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'S5-66442',
                  style: GoogleFontStyles.h3(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'MAC: 24:4A:1F:D0:66:42',
                  style: GoogleFontStyles.h6(
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    // Connected status
                    Row(
                      children: [
                        Container(
                          width: 8.w,
                          height: 8.h,
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          'Connected',
                          style: GoogleFontStyles.h6(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(width: 16.w),

                    // Battery indicator
                    Row(
                      children: [
                        Icon(
                          Icons.battery_4_bar,
                          size: 16.sp,
                          color: Colors.grey[600],
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          '41%',
                          style: GoogleFontStyles.h6(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
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