import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/global_widget/custom_text_field.dart';
import '../../../../core/global_widget/custom_text_view.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../controller/group_post_controller.dart';


class CreatePostScreen extends StatelessWidget {
   CreatePostScreen({super.key});

   final String groupId = Get.arguments['groupId'];

   final GroupPostController controller = Get.find();


  @override
  Widget build(BuildContext context) {
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
                      onTap: () {
                        Get.back();
                      },
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 24.sp,
                      ),
                    ),
                    CustomTextView(
                     text:      "Post Text",
                      fontWeight: FontWeight.w600,
                      fontSize: 20.sp,
                      color: AppColors.white,
                    ),
                    Container(padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100.r),
                        color: AppColors.white,
                        border: Border.all(width: 1.5, color: AppColors.white),
                      ),
                      child: GestureDetector(
                        onTap: (){
                          log("the api calling is loading");
                          controller.createGroupPost(groupId);
                        },
                          child: CustomTextView(  text:   "Post")),
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
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    CustomTextField(
                      controller: controller.contentController,
                      hintText: "Write something here",maxLines: 10,)

                    /// post section


                    /// Comments Section
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
