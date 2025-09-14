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

class HeightInputView extends StatefulWidget {
  const HeightInputView({super.key});

  @override
  State<HeightInputView> createState() => _HeightInputViewState();
}

class _HeightInputViewState extends State<HeightInputView> {
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _feetController = TextEditingController();
  final TextEditingController _inchesController = TextEditingController();
  bool _isHeightValid = false;
  bool _isCmSelected = true; // true for cm, false for ft

  @override
  void initState() {
    super.initState();
    _heightController.addListener(_validateHeight);
    _feetController.addListener(_validateHeight);
    _inchesController.addListener(_validateHeight);
  }

  void _validateHeight() {
    bool isValid = false;

    if (_isCmSelected) {
      final heightText = _heightController.text;
      isValid = heightText.isNotEmpty &&
          double.tryParse(heightText) != null &&
          double.parse(heightText) > 0;
    } else {
      final feetText = _feetController.text;
      final inchesText = _inchesController.text;
      isValid = feetText.isNotEmpty &&
          int.tryParse(feetText) != null &&
          int.parse(feetText) > 0;
    }

    setState(() {
      _isHeightValid = isValid;
    });
  }

  void _onUnitChanged(bool isCm) {
    setState(() {
      _isCmSelected = isCm;
    });
    _validateHeight();
  }



  @override
  void dispose() {
    _heightController.dispose();
    _feetController.dispose();
    _inchesController.dispose();
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
      body: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40.h),
            Text(
              'Enter your height',
              style: GoogleFontStyles.h1(
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              'Last step - enter your height to help scale calories to your stature.',
              style: GoogleFontStyles.h4(
                color: Colors.grey.shade600,
                height: 1.4,
              ),
            ),
            SizedBox(height: 40.h),

            // Unit selector (cm/ft)
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: Colors.grey.shade200,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildUnitButton('cm', _isCmSelected, () => _onUnitChanged(true)),
                  _buildUnitButton('ft', !_isCmSelected, () => _onUnitChanged(false)),
                ],
              ),
            ),

            SizedBox(height: 24.h),

            // Height input - different layouts for cm vs ft
            _isCmSelected ? _buildCmInput() : _buildFeetInchesInput(),

            const Spacer(),

            CustomButton(
              text: 'Continue',
              onTap: _isHeightValid ? _onContinuePressed : (){},
              color: _isHeightValid ? AppColors.primaryColor: AppColors.greyColor,
            ),

            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }

  void _onContinuePressed() {
    Get.toNamed(Routes.HOME);

  }

  Widget _buildCmInput() {
    return CustomTextField(
      controller: _heightController,
      hintText: 'Your height',
      contentPaddingVertical: 18.h,
      textColor: Colors.black,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
      ],
    );
  }

  Widget _buildFeetInchesInput() {
    return Row(
      children: [
        Expanded(
          child: CustomTextField(
            controller: _feetController,
            hintText: 'ft',
            contentPaddingVertical: 18.h,
            textColor: Colors.black,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(1),
            ],
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: CustomTextField(
            controller: _inchesController,
            hintText: 'in',
            contentPaddingVertical: 18.h,
            textColor: Colors.black,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(2),
            ],
          ),
        ),
      ],
    );
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
        const ProgressStep(isActive: true),   // Step 1 - completed
        SizedBox(width: 6.w),
        const ProgressStep(isActive: true),   // Step 2 - completed
        SizedBox(width: 6.w),
        const ProgressStep(isActive: true),   // Step 3 - completed
        SizedBox(width: 6.w),
        const ProgressStep(isActive: true),   // Step 4 - completed
      ],
    );
  }
}
