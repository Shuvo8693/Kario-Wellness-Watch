import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationIcon extends StatelessWidget {
  const NotificationIcon({super.key, required this.iconData, this.notificationCount, this.iconColor, this.iconSize});
  final IconData iconData;
  final int? notificationCount;
  final Color? iconColor;
  final double? iconSize;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Base Icon
        Icon(
          iconData,
          size: iconSize?? 40,
          color:iconColor?? Colors.teal,
        ),
        // Notification Badge
        (notificationCount??0) > 0? Positioned(
          right: 0,
          top: 0,
          child: Container(
            width: 16.h,
            height: 16.w,
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            child:  Center(
              child: Text(notificationCount.toString(), // Badge Count
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ):const SizedBox.shrink(),
      ],
    );
  }
}
