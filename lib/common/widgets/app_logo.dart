import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double imageHeight;
  final double imageWidth;
  final String logo;
  const AppLogo({super.key, required this.imageHeight, required this.imageWidth, required this.logo,});

  @override
  Widget build(BuildContext context) {
      return  Image.asset(logo,
       fit: BoxFit.cover, // Force the image to fill its bounds
        width: imageWidth, // Slightly smaller than the container
        height: imageHeight,
      );
  }
}
