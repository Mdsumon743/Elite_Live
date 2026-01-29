import 'dart:developer';

import 'package:elites_live/core/global_widget/custom_snackbar.dart';
import 'package:elites_live/features/profile/controller/following_follwer_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import '../../../../core/global_widget/custom_text_field.dart';
import '../../../../core/global_widget/custom_text_view.dart';
import '../../../../core/services/socket_service.dart';
import '../../../../core/utils/constants/app_colors.dart';
import 'package:get/get.dart';


class AddContributorDialog {
  static void show(
      BuildContext context, {
        required String streamId,
        required String coHostLink,
        required WebSocketClientService webSocketService,
      }) {
    final FollowingFollwerController controller = Get.find();

    // Initialize filteredFollowing with full list if not already done
    if (controller.filteredFollowing.isEmpty) {
      controller.filteredFollowing.assignAll(controller.myFollowing);
    }

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          contentPadding: const EdgeInsets.all(20),
          backgroundColor: Colors.white,
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title Row with Connection Status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Icon(Icons.arrow_back, color: AppColors.textBody, size: 24.sp),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextView(
                            text: "Add Contributor",
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textHeader,
                          ),
                          // Real-time connection status
                          Obx(() {
                            final isConnected = webSocketService.isConnected.value;
                            final isConnecting = webSocketService.isConnecting.value;

                            if (isConnecting) {
                              return Row(
                                children: [
                                  SizedBox(
                                    width: 12.w,
                                    height: 12.h,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation(Colors.orange),
                                    ),
                                  ),
                                  SizedBox(width: 6.w),
                                  CustomTextView(
                                    text: "Connecting...",
                                    fontSize: 12.sp,
                                    color: Colors.orange,
                                  ),
                                ],
                              );
                            }

                            return Row(
                              children: [
                                Container(
                                  width: 8.w,
                                  height: 8.h,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isConnected ? Colors.green : Colors.red,
                                  ),
                                ),
                                SizedBox(width: 6.w),
                                CustomTextView(
                                  text: isConnected ? "Connected" : "Disconnected",
                                  fontSize: 12.sp,
                                  color: isConnected ? Colors.green : Colors.red,
                                ),
                              ],
                            );
                          }),
                        ],
                      ),
                    ),
                    SizedBox(width: 10.w),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Icon(Icons.close, color: AppColors.textBody, size: 24.sp),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Divider(),

                // Search Field
                CustomTextField(
                  hintText: "Search by Name",
                  onChanged: (value) {
                    controller.searchText.value = value;
                  },
                ),
                SizedBox(height: 24.h),

                // Contributors List
                Flexible(
                  child: Obx(() {
                    final followingList = controller.filteredFollowing;
                    final isConnected = webSocketService.isConnected.value;

                    if (followingList.isEmpty) {
                      return Center(
                        child: CustomTextView(
                          text: "No contributors found.",
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textBody,
                        ),
                      );
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: followingList.length,
                      itemBuilder: (context, index) {
                        final following = followingList[index];
                        final firstName = following.user.firstName;
                        final lastName = following.user.lastName;
                        final name = "$firstName $lastName";
                        final receiverId = following.user.id;

                        return Container(
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Avatar + Name
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: following.user.profileImage != null
                                        ? NetworkImage(following.user.profileImage!)
                                        : null,
                                    radius: 24.r,
                                    backgroundColor: AppColors.lightGrey,
                                    child: following.user.profileImage == null
                                        ? Icon(Icons.person, size: 24.sp, color: Colors.white)
                                        : null,
                                  ),
                                  SizedBox(width: 8.w),
                                  CustomTextView(
                                    text: name,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.sp,
                                    color: AppColors.textHeader,
                                  ),
                                ],
                              ),

                              // Add Button - Disabled when not connected
                              GestureDetector(
                                onTap: isConnected
                                    ? () {
                                  _addContributor(
                                    webSocketService: webSocketService,
                                    receiverId: receiverId,
                                    streamId: streamId,
                                    coHostLink: coHostLink,
                                    userName: name,
                                  );
                                }
                                    : null,
                                child: Opacity(
                                  opacity: isConnected ? 1.0 : 0.5,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16.w,
                                      vertical: 10.h,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(40.r),
                                      gradient: LinearGradient(
                                        colors: isConnected
                                            ? [
                                          AppColors.secondaryColor,
                                          AppColors.primaryColor,
                                        ]
                                            : [
                                          Colors.grey.shade400,
                                          Colors.grey.shade500,
                                        ],
                                      ),
                                    ),
                                    child: CustomTextView(
                                      text: isConnected ? "Add" : "Offline",
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.textWhite,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static void _addContributor({
    required WebSocketClientService webSocketService,
    required String receiverId,
    required String streamId,
    required String coHostLink,
    required String userName,
  }) {
    log("🎯 Attempting to add contributor: $userName");
    log("🔍 WebSocket connected: ${webSocketService.isConnected.value}");
    log("🔍 Receiver ID: $receiverId");
    log("🔍 Stream ID: $streamId");

    // Double-check connection status
    if (!webSocketService.isConnected.value) {
      CustomSnackBar.error(title: "Connection Error", message: "WebSocket is not connected. Please try again.");

      log("❌ Cannot add contributor: WebSocket not connected");
      return;
    }

    // Validate required fields
    if (receiverId.isEmpty || streamId.isEmpty) {
      CustomSnackBar.error(title: "Error", message: "Missing required information");


      log("❌ Missing receiverId or streamId");
      return;
    }

    try {
      // Send add-contributor message via WebSocket
      final message = {
        "type": "add-contributor",
        "receiverId": receiverId,
        "streamId": streamId,
        "coHostLink": coHostLink,
      };

      log("📤 Sending message: $message");
      webSocketService.sendMessage(message);

      // Show success feedback
      CustomSnackBar.success(title: "Contributor Added", message: "$userName has been invited to the live stream",);


      log("✅ Contributor added: $userName (ID: $receiverId)");
    } catch (e) {
      CustomSnackBar.error(title: "Error", message: "Failed to add contributor: $e");

      log("❌ Error adding contributor: $e");
    }
  }
}
