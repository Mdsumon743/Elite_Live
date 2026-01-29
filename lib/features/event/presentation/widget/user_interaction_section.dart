
import 'package:elites_live/core/global_widget/custom_text_view.dart';
import 'package:elites_live/core/utils/constants/app_colors.dart';
import 'package:elites_live/features/home/presentation/widget/share_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class UserInteractionSection extends StatelessWidget {
  final String eventType;        // <-- NEW
  final bool isOwner;            // existing
  final bool isLiked;
  final String likeCount;
  final int commentCount;
  final VoidCallback? onLikeTap;
  final VoidCallback? onCommentTap;
  final VoidCallback? onTipsTap;

  const UserInteractionSection({
    super.key,
    required this.eventType,
    required this.isOwner,
    required this.likeCount,
    required this.commentCount,
    this.onLikeTap,
    required this.isLiked,
    this.onCommentTap,
    this.onTipsTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool showTips = (!isOwner && eventType == "Funding");

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        /// LIKE
        Row(
          children: [
            GestureDetector(
              onTap: onLikeTap,
              child: Icon(
                Icons.favorite,
                color: isLiked ? AppColors.primaryColor : Colors.grey.withValues(alpha: 0.3),
              ),
            ),
            SizedBox(width: 4.w),
            CustomTextView(text: likeCount),
          ],
        ),

        /// COMMENT
        Row(
          children: [
            GestureDetector(
              onTap: onCommentTap,
              child: Icon(Icons.comment),
            ),
            SizedBox(width: 4.w),
            CustomTextView(text: commentCount.toString()),
          ],
        ),

        /// SHARE
        Row(
          children: [
            GestureDetector(
                onTap: () => ShareSheet().show(context),
                child: Icon(Icons.share)),
            SizedBox(width: 4.w),
            CustomTextView(text: "Share"),
          ],
        ),

        /// TIPS BUTTON (only if NOT owner & eventType == "Funding")
        if (showTips)
          GestureDetector(
            onTap: onTipsTap,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                gradient: LinearGradient(
                  colors: [AppColors.secondaryColor, AppColors.primaryColor],
                ),
              ),
              child: CustomTextView(
                text: "Tips",
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 12.sp,
              ),
            ),
          ),
      ],
    );
  }
}

