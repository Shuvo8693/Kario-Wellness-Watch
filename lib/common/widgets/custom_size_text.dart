import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kario_wellness_watch/common/app_text_style/style.dart';

class CustomSizeText extends StatelessWidget {
  const CustomSizeText({
    super.key,
    required this.text,
    this.overflow,
    this.style,
    this.customTextSize,
    this.textWidth,
    this.customFontWeight,
  });

  final String text;
  final TextOverflow? overflow;
  final TextStyle? style;
  final double? customTextSize;
  final double? textWidth;
  final FontWeight? customFontWeight;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: textWidth ?? 180.w,
      child: Text(
        text,
        overflow: overflow ?? TextOverflow.fade,
        softWrap: true,
        style: style ??
            AppStyles.customSize(
              size: customTextSize ?? 14,
              fontWeight: customFontWeight ?? FontWeight.w500,
              family: "Schuyler",
            ),
      ),
    );
  }
}