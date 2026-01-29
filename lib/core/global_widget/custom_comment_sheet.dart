import 'package:elites_live/core/global_widget/custom_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../features/event/controller/schedule_controller.dart';
import '../../features/event/data/event_comment_data_model.dart';
import '../utils/constants/app_colors.dart';
import 'custom_elevated_button.dart';
import 'custom_text_field.dart';
import 'custom_text_view.dart';
import 'date_time_helper.dart';

class CommentSheet extends StatefulWidget {
  final ScheduleController scheduleController;
  final String eventId;

  const CommentSheet({
    super.key,
    required this.scheduleController,
    required this.eventId,
  });

  @override
  State<CommentSheet> createState() => _CommentSheetState();
}

class _CommentSheetState extends State<CommentSheet> {
  @override
  void initState() {
    super.initState();
    // ✅ Call getComment only once when the widget is first created
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.scheduleController.getComment(widget.eventId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (widget.scheduleController.isLoading.value) {
        return Center(child: CustomLoading(color: AppColors.primaryColor));
      }

      final comments = widget.scheduleController.commentList;

      return Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "Comments",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 20),

              // ✅ If no comments, show comment input
              if (comments.isEmpty) ...[
                CustomTextView(
                  text: "Write a comment:",
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                CustomTextField(
                  controller: widget.scheduleController.commentController,
                  maxLines: 3,
                  hintText: "Write your comment...",
                ),
                const SizedBox(height: 10),
                CustomElevatedButton(
                  ontap: () {
                    widget.scheduleController.createComment(widget.eventId);
                  },
                  text: "Create",
                ),
              ],

              // ✅ Show comments and replies
              if (comments.isNotEmpty)
                ...comments.map(
                      (c) => _buildCommentTile(c, widget.scheduleController, widget.eventId),
                ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildCommentTile(
      EventComment comment,
      ScheduleController controller,
      String eventId,
      ) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Comment + user
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(comment.user.profileImage),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextView(
                      text: "${comment.user.firstName} ${comment.user.lastName}",
                      fontWeight: FontWeight.w500,
                      color: AppColors.textHeader,
                      fontSize: 14.sp,
                    ),
                    CustomTextView(
                      text: comment.comment,
                      fontWeight: FontWeight.w500,
                      fontSize: 12.sp,
                      color: AppColors.textBody,
                    ),
                    CustomTextView(
                      text: DateTimeHelper.getTimeAgo(comment.createdAt.toString()),
                      color: AppColors.textBody,
                      fontSize: 12.sp,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // 🔹 Replies
          ...comment.replyComment.map(
                (r) => Container(
              margin: const EdgeInsets.only(left: 50, top: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundImage: NetworkImage(r.user.profileImage),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextView(
                          text: "${r.user.firstName} ${r.user.lastName}",
                          fontWeight: FontWeight.w500,
                          fontSize: 13.sp,
                          color: AppColors.textHeader,
                        ),
                        CustomTextView(text: r.replyComment),
                        CustomTextView(
                          text: DateTimeHelper.getTimeAgo(r.createdAt.toString()),
                          color: AppColors.textBody,
                          fontSize: 11.sp,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 10.h),

          // 🔹 Reply input
          Container(
            margin: EdgeInsets.only(left: 40.w),
            child: Column(
              children: [
                CustomTextField(
                  controller: controller.replyController,
                  hintText: "Write a reply...",
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => controller.createReply(comment.id),
                    child: CustomTextView(
                      text: "Reply",
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textBody,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}