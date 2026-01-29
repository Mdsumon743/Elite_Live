import 'dart:developer';

import 'package:elites_live/core/global_widget/custom_loading.dart';
import 'package:elites_live/core/global_widget/custom_snackbar.dart';
import 'package:elites_live/core/utils/constants/app_colors.dart';
import 'package:elites_live/features/event/controller/event_controller.dart';
import 'package:elites_live/features/event/controller/schedule_controller.dart';
import 'package:elites_live/features/event/presentation/widget/event_follow_section.dart';
import 'package:elites_live/features/profile/controller/profile_controller.dart';
import 'package:elites_live/routes/app_routing.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/global_widget/custom_comment_sheet.dart';
import '../../../../core/global_widget/date_time_helper.dart';
import '../../../home/presentation/widget/designation_section.dart';
import '../../../home/presentation/widget/donation_sheet.dart';
import '../../../home/presentation/widget/live_indicator_section.dart';
import '../../../home/presentation/widget/nameBadgeSection.dart';


import '../../../live/controller/live_screen_controller.dart';
import '../widget/date_time_section.dart';
import '../widget/event_details_section.dart';
import '../widget/user_interaction_section.dart';

class EventScheduleScreen extends StatelessWidget {
  EventScheduleScreen({super.key});


  final EventController eventController = Get.find();
  final ScheduleController scheduleController = Get.find();
  final LiveScreenController controller = Get.find();
  final ProfileController profileController = Get.find();

  final RxString replyingToId = ''.obs;
  final RxString replyingToName = ''.obs;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (eventController.isLoading.value && eventController.eventList.isEmpty) {
        return Center(child: CustomLoading(color: AppColors.primaryColor,));
      }

      if (eventController.eventList.isEmpty) {
        return Center(child: Text('No events found',style: TextStyle(
            color: AppColors.textHeader
        ),));
      }

      return RefreshIndicator(
        onRefresh: eventController.refreshEvents,
        child: ListView.separated(
          controller: eventController.scrollController,
          physics: BouncingScrollPhysics(),
          itemCount: eventController.eventList.length + 1,
          separatorBuilder: (context, index) {
            if (index >= eventController.eventList.length) {
              return SizedBox.shrink();
            }
            return Divider();
          },
          shrinkWrap: true,
          itemBuilder: (context, index) {

            if (index >= eventController.eventList.length) {
              return Obx(() {
                if (eventController.isPaginationLoading.value) {
                  return Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: CustomLoading(color: AppColors.primaryColor,)),
                  );
                }
                return SizedBox.shrink();
              });
            }

            final event = eventController.eventList[index];

            // Extract user data
            final firstName = event.user.firstName;
            final lastName = event.user.lastName;
            final userName = "$firstName $lastName";
            final userImage = event.user.profileImage;
            final profession = event.user.profession;
            final eventId = event.id;
            final currentUserFirstName = profileController.userinfo.value!.firstName;
            final currentUserLastName = profileController.userinfo.value!.lastName;
            final currentUserName = "$currentUserFirstName $currentUserLastName";

            // Extract event data
            final about = event.text;
            final eventType = event.title;
            final joiningFee = event.payAmount.toString();

            // Format date and time
            final scheduleDateTime = DateTimeHelper.formatScheduleDateTime(event.scheduleDate!.toIso8601String());
            final eventDate = scheduleDateTime['date']!;
            final eventTime = scheduleDateTime['time']!;
            final likeStatus = event.isLiked;
            final paymentStatus = event.isPayment;

            // Calculate time ago
            final timeAgo = DateTimeHelper.getTimeAgo(event.createdAt!.toIso8601String());

            // Counts
            final likeCount = event.count.eventLike;
            final commentCount = event.count.eventComment;
            final isOwner = event.isOwner;
            final hostLink = event.stream?.hostLink;
            final audienceLink = event.stream?.audienceLink;
            final cohostLink = event.stream?.coHostLink;
            final streamId = event.streamId;
            final hostId = event.userId;



            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LiveIndicatorSection(
                      onTap: (){
                        Get.toNamed(AppRoute.othersUser, arguments: {"userId":event.userId});
                      },
                      influencerProfile: userImage??'https://cdn2.psychologytoday.com/assets/styles/manual_crop_1_91_1_1528x800/public/field_blog_entry_images/2018-09/shutterstock_648907024.jpg?itok=7lrLYx-B',
                    ),

                    SizedBox(width: 12.w),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          NameBadgeSection(userName: userName),
                          SizedBox(height: 4.h),
                          DesignationSection(
                            designation: profession??'',
                            timeAgo: timeAgo,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(width: 8.w),

                    EventFollowSection(index: index)
                  ],
                ),
                SizedBox(height: 16.h),

