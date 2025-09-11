import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kario_wellness_watch/common/app_color/app_colors.dart';
import 'package:kario_wellness_watch/common/app_text_style/style.dart';

class CustomListTile extends StatelessWidget {
  final String? icon;
  final String? title;
  final VoidCallback onTap;
  final double? iconHeight;

  const CustomListTile({super.key, this.icon, this.title, required this.onTap, this.iconHeight});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: AppColors.primaryColor, width: 1),
            color: AppColors.fillColor,
            borderRadius: BorderRadius.circular(16).r),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
          onTap: onTap,
          leading: SvgPicture.asset(icon!,height: iconHeight ?? 20.h,),
          title: Text(
            title!,
            style: AppStyles.customSize(
              size: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.subTextColor,
              family: "Schuyler",
            ),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            size: 18,
            color: AppColors.dark2Color,
          ),
        ),
      ),
    );
  }
}
