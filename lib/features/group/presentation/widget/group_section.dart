import 'package:elites_live/routes/app_routing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/global_widget/custom_text_view.dart';
import '../../../../core/utils/constants/app_colors.dart';

import 'gradient_button.dart';

class GroupSection extends StatelessWidget {
  const GroupSection({
    super.key,
    required this.groupName,
    required this.groupMember,
    required this.groupImage,
    required this.buttonText,
    required this.groupStaus,
    this.onTap,
  });

  final String groupName;
  final String groupMember;
  final String groupImage;
  final String buttonText;
  final bool groupStaus;
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
          // Avatar
          CircleAvatar(
            radius: 28.sp,
            backgroundImage: NetworkImage(groupImage), // Use the passed parameter
          ),

          SizedBox(width: 12.w),

          // Group Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextView(
                  text:     groupName,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textHeader,
                ),
                SizedBox(height: 4.h),
                CustomTextView(
                text:       "$groupMember Member",
                  fontWeight: FontWeight.w400,
                  fontSize: 13.sp,
                  color: AppColors.textBody,
                ),
              ],
            ),
          ),

          // Invite Button
          GradientButton(isGroup: groupStaus,title: buttonText, onTap: (){
            onTap!();
            ///Get.toNamed(AppRoute.invite);
          },),
        ],
      ),
    );
  }
}