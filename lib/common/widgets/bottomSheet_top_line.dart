import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BottomSheetTopLine extends StatelessWidget {
  const BottomSheetTopLine({
    super.key, this.lineColor,
  });
  final Color? lineColor;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.all(8.0.sp),
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          height: 4.h,
          width: 55.w,
          decoration: BoxDecoration(
            color: lineColor ??Colors.black,
            borderRadius: BorderRadius.circular(3.r),
          ),
        ),
      ),
    );
  }
}