                DateTimeSection(
                  eventDate: eventDate,
                  eventTime: eventTime,
                ),
                SizedBox(height: 10.h),

                /// FIXED: Complete onTap logic for all cases
                EventDetailsSection(
                  eventDetails: about,
                  eventTitle: eventType,
                  joiningFee: joiningFee,
                  isOwner: isOwner,
                  hostLink: hostLink,
                  audienceLink: audienceLink,
                  isPayment: paymentStatus,
                    // In EventDetailsSection onTap callback (EventScheduleScreen)

                    // UPDATED: EventScheduleScreen onTap logic
// Replace the EventDetailsSection onTap callback with this:

                    onTap: () async {
                      log("the stream id is $streamId");

                      if (isOwner) {
                        if (hostLink == null || hostLink.isEmpty) {
                          // OWNER: Start Live (create new session)
                          controller.createAndNavigateToLive(
                            isPaid: false,
                            isHost: isOwner,
                          );
                        } else {
                          // OWNER: Join as Host (existing session)
                          await controller.startLive(streamId!);

                          // ← UPDATED: Pass eventId for comment system
                          Get.toNamed(AppRoute.myLive, arguments: {
                            'roomId': streamId,
                            'eventId': eventId, // ← NEW: Pass event ID
                            'userName': currentUserName,
                            'isHost': isOwner,
                            'hostLink': hostLink,
                            'audienceLink': audienceLink,
                            'hostId': hostId,
                            'coHostLink': cohostLink,
                          });
                        }
                        return;
                      }

                      if (!paymentStatus) {
                        DonationSheet.show(context, eventId: event.id);
                        return;
                      }

                      // CASE B: User has paid → Join as audience
                      if (audienceLink != null && audienceLink.isNotEmpty) {
                        await controller.startLive(streamId!);

                        // ← UPDATED: Pass eventId for comment system
                        Get.toNamed(AppRoute.myLive, arguments: {
                          'roomId': streamId,
                          'eventId': eventId, // ← NEW: Pass event ID
                          'streamId': streamId,
                          'userName': currentUserName,
                          'isHost': isOwner,
                          'hostLink': hostLink,
                          'audienceLink': audienceLink,
                          'hostId': hostId,
                          'coHostLink': cohostLink,
                        });
                      } else {
                        CustomSnackBar.warning(
                          title: "Not Available",
                          message: "The live event hasn't started yet. Please wait for the host to begin.",
                        );
                      }
                    }
                ),

                SizedBox(height: 10.h),

                UserInteractionSection(
                  onLikeTap: (){
                    scheduleController.createLike(eventId);
                  },
                  eventType: eventType,
                  isLiked: likeStatus,
                  likeCount: likeCount.toString(),
                  commentCount: commentCount,
                  onCommentTap: (){
                    showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context){
                          return CommentSheet(
                              scheduleController: scheduleController,
                              eventId: eventId
                          );
                        }
                    );
                  },
                  isOwner: isOwner,
                ),
              ],
            );
          },
        ),
      );
    });
  }
}