import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import '../app_color/app_colors.dart';

class CustomLoaderButton extends StatelessWidget {
  const CustomLoaderButton({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
      height: 43,
      width: Get.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFCF1820), Color(0xFF5E0A0D)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Center(child: SpinKitDualRing(
        color: AppColors.white,
        size: 30.0,
      ),),
    );
  }
}

class CustomLoader extends StatelessWidget {
  final Color color;
  const CustomLoader({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Center(child: SpinKitDualRing(
      color: color,
      size: 30.0,
    ),);
  }
}
