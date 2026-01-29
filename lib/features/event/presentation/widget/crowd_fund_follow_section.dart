import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/global_widget/custom_text_view.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../home/controller/home_controller.dart';
import '../../controller/event_controller.dart';
import '../../controller/schedule_controller.dart';
import '../../data/crowd_funding_data_model.dart';



class CrowdFundFollowSection extends StatelessWidget {
  final CrowdFundingEvent event;

   CrowdFundFollowSection({super.key, required this.event});

  final EventController eventController = Get.find();

  @override
  Widget build(BuildContext context) {
    if (event.isOwner) return SizedBox.shrink(); // hide if owner

    final bool isFollowing = event.user.isFollow;
    final userId = event.userId;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!isFollowing)
          GestureDetector(
            onTap: () {
              eventController.followUnFlow(userId);
              log("start following");
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: CustomTextView(
                text: "Follow",
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                textAlign: TextAlign.center,
                color: const Color(0xFF374151),
              ),
            ),
          ),
        SizedBox(width: 4.w),
        // 3-dot popup
        PopupMenuButton<int>(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          color: Colors.white,
          elevation: 4,
          position: PopupMenuPosition.under,
          icon: Icon(
            Icons.more_vert,
            size: 22.sp,
            color: const Color(0xFF6B7280),
          ),
          itemBuilder: (context) {
            List<PopupMenuEntry<int>> items = [];
            if (isFollowing) {
              items.add(
                PopupMenuItem(
                  value: 0,
                  child: Row(
                    children: [
                      Icon(Icons.person_remove, size: 18.sp, color: Colors.red),
                      SizedBox(width: 10.w),
                      GestureDetector(
                        onTap: () => eventController.followUnFlow(userId),
                        child: CustomTextView(
                          text: "Unfollow",
                          fontWeight: FontWeight.w500,
                          fontSize: 14.sp,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            items.addAll([
              PopupMenuItem(
                value: 1,
                child: Row(
                  children: [
                    Icon(Icons.block, size: 18.sp, color: Colors.black87),
                    SizedBox(width: 10.w),
                    CustomTextView(
                        text: "Not Interested",
                        fontWeight: FontWeight.w500,
                        fontSize: 14.sp,
                        color: Colors.black87),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 2,
                child: Row(
                  children: [
                    Icon(Icons.report_problem_outlined, size: 18.sp, color: Colors.black87),
                    SizedBox(width: 10.w),
                    CustomTextView(
                        text: "Report Channel",
                        fontWeight: FontWeight.w500,
                        fontSize: 14.sp,
                        color: Colors.black87),
                  ],
                ),
              ),
            ]);
            return items;
          },
          onSelected: (value) {
            switch (value) {
              case 0:
                log("User clicked Unfollow");
                break;
              case 1:
                log("User clicked Not Interested");
                break;
              case 2:
                log("User clicked Report Channel");
                break;
            }
          },
        ),
      ],
    );
  }
}

