import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kario_wellness_watch/app/modules/gender_selection/widgets/gender_progressbar.dart';



class TopProgressbarSection extends StatelessWidget {
  const TopProgressbarSection({
    super.key,
    required this.context,
  });

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Back button
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            padding: EdgeInsets.all(8.w),
            child: Icon(
              Icons.arrow_back_ios,
              size: 20.sp,
              color: Colors.black,
            ),
          ),
        ),

        SizedBox(width: 24.w),

        // Progress indicator
        Expanded(
          child: GenderProgressBar(progressModel: [ProgressModel(0, true)],),
        ),
      ],
    );
  }
}