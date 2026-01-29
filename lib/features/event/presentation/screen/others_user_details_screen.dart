import 'dart:developer';
import 'package:elites_live/core/global_widget/custom_loading.dart';
import 'package:elites_live/core/global_widget/custom_text_view.dart';
import 'package:elites_live/core/utils/constants/app_colors.dart';
import 'package:elites_live/features/event/controller/event_controller.dart';
import 'package:elites_live/features/event/controller/schedule_controller.dart';
import 'package:elites_live/features/event/presentation/screen/recorde_live_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';


import 'others_user_schedule_event_screen.dart';


class OthersUserDetailsScreen extends StatelessWidget {
  OthersUserDetailsScreen({super.key});
  final ScheduleController controller = Get.find();
  final userId = Get.arguments['userId'];
  final EventController eventController = Get.find();

  @override
  Widget build(BuildContext context) {
    Future.microtask(() => controller.getSingleUser(userId));
    log("the user id is $userId");

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: const Color(0xFF7C3AED),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Get.back(),
          ),
          title: Obx(() {
            if (controller.othersUserInfo.isEmpty) {
              return const CustomTextView(text: 'Loading...',
                  color: Colors.white);
            }
            final user = controller.othersUserInfo[0];
            return CustomTextView(text: '${user.firstName} ${user.lastName}',
                color: Colors.white, fontSize: 18.sp);
          }),
          centerTitle: false,
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return  Center(child: CustomLoading(color: AppColors.primaryColor,));
          }

          if (controller.othersUserInfo.isEmpty) {
            return const Center(child: CustomTextView(text: 'No user data found'));
          }

          final user = controller.othersUserInfo[0];

          return Column(
            children: [
              // Purple Header Section
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFF7C3AED),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    // Profile Image with Online Indicator
                    Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                          ),
                          child: CircleAvatar(
                            radius: 50.r,
                            backgroundImage: user.profileImage != null
                                ? NetworkImage(user.profileImage)
                                : null,
                            backgroundColor: Colors.grey[300],
                            child: user.profileImage == null
                                ? Text(
                              user.firstName[0],
                              style:  TextStyle(
                                  fontSize: 32.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textHeader),
                            )
                                : null,
                          ),
                        ),
                        Positioned(
                          right: 5,
                          bottom: 5,
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Name
                    Text(
                      '${user.firstName} ${user.lastName}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Profession
                    Text(
                      user.profession ?? 'No profession',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Stats Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [

                        _buildStatColumn(
                            user.followingCount.toString(), 'Following'),
                        Container(
                          width: 1.w,
                          height: 30.h,
                          color: Colors.white.withValues(alpha: 0.3),
                        ),
                        _buildStatColumn(
                            user.followersCount.toString(), 'Followers'),

                        _buildStatColumn(user.count.event.toString(), 'Posts'),
                        Container(
                          width: 1.w,
                          height: 30.h,
                          color: Colors.white.withValues(alpha: 0.3),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Follow Button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () {
                            log("Follow button pressed");
                            eventController.followUnFlow(userId);
                           /// controller.toggleFollow(userId);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF7C3AED),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            user.isFollow ? 'Unfollow' : 'Follow',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
              // Tabs
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.1),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TabBar(
                  indicatorColor: const Color(0xFF7C3AED),
                  indicatorWeight: 3,
                  labelColor: const Color(0xFF7C3AED),
                  unselectedLabelColor: Colors.grey,
                  tabs: const [
                    Tab(icon: Icon(Icons.grid_on)),
                    Tab(icon: Icon(Icons.calendar_today)),

                  ],
                ),
              ),
              // Tab Content
              Expanded(
                child: TabBarView(
                  children: [
                    // Grid Tab - Photos/Videos
                    RecordedLiveSession(userId: userId),
                    // Calendar Tab
                    OthersUserScheduleEventScreen(userId: user.id,),
                    // Profile Tab

                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildStatColumn(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.9),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildGridView() {
    // Placeholder images - Replace with actual data
    return GridView.builder(
      padding: const EdgeInsets.all(2),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
        childAspectRatio: 0.7,
      ),
      itemCount: 12, // Replace with actual count
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Icon(Icons.image, size: 40, color: Colors.grey[400]),
          ),
        );
      },
    );
  }




}