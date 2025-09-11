import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kario_wellness_watch/common/app_color/app_colors.dart';

class GoogleFontText extends StatelessWidget {
  final String title;
  final FontWeight? fontWeight;
  final double? fontSize;
  final Color? color;

  const GoogleFontText({
    super.key,
    required this.title,
    this.fontSize=14,
    this.fontWeight=FontWeight.w400,
    this.color=Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Text(title,
      style: GoogleFonts.inder(
        fontWeight: fontWeight,
        fontSize: fontSize,
        color: color,
      ),
    );
  }
}

///====================== Custom Google font size===============


