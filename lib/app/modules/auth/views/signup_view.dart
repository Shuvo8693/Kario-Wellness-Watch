import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kario_wellness_watch/app/modules/auth/controllers/sign_up_controller.dart';
import 'package:kario_wellness_watch/common/app_logo/app_logo.dart';
import 'package:kario_wellness_watch/common/app_text_style/google_app_style.dart';
import 'package:kario_wellness_watch/common/terms_and_privacy/terms_and_privacy_widgets.dart';
import 'package:kario_wellness_watch/common/widgets/custom_button.dart';
import 'package:kario_wellness_watch/common/widgets/custom_text_field.dart';
import 'package:kario_wellness_watch/common/widgets/have_an_account.dart';

class SignUpScreen extends StatelessWidget {
   SignUpScreen({super.key});

  final SignUpController controller = Get.put(SignUpController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with logo and back button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Spacer(flex: 2,),
                    AppLogo(height: 110.h),
                    Spacer(flex: 1,),
                    IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: Icon(
                        Icons.close,
                        color: Colors.grey[600],
                        size: 24.sp,
                      ),
                    ),
                  ],
                ),
                // Sign up title
                Text(
                  'Create Account',
                  style: GoogleFontStyles.customSize(
                    size: 28.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),

                Text(
                  'Join us to track your wellness journey',
                  style: GoogleFontStyles.h5(
                    color: Colors.grey[600],
                  ),
                ),

                SizedBox(height: 30.h),

                // Profile Image Picker with Obx
                Center(
                  child: GestureDetector(
                    onTap: controller.showImageSourceDialog,
                    child: Obx(() => Container(
                      height: 100.h,
                      width: 100.h,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Color(0xFF4CAF50),
                          width: 2.w,
                        ),
                      ),
                      child: controller.profileImage.value != null
                          ? ClipOval(
                        child: Image.file(
                          controller.profileImage.value!,
                          fit: BoxFit.cover,
                          width: 100.h,
                          height: 100.h,
                        ),
                      )
                          : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.camera_alt_outlined,
                            color: Color(0xFF4CAF50),
                            size: 32.sp,
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'Add Photo',
                            style: GoogleFontStyles.h6(
                              color: Color(0xFF4CAF50),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    )),
                  ),
                ),

                SizedBox(height: 30.h),

                // Name field with error display
                Obx(() => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(
                      controller: controller.nameController,
                      hintText: 'Enter your full name',
                      keyboardType: TextInputType.name,
                      prefixIcon: Icon(
                        Icons.person_outline,
                        color: controller.nameError.value.isNotEmpty
                            ? Colors.red
                            : Colors.grey[600],
                        size: 20.sp,
                      ),
                    ),
                    if (controller.nameError.value.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(left: 4.w, top: 4.h),
                        child: Text(
                          controller.nameError.value,
                          style: GoogleFontStyles.h6(
                            color: Colors.red,
                          ),
                        ),
                      ),
                  ],
                 )
                ),

                SizedBox(height: 20.h),

                // Email field with error display
                Obx(() => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(
                      controller: controller.emailController,
                      hintText: 'Enter your email',
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        color: controller.emailError.value.isNotEmpty
                            ? Colors.red
                            : Colors.grey[600],
                        size: 20.sp,
                      ),
                    ),
                    if (controller.emailError.value.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(left: 4.w, top: 4.h),
                        child: Text(
                          controller.emailError.value,
                          style: GoogleFontStyles.h6(
                            color: Colors.red,
                          ),
                        ),
                      ),
                  ],
                )),

                SizedBox(height: 20.h),

                // Password field with visibility toggle
                Obx(() => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(
                      controller: controller.passwordController,
                      hintText: 'Create a password',
                      isPassword: true,
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: controller.passwordError.value.isNotEmpty
                            ? Colors.red
                            : Colors.grey[600],
                        size: 20.sp,
                      ),
                    ),
                    if (controller.passwordError.value.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(left: 4.w, top: 4.h),
                        child: Text(
                          controller.passwordError.value,
                          style: GoogleFontStyles.h6(
                            color: Colors.red,
                          ),
                        ),
                      ),
                  ],
                )),

                SizedBox(height: 20.h),

                // Confirm Password field
                Obx(() => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(
                      controller: controller.confirmPasswordController,
                      hintText: 'Confirm your password',
                      isPassword: true,
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: controller.confirmPasswordError.value.isNotEmpty
                            ? Colors.red
                            : Colors.grey[600],
                        size: 20.sp,
                      ),
                    ),
                    if (controller.confirmPasswordError.value.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(left: 4.w, top: 4.h),
                        child: Text(
                          controller.confirmPasswordError.value,
                          style: GoogleFontStyles.h6(
                            color: Colors.red,
                          ),
                        ),
                      ),
                  ],
                )),

                // Password requirements hint
                SizedBox(height: 8.h),
                Padding(
                  padding: EdgeInsets.only(left: 4.w),
                  child: Text(
                    'Password must be at least 8 characters',
                    style: GoogleFontStyles.h6(
                      color: Colors.grey[500],
                    ),
                  ),
                ),
                SizedBox(height: 32.h),
                // Sign up button with loading state
                Obx(() => CustomButton(
                  loading: controller.isLoading.value,
                  height: 50.h,
                  width: double.infinity,
                  borderRadius: 25.r,
                  onTap: () {  },
                  text: 'Confirm',
                  )
                ),
                SizedBox(height: 24.h),
                // Already have account
                Align(
                  alignment: Alignment.center,
                    child: HaveAnAccountText(
                      normalText: 'Already have an account? ',
                      clickableText: 'Sign In',
                      onTap: (){
                        Get.back();
                        },
                    ),
                ),
                SizedBox(height: 16.h),
                // Terms and Privacy
                TermsPrivacyWidget(
                  onTermsTap: () {},
                  onPrivacyTap: () {},
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}