import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kario_wellness_watch/common/app_text_style/style.dart';
import 'package:kario_wellness_watch/common/widgets/spacing.dart';



class TitleAndSeeAll extends StatelessWidget {
  const TitleAndSeeAll({
    super.key, required this.title, required this.onTap, this.count, this.buttonTitle,
  });
  final String title;
  final String? buttonTitle;
  final int? count;
  final Function() onTap;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(title,style: AppStyles.h2(),),
            horizontalSpacing(10.w),
            Text(count!=null && count! >0 ? count.toString():'',style: AppStyles.h2(color: Colors.redAccent),),
          ],
        ),
        TextButton(onPressed: onTap, child:  Text(buttonTitle??'See All',style: AppStyles.h2(color: Colors.blueAccent),))
      ],
    );
  }
}
