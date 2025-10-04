
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kario_wellness_watch/common/app_text_style/google_app_style.dart';

class DeviceSearching extends StatefulWidget {
  const DeviceSearching({super.key});

  @override
  State<DeviceSearching> createState() => _DeviceSearchingState();
}

class _DeviceSearchingState extends State<DeviceSearching> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Simple rotating loading indicator
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Transform.rotate(
                angle: _animationController.value * 2 * 3.14159,
                child: Container(
                  width: 85.w,
                  height: 85.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.cyan,
                      width: 4,
                    ),
                    gradient: SweepGradient(
                      colors: [
                        Colors.cyan,
                        Colors.cyan.withOpacity(0.1),
                      ],
                      stops: [0.0, 1.0],
                    ),
                  ),
                ),
              );
            },
          ),

          SizedBox(height: 40.h),

          Text(
            'Searching...',
            style: GoogleFontStyles.h3(
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),

          SizedBox(height: 16.h),

          Text(
            'Did not see your device? Try again',
            style: GoogleFontStyles.h6(
              color: Colors.black38,
            ),
          ),
        ],
      ),
    );
  }
}