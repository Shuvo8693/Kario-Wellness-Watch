import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:kario_wellness_watch/app/modules/gender_selection/widgets/progress_step.dart';
import 'package:kario_wellness_watch/app/routes/app_pages.dart';
import 'package:kario_wellness_watch/common/app_color/app_colors.dart';
import 'package:kario_wellness_watch/common/app_text_style/google_app_style.dart';
import 'package:kario_wellness_watch/common/widgets/custom_button.dart';
import 'package:kario_wellness_watch/common/widgets/custom_text_field.dart';

class AgeInputView extends StatefulWidget {
  const AgeInputView({super.key});

  @override
  State<AgeInputView> createState() => _AgeInputViewState();
}

class _AgeInputViewState extends State<AgeInputView> {
  final TextEditingController _ageController = TextEditingController();
  bool _isAgeValid = false;

  @override
  void initState() {
    super.initState();
    _ageController.addListener(_validateAge);
  }

  void _validateAge() {
    final ageText = _ageController.text;
    final isValid = ageText.isNotEmpty &&
        int.tryParse(ageText) != null &&
        int.parse(ageText) >= 13 &&
        int.parse(ageText) <= 120;

    setState(() {
      _isAgeValid = isValid;
    });
  }



  @override
  void dispose() {
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.grey.shade600),
          onPressed: () => Navigator.pop(context),
        ),
        title: _buildProgressIndicator(),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40.h),
              Text(
                'Enter your age',
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                'Age refines our math - as your watch knows you better.',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.grey.shade600,
                ),
              ),
              SizedBox(height: 40.h),

              // Replace this with your CustomTextField
              CustomTextField(
                controller: _ageController,
                contentPaddingVertical: 18.h,
                hintText: 'Your age',
                textColor: Colors.black,
                hintStyle: GoogleFontStyles.h5(color: Colors.grey),
                keyboardType: TextInputType.number,

                // Add other parameters as needed
              ),

              const Spacer(),

              // Replace this with your CustomButton
              CustomButton(
                text:  'Continue',
                onTap: _isAgeValid ? _onContinuePressed : (){},
                color: _isAgeValid? AppColors.primaryColor: AppColors.greyColor,
                // Add other parameters as needed
              ),

              SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
    );
  }
 //==== onPressed ======
  void _onContinuePressed() {
    Get.toNamed(Routes.WEIGHTINPUT);
  }

  Widget _buildProgressIndicator() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ProgressStep(isActive: true),   // Step 1 - completed
        SizedBox(width: 6.w),
        ProgressStep(isActive: true),   // Step 2 - current
        SizedBox(width: 6.w),
        ProgressStep(isActive: false),  // Step 3 - upcoming
        SizedBox(width: 6.w),
        ProgressStep(isActive: false),  // Step 3 - upcoming
      ],
    );
  }

}