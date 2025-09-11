import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kario_wellness_watch/common/app_color/app_colors.dart';
import 'package:image_picker/image_picker.dart';



class ShowImagePickerRegister {

  /*SignupController registerCtrl=Get.put(SignupController());
   ProfileUpdateController _profileUpdateCtrl = Get.put(ProfileUpdateController());*/

  showImagePickerOption(BuildContext context) {
    showModalBottomSheet(
      // backgroundColor: AppColors.AppBgColor,
        context: context,
        builder: (builder) {
          return Padding(
            padding: const EdgeInsets.all(18.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 4.2,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: ()async {
                     //  await registerCtrl.pickImageFromCamera(ImageSource.gallery);
                      },
                      child: SizedBox(
                        child: Column(
                          children: [
                            Icon(
                              Icons.image,
                              size: 50.w,
                              color: AppColors.primaryColor,
                            ),
                            Text('Gallery')
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () async{
                       // await registerCtrl.pickImageFromCamera(ImageSource.camera);
                      },
                      child: SizedBox(
                        child: Column(
                          children: [
                            Icon(
                              Icons.camera_alt,
                              size: 50.w,
                              color: AppColors.primaryColor,
                            ),
                            Text('Camera')
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  showImagePickerUpdateProfileOption(BuildContext context) {
    showModalBottomSheet(
      // backgroundColor: AppColors.AppBgColor,
        context: context,
        builder: (builder) {
          return Padding(
            padding: const EdgeInsets.all(18.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 4.2,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: ()async {
                       // await _profileUpdateCtrl.pickImageFromCameraForProfilePic(ImageSource.gallery);
                      },
                      child: SizedBox(
                        child: Column(
                          children: [
                            Icon(
                              Icons.image,
                              size: 50.w,
                              color: AppColors.primaryColor,
                            ),
                            Text('Gallery')
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () async{
                       // await _profileUpdateCtrl.pickImageFromCameraForProfilePic(ImageSource.camera);
                      },
                      child: SizedBox(
                        child: Column(
                          children: [
                            Icon(
                              Icons.camera_alt,
                              size: 50.w,
                              color: AppColors.primaryColor,
                            ),
                            Text('Camera')
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }


}