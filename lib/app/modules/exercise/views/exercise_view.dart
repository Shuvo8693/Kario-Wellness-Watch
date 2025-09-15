import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kario_wellness_watch/app/modules/home/widgets/health_app_bar.dart';
import 'package:kario_wellness_watch/common/app_images/app_svg.dart';
import 'package:kario_wellness_watch/common/app_text_style/google_app_style.dart';
import 'package:kario_wellness_watch/common/bottom_menu/bottom_menu..dart';
import 'package:kario_wellness_watch/common/custom_map/reusable_map.dart';
import '../controllers/exercise_controller.dart';

class ExerciseView extends GetView<ExerciseController> {
  const ExerciseView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HealthAppBar(title: 'Exercise',),
      bottomNavigationBar: SafeArea(child: BottomMenu(1)),
      body: Column(
        children: [
          // Top Tab Section
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Obx(() => Row(
              children: [
                _buildTabButton(
                  title: 'Outdoor Run',
                  isSelected: controller.selectedTab.value == 0,
                  onTap: () => controller.changeTab(0),
                ),
                SizedBox(width: 8.w),
                _buildTabButton(
                  title: 'Walking',
                  isSelected: controller.selectedTab.value == 1,
                  onTap: () => controller.changeTab(1),
                ),
                SizedBox(width: 8.w),
                _buildTabButton(
                  title: 'Cycling',
                  isSelected: controller.selectedTab.value == 2,
                  onTap: () => controller.changeTab(2),
                ),
              ],
            )
            ),
          ),

          // Distance Info Section
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20.w),
            color: Colors.white,
            child: Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getDistanceTitle(),
                  style: GoogleFontStyles.h5(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Text(
                      controller.totalDistance.value.toStringAsFixed(2),
                      style: GoogleFontStyles.h1(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Padding(
                      padding: EdgeInsets.only(top: 8.h),
                      child: Text(
                        'miles',
                        style: GoogleFontStyles.h5(
                          color: Colors.grey[600],
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                    const Spacer(),
                    _getActivityIcon(),
                  ],
                ),
              ],
            )),
          ),

          // Google Maps Section using ReusableMap with Stack overlay
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Stack(
                  children: [
                    // Map Widget - Full area for dragging
                    Obx(() => ReusableMap(
                      key: controller.mapKey,
                      initialPosition: controller.currentPosition.value ??
                          const LatLng(23.8103, 90.4125), // Default to Dhaka
                      initialZoom: 15.0,
                      markers: controller.markers.toSet(),
                      polylines: controller.polylines.toSet(),
                      showMyLocation: true,
                      showMyLocationButton: false,
                      mapType: MapType.normal,
                      darkMode: false,
                      onMapCreated: controller.onMapCreated,
                      // Remove customFloatingButton to allow map interactions
                      )
                    ),

                    // Custom controls overlay with pointer events only on buttons
                    Positioned.fill(
                      child: IgnorePointer(
                        child: Stack(
                          children: [
                            // Zoom Controls - Top Right
                            Positioned(
                              right: 16.w,
                              top: 16.h,
                              child: IgnorePointer(
                                ignoring: false, // Allow interactions with these buttons
                                child: Column(
                                  children: [
                                    _buildMapButton(
                                      icon: Icons.add,
                                      onTap: controller.zoomIn,
                                    ),
                                    SizedBox(height: 8.h),
                                    _buildMapButton(
                                      icon: Icons.remove,
                                      onTap: controller.zoomOut,
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // My Location Button - Top Left
                            Positioned(
                              left: 16.w,
                              top: 16.h,
                              child: IgnorePointer(
                                ignoring: false, // Allow interactions with this button
                                child: _buildMapButton(
                                  icon: Icons.my_location,
                                  onTap: controller.goToCurrentLocation,
                                ),
                              ),
                            ),

                            // GO/STOP Button - Bottom Center
                            Positioned(
                              bottom: 24.h,
                              left: 0,
                              right: 0,
                              child: Center(
                                child: IgnorePointer(
                                  ignoring: false, // Allow interactions with this button
                                  child: Obx(() => GestureDetector(
                                    onTap: controller.isTracking.value
                                        ? controller.stopTracking
                                        : controller.startTracking,
                                    child: Container(
                                      width: 80.w,
                                      height: 80.w,
                                      decoration: BoxDecoration(
                                        color: controller.isTracking.value
                                            ? Colors.red
                                            : const Color(0xFFFF6B35),
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.2),
                                            blurRadius: 8,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child: Text(
                                          controller.isTracking.value ? 'STOP' : 'GO',
                                          style: GoogleFontStyles.h4(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SizedBox(height: 16.h),
        ],
      ),
    );
  }

  Widget _buildTabButton({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFFFE5DB) : Colors.grey[100],
            borderRadius: BorderRadius.circular(8.r),
            border: isSelected
                ? Border.all(color: const Color(0xFFFF6B35), width: 1)
                : null,
          ),
          child: Center(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFontStyles.h6(
                  color: isSelected ? const Color(0xFFFF6B35) : Colors.grey[600],
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMapButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40.w,
        height: 40.w,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          icon,
          size: 20.sp,
          color: Colors.grey[700],
        ),
      ),
    );
  }

  String _getDistanceTitle() {
    switch (controller.selectedTab.value) {
      case 0:
        return 'Total running distance';
      case 1:
        return 'Total walking distance';
      case 2:
        return 'Total cycling distance';
      default:
        return 'Total distance';
    }
  }

  Widget _getActivityIcon() {
    switch (controller.selectedTab.value) {
      case 0:
        return SvgPicture.asset(
          AppSvg.out_door_runSvg, // Replace with your running icon
          width: 50.w,
          height: 87.h,
          errorBuilder: (context, error, stackTrace) => Container(
            width: 50.w,
            height: 50.h,
            decoration: BoxDecoration(
              color: Colors.orange[100],
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(Icons.directions_run, color: Colors.orange, size: 30.sp),
          ),
        );
      case 1:
        return SvgPicture.asset(
          AppSvg.walkingSvg, // Replace with your walking icon
          width: 50.w,
          height: 87.h,
          errorBuilder: (context, error, stackTrace) => Container(
            width: 50.w,
            height: 50.h,
            decoration: BoxDecoration(
              color: Colors.blue[100],
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(Icons.directions_walk, color: Colors.blue, size: 30.sp),
          ),
        );
      case 2:
        return SvgPicture.asset(
          AppSvg.cyclingSvg, // Replace with your cycling icon
          width: 50.w,
          height: 87.h,
          errorBuilder: (context, error, stackTrace) => Container(
            width: 50.w,
            height: 50.h,
            decoration: BoxDecoration(
              color: Colors.green[100],
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(Icons.directions_bike, color: Colors.green, size: 30.sp),
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}