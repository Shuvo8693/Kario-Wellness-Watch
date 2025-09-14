import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:kario_wellness_watch/app/modules/gender_selection/widgets/progress_step.dart';
import 'package:kario_wellness_watch/app/routes/app_pages.dart';
import 'package:kario_wellness_watch/common/app_text_style/google_app_style.dart';
import 'package:kario_wellness_watch/common/widgets/custom_button.dart';
import 'package:kario_wellness_watch/common/widgets/custom_text_field.dart';
import 'package:kario_wellness_watch/common/app_color/app_colors.dart';
import 'package:kario_wellness_watch/common/widgets/spacing.dart';

class WeightInputView extends StatefulWidget {
  const WeightInputView({super.key});

  @override
  State<WeightInputView> createState() => _WeightInputViewState();
}

class _WeightInputViewState extends State<WeightInputView> {
  final TextEditingController _weightController = TextEditingController();
  bool _isWeightValid = false;
  bool _isKgSelected = true; // true for kg, false for lb

  @override
  void initState() {
    super.initState();
    _weightController.addListener(_validateWeight);
  }

  void _validateWeight() {
    final weightText = _weightController.text;
    final isValid = weightText.isNotEmpty &&
        double.tryParse(weightText) != null &&
        double.parse(weightText) > 0;

    setState(() {
      _isWeightValid = isValid;
    });
  }

  void _onUnitChanged(bool isKg) {
    setState(() {
      _isKgSelected = isKg;
    });
  }



  @override
  void dispose() {
    _weightController.dispose();
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
              SizedBox(height: 25.h),
              Text(
                'Enter your weight',
                style: GoogleFontStyles.h1(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                'Enter your latest body weight for the most accurate calorie estimate.',
                style: GoogleFontStyles.h4(
                  color: Colors.grey.shade600,
                  height: 1.4,
                ),
              ),
              SizedBox(height: 40.h),

              // Unit selector (kg/lb)
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  color: Colors.grey.shade200,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildUnitButton('kg', _isKgSelected, () => _onUnitChanged(true)),
                    _buildUnitButton('lb', !_isKgSelected, () => _onUnitChanged(false)),
                  ],
                ),
              ),

              SizedBox(height: 24.h),

              CustomTextField(
                controller: _weightController,
                hintText: 'Your weight',
                contentPaddingVertical: 18.h,
                textColor: Colors.black,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
              ),

              const Spacer(),

              CustomButton(
                text: 'Continue',
                onTap: _isWeightValid ? _onContinuePressed : (){},
                color: _isWeightValid ? AppColors.primaryColor: AppColors.greyColor,
              ),

              SizedBox(height: 25.h),
            ],
          ),
        ),
      ),
    );
  }

  void _onContinuePressed() {
    Get.toNamed(Routes.HEIGHTINPUT);
  }

  Widget _buildUnitButton(String unit, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          color: isSelected ? AppColors.primaryColor : Colors.transparent,
        ),
        child: Text(
          unit,
          style: GoogleFontStyles.h4(
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : Colors.grey.shade600,
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ProgressStep(isActive: true),   // Step 1 - completed
        SizedBox(width: 6.w),
        ProgressStep(isActive: true),   // Step 2 - current
        SizedBox(width: 6.w),
        ProgressStep(isActive: true),  // Step 3 - upcoming
        SizedBox(width: 6.w),
        ProgressStep(isActive: false),  // Step 3 - upcoming
      ],
    );
  }
}

