

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kario_wellness_watch/app/modules/my/widgets/menu_item.dart';
import 'package:kario_wellness_watch/app/routes/app_pages.dart';
import 'package:kario_wellness_watch/common/app_text_style/google_app_style.dart';
import 'package:kario_wellness_watch/common/bottom_menu/bottom_menu..dart';
import 'package:kario_wellness_watch/common/widgets/custom_button.dart';

class MyView extends StatelessWidget {
  const MyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SafeArea(child: BottomMenu(3)),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
            child: Column(
              children: [
                // Profile Section
                _buildProfileSection(),
                SizedBox(height: 40.h),
                // Menu Items
                _buildMenuItems(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Column(
      children: [
        // Avatar Circle
        Container(
          width: 100.w,
          height: 100.w,
          decoration: BoxDecoration(
            color: const Color(0xFFB0B0B0),
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFF9E9E9E),
              width: 2.w,
            ),
          ),
          child: Icon(
            Icons.person,
            size: 50.sp,
            color: const Color(0xFF757575),
          ),
        ),
        SizedBox(height: 20.h),

        // Sign In Button
        CustomButton(
          onTap: (){
            Get.toNamed(Routes.SIGNIN);
          },
          text: 'Please sign in',
          textStyle: GoogleFontStyles.h5(color: Colors.white),
          color: Colors.red,
          borderRadius: 25.r,
          height: 36.h,
          width: 125.w,
        ),
        SizedBox(height: 16.h),
        // Guest Mode Text
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.w),
          child: Text(
            'You are currently in guest mode. Sign in to save your progress.',
            textAlign: TextAlign.center,
            style: GoogleFontStyles.h5(
              color: const Color(0xFF757575),
              fontSize: 13.sp,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItems() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          MyMenuItem(
            icon: Icons.person_outline,
            title: 'Personal',
            onTap: () {
              Get.toNamed(Routes.PROFILESHOW);
            },
          ),
          _buildDivider(),
          MyMenuItem(
            icon: Icons.settings_outlined,
            title: 'System settings',
            onTap: () {},
          ),
          _buildDivider(),
          MyMenuItem(
            icon: Icons.lock_outline,
            title: 'Permissions',
            onTap: () {
              Get.toNamed(Routes.PERMISSION);
            },
          ),
          _buildDivider(),
          MyMenuItem(
            icon: Icons.message_outlined,
            title: 'Feedback',
            onTap: () {},
          ),
          _buildDivider(),
          MyMenuItem(
            icon: Icons.info_outline,
            title: 'About',
            onTap: () {},
            isLast: true,
          ),
        ],
      ),
    );
  }
  

  Widget _buildDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Divider(
        height: 1.h,
        thickness: 0.5,
        color: const Color(0xFFE0E0E0),
      ),
    );
  }
}

