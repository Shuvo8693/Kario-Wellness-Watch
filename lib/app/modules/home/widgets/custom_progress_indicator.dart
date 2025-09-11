import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kario_wellness_watch/common/widgets/spacing.dart';

class CustomProgressIndicator extends StatefulWidget {
  final double progress; // 0.0 to 1.0
  final Color progressColor;
  final Color backgroundColor;
  final double size;
  final double strokeWidth;
  final Widget? centerWidget,bottomWidgets;
  final bool showSteps;
  final bool animated;
  final Duration animationDuration;
  final double startAngle; // Starting angle in radians
  final double sweepAngle; // Total sweep angle in radians (e.g., 240 degrees = 4.19 radians)

  const CustomProgressIndicator({
    super.key,
    required this.progress,
    this.progressColor = const Color(0xFF4CAF50),
    this.backgroundColor = const Color(0xFFE0E0E0),
    this.size = 80.0,
    this.strokeWidth = 6.0,
    this.centerWidget,
    this.showSteps = true,
    this.animated = true,
    this.animationDuration = const Duration(milliseconds: 800),
    this.startAngle = -3.7, // -120 degrees (top-left)
    this.sweepAngle = 4.189, // 240 degrees total arc
    this.bottomWidgets,
  });

  @override
  State<CustomProgressIndicator> createState() => _CustomProgressIndicatorState();
}

class _CustomProgressIndicatorState extends State<CustomProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: widget.progress,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    if (widget.animated) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(CustomProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress) {
      _animation = Tween<double>(
        begin: _animation.value,
        end: widget.progress,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ));
      _animationController.reset();
      if (widget.animated) {
        _animationController.forward();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: widget.size.w,
          height: widget.size.h,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Progress Arc
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return CustomPaint(
                    size: Size(widget.size.w, widget.size.h),
                    painter: ArcProgressPainter(
                      progress: widget.animated ? _animation.value : widget.progress,
                      progressColor: widget.progressColor,
                      backgroundColor: widget.backgroundColor,
                      strokeWidth: widget.strokeWidth.w,
                      showSteps: widget.showSteps,
                      startAngle: widget.startAngle,
                      sweepAngle: widget.sweepAngle,
                    ),
                  );
                },
              ),
              // Center Content
              if (widget.centerWidget != null)
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: widget.centerWidget!,
                  ),
                ),

            ],
          ),
        ),
        verticalSpacing(8.h),
        // Bottom Content
        if (widget.bottomWidgets != null) widget.bottomWidgets!
      ],
    );
  }
}

class ArcProgressPainter extends CustomPainter {
  final double progress;
  final Color progressColor;
  final Color backgroundColor;
  final double strokeWidth;
  final bool showSteps;
  final double startAngle;
  final double sweepAngle;

  ArcProgressPainter({
    required this.progress,
    required this.progressColor,
    required this.backgroundColor,
    required this.strokeWidth,
    required this.showSteps,
    required this.startAngle,
    required this.sweepAngle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    // Background arc
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, startAngle, sweepAngle, false, backgroundPaint);

    // Progress arc
    final progressPaint = Paint()
      ..color = progressColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final progressSweep = sweepAngle * progress;
    canvas.drawArc(rect, startAngle, progressSweep, false, progressPaint);
  }


  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}

// Usage Examples Widget
class ProgressIndicatorExamples extends StatelessWidget {
  const ProgressIndicatorExamples({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(title: const Text('Arc Progress Examples')),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            // Steps Progress (clean arc)
            _buildExampleCard(
              'Steps Progress',
              CustomProgressIndicator(
                progress: 0.3,
                size: 100,
                strokeWidth: 8.0,
                progressColor: const Color(0xFF4CAF50),
                backgroundColor: const Color(0xFFE0E0E0),
                centerWidget: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('29', style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
                    Text('steps', style: TextStyle(fontSize: 12.sp, color: Colors.grey[600])),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20.h),

            // Miles Progress
            _buildExampleCard(
              'Distance Progress',
              CustomProgressIndicator(
                progress: 0.05,
                size: 100,
                strokeWidth: 8.0,
                progressColor: const Color(0xFF2196F3),
                backgroundColor: const Color(0xFFE3F2FD),
                centerWidget: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.location_on, color: const Color(0xFF2196F3), size: 16.sp),
                    SizedBox(height: 4.h),
                    Text('0.01', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
                    Text('miles', style: TextStyle(fontSize: 12.sp, color: Colors.grey[600])),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20.h),

            // Calories Progress
            _buildExampleCard(
              'Calories Progress',
              CustomProgressIndicator(
                progress: 0.02,
                size: 100,
                strokeWidth: 8.0,
                progressColor: const Color(0xFFFF5722),
                backgroundColor: const Color(0xFFFFE0DB),
                centerWidget: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.local_fire_department, color: const Color(0xFFFF5722), size: 16.sp),
                    SizedBox(height: 4.h),
                    Text('1', style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
                    Text('kcal', style: TextStyle(fontSize: 12.sp, color: Colors.grey[600])),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExampleCard(String title, Widget progressIndicator) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 20.h),
          progressIndicator,
        ],
      ),
    );
  }
}