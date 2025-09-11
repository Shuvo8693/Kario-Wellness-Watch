import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kario_wellness_watch/common/app_color/app_colors.dart';
import 'package:kario_wellness_watch/common/app_string/app_string.dart';
import 'package:kario_wellness_watch/common/app_text_style/style.dart';

class HaveAnAccountTextButton extends StatelessWidget {
  const HaveAnAccountTextButton({
    super.key, this.firstText, this.secondText, required this.onTap, this.isShowStar,
  });

  final String? firstText;
  final String? secondText;
  final Function() onTap;
  final bool? isShowStar;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(firstText??"Already have an account? ",
            style: AppStyles.customSize(
                size: 14,
                family: "Schuyler",
                fontWeight: FontWeight.w500,
                color: Colors.black)),
        InkWell(
          onTap: onTap,
          child: Padding(
            padding:  EdgeInsets.only(left: 6.w),
            child: Text( secondText??AppString.loginText,
              style: AppStyles.customSize(
                  size: 15,
                  family: "Schuyler",
                  fontWeight: FontWeight.w500,
                  color: Colors.blueAccent),
            ),
          ),
        ),
        if(isShowStar==true)
        const Text('*',style: TextStyle(fontSize: 16, color: Colors.red),)
      ],
    );
  }
}