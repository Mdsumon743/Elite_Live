

import 'dart:developer';

import 'package:elites_live/features/event/controller/schedule_controller.dart';
import 'package:elites_live/features/event/presentation/widget/cloud_funding_details.dart';
import 'package:elites_live/features/event/presentation/widget/crowd_fund_follow_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/global_widget/custom_comment_sheet.dart';
import '../../../../core/global_widget/date_time_helper.dart';
import '../../../../routes/app_routing.dart';
import '../../../home/controller/home_controller.dart';
import '../../../home/presentation/widget/designation_section.dart';
import '../../../home/presentation/widget/donation_sheet.dart';

import '../../../home/presentation/widget/live_indicator_section.dart';
import '../../../home/presentation/widget/nameBadgeSection.dart';
import '../widget/user_interaction_section.dart';

class CloudFundingScreen extends StatelessWidget {
   CloudFundingScreen({super.key});
   final HomeController controller = Get.find();
   final ScheduleController scheduleController = Get.find();
   final RxString replyingToId = ''.obs;
   final RxString replyingToName = ''.obs;


  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        physics: BouncingScrollPhysics(),
        itemCount: scheduleController.crowdFundList.length,
        separatorBuilder: (context,index){

          return Divider();
        },
        shrinkWrap: true,
        itemBuilder: (context,index){
          final crowdFund = scheduleController.crowdFundList[index];
          log("the eventype is ${crowdFund.eventType}");

          final firstName = crowdFund.user.firstName;
          final lastName = crowdFund.user.lastName;

          final userName = "$firstName $lastName";
          final userImage = crowdFund.user.profileImage;
          final designation = crowdFund.user.profession;
          ///final isLive = controller.eventLive[index];
          final timeAgo = DateTimeHelper.getTimeAgo(crowdFund.createdAt.toIso8601String());
          final crowdLike = crowdFund.count.eventLike;
          final crowdComment = crowdFund.count.eventComment;
          final about = crowdFund.text;
          final title = crowdFund.title;
          final eventYpe = crowdFund.eventType;
          final eventId = crowdFund.id;
          final likeStatus = crowdFund.isLiked;
          final isOwner = crowdFund.isOwner;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// live indicator
                  LiveIndicatorSection(
                    onTap: (){
                      Get.toNamed(AppRoute.othersUser, arguments: {"userId":crowdFund.userId});
                    },
                    influencerProfile: userImage??'https://cdn2.psychologytoday.com/assets/styles/manual_crop_1_91_1_1528x800/public/field_blog_entry_images/2018-09/shutterstock_648907024.jpg?itok=7lrLYx-B',),

                  SizedBox(width: 12.w),

                  /// Expanded wrapper to prevent overflow
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// name and badge
                        NameBadgeSection(userName: userName,),
                        SizedBox(height: 4.h),

                        /// designation and hours before live
                        DesignationSection(designation: designation??'',timeAgo: timeAgo,),
                      ],
                    ),
                  ),

                  SizedBox(width: 8.w),

                  /// follow and dot indicator section
                  CrowdFundFollowSection(event: crowdFund,)
                ],
              ),
              SizedBox(height: 16.h,),

              SizedBox(height: 10.h,),

              /// Event Details Section
              CloudFundingDetails(eventDescription: about,title: title, event: crowdFund,),

              SizedBox(height: 10.h,),
              /// like comment and share Section
              UserInteractionSection(
                isOwner: isOwner,
                isLiked: likeStatus,
               eventType: eventYpe,
                onLikeTap: (){
                scheduleController.createLike(eventId);
                },
                onCommentTap: (){
                  showModalBottomSheet(context: context, builder: (BuildContext context){
                    return CommentSheet(scheduleController: scheduleController, eventId: eventId);
                  });
                },
                onTipsTap: (){


                  DonationSheet.show(context,eventId: crowdFund.id);
                },
                likeCount: crowdLike.toString(),commentCount: crowdComment,),
              SizedBox(height: 20.h,),



            ],

          );
        });
  }
}


