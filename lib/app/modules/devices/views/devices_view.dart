import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kario_wellness_watch/app/modules/devices/widgets/add_device.dart';
import 'package:kario_wellness_watch/app/modules/devices/widgets/app_center.dart';
import 'package:kario_wellness_watch/app/modules/devices/widgets/device_connection_card.dart';
import 'package:kario_wellness_watch/app/modules/devices/widgets/device_header.dart';
import 'package:kario_wellness_watch/app/modules/devices/widgets/searching_device.dart';
import 'package:kario_wellness_watch/app/modules/devices/widgets/watch_face_gallery.dart';
import 'package:kario_wellness_watch/app/modules/home/widgets/health_app_bar.dart';
import 'package:kario_wellness_watch/common/app_text_style/google_app_style.dart';
import 'package:kario_wellness_watch/common/bottom_menu/bottom_menu..dart';

class DevicesView extends StatefulWidget {
  const DevicesView({super.key});

  @override
  State<DevicesView> createState() => _DevicesViewState();
}

class _DevicesViewState extends State<DevicesView> {
  bool isConnected = false;
  bool isDeviceSearching = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: KarioAppBar(
        title: 'Devices',
        isUnpairActionActive: isConnected,
        isHomeActionActive: !isConnected,
        onUnpairTap: () {
          setState(() {
            isConnected =false;
            isDeviceSearching = false;
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
                if(!isConnected && !isDeviceSearching)
                AddDevice(
                  addDeviceTab: () {
                    setState(() {
                      isDeviceSearching = true;
                    });
                  },
                ),
                if(isConnected)
                  DeviceHeader(),
                SizedBox(height: 10.h),
                if(isDeviceSearching && !isConnected )
                DeviceSearching(),
                SizedBox(height: 40.h),
                if(!isConnected)
                DeviceConnectionCard(
                  deviceName: 'S5-66d42',
                  deviceId: '93:05:12:C9:6D:42',
                  isConnected: isConnected,
                  onConnect: () {
                    setState(() {
                      isConnected = true;
                    });
                    // Handle connect logic
                    print('Connecting to device...');
                  },
                  onDisconnect: () {
                    setState(() {
                      isConnected = false;
                    });
                    // Handle disconnect logic
                    print('Disconnecting from device...');
                  },
                ),
                // Device Header Section
                SizedBox(height: 8.h),

                // Watch Face Gallery Section
                if(isConnected)
                  WatchFaceGallery(),

                SizedBox(height: 8.h),

                // App Center Section
                if(isConnected)
                AppCenter(),

                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


