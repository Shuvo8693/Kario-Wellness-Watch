
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:async';

import 'package:kario_wellness_watch/common/app_text_style/google_app_style.dart';
import 'package:kario_wellness_watch/common/widgets/custom_button.dart';

enum StressDetectionState {
  initial,
  measuring,
  result,
}

class StressDetectionView extends StatefulWidget {
  const StressDetectionView({super.key});

  @override
  State<StressDetectionView> createState() => _StressDetectionViewState();
}

class _StressDetectionViewState extends State<StressDetectionView> {
  StressDetectionState _currentState = StressDetectionState.initial;
  int _countdown = 56;
  int _stressLevel = 40;
  Timer? _timer;

  void _startMeasurement() {
    setState(() {
      _currentState = StressDetectionState.measuring;
      _countdown = 56;
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        setState(() {
          _countdown--;
        });
      } else {
        timer.cancel();
        setState(() {
          _currentState = StressDetectionState.result;
        });
      }
    });
  }

  void _resetMeasurement() {
    _timer?.cancel();
    setState(() {
      _currentState = StressDetectionState.initial;
      _countdown = 56;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            _timer?.cancel();
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Stress detection',
          style: GoogleFontStyles.h3(
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    switch (_currentState) {
      case StressDetectionState.initial:
        return _buildInitialState();
      case StressDetectionState.measuring:
        return _buildMeasuringState();
      case StressDetectionState.result:
        return _buildResultState();
    }
  }

  // State 1: Initial - Show wrist watch illustration
  Widget _buildInitialState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Spacer(),

        // Wrist Watch Illustration
        Icon(
          Icons.watch,
          size: 150.sp,
          color: Colors.grey[400],
        ),

        SizedBox(height: 40.h),

        // Instructions
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.w),
          child: Text(
            'Please wear tour device properly and stay still.',
            style: GoogleFontStyles.h5(
              color: Colors.black87,
              fontSize: 16.sp,
            ),
            textAlign: TextAlign.center,
          ),
        ),

        SizedBox(height: 16.h),

        // Tap instruction
        Text(
          'Tap "Start" for stress detection.',
          style: GoogleFontStyles.h6(
            color: Colors.black54,
          ),
          textAlign: TextAlign.center,
        ),

        Spacer(),

        // Start Button
        Padding(
          padding: EdgeInsets.all(24.w),
          child: CustomButton(
            text: 'Start',
            onTap: _startMeasurement,
          ),
        ),
      ],
    );
  }

  // State 2: Measuring - Show countdown timer
  Widget _buildMeasuringState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Spacer(),

        // Circular Progress with Countdown
        SizedBox(
          width: 200.w,
          height: 200.h,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Progress Circle
              SizedBox(
                width: 200.w,
                height: 200.h,
                child: CircularProgressIndicator(
                  value: (_countdown / 56),
                  strokeWidth: 12,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.cyan),
                ),
              ),

              // Countdown Text
              Text(
                '${_countdown}s',
                style: GoogleFontStyles.h1(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 48.sp,
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 60.h),

        // Instructions
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.w),
          child: Text(
            'Please wear tour device properly and stay still.',
            style: GoogleFontStyles.h5(
              color: Colors.black87,
              fontSize: 16.sp,
            ),
            textAlign: TextAlign.center,
          ),
        ),

        Spacer(),
      ],
    );
  }

  // State 3: Result - Show stress level
  Widget _buildResultState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Spacer(),

        // Hexagon with Stress Level
        CustomPaint(
          size: Size(200.h, 200.h),
          painter: HexagonPainter(),
          child: Container(
            width: 200.h,
            height: 200.h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Current stress',
                  style: GoogleFontStyles.h6(
                    color: Colors.black87,
                  ),
                ),
                Text(
                  'level',
                  style: GoogleFontStyles.h6(
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  _stressLevel.toString(),
                  style: GoogleFontStyles.h1(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 48.sp,
                  ),
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: 40.h),

        // Latest Stress Level
        Text(
          'Latest stress level: $_stressLevel',
          style: GoogleFontStyles.h5(
            color: Colors.black87,
            fontSize: 16.sp,
          ),
          textAlign: TextAlign.center,
        ),

        Spacer(),

        // Done Button
        Padding(
          padding: EdgeInsets.all(24.w),
          child: CustomButton(
            text: 'Done',
            onTap: () {
              Navigator.pop(context, _stressLevel);
            },
          ),
        ),
      ],
    );
  }
}

// Custom Painter for Hexagon
class HexagonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.cyan
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    final path = Path();
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 20;

    for (int i = 0; i < 6; i++) {
      final angle = (60 * i - 30) * 3.14159 / 180;
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;

  double cos(double angle) =>
      (angle == 0) ? 1.0 :
      (angle == 1.0472) ? 0.5 :
      (angle == 2.0944) ? -0.5 :
      (angle == 3.14159) ? -1.0 :
      (angle == -2.0944) ? -0.5 :
      (angle == -1.0472) ? 0.5 : 0.866;

  double sin(double angle) =>
      (angle == 0) ? 0.0 :
      (angle == 1.0472) ? 0.866 :
      (angle == 2.0944) ? 0.866 :
      (angle == 3.14159) ? 0.0 :
      (angle == -2.0944) ? -0.866 :
      (angle == -1.0472) ? -0.866 : 0.5;
}