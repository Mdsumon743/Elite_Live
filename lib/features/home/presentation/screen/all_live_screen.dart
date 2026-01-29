import 'package:elites_live/core/global_widget/custom_loading.dart';
import 'package:elites_live/core/global_widget/custom_text_view.dart';
import 'package:elites_live/core/utils/constants/app_colors.dart';
import 'package:elites_live/features/home/controller/home_controller.dart';
import 'package:elites_live/features/home/presentation/widget/video_player_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widget/designation_section.dart';
import '../widget/follow_section.dart';
import '../widget/live_description_section.dart';
import '../widget/live_indicator_section.dart';
import '../widget/nameBadgeSection.dart';
import '../widget/top_influence_section.dart';
import '../widget/video_interaction_section.dart';
import 'package:get/get.dart';

class AllLiveScreen extends StatelessWidget {
  AllLiveScreen({super.key});

  final HomeController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    Future.microtask(() => controller.getAllRecordedLive(
        controller.currentPage.value, controller.limit.value));
    return Obx(() {
      /// -------------------------------
      /// 1. LOADING STATE
      /// -------------------------------
      if (controller.isLoading.value) {
        return Center(
          child: Padding(
            padding: EdgeInsets.only(top: 100.h),
            child: CustomLoading(
              color: AppColors.primaryColor,
            ),
          ),
        );
      }

      /// -------------------------------
      /// 2. EMPTY STATE
      /// -------------------------------
      if (controller.allStreamList.isEmpty) {
        return Center(
          child: Padding(
            padding: EdgeInsets.only(top: 120.h),
            child: CustomTextView(
              text: "No live events available",
              fontSize: 16.sp,
              color: AppColors.textHeader,
            ),
          ),
        );
      }

      /// -------------------------------
      /// 3. MAIN CONTENT
      /// -------------------------------
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// LIVE LIST
            Container(
              width: double.infinity,
              color: Colors.white,
              child: ListView.builder(
                itemCount: controller.allStreamList.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final recordedEvent = controller.allStreamList[index];

                  // Extract data safely
                  final isLive = recordedEvent.stream?.isLive ?? false;
                  final firstName = recordedEvent.user.firstName ?? '';
                  final lastName = recordedEvent.user.lastName ?? '';
                  final userName = "$firstName $lastName".trim();
                  final userId = recordedEvent.userId ?? '';
                  final isFollowing = recordedEvent.user.isFollow ?? false;

                  return Container(
                    margin: EdgeInsets.only(left: 14.w, right: 14.w, top: 8.h),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// Live indicator
                            LiveIndicatorSection(
                              influencerProfile:
                              "${recordedEvent.user.profileImage ?? ''}",
                              isLive: isLive,
                            ),

                            SizedBox(width: 12.w),

                            /// user name + badge + designation
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  NameBadgeSection(userName: userName),
                                  SizedBox(height: 4.h),
                                  DesignationSection(
                                    timeAgo: formatScheduleDate(
                                        recordedEvent.scheduleDate ??
                                            DateTime.now()),
                                    designation:
                                    "${recordedEvent.user.profession ?? 'N/A'}",
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(width: 8.w),

                            /// follow button section - FIXED: Pass userId and isFollowing
                            FollowSection(
                              userId: userId,
                              isFollowing: isFollowing,
                            ),
                          ],
                        ),

                        /// video
                        VideoPlayerSection(
                          videoUrl: recordedEvent.recordedLink?.toString() ?? '',
                        ),

                        /// like, comment, share
                        VideoInteractionSection(
                          eventId: recordedEvent.id ?? '',
                          reactionCount:
                          recordedEvent.count?.eventLike?.toString() ?? '0',
                          commentCount:
                          recordedEvent.count?.eventComment?.toString() ?? '0',
                        ),
                        SizedBox(height: 12.h),

                        /// description
                        LiveDescriptionSection(
                            description: recordedEvent.text ?? ''),
                      ],
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 32.h),

            /// top influencer
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              child: CustomTextView(
                text: "Top Influencer Live",
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textHeader,
              ),
            ),

            SizedBox(height: 16.h),

            SizedBox(
              height: 260.h,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 14.w),
                itemCount: controller.topInfluencerLiveList.length,
                itemBuilder: (context, index) {
                  final topInfluencerLive =
                  controller.topInfluencerLiveList[index];

                  final eventName = (topInfluencerLive.events?.isNotEmpty ?? false)
                      ? topInfluencerLive.events!.first.title ?? "No Title"
                      : "No Title";

                  return TopInfluenceSection(
                    watchCount: topInfluencerLive.watchCount?.toString() ?? '0',
                    eventName: eventName,
                  );
                },
              ),
            ),

            SizedBox(height: 32.h),
          ],
        ),
      );
    });
  }

  String formatScheduleDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(Duration(days: 1));

    final target = DateTime(date.year, date.month, date.day);

    if (target == today) return "Today";
    if (target == tomorrow) return "Tomorrow";

    // Format: 17th Nov 2025
    String daySuffix(int day) {
      if (day >= 11 && day <= 13) return "th";
      switch (day % 10) {
        case 1:
          return "st";
        case 2:
          return "nd";
        case 3:
          return "rd";
        default:
          return "th";
      }
    }

    List<String> months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];

    final suffix = daySuffix(date.day);
    return "${date.day}$suffix ${months[date.month - 1]} ${date.year}";
  }
}