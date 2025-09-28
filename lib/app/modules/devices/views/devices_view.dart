import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kario_wellness_watch/app/modules/devices/widgets/add_device.dart';
import 'package:kario_wellness_watch/app/modules/devices/widgets/app_center.dart';
import 'package:kario_wellness_watch/app/modules/devices/widgets/device_connection_card.dart';
import 'package:kario_wellness_watch/app/modules/devices/widgets/device_header.dart';
import 'package:kario_wellness_watch/app/modules/home/widgets/health_app_bar.dart';
import 'package:kario_wellness_watch/common/app_text_style/google_app_style.dart';
import 'package:kario_wellness_watch/common/bottom_menu/bottom_menu..dart';

class DevicesView extends StatefulWidget {
  const DevicesView({super.key});

  @override
  State<DevicesView> createState() => _DevicesViewState();
}

class _DevicesViewState extends State<DevicesView> {
  bool isDeviceActive = false;
  bool isConnected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: KarioAppBar(
        title: 'Devices',
        isUnpairActionActive: isDeviceActive,
        isHomeActionActive: !isDeviceActive,
        onUnpairTap: () {
          setState(() {
            isDeviceActive = false;
          });
        },
      ),
      bottomNavigationBar: SafeArea(child: BottomMenu(2)),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 12.h),
                // add device
                !isDeviceActive
                    ? AddDevice(
                        addDeviceTab: () {
                          setState(() {
                            isDeviceActive = true;
                          });
                        },
                      )
                    : DeviceHeader(),
                SizedBox(height: 40.h),
                if(!isDeviceActive)
                DeviceConnectionCard(
                  deviceName: 'S5-66d42',
                  deviceId: '93:05:12:C9:6D:42',
                  isConnected: isConnected,
                  onConnect: () {
                    setState(() {
                      isConnected = true;
                      isDeviceActive = true;
                    });
                    // Handle connect logic
                    print('Connecting to device...');
                  },
                  onDisconnect: () {
                    setState(() {
                      isConnected = false;
                      isDeviceActive = false;
                    });
                    // Handle disconnect logic
                    print('Disconnecting from device...');
                  },
                ),
                // Device Header Section
                SizedBox(height: 8.h),

                // Watch Face Gallery Section
                if(isDeviceActive)
                _buildWatchFaceGallery(),

                SizedBox(height: 8.h),

                // App Center Section
                if(isDeviceActive)
                AppCenter(),

                SizedBox(height: 24.h),
              ],
            ),
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
                    style: GoogleFontStyles.h5(color: Colors.grey[600]),
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
                return Container(
                  height: 80.h,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.all(Radius.circular(8.r)),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
