import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kario_wellness_watch/common/app_images/app_images.dart';

import 'app_logo.dart';
import 'notification_icon.dart';

class NotificationAppBar extends StatelessWidget {
  const NotificationAppBar({
    super.key,
    required this.messageOnTap,
    required this.notificationOnTap,
    this.messageCount,
    this.notificationCount,
  });

  final Function() messageOnTap;
  final Function() notificationOnTap;
  final int? messageCount;
  final int? notificationCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppLogo(
            imageHeight: 50.h, imageWidth: 173.w, logo: '===input====='),
        Wrap(
          spacing: 8,
          children: [
            /// Message Notification Button
            InkWell(
              onTap: messageOnTap,
              child: NotificationIcon(
                iconData: Icons.message_outlined,
                iconSize: 30,
                notificationCount: messageCount ?? 0,
              ),
            ),

            /// Notification Button
            InkWell(
              onTap: notificationOnTap,
              child: NotificationIcon(
                iconData: Icons.notifications_none_outlined,
                iconSize: 30,
                notificationCount: notificationCount ?? 0,
              ),
            ),
          ],
        )
      ],
    );
  }
}
