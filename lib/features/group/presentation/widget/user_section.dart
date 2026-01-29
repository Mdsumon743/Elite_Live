
import 'dart:developer';

import 'package:elites_live/features/group/presentation/widget/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/global_widget/custom_text_view.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/image_path.dart';



class UserSection extends StatelessWidget {
  const UserSection({
    super.key,
    required this.groupName,
    required this.groupImage,
    required this.userProfession,
    this.userId,
    this.profileImage,
    this.groupId,
    this.onTap,

  });

  final String groupName;
  final String userProfession;
  final String groupImage;
  final String? userId;
  final String? profileImage;
  final String? groupId;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          /// Avatar
          CircleAvatar(
            radius: 28.sp,
            backgroundImage: (profileImage != null && profileImage!.isNotEmpty)
                ? NetworkImage(profileImage!)
                : (groupImage.isNotEmpty
                ? NetworkImage(groupImage)
                : AssetImage(ImagePath.dance) as ImageProvider),
            onBackgroundImageError: (_, __) {
              log("Failed to load image");
            },
            child: (profileImage == null || profileImage!.isEmpty) &&
                (groupImage.isEmpty)
                ? Text(
              groupName.isNotEmpty ? groupName[0].toUpperCase() : '?',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            )
                : null,
          ),

          SizedBox(width: 12.w),

          /// User info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextView(
                  text: groupName,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textHeader,
                ),
                SizedBox(height: 4.h),
                CustomTextView(
                  text: userProfession,
                  fontWeight: FontWeight.w400,
                  fontSize: 13.sp,
                  color: AppColors.textBody,
                ),
              ],
            ),
          ),


          GradientButton(
            title: "Invite",
            onTap: () {
              if (onTap != null) onTap!();
            },

          ),
        ],
      ),
    );
  }
}
