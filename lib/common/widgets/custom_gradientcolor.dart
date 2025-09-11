
import 'package:flutter/material.dart';

class CustomGradientColor extends StatelessWidget {
 final Widget chiled;
  const CustomGradientColor({super.key,required this.chiled});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          tileMode: TileMode.mirror,
          stops: [0.1,0.5, 0.9],
          colors: [
            Color(0xff4361EE).withOpacity(0.5),
            Colors.white.withOpacity(0.2),
            Color(0xff4361EE).withOpacity(0.5)
          ],

        ),
      ),
      child: chiled,

    );
  }
}
