

// lib/features/live/presentation/widget/live_comment_widget.dart

import 'package:elites_live/core/global_widget/custom_loading.dart';
import 'package:elites_live/core/global_widget/custom_text_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:elites_live/core/utils/constants/app_colors.dart';
import '../../../../core/global_widget/custom_snackbar.dart';
import '../../controller/live_comment_controller.dart';
import '../../data/live_comment_data_model.dart';










// lib/features/live/presentation/widget/live_comment_widget.dart

import 'package:elites_live/core/global_widget/custom_loading.dart';
import 'package:elites_live/core/global_widget/custom_text_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:elites_live/core/utils/constants/app_colors.dart';
import '../../../../core/global_widget/custom_snackbar.dart';
import '../../controller/live_comment_controller.dart';
import '../../data/live_comment_data_model.dart';

class LiveCommentWidget extends StatefulWidget {
  final String? eventId;
  final String? streamId; // Make streamId nullable
  final bool isFromEvent;
  final bool isHost;
  final bool isCoHost;

  const LiveCommentWidget({
    super.key,
    this.eventId,
    this.streamId,
    required this.isFromEvent,
    this.isHost = false,
    this.isCoHost = false,
  });

  @override
  State<LiveCommentWidget> createState() => _LiveCommentWidgetState();
}

