import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kario_wellness_watch/common/app_images/network_image%20.dart';
import 'package:kario_wellness_watch/common/app_text_style/style.dart';

import 'casess_network_image.dart';
import 'custom_button.dart';
import 'custom_card.dart';
import 'icon_and_text.dart';

class EventCard extends StatelessWidget {
  const EventCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      crossAxisAlignment: CrossAxisAlignment.start,
      padding: 1,
      elevation: 2,
      borderSideColor: Colors.white,
      children: [
        CustomNetworkImage(
          imageUrl: AppNetworkImage.golfFlayerImg,
          height: 112.h,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(8.r),topRight:  Radius.circular(8.r)),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Wrap(
            runSpacing: 5,
            children: [
              Text('Event name',style: AppStyles.h2(),),
              IconText(
                iconData: Icons.calendar_month_outlined,
                text: 'Fri, 12 Sep',
              ),
              IconText(
                iconData: Icons.access_time_outlined,
                text: '10:00 pm',
              ),
              Text('A dedicated Army professional with extensive experience in leadership, strategy, and discipline.',style: AppStyles.h5(color: Colors.grey),),

              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: CustomButton(onTap: (){}, text: 'Book now'),
              ),
            ],
          ),
        )
      ],
    );
  }
}