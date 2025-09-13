import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kario_wellness_watch/common/app_images/app_svg.dart';
import 'package:kario_wellness_watch/common/app_text_style/google_app_style.dart';


class GenderSelectionView extends StatefulWidget {
  const GenderSelectionView({super.key});

  @override
  State<GenderSelectionView> createState() => _GenderSelectionViewState();
}

class _GenderSelectionViewState extends State<GenderSelectionView> {
  String? selectedGender;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),

              // Top section with back button and progress indicator
              _buildTopSection(),

              SizedBox(height: 40.h),

              // Title
              Text(
                'Select your gender',
                style: GoogleFontStyles.h2(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),

              SizedBox(height: 16.h),

              // Description
              Text(
                'Gender determines how your body burns calories, making it fundamental for delivering accurate numbers.',
                style: GoogleFontStyles.h5(
                  color: Colors.grey[600],
                  height: 1.5,
                ),
              ),

              SizedBox(height: 60.h),

              // Gender options
              _buildGenderOptions(),

              Spacer(),

              // Continue button
              _buildContinueButton(),

              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopSection() {
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
          child: GenderProgressBar(),
        ),
      ],
    );
  }

  Widget _buildGenderOptions() {
    return Row(
      children: [
        Expanded(
          child: _buildGenderCard(
            gender: 'Male',
            isSelected: selectedGender == 'Male',
            avatar: _buildMaleAvatar(),
          ),
        ),

        SizedBox(width: 24.w),

        Expanded(
          child: _buildGenderCard(
            gender: 'Female',
            isSelected: selectedGender == 'Female',
            avatar: _buildFemaleAvatar(),
          ),
        ),
      ],
    );
  }

  Widget _buildGenderCard({
    required String gender,
    required bool isSelected,
    required Widget avatar,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedGender = gender;
        });
      },
      child: Column(
        children: [
          // Avatar with selection ring
          Container(
            width: 100.w,
            height: 100.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: isSelected
                  ? Border.all(color: Color(0xFF4CAF50), width: 4.w)
                  : null,
            ),
            child: avatar,
          ),

          SizedBox(height: 16.h),

          // Gender label
          Text(
            gender,
            style: GoogleFontStyles.h4(
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMaleAvatar() {
    return Container(
      width: 92.w,
      height: 92.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            Color(0xFF90CAF9),
            Color(0xFF42A5F5),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: SvgPicture.asset(AppSvg.maleSvg),
      ),
    );
  }

  Widget _buildFemaleAvatar() {
    return Container(
      width: 92.w,
      height: 92.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            Color(0xFFFFB74D),
            Color(0xFFFF8A65),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: SvgPicture.asset(AppSvg.femaleSvg),
      ),
    );
  }

  Widget _buildContinueButton() {
    final bool isEnabled = selectedGender != null;

    return SizedBox(
      width: double.infinity,
      height: 52.h,
      child: ElevatedButton(
        onPressed: isEnabled ? _onContinue : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isEnabled
              ? Color(0xFF4CAF50)
              : Colors.grey[300],
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        child: Text(
          'Continue',
          style: GoogleFontStyles.h4(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void _onContinue() {
    if (selectedGender != null) {
      // Handle continue action
      print('Selected gender: $selectedGender');
      // Navigate to next screen or save data
      // Navigator.push(context, MaterialPageRoute(builder: (context) => NextScreen()));
    }
  }
}

class GenderProgressBar extends StatelessWidget {
  const GenderProgressBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Active step
        Container(
          height: 4.h,
          width: 40.w,
          decoration: BoxDecoration(
            color: Color(0xFF4CAF50),
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),

        SizedBox(width: 8.w),

        // Inactive steps
        ...List.generate(3, (index) => Row(
          children: [
            Container(
              height: 4.h,
              width: 40.w,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            if (index < 2) SizedBox(width: 8.w),
          ],
        )),
      ],
    );
  }
}