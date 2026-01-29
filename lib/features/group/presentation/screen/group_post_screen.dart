import 'dart:developer';
import 'package:elites_live/core/global_widget/custom_loading.dart';
import 'package:elites_live/core/global_widget/custom_snackbar.dart';
import 'package:elites_live/features/profile/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../../core/global_widget/custom_elevated_button.dart';
import '../../../../core/global_widget/custom_text_field.dart';
import '../../../../core/global_widget/custom_text_view.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/image_path.dart';
import '../../../../routes/app_routing.dart';
import '../../../home/controller/home_controller.dart';
import '../../controller/group_post_controller.dart';
import '../../data/group_info_data_model.dart';
import '../widget/gradient_button.dart';
import '../widget/group_post_details_screen.dart';

class GroupPostScreen extends StatelessWidget {
  GroupPostScreen({super.key});

  final HomeController controller = Get.find<HomeController>();
  final RxString replyingToId = ''.obs;
  final RxString replyingToName = ''.obs;
  final String groupId = Get.arguments['groupId'];
  final GroupPostController groupPostController = Get.find<GroupPostController>();
  final ProfileController profileController = Get.find();

  @override
  Widget build(BuildContext context) {
    // Fetch group info when screen loads
    Future.microtask(() => groupPostController.getGroupInfo(groupId));

    log("the Group id is***** $groupId");

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Column(
        children: [
          /// Gradient Header
          _buildHeader(context),

          /// Content - Use Obx to display API data
          Expanded(
            child: Obx(() {
              if (groupPostController.isLoading.value) {
                return CustomLoading(color: AppColors.primaryColor);
              }

              if (groupPostController.groupInfo.value == null) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 48.sp, color: Colors.red),
                        SizedBox(height: 16.h),
                        CustomTextView(
                          text: "Failed to load group info",
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textBody,
                        ),
                        SizedBox(height: 16.h),
                        ElevatedButton(
                          onPressed: () => groupPostController.getGroupInfo(groupId),
                          child: Text("Retry"),
                        ),
                      ],
                    ),
                  ),
                );
              }

