import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/global_widget/custom_text_field.dart';
import '../../../../core/global_widget/custom_text_view.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../routes/app_routing.dart';
import '../../controller/group_controller.dart';
import '../widget/group_section.dart';

class DiscoverGroup extends StatelessWidget {
  const DiscoverGroup({super.key});

  @override
  Widget build(BuildContext context) {
    final GroupController controller = Get.find();
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
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: (){
                        Get.back();
                      },
                        child: Icon(Icons.arrow_back, color: Colors.white, size: 24.sp)),
                    SizedBox(width: 12.w),
                    CustomTextView(
                     text:      "Discover Group",
                      fontWeight: FontWeight.w600,
                      fontSize: 20.sp,
                      color: AppColors.white,
                    ),

                    PopupMenuButton<int>(
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      color: Colors.white,
                      elevation: 4,
                      position: PopupMenuPosition.under,
                      icon: Container(
                        ///padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),


                        decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(100.r),
                            border: Border.all(
                                width: 1.5,
                                color: AppColors.white
                            )

                        ),
                        child: Icon(
                          Icons.more_vert,
                          size: 22.sp,
                          color: const Color(0xFF6B7280),
                        ),
                      ),
                      itemBuilder: (context) {
                        List<PopupMenuEntry<int>> items = [];



                        items.addAll([
                          PopupMenuItem(
                            value: 1,
                            child: Row(
                              children: [

                                SizedBox(width: 10.w),
                                CustomTextView(  text:   "Edit", fontWeight: FontWeight.w500, fontSize: 14.sp, color: AppColors.textHeader),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 2,
                            child: Row(
                              children: [

                                SizedBox(width: 10.w),
                                CustomTextView(  text:   "Delete", fontWeight: FontWeight.w500, fontSize: 14.sp, color: AppColors.textHeader),
                              ],
                            ),
                          ),
                        ]);

                        return items;
                      },
                      onSelected: (value) {
                        switch (value) {
                          case 0:
                            log("User clicked Unfollow");
                            // Unfollow logic:
                            // controller.isFollow[index] = false;
                            // controller.update(); // if using GetX
                            break;
                          case 1:
                            log("User clicked Not Interested");
                            break;
                          case 2:
                            log("User clicked Report Channel");
                            break;
                        }
                      },
                    ),
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
                  /// Search Bar
                  CustomTextField(
                    onChanged: (value) {
                      controller.searchTermController.text = value;
                    },
                    onSubmitted: (value) {
                      controller.searchGroup(value.trim());
                    },
                    hintText: "Search by Group",
                  ),

                  SizedBox(height: 16.h),

                  /// Group List
                  Obx(()=>
                    Expanded(
                      child: ListView.builder(
                        itemCount: controller.discoverGroupList.length,
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          final group = controller.discoverGroupList[index];
                          final groupName = group.groupName;
                          final groupMember = group.count.groupMember;
                          final groupImage = group.photo;

                          return GestureDetector(
                            onTap: (){
                              Get.toNamed(AppRoute.groupPost, arguments: {'groupId': group.id});
                            },
                            child: GroupSection(
                              onTap: (){
                                controller.joinGroup(group.id);
                              },
                              buttonText: "Join Now",
                              groupName: groupName,
                              groupMember: groupMember.toString(),
                              groupImage: groupImage,
                              groupStaus: false,
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  SizedBox(height: 16.h),

                  /// Bottom Buttons

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
