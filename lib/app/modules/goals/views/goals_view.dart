
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kario_wellness_watch/app/modules/goals/widgets/goal_item.dart';
import 'package:kario_wellness_watch/common/app_text_style/google_app_style.dart';
import 'package:kario_wellness_watch/common/custom_appbar/custom_appbar.dart';

class GoalsView extends StatelessWidget {
  const GoalsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Goals'),
      body: ListView(
        padding: EdgeInsets.all(16.w),
        children: [
          GoalItem(
            title: 'Step',
            value: '1000 steps',
            onTap: () {
              // Navigate to step goal setting
            },
          ),
          SizedBox(height: 12.h),
          GoalItem(
            title: 'Calories',
            value: '500 kcal',
            onTap: () {
              // Navigate to calories goal setting
            },
          ),
          SizedBox(height: 12.h),
          GoalItem(
            title: 'Distance',
            value: '6.21 miles',
            onTap: () {
              // Navigate to distance goal setting
            },
          ),
        ],
      ),
    );
  }
}

