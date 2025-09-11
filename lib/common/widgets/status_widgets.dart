import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StatusCard extends StatelessWidget {
  final String status;
  final Color backgroundColor;
  final Color textColor;
  final double fontSize;
  final double? height;
  final double borderRadius;
  final EdgeInsets padding;

  const StatusCard({
    super.key,
    required this.status,
    this.backgroundColor = const Color(0xFFFFF8E1), // Amber[100]
    this.textColor = const Color(0xFFFFA000), // Amber[800]
    this.fontSize = 12.0, // Default font size
    this.borderRadius = 4.0, // Default border radius
    this.padding = const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: EdgeInsets.symmetric(
        horizontal: padding.horizontal.w,
        vertical: padding.vertical.h,
      ),
      decoration: BoxDecoration(
        color: getBackgroundColor(100),
        borderRadius: BorderRadius.circular(borderRadius.r),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: getBackgroundColor(800),
          fontSize: fontSize.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color getBackgroundColor(int value) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.amber[value]!;
      case 'processing':
        return Colors.blue[value]!;
      case 'completed':
        return Colors.green[value]!;
      default:
        return Colors.grey[value]!;
    }
  }
}