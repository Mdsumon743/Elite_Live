import 'package:elites_live/features/home/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/global_widget/custom_loading.dart';
import '../../../../core/global_widget/custom_text_view.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../event/controller/event_controller.dart';
import '../widget/designation_section.dart';
import '../widget/follow_section.dart';
import '../widget/live_description_section.dart';
import '../widget/live_indicator_section.dart';
import '../widget/nameBadgeSection.dart';
import '../widget/video_interaction_section.dart';
import '../widget/video_player_section.dart';

class FollowingScreen extends StatelessWidget {
  FollowingScreen({super.key});

  final EventController controller = Get.find();
  final HomeController homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    Future.microtask(()=>homeController.getFollowingRecordedLive(homeController.currentPage.value, controller.limit.value));
    return Obx(() {
      /// -------------------------------
      /// 1. LOADING STATE
      /// -------------------------------
      if (homeController.isLoading.value) {
        return Center(
          child: Padding(
            padding: EdgeInsets.only(top: 100.h),
            child: CustomLoading(
              color: AppColors.primaryColor,
            ),
          ),
        );
      }

      /// ✅ FILTER: Show only events where user.isFollow == true
      /*final followingEvents = home.eventList
          .where((event) => event.user.isFollow == true)
          .toList();*/


      /// -------------------------------
      /// 2. EMPTY STATE
      /// -------------------------------
      if (homeController.followingStreamList.isEmpty) {
        return Center(
          child: Padding(
            padding: EdgeInsets.only(top: 120.h),
            child: CustomTextView(
              text: "No events from people you follow",
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
                itemCount: homeController.followingStreamList.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final recordeEvent = homeController.followingStreamList[index];

                  /// ✅ FIXED: Use stream.isLive instead of user.isFollow
                  final isLive = recordeEvent.stream.isLive ?? false;

                  final firstName = recordeEvent.user.firstName;
                  final lastName = recordeEvent.user.lastName;
                  final userName = "$firstName $lastName";
                  final userId = recordeEvent.userId ?? '';
                  final isFollowing = recordeEvent.user.isFollow ?? false;

                  return Container(
                    margin: EdgeInsets.only(left: 14.w, right: 14.w, top: 8.h),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// Live indicator
                            LiveIndicatorSection(
                              influencerProfile: recordeEvent.user.profileImage,
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
                                    timeAgo: formatScheduleDate(recordeEvent.scheduleDate??DateTime.now()),
                                    designation: recordeEvent.user.profession,
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(width: 8.w),

                            /// follow button section
                            FollowSection(userId: userId,isFollowing: isFollowing,),
                          ],
                        ),

                        /// video
                        VideoPlayerSection(
                          videoUrl: recordeEvent.recordedLink,
                        ),

                        /// like, comment, share
                        VideoInteractionSection(
                          eventId: recordeEvent.id,
                          reactionCount: recordeEvent.count.eventLike.toString(),
                          commentCount: recordeEvent.count.eventComment.toString(),
                        ),
                        SizedBox(height: 12.h),

                        /// description
                        LiveDescriptionSection(description: recordeEvent.text),
                      ],
                    ),
                  );
                },
              ),
            ),



            SizedBox(height: 16.h),
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
      "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];

    final suffix = daySuffix(date.day);
    return "${date.day}$suffix ${months[date.month - 1]} ${date.year}";
  }
}