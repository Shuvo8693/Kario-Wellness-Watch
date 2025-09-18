import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kario_wellness_watch/app/routes/app_pages.dart';
import 'package:kario_wellness_watch/common/app_color/app_colors.dart';
import 'package:kario_wellness_watch/common/app_text_style/google_app_style.dart';

class ProfileShowScreen extends StatelessWidget {
  const ProfileShowScreen({super.key});

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
          'Profile',
          style: GoogleFontStyles.h3(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.toNamed(Routes.PROFILEEDIT);
            },
            child: Text(
              'Update',
              style: GoogleFontStyles.h4(color: Colors.blueAccent),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            SizedBox(height: 20.h),
            // Avatar Section
            Center(
              child: CircleAvatar(
                radius: 50.r,
                backgroundColor: AppColors.primaryColor.withOpacity(0.1),
                child: Icon(
                  Icons.person,
                  size: 50.sp,
                  color: AppColors.primaryColor,
                ),
              ),
            ),

            SizedBox(height: 30.h),

            _buildProfileItem(label: 'Nickname', value: 'Akash Roy'),

            _buildProfileItem(label: 'Gender', value: 'Male'),

            _buildProfileItem(label: 'Birthday', value: '2001/07/09'),

            _buildProfileItem(label: 'Height', value: '5ft8in'),

            _buildProfileItem(label: 'Weight', value: '145.5lb'),

            _buildProfileItem(
              label: 'Pronouns',
              value: 'Love sports and enjoy life',
              isLast: true,
            ),

            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem({
    required String label,
    required String value,
    bool showAvatar = false,
    bool isLast = false,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: isLast ? 0 : 16.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          // Label
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: GoogleFontStyles.h5(
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // Value
          Expanded(
            flex: 3,
            child: showAvatar
                ? Row(
                    children: [
                      CircleAvatar(
                        radius: 16.r,
                        backgroundColor: AppColors.primaryColor.withOpacity(
                          0.1,
                        ),
                        child: Icon(
                          Icons.person,
                          size: 16.sp,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ],
                  )
                : Text(
                    value,
                    style: GoogleFontStyles.h5(color: Colors.black54),
                    textAlign: TextAlign.end,
                  ),
          ),

          // Arrow
          SizedBox(width: 8.w),
          Icon(
            Icons.arrow_forward_ios,
            size: 16.sp,
            color: Colors.grey.shade400,
          ),
        ],
      ),
    );
  }
}
