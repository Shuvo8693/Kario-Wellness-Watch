import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kario_wellness_watch/common/app_text_style/style.dart';
import 'package:kario_wellness_watch/common/widgets/spacing.dart';

import 'custom_button.dart';

class CustomDialogue extends StatelessWidget {
  const CustomDialogue({
    super.key, this.isConfirm =false,
  });
  final bool isConfirm;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius:
        BorderRadius.circular(16.0), // Optional rounded corners
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Circle with checkmark icon
          Container(
            decoration: BoxDecoration(
              color: isConfirm? Colors.green.withOpacity(0.1):Colors.red.withOpacity(0.1),
              // Light green background
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(16.0),
            child: Icon(isConfirm?Icons.help_center_outlined : Icons.warning_amber,
              color: isConfirm?Colors.green: Colors.red,
              size: 40.0,
            ),
          ),
          const SizedBox(height: 16.0),
          // Title
          Text('Are You Sure ?',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8.0),
          // Subtitle
          Text('You are going to delete this request.?',
            textAlign: TextAlign.center,
            style: AppStyles.h5(color: Colors.grey[700]),
          ),
        ],
      ),
      actions: [
        Row(
          children: [
            Flexible(
              flex: 1,
              child: CustomButton(
                onTap: (){
                  Get.back();
                }, text: 'Close',color: Colors.blue[50],textStyle: AppStyles.h4(color: Colors.blue),),
            ),
            horizontalSpacing(8.w),
            Flexible(
              flex: 1,
              child: CustomButton(onTap: () {}, text: 'Yes',color: isConfirm? Colors.green:Colors.red,),
            ),
          ],
        )
      ],
    );
  }
}