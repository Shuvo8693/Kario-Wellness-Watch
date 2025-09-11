import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:kario_wellness_watch/app/routes/app_pages.dart';
import 'package:kario_wellness_watch/common/app_color/app_colors.dart';
import 'package:kario_wellness_watch/common/app_icons/app_icons.dart';
import 'package:kario_wellness_watch/common/prefs_helper/prefs_helpers.dart';

class BottomMenu extends StatefulWidget {
  final int menuIndex;
  final String? chooseServiceOrOrder;
  final String? chooseMechanicOrPayment;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  const BottomMenu(this.menuIndex, {super.key, this.chooseServiceOrOrder, this.scaffoldKey, this.chooseMechanicOrPayment});

  @override
  _BottomMenuState createState() => _BottomMenuState();
}

class _BottomMenuState extends State<BottomMenu> {
  late int _selectedIndex;
  String? userRole;
  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.menuIndex; // Set initial index
    WidgetsBinding.instance.addPostFrameCallback((__)async{
      await getRole();
    });
  }
 getRole()async{
   String? roleUser = await PrefsHelper.getString('role');
   setState(() {
     userRole = roleUser;
   });
 }
  void _onItemTapped(int index) {
    if (_selectedIndex == index) {
      // Prevent unnecessary re-navigation to the same screen
      return;
    }
    FocusScope.of(context).unfocus();
    setState(() {
      _selectedIndex = index;
    });

    // Navigate to corresponding pages
    switch (index)  {
      case 0 :
        if(userRole =='user'){
          Get.offAllNamed(Routes.HOME);
        } else if(userRole =='mechanic'){
         // Get.offAllNamed(Routes.MECHANIC_HOME);
        }else{
          Get.snackbar('Failed route', ' Select your role before route home');
        }
        break;
      case 1:
        if(userRole =='user'){
          //Get.offAllNamed(Routes.SERVICE);
        } else if(userRole =='mechanic'){
          //Get.offAllNamed(Routes.MECHANIC_ORDER);
        }else{
          Get.snackbar('Failed route', ' Select your role before route home');
        }
        break;
      case 2:
        if(userRole =='user'){
         // Get.offAllNamed(Routes.MECHANIC);
        } else if(userRole =='mechanic'){
         // Get.offAllNamed(Routes.MECHANIC_PAYMENT);
        }else{
          Get.snackbar('Failed route', ' Select your role before route home');
        }
        break;
      case 3:
        //widget.scaffoldKey?.currentState!.openDrawer();
       // Get.offAllNamed(Routes.ACCOUNT);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80.h,
      child: BottomNavigationBar(
          currentIndex: _selectedIndex, // Set the selected index
          onTap: _onItemTapped, // Handle taps on items
          type: BottomNavigationBarType.fixed, // Prevents shifting behavior
          backgroundColor: AppColors.white,
          selectedItemColor: AppColors.primaryColor,
          showSelectedLabels: true,
          unselectedItemColor: Colors.grey, // Inactive item color
          showUnselectedLabels: true,
          unselectedIconTheme: IconThemeData(color: Colors.black),
          selectedFontSize: 12.0,
          unselectedFontSize: 12.0,
          items: [
            _buildBottomNavItem('====Give====', 'Home'),
            _buildBottomNavItem(userRole =='mechanic'? '====Give====' : '====Give====', userRole =='mechanic'? 'Order': 'My Booking'),
            _buildBottomNavItem(userRole =='mechanic'? '====Give====': '====Give====', userRole =='mechanic'? 'Payment': 'Mechanic'),
            _buildBottomNavItem('====Give====', 'Account'),
          ],
        ),
    );

  }

  BottomNavigationBarItem _buildBottomNavItem(String iconPath, String label) {
    return BottomNavigationBarItem(
      icon: SvgPicture.asset(
        iconPath,
        height: 28.0.h,
        width: 28.0.w,
        colorFilter: const ColorFilter.mode(AppColors.greyColor, BlendMode.srcIn), // Inactive icon color
      ),
      activeIcon: SvgPicture.asset(
        iconPath,
        height: 30.0.h,
        width: 30.0.w,
        colorFilter: const ColorFilter.mode(AppColors.primaryColor, BlendMode.srcIn), // Active icon color
      ),
      label: label,
    );
  }
}
