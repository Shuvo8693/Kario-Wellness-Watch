/*
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


class CustomLoadingButton extends StatelessWidget {

  final double width;
  final Color color;
  final Function()? ontap;
  const CustomLoadingButton({
    super.key,
    required this.width,
    required this.color,
    this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Container(
          height: 43,
          width: width,
          decoration: BoxDecoration(
              color: AppColors.mainColor,
              borderRadius: BorderRadius.circular(4)
          ),
          child: Center(
            child: SpinKitThreeInOut(
              color: color,
              size: 30.0,
            ),
          )
        ),
      ),
    );
  }
}*/
