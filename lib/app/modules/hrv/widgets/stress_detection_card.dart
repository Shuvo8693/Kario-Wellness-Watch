import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kario_wellness_watch/common/app_text_style/google_app_style.dart';

class StressDetectionCard extends StatefulWidget {
  const StressDetectionCard({
    super.key,
    required this.isExpanded,
  });

  final bool isExpanded;

  @override
  State<StressDetectionCard> createState() => _StressDetectionCardState();
}

class _StressDetectionCardState extends State<StressDetectionCard> {
  bool _isExpanded = false;
  @override
  void initState() {
    super.initState();
    _isExpanded = widget.isExpanded;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !widget.isExpanded;
              });
            },
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                children: [
                  Text(
                    'Stress detection',
                    style: GoogleFontStyles.h4(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Spacer(),
                  Icon(
                    _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: Colors.black54,
                  ),
                ],
              ),
            ),
          ),
          if (_isExpanded)
            Padding(
              padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.h),
              child: Text(
                'Stress detection measures your heart rate variability to assess stress levels throughout the day.',
                style: GoogleFontStyles.h6(
                  color: Colors.black54,
                  height: 1.5,
                ),
              ),
            ),
        ],
      ),
    );
  }
}