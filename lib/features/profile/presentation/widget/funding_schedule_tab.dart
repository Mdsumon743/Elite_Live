import 'package:elites_live/core/global_widget/custom_text_view.dart';
import 'package:elites_live/features/event/controller/schedule_controller.dart';
import 'package:elites_live/features/profile/controller/my_crowd_funding_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'dart:developer';

import '../../../../core/global_widget/custom_comment_sheet.dart';
import '../../../../core/global_widget/custom_loading.dart';
import '../../../../core/utils/constants/app_colors.dart';

import '../../../event/presentation/widget/user_interaction_section.dart';
import '../../data/my_crowd_funding_data_model.dart';

class FundingScheduleTab extends StatelessWidget {
  FundingScheduleTab({super.key});

  final ScheduleController scheduleController = Get.find();

  @override
  Widget build(BuildContext context) {
    final MyCrowdFundController controller = Get.find();

    return Obx(() {
      log("UI REBUILD → isLoading: ${controller.isLoading.value} | events: ${controller.events.length}");

      if (controller.isLoading.value) {
        return SizedBox(
          height: 200.h,
          child: Center(child: CustomLoading(color: AppColors.primaryColor)),
        );
      }

      if (controller.myCrowd.isEmpty) {
        log("UI: No events → showing empty state");
        return _buildEmptyState();
      }

      log("UI: Rendering ${controller.myCrowd.length} event(s)");

      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        itemCount: controller.myCrowd.length,
        separatorBuilder: (_, __) => SizedBox(height: 16.h),
        itemBuilder: (context, index) {
          final event = controller.myCrowd[index];
          log("Building card for: ${event.events.first.title}");

          return EventCard(
            event: event.events.first,
            scheduleController: scheduleController, // FIXED
          );
        },
      );
    });
  }

  Widget _buildEmptyState() {
    return SizedBox(
      height: 200.h,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy, size: 64.sp, color: Colors.grey[400]),
            SizedBox(height: 16.h),
            Text(
              "No Schedule Available",
              style: GoogleFonts.inter(fontSize: 16.sp, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 8.h),
            Text(
              "Your scheduled events will appear here",
              style: GoogleFonts.inter(fontSize: 14.sp, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

// ----------------------------
// Event Card Widget
// ----------------------------
class EventCard extends StatelessWidget {
  final Event event;
  final ScheduleController scheduleController; // FIXED

  const EventCard({
    required this.event,
    required this.scheduleController, // FIXED
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE8E8E8)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Header
          Row(
            children: [
              CircleAvatar(
                radius: 20.r,
                backgroundImage: event.user.profileImage != null
                    ? NetworkImage(event.user.profileImage!)
                    : null,
                child: event.user.profileImage == null
                    ? Text(event.user.firstName[0].toUpperCase())
                    : null,
              ),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextView(
                    text: "${event.user.firstName} ${event.user.lastName}",
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                  ),
                  CustomTextView(
                    text: event.user.profession,
                    fontSize: 12.sp,
                    color: AppColors.textBody,
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 12.h),

          // Title
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            child: CustomTextView(
              text: event.title,
              color: AppColors.textHeader,
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: 12.h),

          // Content
          CustomTextView(
            text: event.text,
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.textBody,
          ),

          SizedBox(height: 16.h),

          // User Interaction Section
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            child: UserInteractionSection(
              eventType: event.eventType,
              isOwner: true,
              isLiked: event.isLiked,
              likeCount: event.count.eventLike.toString(),
              commentCount: event.count.eventComment,
              onLikeTap: () {
                scheduleController.createLike(event.id); // FIXED
              },
              onCommentTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return CommentSheet(
                      scheduleController: scheduleController,
                      eventId: event.id,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
