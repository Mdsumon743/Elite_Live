import 'package:elites_live/core/global_widget/custom_text_view.dart';
import 'package:elites_live/core/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../controller/notification_controller.dart';
import '../../data/notification_data_model.dart';



class NotificationItem extends StatelessWidget {
  final NotificationResult notification;
  final NotificationController controller;

  const NotificationItem({
    super.key,
    required this.notification,
    required this.controller,
  });

  String _senderFullName() {
    final s = notification.sender;
    if (s == null) return '';
    final first = s.firstName ?? '';
    final last = s.lastName ?? '';
    final full = ('$first $last').trim();
    return full.isEmpty ? '' : full;
  }

  Widget _buildAvatar() {
    final s = notification.sender;
    if (s != null && (s.profileImage != null && s.profileImage!.isNotEmpty)) {
      return CircleAvatar(
        radius: 24.r,
        backgroundImage: NetworkImage(s.profileImage!),
      );
    }

    final name = _senderFullName();
    if (name.isNotEmpty) {
      return CircleAvatar(
        radius: 24.r,
        backgroundColor: AppColors.primaryColor,
        child: Text(
          name[0].toUpperCase(),
          style: TextStyle(color: Colors.white, fontSize: 18.sp),
        ),
      );
    }

    // fallback icon when no sender info
    return CircleAvatar(
      radius: 24.r,
      backgroundColor: Colors.grey.shade300,
      child: Icon(
        Icons.notifications,
        color: Colors.grey.shade700,
        size: 20.sp,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final senderName = _senderFullName();
    final showSender = senderName.isNotEmpty;

    return InkWell(
      onTap: () {
         controller.updateNotificationStatus(notification.id);
        // navigate if required
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        color: notification.isRead ? Colors.white : AppColors.primaryColor.withValues(alpha: 0.1),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAvatar(),
            SizedBox(width: 12.w),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: showSender
                            ? Row(
                          children: [
                            CustomTextView(
                              text: senderName,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textBody,
                            ),
                          ],
                        )
                            : CustomTextView(
                          text: notification.title,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textBody,
                        ),
                      ),
                      Text(
                        controller.getTimeAgo(notification.createdAt),
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),

                  Text(
                    showSender ? notification.body : notification.body,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
