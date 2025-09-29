
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kario_wellness_watch/app/modules/device_settings/widgets/settings_card.dart';
import 'package:kario_wellness_watch/common/app_color/app_colors.dart';
import 'package:kario_wellness_watch/common/app_text_style/google_app_style.dart';
import 'package:kario_wellness_watch/common/custom_appbar/custom_appbar.dart';
import 'package:kario_wellness_watch/common/widgets/spacing.dart';

class DeviceSettingsView extends StatefulWidget {
  const DeviceSettingsView({super.key});

  @override
  State<DeviceSettingsView> createState() => _DeviceSettingsViewState();
}

class _DeviceSettingsViewState extends State<DeviceSettingsView> {
  bool raiseWristToWake = true;
  double brightnessLevel = 91.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Device settings'),
      body: ListView(
        padding: EdgeInsets.all(16.w),
        children: [
          // Raise wrist to wake
          SettingCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Raise wrist to wake',
                            style: GoogleFontStyles.h4(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'When enabled, you can light up your device screen by raising your wrist.',
                            style: GoogleFontStyles.h6(
                              color: Colors.grey[500],
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: raiseWristToWake,
                      onChanged: (value) {
                        setState(() {
                          raiseWristToWake = value;
                        });
                      },
                      activeColor: Colors.white,
                      activeTrackColor: AppColors.primaryColor,
                      inactiveThumbColor: Colors.white,
                      inactiveTrackColor: Colors.grey[300],
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          // Brightness level
          SettingCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Brightness level',
                  style: GoogleFontStyles.h4(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 24.h),
                Row(
                  children: [
                    Icon(
                      Icons.wb_sunny_outlined,
                      color: Colors.grey[600],
                      size: 24.sp,
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: SliderTheme(
                        data: SliderThemeData(
                          trackHeight: 8.h,
                          thumbShape: RoundSliderThumbShape(
                            enabledThumbRadius: 15.r,
                          ),
                          overlayShape: RoundSliderOverlayShape(
                            overlayRadius: 0,
                          ),
                          activeTrackColor: Colors.cyan,
                          inactiveTrackColor: Colors.grey[300],
                          thumbColor: Colors.cyan,
                        ),
                        child: Slider(
                          value: brightnessLevel,
                          min: 0,
                          max: 100,
                          label: '00',
                          onChanged: (value) {
                            setState(() {
                              brightnessLevel = value;
                            });
                          },
                        ),
                      ),
                    ),
                    horizontalSpacing(8.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.cyan,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        '${brightnessLevel.toInt()}%',
                        style: GoogleFontStyles.h6(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 16.h),

          // Screen timeout
          SettingCard(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Screen timeout',
                  style: GoogleFontStyles.h4(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      '5seconds',
                      style: GoogleFontStyles.h5(
                        color: Colors.grey[400],
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Icon(
                      Icons.chevron_right,
                      color: Colors.grey[400],
                      size: 20.sp,
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

