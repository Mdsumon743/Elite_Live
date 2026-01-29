import 'dart:developer';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../../core/global_widget/custom_text_view.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../home/controller/home_controller.dart';
import '../../controller/event_controller.dart';


class EventFollowSection extends StatelessWidget {
  final int index;

  EventFollowSection({super.key, required this.index});

  final HomeController controller = Get.find();
  final EventController eventController = Get.find();

  @override
  Widget build(BuildContext context) {
    final event = eventController.eventList[index];
    final bool isFollowing = event.user.isFollow;
    final bool isOwner = event.isOwner;
    final userId = event.userId;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Only show follow button if user is NOT the owner and NOT following
        if (!isOwner && !isFollowing)
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

        // Add spacing only if follow button is visible
        if (!isOwner && !isFollowing) SizedBox(width: 4.w),

        /// 3-dot popup menu
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

            // Only show Unfollow option if user is following and NOT the owner
            if (isFollowing && !isOwner) {
              items.add(
                PopupMenuItem(
                  value: 0,
                  child: Row(
                    children: [
                      Icon(Icons.person_remove,
                          size: 18.sp, color: AppColors.redColor),
                      SizedBox(width: 10.w),
                      CustomTextView(
                        text: "Unfollow",
                        fontWeight: FontWeight.w500,
                        fontSize: 14.sp,
                        color: AppColors.redColor,
                      ),
                    ],
                  ),
                ),
              );
            }

            // Show these options only if NOT the owner
            if (!isOwner) {
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
                        color: AppColors.textHeader,
                      ),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 2,
                  child: Row(
                    children: [
                      Icon(Icons.report_problem_outlined,
                          size: 18.sp, color: Colors.black87),
                      SizedBox(width: 10.w),
                      CustomTextView(
                        text: "Report Channel",
                        fontWeight: FontWeight.w500,
                        fontSize: 14.sp,
                        color: AppColors.textHeader,
                      ),
                    ],
                  ),
                ),
              ]);
            }

            // If owner, show different menu options
            if (isOwner) {
              items.addAll([
                PopupMenuItem(
                  value: 3,
                  child: Row(
                    children: [
                      Icon(Icons.edit, size: 18.sp, color: Colors.black87),
                      SizedBox(width: 10.w),
                      CustomTextView(
                        text: "Edit Event",
                        fontWeight: FontWeight.w500,
                        fontSize: 14.sp,
                        color: AppColors.textHeader,
                      ),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 4,
                  child: Row(
                    children: [
                      Icon(Icons.delete,
                          size: 18.sp, color: AppColors.redColor),
                      SizedBox(width: 10.w),
                      CustomTextView(
                        text: "Delete Event",
                        fontWeight: FontWeight.w500,
                        fontSize: 14.sp,
                        color: AppColors.redColor,
                      ),
                    ],
                  ),
                ),
              ]);
            }

            return items;
          },
          onSelected: (value) {
            switch (value) {
              case 0:
                log("User clicked Unfollow");
                eventController.followUnFlow(userId);
                break;
              case 1:
                log("User clicked Not Interested");
                // Add not interested logic here
                break;
              case 2:
                log("User clicked Report Channel");
                // Add report logic here
                break;
              case 3:
                log("User clicked Edit Event");
                // Add edit event logic here
                break;
              case 4:
                log("User clicked Delete Event");
                // Add delete event logic here
                break;
            }
          },
        ),
      ],
    );
  }
}