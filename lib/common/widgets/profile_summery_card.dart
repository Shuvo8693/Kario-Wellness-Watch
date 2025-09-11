import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kario_wellness_watch/common/app_images/network_image%20.dart';
import 'package:kario_wellness_watch/common/app_text_style/style.dart';
import 'package:kario_wellness_watch/common/widgets/spacing.dart';

import 'casess_network_image.dart';
import 'icon_and_text.dart';

class ProfileSummeryCard extends StatelessWidget {
  const ProfileSummeryCard({
    super.key,
    this.isDateActive = true,
    this.imageHeight,
    this.imageWidth,
    required this.name,
    required this.description,
    required this.imageUrl,
    this.date,
  });

  final bool isDateActive;
  final double? imageHeight;
  final double? imageWidth;
  final String name;
  final String description;
  final String imageUrl;
  final String? date;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Profile Image
        CustomNetworkImage(
          imageUrl: imageUrl,
          height: imageHeight ?? 86.h,
          width: imageWidth ?? 86.w,
          boxShape: BoxShape.circle,
        ),
        const SizedBox(width: 13.0),

        /// Profile Details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name and Role
              Text(
                name,
                style: AppStyles.h2(),
                maxLines: 1, // Restrict to one line
                overflow: TextOverflow.ellipsis, // Add ellipsis for overflow
              ),

              /// Description
              SizedBox(height: 4.0.h),
              Text(
                description,
                maxLines: 3, // Limit description to 3 lines
                overflow: TextOverflow.ellipsis, // Add ellipsis for overflow
                style: AppStyles.h4(color: Colors.grey),
              ),
              const SizedBox(height: 8.0),

              // Optional Date
              if (isDateActive)
                Row(
                  children: [
                    const Icon(Icons.calendar_month_outlined, size: 16,color: Colors.grey,),
                    const SizedBox(width: 4.0),
                    Text(
                      date ?? 'N/A',
                      style: AppStyles.h6(color: Colors.grey),
                      overflow: TextOverflow.ellipsis, // Add ellipsis for overflow
                    ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );

  }
}