              final groupData = groupPostController.groupInfo.value!;
              return _buildContent(context, groupData);
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, GroupInfoResult groupData) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Group Image
            CircleAvatar(
              radius: 50.r,
              backgroundImage: (groupData.photo.isNotEmpty)
                  ? NetworkImage(groupData.photo)
                  : const AssetImage(ImagePath.dance),
            ),


            SizedBox(height: 7.h),

            // Group Name and Leave Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CustomTextView(
                    text: groupData.groupName,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textHeader,
                  ),
                ),
                GradientButton(
                  title: "Leave Group",
                  onTap: () => _showLeaveConfirmation(context),
                ),
              ],
            ),
            SizedBox(height: 24.h),

            // Group Description
            CustomTextView(
              text: groupData.description,
              fontWeight: FontWeight.w400,
              fontSize: 14.sp,
              color: AppColors.textBody,
            ),
            SizedBox(height: 24.h),

            // Create Post Input
            Row(
              children: [
                CircleAvatar(
                  backgroundImage:
                  (profileController.userinfo.value?.profileImage != null &&
                      profileController.userinfo.value!.profileImage!.isNotEmpty)
                      ? NetworkImage(profileController.userinfo.value!.profileImage!)
                      : const AssetImage(ImagePath.dance),
                ),

                SizedBox(width: 12.w),
                Expanded(
                  child: GestureDetector(
                    onTap: () => Get.toNamed(AppRoute.createPost, arguments: {
                      'groupId': groupId,
                    }),
                    child: AbsorbPointer(
                      absorbing: true,
                      child: CustomTextField(
                        hintText: "Write something",
                        isReadonly: true,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),

            /// Post Section - Only show if there are posts
            if (groupData.groupPost.isNotEmpty)
              GroupPostDetailsSection(
                groupId: groupData.groupPost.first.id,
                replyingToId: replyingToId,
                replyingToName: replyingToName,
                controller: controller,
                groupPosts: groupData.groupPost,
              )
            else
            // Show empty state when no posts
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 40.h),
                  child: Column(
                    children: [
                      Icon(
                        Icons.post_add,
                        size: 64.sp,
                        color: Colors.grey[400],
                      ),
                      SizedBox(height: 16.h),
                      CustomTextView(
                        text: "No posts yet",
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600]!,
                      ),
                      SizedBox(height: 8.h),
                      CustomTextView(
                        text: "Be the first to create a post in this group",
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[500]!,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => Get.back(),
                child: Icon(Icons.arrow_back, color: Colors.white, size: 24.sp),
              ),
              CustomTextView(
                text: "Group Post",
                fontWeight: FontWeight.w600,
                fontSize: 20.sp,
                color: AppColors.white,
              ),
              _buildPopupMenu(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPopupMenu(BuildContext context) {
    return PopupMenuButton<int>(
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      color: Colors.white,
      elevation: 4,
      position: PopupMenuPosition.under,
      icon: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(100.r),
          border: Border.all(width: 1.5, color: AppColors.white),
        ),
        child: Icon(
          Icons.more_vert,
          size: 22.sp,
          color: const Color(0xFF6B7280),
        ),
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          child: Row(
            children: [
              SizedBox(width: 10.w),
              CustomTextView(
                text: "Edit",
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
              SizedBox(width: 10.w),
              CustomTextView(
                text: "Delete",
                fontWeight: FontWeight.w500,
                fontSize: 14.sp,
                color: AppColors.textHeader,
              ),
            ],
          ),
        ),
      ],
      onSelected: (value) {
        switch (value) {
          case 1:
            final groupData = groupPostController.groupInfo.value;
            if (groupData != null) {
              _showEditGroupBottomSheet(context, groupData, groupId);
            }
            break;
          case 2:
            _showDeleteBottomSheet(context, groupId);
            break;
        }
      },
    );
  }

  void _showLeaveConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100.r),
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF591AD4).withValues(alpha: 0.1),
                      AppColors.primaryColor.withValues(alpha: 0.1),
                    ],
                  ),
                ),
                child: ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [Color(0xFF591AD4), AppColors.primaryColor],
                  ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                  child: Icon(
                    FontAwesomeIcons.check,
                    size: 33.h,
                    color: Colors.white,
                  ),
                ),
              ),
              CustomTextView(
                text: "Leave Group",
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textHeader,
              ),
            ],
          ),
          content: CustomTextView(
            text: "Are you sure you want to leave group?",
            fontWeight: FontWeight.w500,
            fontSize: 14.sp,
            color: AppColors.textBody,
            textAlign: TextAlign.center,
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: CustomElevatedButton(
                    ontap: () => Get.back(),
                    text: "Cancel",
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: CustomElevatedButton(
                    ontap: () {
                      groupPostController.leaveGroup(groupId);
                      Get.back();
                    },
                    text: "Leave",
                    backgroundColor: AppColors.white,
                    textColor: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _showDeleteBottomSheet(BuildContext context, String groupId) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 20.h),

            // Title with close button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomTextView(
                  text: 'Delete Group',
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textHeader,
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: Icon(Icons.close, color: Colors.grey[600]),
                ),
              ],
            ),
            SizedBox(height: 24.h),

            // Warning Icon
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.delete_outline,
                size: 48.sp,
                color: Colors.red,
              ),
            ),
            SizedBox(height: 24.h),

            // Confirmation message
            CustomTextView(
              text: 'Are you sure you want to delete this group?',
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.textBody,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),

            CustomTextView(
              text: 'This action cannot be undone.',
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: Colors.red,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32.h),

            // Action Buttons
            Row(
              children: [
                // Cancel Button
                Expanded(
                  child: CustomElevatedButton(
                    ontap: () => Get.back(),
                    text: "Cancel",
                    backgroundColor: Colors.grey[200]!,
                    textColor: AppColors.textHeader,
                  ),
                ),
                SizedBox(width: 12.w),

                // Delete Button
                Expanded(
                  child: Obx(
                        () => CustomElevatedButton(
                      ontap: groupPostController.isLoading.value
                          ? () {}
                          : () => _handleDelete(groupPostController, groupId),
                      text: groupPostController.isLoading.value
                          ? "Deleting..."
                          : "Delete",
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
    );
  }

  // Add this handler method for delete action
  Future<void> _handleDelete(
      GroupPostController groupPostController, String groupId) async {
    await groupPostController.deleteGroup(groupId);

    // Close bottom sheet after successful deletion
    if (Get.isBottomSheetOpen ?? false) {
      Get.back();
    }

    // Navigate back to previous screen
    Get.back();
  }

  void _showEditGroupBottomSheet(
      BuildContext context, GroupInfoResult groupData, String groupId) {
    groupPostController.groupNameController.text = groupData.groupName;
    groupPostController.descriptionController.text = groupData.description;
    groupPostController.isPublic.value = true;
    groupPostController.selectedImage.value = null;

    Get.bottomSheet(
      Container(
        height: MediaQuery.of(context).size.height * 0.85,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 20.h),

            // Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomTextView(
                  text: 'Edit Group',
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textHeader,
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: Icon(Icons.close, color: Colors.grey[600]),
                ),
              ],
            ),
            SizedBox(height: 24.h),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Group Image
                    Center(
                      child: Stack(
                        children: [
                          Obx(() {
                            return CircleAvatar(
                              radius: 60.r,
                              backgroundImage: groupPostController.selectedImage.value != null
                                  ? FileImage(groupPostController.selectedImage.value!)
                                  : ((groupData.photo.isNotEmpty)
                                  ? NetworkImage(groupData.photo)
                                  : const AssetImage(ImagePath.dance)),

                            );
                          }),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () =>
                                  groupPostController.showImagePickerBottomSheet(),
                              child: Container(
                                padding: EdgeInsets.all(8.w),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
                                  ),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 2),
                                ),
                                child: Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 20.sp,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // Group Name
                    CustomTextView(
                      text: 'Group Name',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textHeader,
                    ),
                    SizedBox(height: 8.h),
                    CustomTextField(
                      controller: groupPostController.groupNameController,
                      hintText: "Enter group name",
                    ),
                    SizedBox(height: 16.h),

                    // Group Description
                    CustomTextView(
                      text: 'Description',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textHeader,
                    ),
                    SizedBox(height: 8.h),
                    CustomTextField(
                      controller: groupPostController.descriptionController,
                      hintText: "Enter group description",
                      maxLines: 4,
                    ),
                    SizedBox(height: 16.h),

                    // Privacy Switch
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextView(
                              text: 'Public Group',
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textHeader,
                            ),
                            SizedBox(height: 4.h),
                            CustomTextView(
                              text: 'Anyone can join this group',
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textBody,
                            ),
                          ],
                        ),
                        Obx(
                              () => Switch(
                            value: groupPostController.isPublic.value,
                            onChanged: (value) {
                              groupPostController.isPublic.value = value;
                            },
                            activeThumbColor: Color(0xFF8E2DE2),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),

            // ACTION BUTTONS
            Row(
              children: [
                // CANCEL
                Expanded(
                  child: CustomElevatedButton(
                    ontap: () {
                      groupPostController.groupNameController.clear();
                      groupPostController.descriptionController.clear();
                      groupPostController.selectedImage.value = null;
                      Get.back();
                    },
                    text: "Cancel",
                    backgroundColor: Colors.grey[200]!,
                    textColor: AppColors.textHeader,
                  ),
                ),
                SizedBox(width: 12.w),

                // CONFIRM
                Expanded(
                  child: Obx(
                        () => CustomElevatedButton(
                      ontap: groupPostController.isLoading.value
                          ? () {}
                          : () => _handleConfirm(groupPostController, groupId),
                      text: groupPostController.isLoading.value
                          ? "Please wait..."
                          : "Confirm",
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
    );
  }

  Future<void> _handleConfirm(
      GroupPostController groupPostController, String groupId) async {
    if (groupPostController.groupNameController.text.trim().isEmpty) {
      CustomSnackBar.warning(title: "Error", message: "Please enter group name");

      return;
    }

    if (groupPostController.descriptionController.text.trim().isEmpty) {
      CustomSnackBar.error(title: "Error", message: "Please enter Description");
      return;
    }

    await groupPostController.updateGroup(groupId);
    await groupPostController.getGroupInfo(groupId);
  }
}