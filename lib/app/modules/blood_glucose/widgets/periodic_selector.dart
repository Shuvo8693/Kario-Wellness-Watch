import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kario_wellness_watch/common/app_text_style/google_app_style.dart';

class PeriodSelector extends StatefulWidget {
  late  String selectedPeriod;
  PeriodSelector({
    super.key,
    required this.selectedPeriod ,
  });

  @override
  State<PeriodSelector> createState() => _PeriodSelectorState();
}

class _PeriodSelectorState extends State<PeriodSelector> {

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: ['Day', 'Week', 'Month'].map((period) {
          final isSelected = widget.selectedPeriod == period;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => widget.selectedPeriod = period),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.grey[300] : Colors.transparent,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  period,
                  textAlign: TextAlign.center,
                  style: GoogleFontStyles.h5(
                    color: Colors.black87,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}