class _LiveCommentWidgetState extends State<LiveCommentWidget> {
  final LiveCommentController commentController = Get.put(LiveCommentController());
  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initializeComments();
  }

  Future<void> _initializeComments() async {
    try {
      if (widget.isFromEvent && widget.eventId != null) {
        await commentController.initializeForEvent(
          widget.eventId!,
          isHostUser: widget.isHost,
          isCoHostUser: widget.isCoHost,
        );
      } else if (!widget.isFromEvent && widget.streamId != null) {
        await commentController.initializeForFreeLive(
          widget.streamId!,
          isHostUser: widget.isHost,
          isCoHostUser: widget.isCoHost,
        );
      }
    } catch (e) {
      debugPrint("Error initializing comments: $e");
    }
  }

  void _sendComment() {
    final text = textController.text.trim();
    if (text.isEmpty) return;

    commentController.sendComment(text).then((_) {
      textController.clear();
    }).catchError((e) {});
  }

  void _showBanUserMenu(LiveComment comment) {
    if (!widget.isHost && !widget.isCoHost) return;

    final currentUserId = commentController.helper.getString('userId');
    if (currentUserId == comment.userId) {
      CustomSnackBar.warning(
        title: "Not Allowed",
        message: "You cannot ban yourself",
      );
      return;
    }

    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 20.h),
            Row(
              children: [
                CircleAvatar(
                  radius: 24.r,
                  backgroundImage: comment.userImage.isNotEmpty
                      ? NetworkImage(comment.userImage)
                      : null,
                  backgroundColor: AppColors.primaryColor,
                  child: comment.userImage.isEmpty
                      ? Text(
                    comment.userName[0].toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                      : null,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        comment.userName,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        comment.comment,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            InkWell(
              onTap: () {
                Get.back();
                _confirmBanUser(comment);
              },
              child: Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: Colors.red, width: 1.5),
                ),
                child: Row(
                  children: [
                    Icon(Icons.block, color: Colors.red, size: 24.sp),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ban User',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.red,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'Remove user from this stream',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, size: 16.sp, color: Colors.red),
                  ],
                ),
              ),
            ),
            SizedBox(height: 12.h),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Get.back(),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                ),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      isDismissible: true,
      enableDrag: true,
    );
  }

  void _confirmBanUser(LiveComment comment) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 28.sp),
            SizedBox(width: 12.w),
            Text(
              'Ban User?',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to ban ${comment.userName}?',
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
            SizedBox(height: 12.h),
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: Colors.red.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.red, size: 20.sp),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      'This user will be removed from the stream and cannot rejoin.',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.red[700],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey[600],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              // Correctly pass nullable streamId
              commentController.banUser(
                comment.userId,
                comment.userName,
                widget.streamId.toString(),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: Text(
              'Ban User',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    textController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black.withOpacity(0.3),
            Colors.black.withOpacity(0.7),
          ],
        ),
      ),
      child: Column(
        children: [
          Obx(() {
            if (commentController.isConnecting.value) {
              return _buildConnectionStatus(
                icon: Icons.hourglass_empty,
                text: "Connecting to chat...",
                color: Colors.orange,
              );
            } else if (commentController.connectionError.value.isNotEmpty) {
              return _buildConnectionStatus(
                icon: Icons.error_outline,
                text: "Connection failed",
                color: Colors.red,
                showRetry: true,
              );
            } else if (!commentController.isJoined.value) {
              return _buildConnectionStatus(
                icon: Icons.info_outline,
                text: "Not connected to chat",
                color: Colors.grey,
              );
            } else if (commentController.warningCount.value > 0) {
              return _buildWarningBanner();
            }
            return SizedBox.shrink();
          }),
          Expanded(
            child: Obx(() {
              if (commentController.isConnecting.value) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomLoading(color: AppColors.primaryColor),
                      SizedBox(height: 12.h),
                      Text(
                        'Connecting to chat...',
                        style: TextStyle(color: Colors.white70, fontSize: 14.sp),
                      ),
                    ],
                  ),
                );
              }
              if (commentController.connectionError.value.isNotEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, color: Colors.red, size: 48.sp),
                      SizedBox(height: 12.h),
                      Text(
                        'Failed to connect to chat',
                        style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        commentController.connectionError.value,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white70, fontSize: 12.sp),
                      ),
                      SizedBox(height: 16.h),
                      ElevatedButton.icon(
                        onPressed: () => commentController.retryConnection(),
                        icon: Icon(Icons.refresh),
                        label: Text('Retry'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                );
              }
              if (commentController.comments.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.chat_bubble_outline, color: Colors.white54, size: 48.sp),
                      SizedBox(height: 12.h),
                      Text(
                        'No comments yet',
                        style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Be the first to comment!',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white70, fontSize: 14.sp),
                      ),
                    ],
                  ),
                );
              }
              return ListView.builder(
                controller: scrollController,
                reverse: true,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                itemCount: commentController.comments.length,
                itemBuilder: (context, index) {
                  final comment = commentController.comments[index];
                  return _buildCommentItem(comment);
                },
              );
            }),
          ),
          _buildCommentInput(),
        ],
      ),
    );
  }

  Widget _buildConnectionStatus({
    required IconData icon,
    required String text,
    required Color color,
    bool showRetry = false,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      color: color.withOpacity(0.2),
      child: Row(
        children: [
          Icon(icon, color: color, size: 16.sp),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: color, fontSize: 12.sp, fontWeight: FontWeight.w500),
            ),
          ),
          if (showRetry)
            GestureDetector(
              onTap: () => commentController.retryConnection(),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  'Retry',
                  style: TextStyle(color: Colors.white, fontSize: 11.sp, fontWeight: FontWeight.w600),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildWarningBanner() {
    return Obx(() {
      final count = commentController.warningCount.value;
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange.shade700, Colors.red.shade600],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.orange.withOpacity(0.3),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.warning_amber_rounded,
                color: Colors.white,
                size: 18.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Community Guidelines Warning',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    '$count violation${count > 1 ? 's' : ''} detected',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildCommentItem(LiveComment comment) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16.r,
            backgroundImage: comment.userImage.isNotEmpty
                ? NetworkImage(comment.userImage)
                : null,
            backgroundColor: AppColors.primaryColor,
            child: comment.userImage.isEmpty
                ? Text(
              comment.userName[0].toUpperCase(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            )
                : null,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  comment.userName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4.h),
                CustomTextView(
                  text: comment.comment,
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 13.sp,
                ),
              ],
            ),
          ),
          if (widget.isHost || widget.isCoHost)
            GestureDetector(
              onTap: () => _showBanUserMenu(comment),
              child: Container(
                padding: EdgeInsets.all(4.w),
                child: Icon(
                  Icons.more_vert,
                  color: Colors.white.withOpacity(0.7),
                  size: 18.sp,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCommentInput() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        border: Border(
          top: BorderSide(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Obx(() {
          final isDisabled = !commentController.isJoined.value ||
              commentController.isConnecting.value ||
              commentController.isBanned.value;

          final isBanned = commentController.isBanned.value;

          return Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(
                        isBanned ? 0.03 : (isDisabled ? 0.05 : 0.1)),
                    borderRadius: BorderRadius.circular(24.r),
                    border: Border.all(
                      color: isBanned
                          ? Colors.red.withOpacity(0.3)
                          : Colors.white.withOpacity(isDisabled ? 0.1 : 0.2),
                      width: 1,
                    ),
                  ),
                  child: TextField(
                    controller: textController,
                    enabled: !isDisabled,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                    ),
                    decoration: InputDecoration(
                      hintText: isBanned
                          ? 'You are banned from commenting'
                          : (isDisabled ? 'Connecting...' : 'Add a comment...'),
                      hintStyle: TextStyle(
                        color: isBanned
                            ? Colors.red.withOpacity(0.6)
                            : Colors.white.withOpacity(0.5),
                        fontSize: 14.sp,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 10.h,
                      ),
                    ),
                    maxLines: 1,
                    textInputAction: TextInputAction.send,
                    onSubmitted: isDisabled ? null : (_) => _sendComment(),
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              GestureDetector(
                onTap: (commentController.isSending.value || isDisabled)
                    ? null
                    : _sendComment,
                child: Container(
                  width: 44.w,
                  height: 44.h,
                  decoration: BoxDecoration(
                    gradient: (commentController.isSending.value || isDisabled)
                        ? LinearGradient(colors: [Colors.grey, Colors.grey.shade700])
                        : LinearGradient(colors: [
                      AppColors.primaryColor,
                      AppColors.secondaryColor,
                    ]),
                    shape: BoxShape.circle,
                    boxShadow: isDisabled
                        ? []
                        : [
                      BoxShadow(
                        color: AppColors.primaryColor.withOpacity(0.3),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: commentController.isSending.value
                      ? Center(
                    child: SizedBox(
                      width: 18.w,
                      height: 18.h,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    ),
                  )
                      : Icon(
                    isBanned ? Icons.block : Icons.send,
                    color: Colors.white,
                    size: 20.sp,
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

