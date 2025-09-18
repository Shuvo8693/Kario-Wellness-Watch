import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:kario_wellness_watch/app/modules/auth/controllers/sign_up_controller.dart';
import 'package:kario_wellness_watch/app/modules/my/widgets/profile_image_picker.dart';
import 'package:kario_wellness_watch/common/app_color/app_colors.dart';
import 'package:kario_wellness_watch/common/widgets/custom_text_field.dart';
import 'package:kario_wellness_watch/common/widgets/custom_button.dart';
import 'package:kario_wellness_watch/common/app_text_style/google_app_style.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
   final SignUpController _signUpController = Get.put(SignUpController());
  final _formKey = GlobalKey<FormState>();
  final _nicknameController = TextEditingController(text: 'Akash Roy');
  final _birthdayController = TextEditingController(text: '2001/07/09');
  final _heightController = TextEditingController(text: '5ft8in');
  final _weightController = TextEditingController(text: '145.5lb');
  final _pronounsController = TextEditingController(text: 'Love sports and enjoy life');

  String _selectedGender = 'Male';
  final List<String> _genderOptions = ['Male', 'Female', 'Other'];

  @override
  void dispose() {
    _nicknameController.dispose();
    _birthdayController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _pronounsController.dispose();
    super.dispose();
  }

  void _updateProfile() {
    if (_formKey.currentState!.validate()) {
      // Handle profile update logic here
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 20.sp),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Edit Profile',
          style: GoogleFontStyles.h3(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    children: [
                      SizedBox(height: 20.h),

                      // profile image picker
                      ProfileImagePicker(controller: _signUpController),

                      SizedBox(height: 30.h),

                      // Form Fields
                      CustomTextField(
                        controller: _nicknameController,
                        labelText: 'Nickname',
                        hintText: 'Enter your nickname',
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Nickname is required';
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 20.h),

                      // Gender Dropdown
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Gender',
                            style: GoogleFontStyles.h5(
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _selectedGender,
                                isExpanded: true,
                                icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedGender = newValue!;
                                  });
                                },
                                items: _genderOptions.map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: GoogleFontStyles.h5(color: Colors.black87),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 20.h),
                     // === Birthday ===
                      GestureDetector(
                        onTap: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime(2001, 7, 9),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null) {
                            _birthdayController.text =
                            '${picked.year}/${picked.month.toString().padLeft(2, '0')}/${picked.day.toString().padLeft(2, '0')}';
                          }
                        },
                        child: CustomTextField(
                          controller: _birthdayController,
                          labelText: 'Birthday',
                          hintText: 'Select your birthday',
                          readOnly: true,
                          suffixIcon: Icon(Icons.calendar_today, color: AppColors.greyColor),
                        ),
                      ),

                      SizedBox(height: 20.h),

                      CustomTextField(
                        controller: _heightController,
                        labelText: 'Height',
                        hintText: 'Enter your height',
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Height is required';
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 20.h),

                      CustomTextField(
                        controller: _weightController,
                        labelText: 'Weight',
                        hintText: 'Enter your weight',
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Weight is required';
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 20.h),

                      CustomTextField(
                        controller: _pronounsController,
                        labelText: 'Pronouns',
                        hintText: 'Love sports and enjoy life',
                        maxLines: 2,
                      ),

                      SizedBox(height: 40.h),
                    ],
                  ),
                ),
              ),

              // Update Button
              Padding(
                padding: EdgeInsets.all(20.w),
                child: CustomButton(
                  text: 'Update Profile',
                  onTap: _updateProfile,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}