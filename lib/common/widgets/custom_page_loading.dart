import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kario_wellness_watch/common/app_color/app_colors.dart';


class CustomPageLoading extends StatelessWidget {
  const CustomPageLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SpinKitCircle(
        color:AppColors.primaryColor,
        size: 60.0,
    ),);
  }
}

