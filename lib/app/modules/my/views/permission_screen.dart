import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kario_wellness_watch/common/app_color/app_colors.dart';
import 'package:kario_wellness_watch/common/app_text_style/google_app_style.dart';

class PermissionsScreen extends StatefulWidget {
  const PermissionsScreen({super.key});

  @override
  State<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends State<PermissionsScreen> {
  final Map<String, bool> _permissions = {
    'Notifications': false,
    'Location': false,
    'Phone': false,
    'Contacts': false,
    'Battery saving': false,
    'Camera': false,
    'Storage': false,
    'Background running': false,
  };

  final Map<String, String> _permissionDescriptions = {
    'Notifications': 'This permission may affect push notifications and messages while using the app. Enable this permission if you need to display push notifications, alarms, and content quickly on this device.',
    'Location': 'To have your exercise habits or use the Food and Nutrition features, place of the Kario app needs your location to track your activities and daily steps on this map.',
    'Phone': 'To make a seamless device connection call permissions, if you choose "Disable" or "Deny," a pop-up may ask you to turn on permissions while using the app. Disable this permission without adding to the background.',
    'Contacts': 'To make a seamless device connection call permissions, if you choose "Disable" or "Deny," a pop-up may ask you to turn on permissions while using the app. Enable the permission for the connection.',
    'Battery saving': 'This optimized automatic power-saving mode may affect multiple aspects of the app for those such as frequency Bluetooth disconnection between connection Bluetooth (frequency), and step counter accuracy may be affected while this app is running.',
    'Camera': 'To use face recognition, photo capture and photo editing features, if you choose "Disable" or "Deny," a pop-up may ask you to turn on permissions while using the app. QmGuard?',
    'Storage': 'To save images, attach data, and read text, examples: taking photos, instant detection, file storage, etc.',
    'Background running': 'To avoid personal data conflicts and excessive data costs, if you choose "Enable" during data determination device "Disable in the permissions permission will not affect overall performance of the app. Enable/disable the app based permissions. Data and use is according to regulation.',
  };

  final Map<String, IconData> _permissionIcons = {
    'Notifications': Icons.notifications_outlined,
    'Location': Icons.location_on_outlined,
    'Phone': Icons.phone_outlined,
    'Contacts': Icons.contacts_outlined,
    'Battery saving': Icons.battery_saver_outlined,
    'Camera': Icons.camera_alt_outlined,
    'Storage': Icons.folder_outlined,
    'Background running': Icons.apps_outlined,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 20.sp),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Permissions',
          style: GoogleFontStyles.h3(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Description
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              child: Text(
                'To ensure seamless device connectivity, data display, and push notifications, while preventing the Kario app from closing unexpectedly, it is recommended to enable the following permissions:',
                style: GoogleFontStyles.h5(
                  color: Colors.black87,
                  height: 1.4,
                ),
              ),
            ),

            SizedBox(height: 10.h),

            // Permissions List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _permissions.length,
              itemBuilder: (context, index) {
                final permission = _permissions.keys.elementAt(index);
                final isEnabled = _permissions[permission]!;

                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: ExpansionTile(
                    leading: Icon(
                      _permissionIcons[permission]!,
                      color: Colors.grey.shade600,
                      size: 24.sp,
                    ),
                    title: Text(
                      permission,
                      style: GoogleFontStyles.h5(
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            'Off',
                            style: GoogleFontStyles.h6(
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.grey.shade600,
                        ),
                      ],
                    ),
                    tilePadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                    childrenPadding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
                    children: [
                      // Description
                      Container(
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          _permissionDescriptions[permission]!,
                          style: GoogleFontStyles.h6(
                            color: Colors.grey.shade700,
                            height: 1.4,
                          ),
                        ),
                      ),

                      SizedBox(height: 12.h),

                      // Toggle Switch
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Text(
                      //       'Enable $permission',
                      //       style: GoogleFontStyles.h5(
                      //         color: Colors.black87,
                      //         fontWeight: FontWeight.w500,
                      //       ),
                      //     ),
                      //     Switch(
                      //       value: isEnabled,
                      //       onChanged: (value) {
                      //         setState(() {
                      //           _permissions[permission] = value;
                      //         });
                      //       },
                      //       activeColor: AppColors.primaryColor,
                      //       inactiveThumbColor: Colors.grey.shade400,
                      //       inactiveTrackColor: Colors.grey.shade300,
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                );
              },
            ),

            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }
}