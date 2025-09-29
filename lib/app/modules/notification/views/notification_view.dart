
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kario_wellness_watch/app/modules/notification/widgets/notification_toggle_item.dart';
import 'package:kario_wellness_watch/common/app_text_style/google_app_style.dart';
import 'package:kario_wellness_watch/common/custom_appbar/custom_appbar.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  bool enableNotifications = true;
  bool phoneNotifications = true;
  bool messagesNotifications = true;
  bool emailNotifications = true;
  bool facebookNotifications = true;
  bool instagramNotifications = true;
  bool linkedInNotifications = true;
  bool telegramNotifications = true;
  bool otherNotifications = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Notifications'),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(16.w),
          children: [
            // Enable Notifications
            NotificationToggleItem(
              title: 'Enable notifications',
              value: enableNotifications,
              onChanged: (value) {
                setState(() {
                  enableNotifications = value;
                });
              },
            ),

            SizedBox(height: 16.h),

            // Phone
            NotificationToggleItem(
              icon: Icons.phone,
              iconColor: Colors.blue,
              title: 'Phone',
              value: phoneNotifications,
              onChanged: (value) {
                setState(() {
                  phoneNotifications = value;
                });
              },
            ),

            SizedBox(height: 16.h),

            // Messages
            NotificationToggleItem(
              icon: Icons.message,
              iconColor: Colors.blue,
              title: 'Messages',
              value: messagesNotifications,
              onChanged: (value) {
                setState(() {
                  messagesNotifications = value;
                });
              },
            ),

            SizedBox(height: 16.h),

            // Email
            NotificationToggleItem(
              icon: Icons.email,
              iconColor: Colors.lightBlue,
              title: 'Email',
              value: emailNotifications,
              onChanged: (value) {
                setState(() {
                  emailNotifications = value;
                });
              },
            ),

          //  SizedBox(height: 16.h),

/*            // Facebook
            NotificationToggleItem(
              icon: Icons.facebook,
              iconColor: Colors.blue[800]!,
              title: 'Facebook',
              value: facebookNotifications,
              onChanged: (value) {
                setState(() {
                  facebookNotifications = value;
                });
              },
            ),

            SizedBox(height: 16.h),

            // Instagram
            NotificationToggleItem(
              iconWidget: Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.purple, Colors.pink, Colors.orange],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(Icons.camera_alt, color: Colors.white, size: 20.sp),
              ),
              title: 'Instagram',
              value: instagramNotifications,
              onChanged: (value) {
                setState(() {
                  instagramNotifications = value;
                });
              },
            ),

            SizedBox(height: 16.h),

            // LinkedIn
            NotificationToggleItem(
              icon: Icons.business,
              iconColor: Colors.blue[700]!,
              title: 'LinkedIn',
              value: linkedInNotifications,
              onChanged: (value) {
                setState(() {
                  linkedInNotifications = value;
                });
              },
            ),

            SizedBox(height: 16.h),

            // Telegram
            NotificationToggleItem(
              icon: Icons.send,
              iconColor: Colors.blue[400]!,
              title: 'Telegram',
              value: telegramNotifications,
              onChanged: (value) {
                setState(() {
                  telegramNotifications = value;
                });
              },
            ),*/

            SizedBox(height: 16.h),

            // Other
            NotificationToggleItem(
              icon: Icons.more_horiz,
              iconColor: Colors.grey,
              title: 'Other',
              value: otherNotifications,
              onChanged: (value) {
                setState(() {
                  otherNotifications = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

