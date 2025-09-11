import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kario_wellness_watch/common/app_color/app_colors.dart';

class CustomCard extends StatelessWidget {
  final List<Widget> children;
  final double? cardHeight;
  final double? cardWidth;
  final bool? isRow;
  final double? padding;
  final double? elevation;
  final double? borderRadius;
  final Color? borderSideColor;
  final Color? cardColor;
  final CrossAxisAlignment? crossAxisAlignment;
  final MainAxisAlignment? mainAxisAlignment;

  const CustomCard(
      {super.key,
      required this.children,
      this.cardHeight,
      this.cardWidth,
      this.isRow = false,
      this.padding,
      this.borderSideColor,
      this.cardColor,
      this.crossAxisAlignment,
      this.mainAxisAlignment,
      this.elevation, this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: cardHeight?.h,
      width: cardWidth?.w,
      child: Card(
        color: cardColor ?? Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: borderSideColor ?? AppColors.primaryColor, // Outline color
            width: 2.h, // Outline width
          ),
          borderRadius: BorderRadius.circular(borderRadius??10.r), // Rounded corners
        ),
        elevation:elevation?? 5, // Shadow depth
        //margin: EdgeInsets.all(8.sp), // Space outside the card
        child: Padding(
          padding: EdgeInsets.all(padding?.sp ?? 12.sp),
          // Space inside the card
          child: isRow == true
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment:
                      mainAxisAlignment ?? MainAxisAlignment.start,
                  crossAxisAlignment:
                      crossAxisAlignment ?? CrossAxisAlignment.center,
                  children: children,
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
                  mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
                  children: children,
                ),
        ),
      ),
    );
  }
}
