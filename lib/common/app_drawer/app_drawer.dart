import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:kario_wellness_watch/app/routes/app_pages.dart';
import 'package:kario_wellness_watch/common/app_icons/app_icons.dart';
import 'package:kario_wellness_watch/common/app_string/app_string.dart';
import 'package:kario_wellness_watch/common/app_text_style/style.dart';
import 'package:kario_wellness_watch/common/prefs_helper/prefs_helpers.dart';
import 'package:kario_wellness_watch/common/url_luncher/externer_url_luncher.dart';
import 'package:kario_wellness_watch/common/widgets/app_logo.dart';
import 'package:kario_wellness_watch/common/widgets/custom_button.dart';
import 'package:kario_wellness_watch/common/widgets/custom_outlinebutton.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 270.w,
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 40.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Menu',
                      style: AppStyles.h2(fontWeight: FontWeight.w500)),
                  InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: const Icon(Icons.close)),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              child: Wrap(runSpacing: 2, children: [
                ListTile(
                  title: Text(
                    AppString.profileText,
                    style: AppStyles.h3(),
                  ),
                  leading: const Icon(Icons.person_outline),
                  horizontalTitleGap: 20.w,
                  onTap: () {
                    Navigator.pop(context);
                    //Get.toNamed(Routes.PROFILE);
                  },
                ),
                ListTile(
                  title: Text(
                    AppString.eventText,
                    style: AppStyles.h3(),
                  ),
                  leading: const Icon(Icons.event_note_outlined),
                  horizontalTitleGap: 20.w,
                  trailing: Container(
                    height: 12.h,
                    width: 12.h,
                    decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    //Get.toNamed(Routes.EVENT_LIST);
                  },
                ),
                ListTile(
                  title: Text(
                    AppString.notificationText,
                    style: AppStyles.h3(),
                  ),
                  leading: const Icon(Icons.notifications_none_outlined),
                  horizontalTitleGap: 20.w,
                  trailing: Container(
                    height: 12.h,
                    width: 12.h,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    //Get.toNamed(Routes.NOTIFICATION);
                  },
                ),
                ListTile(
                  title: Text(
                    AppString.supportText,
                    style: AppStyles.h3(),
                  ),
                  leading: const Icon(Icons.contact_support_outlined),
                  horizontalTitleGap: 20.w,
                  onTap: () {
                    Navigator.pop(context);
                    //Get.toNamed(Routes.SUPPORT);
                  },
                ),
                ListTile(
                  title: Text(
                    AppString.scheduleText,
                    style: AppStyles.h3(),
                  ),
                  leading: const Icon(Icons.schedule),
                  horizontalTitleGap: 20.w,
                  onTap: () {
                    Navigator.pop(context);
                    //Get.toNamed(Routes.SCHEDULE_LIST);
                  },
                ),
                ListTile(
                  title: Text(
                    AppString.mentorshipRequestsText,
                    style: AppStyles.h3(),
                  ),
                  leading: SvgPicture.asset('====Give====',
                      height: 32.h,
                      colorFilter: const ColorFilter.mode(
                          Colors.black, BlendMode.srcIn)),
                  horizontalTitleGap: 20.w,
                  onTap: () {
                    Navigator.pop(context);
                    //Get.toNamed(Routes.MENTORSHIP_REQUEST);
                  },
                ),
                ListTile(
                  title: Text(
                    AppString.shopText,
                    style: AppStyles.h3(),
                  ),
                  leading: const Icon(Icons.shopping_cart_outlined),
                  horizontalTitleGap: 20.w,
                  onTap: () {
                    Navigator.pop(context);
                   // ExternalUrlLauncher.lunchUrl(ExternalUrl.shopUrl);
                  },
                ),
                ListTile(
                  title: Text(
                    AppString.privacyPolicyText,
                    style: AppStyles.h3(),
                  ),
                  leading: const Icon(Icons.privacy_tip_outlined),
                  horizontalTitleGap: 20.w,
                  onTap: () {
                    Navigator.pop(context);
                   // ExternalUrlLauncher.lunchUrl(ExternalUrl.privacyPolicyUrl);
                  },
                ),
                ListTile(
                  title: Text(
                    AppString.termConditionText,
                    style: AppStyles.h3(),
                  ),
                  leading: SvgPicture.asset(
                   '====Give====',
                    height: 32.h,
                    colorFilter:
                        const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                  ),
                  horizontalTitleGap: 20.w,
                  onTap: () {
                    Navigator.pop(context);
                   // ExternalUrlLauncher.lunchUrl(ExternalUrl.termsAndConditionsUrl);
                  },
                ),
                ListTile(
                  title: Text(
                    AppString.signOutText,
                    style: AppStyles.h3(color: Colors.redAccent),
                  ),
                  leading: SvgPicture.asset(
                    '====Give====',
                    height: 32.h,
                    colorFilter: const ColorFilter.mode(
                        Colors.redAccent, BlendMode.srcIn),
                  ),
                  horizontalTitleGap: 20.w,
                  onTap: () {
                    Navigator.pop(context);
                    showCustomDialog(context);
                  },
                ),
              ]),
            ),
            SizedBox(
              height: 80.h,
            )
          ],
        ),
      ),
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
                width: 55,
                onTap: (){
                  Get.back();
                }, text: 'No'),

            CustomButton(
                width: 55,
                onTap: ()async{
                  await PrefsHelper.remove('token');
                  String token = await PrefsHelper.getString('token');
                  if(token.isEmpty){
                    //Get.offAllNamed(Routes.SIGN_IN);
                  }
                }, text: 'Yes'),
          ],
        );
      },
    );
  }
}
