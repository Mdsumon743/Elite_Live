import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../../core/global_widget/custom_text_view.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/image_path.dart';
import '../../../home/controller/home_controller.dart';
import '../../../home/data/comment_data_model.dart';
import '../../../home/presentation/widget/comment_input_box.dart';
import '../../../home/presentation/widget/share_sheet.dart';


class GroupPostSection extends StatelessWidget {
  const  GroupPostSection({
    super.key,
    required this.replyingToId,
    required this.replyingToName,
    required this.controller,
    this.onTap,
  });

  final RxString replyingToId;
  final RxString replyingToName;
  final HomeController controller;
  final VoidCallback? onTap;



  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13.r),
        border: Border.all(width: 1.w, color: Color(0xFFEDEEF4)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage(ImagePath.dance),
                radius: 20.r,
              ),
              SizedBox(width: 7.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextView(
                    text:     "Dance Club",
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textHeader,
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      CustomTextView(
                         text:    "April 06, 2025",
                        fontWeight: FontWeight.w400,
                        fontSize: 10.sp,
                        color: AppColors.textBody,
                      ),
                      SizedBox(width: 4.w),
                      Image.asset(
                        ImagePath.dotIndicator,
                        height: 10.h,
                        width: 10.w,
                      ),
                      SizedBox(width: 4.w),
                      CustomTextView(
                        text:     "6:20 pm",
                        fontWeight: FontWeight.w400,
                        fontSize: 10.sp,
                        color: AppColors.textBody,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 24.h),
          CustomTextView(
            text:     "Join us for a special live stream where 🎶 Arif will be performing his favorite acoustic covers and interacting with fans in real time! Don’t miss the chance to request your song live and send virtual gifts.",
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.textBody,
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.favorite_outline),
                  SizedBox(width: 4.w),
                  CustomTextView(  text:   "4.5M",
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                      color: AppColors.textHeader),
                ],
              ),
              Row(
                children: [
                  Icon(FontAwesomeIcons.comment),
                  SizedBox(width: 4.w),
                  CustomTextView(  text:   "25.2k",
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                      color: AppColors.textHeader),
                ],
              ),
              GestureDetector(
                onTap: () {
                  ShareSheet().show(context);
                },
                child: Row(
                  children: [
                    Icon(FontAwesomeIcons.share),
                    SizedBox(width: 4.w),
                    CustomTextView(  text:   "Share",
                        fontWeight: FontWeight.w500,
                        fontSize: 14.sp,
                        color: AppColors.textHeader),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Obx(() => replyingToId.value.isNotEmpty
              ? Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Replying to ${replyingToName.value}",
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    replyingToId.value = '';
                    replyingToName.value = '';
                  },
                )
              ],
            ),
          )
              : SizedBox.shrink()),
          Obx(() => ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: controller.comments.length,
            itemBuilder: (context, index) {
              final comment = controller.comments[index];
              return _buildCommentTile(comment, replyingToId, replyingToName, controller);
            },
          )),
          SizedBox(height: 10.h),
          CommentInputBox(
            onTap: (){
             onTap!();
            },
          ),
        ],
      ),
    );
  }
}

/// Helper: Build Comment Tile
Widget _buildCommentTile(
    Comment comment,
    RxString replyingToId,
    RxString replyingToName,
    HomeController controller,
    ) {
  return GestureDetector(
    onTap: () {

      replyingToId.value = comment.id;
      replyingToName.value = comment.userName;
    },
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(comment.userImage),
            radius: 20.r,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextView(
                   text:    comment.userName,
                  fontWeight: FontWeight.w600,
                  fontSize: 12.sp,
                  color: AppColors.textHeader,
                ),
                SizedBox(height: 4.h),
                if (comment.text.isNotEmpty)
                  CustomTextView(
                   text:      comment.text,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textBody,
                  ),
                if (comment.imagePath != null)
                  Padding(
                    padding: EdgeInsets.only(top: 8.h),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: Image.file(
                        File(comment.imagePath!),
                        height: 120.h,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    CustomTextView(
                      text:     _getTimeAgo(comment.timestamp),
                      fontWeight: FontWeight.w400,
                      fontSize: 10.sp,
                      color: AppColors.textHeader,
                    ),
                    SizedBox(width: 16.w),
                    GestureDetector(
                      onTap: () => controller.toggleLike(comment.id),
                      child: CustomTextView(
                   text:          comment.isLiked.value ? "Liked" : "Like",
                        color: AppColors.textHeader,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    GestureDetector(
                      onTap: () {
                        replyingToId.value = comment.id;
                        replyingToName.value = comment.userName;
                      },
                      child: CustomTextView(
                        text:     "Reply",
                        color: AppColors.textHeader,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

/// Time Ago Formatter
String _getTimeAgo(DateTime timestamp) {
  final Duration diff = DateTime.now().difference(timestamp);

  if (diff.inMinutes < 1) return 'Just now';
  if (diff.inMinutes < 60) return '${diff.inMinutes}m';
  if (diff.inHours < 24) return '${diff.inHours}h';
  if (diff.inDays < 7) return '${diff.inDays}d';
  return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
}