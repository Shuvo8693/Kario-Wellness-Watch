import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kario_wellness_watch/common/app_text_style/google_app_style.dart';

class DevicePairingView extends StatefulWidget {
  const DevicePairingView({super.key});

  @override
  State<DevicePairingView> createState() => _DevicePairingViewState();
}

class _DevicePairingViewState extends State<DevicePairingView>
    with TickerProviderStateMixin {
  late AnimationController _dotsController;
  late AnimationController _successController;
  late Animation<double> _fadeAnimation;

  bool isPairing = true;
  bool showSuccess = false;

  @override
  void initState() {
    super.initState();

    // Animation for pairing dots
    _dotsController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Animation for success state
    _successController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _successController,
      curve: Curves.easeInOut,
    ));

    // Start pairing animation
    _dotsController.repeat();

    // Simulate pairing completion after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      _completePairing();
    });
  }

  void _completePairing() {
    setState(() {
      isPairing = false;
      showSuccess = true;
    });

    _dotsController.stop();
    _successController.forward();

    // Auto navigate back or show next screen after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context);
    });
  }

  @override
  void dispose() {
    _dotsController.dispose();
    _successController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Device illustrations
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Phone
                  _buildPhoneDevice(),

                  SizedBox(width: 60.w),

                  // Connection indicator
                  _buildConnectionIndicator(),

                  SizedBox(width: 60.w),

                  // Watch
                  _buildWatchDevice(),
                ],
              ),

              SizedBox(height: 60.h),

              // Status text
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: isPairing
                    ? _buildPairingText()
                    : _buildSuccessText(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneDevice() {
    return Container(
      width: 80.w,
      height: 140.h,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Center(
        child: Container(
          width: 60.w,
          height: 100.h,
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
      ),
    );
  }

  Widget _buildWatchDevice() {
    return Container(
      width: 80.w,
      height: 60.h,
      decoration: BoxDecoration(
        color: Colors.grey[700],
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Center(
        child: Container(
          width: 50.w,
          height: 30.h,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Center(
            child: Text(
              'HUAWEI',
              style: GoogleFontStyles.customSize(
                size: 8.sp,
                color: Colors.green,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildConnectionIndicator() {
    if (showSuccess) {
      return FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          width: 40.w,
          height: 40.h,
          decoration: const BoxDecoration(
            color: Colors.green,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.check,
            color: Colors.white,
            size: 24.sp,
          ),
        ),
      );
    }

    return AnimatedBuilder(
      animation: _dotsController,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(4, (index) {
            final delay = index * 0.2;
            final animationValue = (_dotsController.value - delay).clamp(0.0, 1.0);
            final opacity = (animationValue * 2).clamp(0.0, 1.0);

            return Container(
              margin: EdgeInsets.symmetric(horizontal: 2.w),
              child: AnimatedOpacity(
                opacity: opacity > 1.0 ? 2.0 - opacity : opacity,
                duration: const Duration(milliseconds: 100),
                child: Container(
                  width: 8.w,
                  height: 8.h,
                  decoration: const BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildPairingText() {
    return Column(
      key: const ValueKey('pairing'),
      children: [
        Text(
          'Pairing...',
          style: GoogleFontStyles.h3(
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          'Please wait while we connect your device',
          style: GoogleFontStyles.h5(
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildSuccessText() {
    return Column(
      key: const ValueKey('success'),
      children: [
        Text(
          'Pairing Successful',
          style: GoogleFontStyles.h3(
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          'Your device has been connected successfully',
          style: GoogleFontStyles.h5(
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
