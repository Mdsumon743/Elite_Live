import 'package:elites_live/core/global_widget/custom_loading.dart';
import 'package:elites_live/core/global_widget/custom_text_view.dart';
import 'package:elites_live/core/utils/constants/app_colors.dart';
import 'package:elites_live/features/event/controller/schedule_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:elites_live/core/global_widget/custom_elevated_button.dart';


import '../../../../core/global_widget/custom_comment_sheet.dart';
import '../../../../routes/app_routing.dart';
import '../../../home/presentation/widget/donation_sheet.dart';
import '../widget/user_interaction_section.dart';

class OthersUserScheduleEventScreen extends StatelessWidget {
  OthersUserScheduleEventScreen({super.key, this.userId});

  final String? userId;
  final ScheduleController controller = Get.find();

  String formatDate(DateTime date) {
    return DateFormat('dd-MM-yyyy').format(date);
  }

  String formatTime(DateTime date) {
    return DateFormat('hh:mm a').format(date);
  }



  @override
  Widget build(BuildContext context) {
    Future.microtask(() => controller.getOthersUserScheduleEvent(userId!));

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CustomLoading(color: AppColors.primaryColor),
          );
        }

        if (controller.otherScheduleEvent.isEmpty) {
          return const Center(
            child: CustomTextView(text: "No Schedule Event Found"),
          );
        }

        final result = controller.otherScheduleEvent.first;

        return ListView.builder(
          padding: EdgeInsets.all(16.w),
          itemCount: result.events.length,
          itemBuilder: (context, index) {
            final event = result.events[index];
            final isOwner = event.isOwner;
            final isPayment = event.isPayment;
            final hostLink = event.stream.hostLink;
            final audienceLink = event.stream.audienceLink;
            final coHostLink = event.stream.coHostLink;
            final streamId = event.streamId;
            final hostId = event.userId;
            final firstName = event.user.firstName;
            final lastName = event.user.lastName;
            final userName = "$firstName $lastName";

            // Determine which link to display


            return Container(
              margin: EdgeInsets.only(bottom: 16.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: Colors.blue.shade200,
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.1),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with Date and Time
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12.r),
                        topRight: Radius.circular(12.r),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomTextView(
                          text: 'Date: ${formatDate(event.scheduleDate??DateTime.now())}',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                        CustomTextView(
                          text: formatTime(event.scheduleDate??DateTime.now()),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryColor,
                        ),
                      ],
                    ),
                  ),

                  // Content
                  Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        CustomTextView(
                          text: event.title,
                          fontWeight: FontWeight.w600,
                          fontSize: 18.sp,
                          color: Colors.black,
                        ),
                        SizedBox(height: 12.h),

                        // Description
                        CustomTextView(
                          text: event.text,
                          fontWeight: FontWeight.w400,
                          fontSize: 14.sp,
                          color: Colors.grey.shade700,
                          maxLines: 10,
                        ),
                        SizedBox(height: 16.h),

                        // Pay Amount Display (if applicable)
                        if (event.payAmount > 0 && !isOwner)
                          Padding(
                            padding: EdgeInsets.only(bottom: 12.h),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 6.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green.shade50,
                                borderRadius: BorderRadius.circular(8.r),
                                border: Border.all(
                                  color: Colors.green.shade200,
                                ),
                              ),
                              child: CustomTextView(
                                text: 'Joining Fee: \$${event.payAmount}',
                                fontWeight: FontWeight.w600,
                                fontSize: 14.sp,
                                color: Colors.green.shade700,
                              ),
                            ),
                          ),



                        // Action Button
                        _buildActionButton(
                          context: context,
                          event: event,
                          userName: userName,
                          isOwner: isOwner,
                          isPayment: isPayment,
                          hostLink: hostLink,
                          audienceLink: audienceLink,
                          coHostLink: coHostLink,
                          streamId: streamId,
                          hostId: hostId,
                        ),
                      ],
                    ),
                  ),

                  // Footer with Stats

                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                    child: UserInteractionSection(
                      onLikeTap: (){
                        controller.createLike(event.id);
                      },
                      eventType: event.eventType,
                      isLiked: event.isLiked,
                      likeCount: event.count.eventLike.toString(),
                      commentCount: event.count.eventComment,
                      onCommentTap: (){
                        showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context){
                              return CommentSheet(
                                  scheduleController: controller,
                                  eventId: event.id
                              );
                            }
                        );
                      },
                      isOwner: isOwner,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required dynamic event,
    required bool isOwner,
    required bool isPayment,
    required String hostLink,
    required String? audienceLink,
    required String? coHostLink,
    required String streamId,
    required String hostId,
    required String userName,
  }) {
    final hasLive = hostLink.isNotEmpty;

    // OWNER: Start Live
    if (isOwner) {
      if (!hasLive) {
        return CustomElevatedButton(
          text: "Start Live",
          ontap: () {
            Get.toNamed(AppRoute.myLive, arguments: {
              'roomId': streamId,
              'eventId': event.id,     // ✅ FIXED
              'userName': userName,    // ✅ FIXED
              'isHost': true,
              'hostLink': hostLink,
              'audienceLink': audienceLink,
              'hostId': hostId,
              'coHostLink': coHostLink, // ✅ FIXED
            });
          },
        );
      }

      return CustomElevatedButton(
        text: "Join as Host",
        ontap: () {
          Get.toNamed(
            AppRoute.myLive,
            arguments: {
              'roomId': streamId,
              'userName': userName,
              'isHost': true,
              'hostLink': hostLink,
              'audienceLink': audienceLink,
              'hostId': hostId,
              'coHostLink': coHostLink,
            },
          );
        },
      );
    }

    // AUDIENCE: Pay First
    if (!isPayment) {
      return CustomElevatedButton(
        text: "Pay \$${event.payAmount}",
        ontap: () {
          DonationSheet.show(context, eventId: event.id);
        },
        textColor: Colors.white,
      );
    }

    // AUDIENCE: Join After Payment
    if (audienceLink != null && audienceLink.isNotEmpty) {
      return CustomElevatedButton(
        text: "Join Now",
        ontap: () {
          Get.toNamed(AppRoute.myLive, arguments: {
            'roomId': streamId,
            'userName': userName,
            'isHost': false,
            'hostLink': hostLink,
            'audienceLink': audienceLink,
            'hostId': hostId,
          });
        },
      );
    }

    // Live not started
    return CustomElevatedButton(
      text: "Waiting for Live",
      ontap: () {
        Get.snackbar(
          'Not Available',
          'The live event hasn\'t started yet.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      },
    );
  }




}

// TODO: Add these classes if they don't exist in your project



