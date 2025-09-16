import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kario_wellness_watch/common/app_color/app_colors.dart';
import 'package:kario_wellness_watch/common/app_logo/app_logo.dart';
import 'package:kario_wellness_watch/common/app_text_style/google_app_style.dart';
import 'package:kario_wellness_watch/common/widgets/custom_button.dart';
import 'package:kario_wellness_watch/common/widgets/custom_text_field.dart';
import 'package:kario_wellness_watch/common/widgets/spacing.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: ListView(
          //  crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with logo and skip button
              SizedBox(height: 10.h),
              Row(
               mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Spacer(flex: 2,),
                  AppLogo(height: 130.h),
                  Spacer(flex: 1,),
                  TextButton(
                    onPressed: () {
                      // Handle skip action
                    },
                    child: Text(
                      'skip',
                      style: GoogleFontStyles.h5(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 30.h),

              // Sign in title
              Text(
                'Sign in',
                style: GoogleFontStyles.customSize(
                  size: 28.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),

              SizedBox(height: 40.h),

              // Email field
              CustomTextField(
                controller: _emailController,
                hintText: 'Enter your email',
                keyboardType: TextInputType.emailAddress,
                hintStyle: GoogleFontStyles.h4(
                  color: Colors.grey[400],
                ),
              ),

              SizedBox(height: 24.h),

              // Password field
              CustomTextField(
                controller: _passwordController,
                hintText: 'Enter your password',
                isPassword: true,
                hintStyle: GoogleFontStyles.h4(
                  color: Colors.grey[400],
                ),
              ),

              SizedBox(height: 12.h),

              // Forgot password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // Handle forgot password
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Forgot password?',
                    style: GoogleFontStyles.h5(
                      color: Color(0xFF4CAF50),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 32.h),

              // Sign in button
              CustomButton(
                onTap: () {
                  // Handle sign in
                },
                text: 'Sign in',
                height: 50.h,
                width: double.infinity,
                borderRadius: 25.r,
                textStyle: GoogleFontStyles.h4(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),

              SizedBox(height: 24.h),

              // Or divider
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: Colors.grey[300],
                      thickness: 1,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Text(
                      'Or',
                      style: GoogleFontStyles.h5(
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: Colors.grey[300],
                      thickness: 1,
                    ),
                  ),
                ],
              ),

              // Spacer to push bottom content down
              verticalSpacing(30.h),

              // Sign up section
              Column(
                children: [
                  Center(
                    child: RichText(
                      text: TextSpan(
                        style: GoogleFontStyles.h5(
                          color: Colors.grey[600],
                        ),
                        children: [
                          TextSpan(text: "Don't have an account? "),
                          TextSpan(
                            text: 'Sign up',
                            style: GoogleFontStyles.h5(
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF4CAF50),
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                // Navigate to sign up
                              },
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 16.h),

                  // Terms and Privacy
                  Center(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: GoogleFontStyles.h6(
                          color: Colors.grey[500],
                        ),
                        children: [
                          TextSpan(text: 'By signing up, you agree to our '),
                          TextSpan(
                            text: 'Terms of Service',
                            style: GoogleFontStyles.customSize(
                              size: 12.sp,
                              color: Color(0xFF4CAF50),
                              underline: TextDecoration.underline,
                              underlineColor: Color(0xFF4CAF50),
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                // Open Terms of Service
                              },
                          ),
                          TextSpan(text: ' and '),
                          TextSpan(
                            text: 'Privacy Policy',
                            style: GoogleFontStyles.customSize(
                              size: 12.sp,
                              color: Color(0xFF4CAF50),
                              underline: TextDecoration.underline,
                              underlineColor: Color(0xFF4CAF50),
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                // Open Privacy Policy
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}