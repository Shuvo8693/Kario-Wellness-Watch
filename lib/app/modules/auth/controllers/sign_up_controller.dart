import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class SignUpController extends GetxController {
  // Text Controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Observable States
  final RxBool obscurePassword = true.obs;
  final RxBool obscureConfirmPassword = true.obs;
  final Rx<File?> profileImage = Rx<File?>(null);
  final RxBool isLoading = false.obs;

  // Image Picker
  final ImagePicker _picker = ImagePicker();

  // Form validation
  final RxString nameError = ''.obs;
  final RxString emailError = ''.obs;
  final RxString passwordError = ''.obs;
  final RxString confirmPasswordError = ''.obs;


  // Pick image from camera or gallery
  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1080,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        profileImage.value = File(pickedFile.path);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Remove profile image
  void removeProfileImage() {
    profileImage.value = null;
  }

  // Show image source bottom sheet
  void showImageSourceDialog() {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Choose Profile Photo',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 20.h),
                ListTile(
                  leading: Icon(
                    Icons.camera_alt_outlined,
                    color: Color(0xFF4CAF50),
                    size: 24.sp,
                  ),
                  title: Text(
                    'Camera',
                    style: TextStyle(fontSize: 16.sp),
                  ),
                  onTap: () {
                    Get.back();
                    pickImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.photo_library_outlined,
                    color: Color(0xFF4CAF50),
                    size: 24.sp,
                  ),
                  title: Text(
                    'Gallery',
                    style: TextStyle(fontSize: 16.sp),
                  ),
                  onTap: () {
                    Get.back();
                    pickImage(ImageSource.gallery);
                  },
                ),
                if (profileImage.value != null)
                  ListTile(
                    leading: Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                      size: 24.sp,
                    ),
                    title: Text(
                      'Remove Photo',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.red,
                      ),
                    ),
                    onTap: () {
                      removeProfileImage();
                      Get.back();
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  // Sign up method
  Future<void> signUp() async {

    try {
      isLoading.value = true;

      // Prepare sign up data
      final signUpData = {
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'password': passwordController.text,
      };

      // TODO: Implement your actual sign up API call here
      // Example:
      // final response = await ApiService.signUp(signUpData);

      // Simulated API call
      await Future.delayed(Duration(seconds: 2));

      // Upload profile image if exists
      if (profileImage.value != null) {
        // TODO: Upload image to server
        // Example:
        // await ApiService.uploadProfileImage(profileImage.value!);
      }

      // Success
      Get.snackbar(
        'Success',
        'Account created successfully!',
        backgroundColor: Color(0xFF4CAF50),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );

      // Navigate to next screen or back to sign in
      // You can use Get.offAll() to replace all routes
      // Get.offAll(() => HomeScreen());
      // Or just go back to sign in
      Get.back();

    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to create account. Please try again.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Clear all fields
  void clearFields() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    profileImage.value = null;
    nameError.value = '';
    emailError.value = '';
    passwordError.value = '';
    confirmPasswordError.value = '';
  }

  @override
  void onInit() {
    super.onInit();
    // You can add listeners to text controllers here if needed
    // Example:
    // emailController.addListener(() {
    //   if (emailError.value.isNotEmpty) {
    //     emailError.value = ''; // Clear error when user starts typing
    //   }
    // });
  }

  @override
  void onClose() {
    // Dispose all controllers
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}