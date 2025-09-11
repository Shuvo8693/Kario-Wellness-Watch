import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kario_wellness_watch/common/app_color/app_colors.dart';
import 'package:kario_wellness_watch/common/app_text_style/style.dart';

import '../app_string/app_string.dart';
import 'custom_card.dart';
import 'custom_text_field.dart';

class CustomSearchField extends StatelessWidget {
  const CustomSearchField({
    super.key,
    required this.searchCtrl, this.onChanged, this.fillColor, this.suffixIcon, required this.iconOnTap,
  });
  final Function(String?)? onChanged;
  final TextEditingController searchCtrl;
  final Color? fillColor;
  final IconData? suffixIcon;
  final VoidCallback iconOnTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomTextField(
            fillColor:fillColor?? AppColors.fillColor,
            contentPaddingVertical: 18.h,
            prefixIcon: Padding(
              padding:  EdgeInsets.all(8.0.sp),
              child: const Icon(
                Icons.search_outlined,
                size: 25,
                color: AppColors.primaryColor,
              ),
            ),
            suffixIcon: Padding(
              padding:  EdgeInsets.all(8.0.sp),
              child:  InkWell(
                onTap: iconOnTap,
                child: Icon(suffixIcon??Icons.filter_list_outlined,
                  size: 25,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
            hintText: 'Search...',
            controller: searchCtrl,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}