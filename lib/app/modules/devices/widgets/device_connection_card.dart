
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kario_wellness_watch/common/app_images/app_svg.dart';
import 'package:kario_wellness_watch/common/app_text_style/google_app_style.dart';
import 'package:kario_wellness_watch/common/svg_base64/ExtractionBase64Image.dart';
import 'package:kario_wellness_watch/common/widgets/custom_button.dart';

class DeviceConnectionCard extends StatelessWidget {
  final String deviceName;
  final String deviceId;
  final bool isConnected;
  final VoidCallback? onConnect;
  final VoidCallback? onDisconnect;

  const DeviceConnectionCard({
    super.key,
    required this.deviceName,
    required this.deviceId,
    this.isConnected = false,
    this.onConnect,
    this.onDisconnect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.w),
      margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Device Image/Icon
          // Watch Device Image
          ExtractBase64ImageWidget(svgAssetPath: AppSvg.kario_watchSvg,height: 100.h),


          // Device Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  deviceName,
                  style: GoogleFontStyles.h4(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  deviceId,
                  style: GoogleFontStyles.h6(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: 16.w),

          // Connect Button
          CustomButton(
            text: isConnected ? 'Disconnect' : 'Connect',
            onTap: isConnected? onDisconnect! : onConnect!,
            color: isConnected ? Colors.red[400] : Colors.green[400],
            width: 80.w,
            height: 36.h,
            textStyle: GoogleFontStyles.h5(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

// Example usage widget
class DeviceConnectionExample extends StatefulWidget {
  const DeviceConnectionExample({super.key});

  @override
  State<DeviceConnectionExample> createState() => _DeviceConnectionExampleState();
}

class _DeviceConnectionExampleState extends State<DeviceConnectionExample> {
  bool isConnected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Device Connection'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          SizedBox(height: 20.h),
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
        ],
      ),
    );
  }
}