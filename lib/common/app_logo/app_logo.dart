import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kario_wellness_watch/common/app_images/app_svg.dart';
import 'package:kario_wellness_watch/common/svg_base64/ExtractionBase64Image.dart';

class AppLogo extends StatelessWidget {
  final double? height;
  const AppLogo({super.key, this.height});

  @override
  Widget build(BuildContext context) {
    return ExtractBase64ImageWidget(svgAssetPath: AppSvg.karioLogoSvg,height: height??80.h);
  }
}
