
import 'dart:developer';
import 'package:elites_live/features/group/controller/invite_group_controller.dart';
import 'package:elites_live/features/group/presentation/widget/user_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/global_widget/custom_text_field.dart';
import '../../../../core/global_widget/custom_text_view.dart';
import '../../../../core/utils/constants/app_colors.dart';


class InvitePeopleScreen extends StatelessWidget {
  InvitePeopleScreen({super.key});

  final InviteGroupController controller = Get.find();
  final groupId = Get.arguments['groupId'];

  @override
  Widget build(BuildContext context) {
    log("the group id is $groupId");
    // Load all users initially
    Future.microtask(() => controller.getUserInviteGroup(groupId));

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Column(
        children: [
          /// Gradient Header
          Container(
            height: 130.h,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Icon(Icons.arrow_back, color: Colors.white, size: 24.sp),
                    ),
                    SizedBox(width: 12.w),
                    CustomTextView(
                      text: "Invite People",
                      fontWeight: FontWeight.w600,
                      fontSize: 20.sp,
                      color: AppColors.white,
                    )
                  ],
                ),
              ),
            ),
          ),

          /// White Card Container
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
              ),
              child: Column(
                children: [
                  /// Search Bar with onSubmitted
                  CustomTextField(
                    controller: controller.nameController,
                    hintText: "Search by Name",
                    textInputAction: TextInputAction.search,
                    onSubmitted: (value) {

                      log("🔍 Search submitted with value: $value");
                      if (value.trim().isEmpty) {

                        controller.getUserInviteGroup(groupId);
                      } else {

                        controller.searchPeople(groupId, value.trim());
                      }
                    },

                  ),
                  SizedBox(height: 16.h),

                  /// Group List with Obx
                  Expanded(
                    child: Obx(() {
                      // Show loading state
                      if (controller.isLoading.value) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(height: 16.h),
                              Text('Loading users...'),
                            ],
                          ),
                        );
                      }

                      // Show error state
                      if (controller.errorMessage.value.isNotEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.error_outline, size: 48.sp, color: Colors.red),
                              SizedBox(height: 16.h),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 32.w),
                                child: Text(
                                  controller.errorMessage.value,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              SizedBox(height: 16.h),
                              ElevatedButton(
                                onPressed: () {
                                  if (controller.nameController.text.trim().isEmpty) {
                                    controller.retry(groupId);
                                  } else {
                                    controller.searchPeople(
                                      groupId,
                                      controller.nameController.text.trim(),
                                    );
                                  }
                                },
                                child: Text('Retry'),
                              ),
                            ],
                          ),
                        );
                      }

                      // Get user result
                      final userResult = controller.groupUserResult.value;

                      // Show empty state
                      if (userResult == null || userResult.users.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.people_outline, size: 48.sp, color: Colors.grey),
                              SizedBox(height: 16.h),
                              Text(
                                controller.nameController.text.trim().isEmpty
                                    ? 'No users available'
                                    : 'No users found for "${controller.nameController.text}"',
                                style: TextStyle(color: Colors.grey),
                                textAlign: TextAlign.center,
                              ),
                              if (controller.nameController.text.trim().isNotEmpty) ...[
                                SizedBox(height: 16.h),
                                TextButton(
                                  onPressed: () {
                                    controller.nameController.clear();
                                    controller.getUserInviteGroup(groupId);
                                  },
                                  child: Text('Clear search'),
                                ),
                              ],
                            ],
                          ),
                        );
                      }

                      // Display users list
                      return ListView.builder(
                        itemCount: userResult.users.length,
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          final user = userResult.users[index];
                          final userName = "${user.firstName} ${user.lastName}";
                          final userProfession = user.profession ?? 'N/A';
                          final profileImage = user.profileImage ??
                              'https://cdn2.psychologytoday.com/assets/styles/manual_crop_1_91_1_1528x800/public/field_blog_entry_images/2018-09/shutterstock_648907024.jpg?itok=7lrLYx-B';

                          return UserSection(
                            onTap: (){
                              controller.inviteGroup(groupId, user.id);
                            },
                            groupName: userName,
                            groupImage: profileImage,
                            userProfession: userProfession,
                            userId: user.id,
                            profileImage: user.profileImage,
                          );
                        },
                      );
                    }),
                  ),

                  SizedBox(height: 16.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}