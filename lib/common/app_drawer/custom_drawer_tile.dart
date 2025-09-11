import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kario_wellness_watch/common/app_color/app_colors.dart';
import 'package:kario_wellness_watch/common/prefs_helper/prefs_helpers.dart';
import 'package:kario_wellness_watch/common/widgets/custom_button.dart';
import 'package:kario_wellness_watch/common/widgets/custom_outlinebutton.dart';

import '../../../../common/app_text_style/style.dart';

class CustomDrawerTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color? iconColor;
  final Color? textColor;
  final String routeName;
  final bool isLogout;

  const CustomDrawerTile({
    super.key,
    required this.icon,
    required this.title,
    this.iconColor,
    this.textColor,
    required this.routeName,
    this.isLogout = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: isLogout ? Colors.red : iconColor ?? AppColors.primaryColor,
        size: 24.sp,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16.sp,
          color: isLogout ? Colors.red : textColor ?? Colors.black,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 18,
        color: AppColors.primaryColor,
      ),
      onTap: () {
        if (isLogout) {
          showCustomDialog(context);
        } else {
          Get.toNamed(routeName);
        }
      },
    );
  }

  void showCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Logout",style: AppStyles.h2(),),
          content: const Text("Are you sure you want to log out ?"),
          actions: [
            CustomOutlineButton(
                width: 55.w,
                onTap: (){
                  Navigator.pop(context);
                }, text: 'No'),

            CustomButton(
                width: 60.w,
                onTap: ()async{
                  await PrefsHelper.remove('token');
                  String token = await PrefsHelper.getString('token');
                  if(token.isEmpty){
                    Get.offAllNamed(routeName);// Clear navigation stack for logout
                  }
                }, text: 'Yes'),
          ],
        );
      },
    );
  }
}