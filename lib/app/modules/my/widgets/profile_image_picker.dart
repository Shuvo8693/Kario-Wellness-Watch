import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:kario_wellness_watch/app/modules/auth/controllers/sign_up_controller.dart';
import 'package:kario_wellness_watch/common/app_text_style/google_app_style.dart';


class ProfileImagePicker extends StatelessWidget {
  const ProfileImagePicker({
    super.key,
    required this.controller,
  });

  final SignUpController controller;

  @override
  Widget build(BuildContext context) {
    return Center(
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
          ) : Column(
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
    );
  }
}