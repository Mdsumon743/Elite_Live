
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/global_widget/custom_text_view.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/image_path.dart';

class NameBadgeSection extends StatelessWidget {
  const NameBadgeSection({
    super.key,
    required this.userName,
  });

  final String? userName;

  @override
  Widget build(BuildContext context) {
    // Handle null / empty / "null"
    final String safeName = (userName == null ||
        userName!.trim().isEmpty ||
        userName!.trim().toLowerCase() == "null")
        ? "Unknown"
        : userName!.trim();

    final bool hasValidName = safeName.isNotEmpty;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: CustomTextView(
            text: safeName,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textHeader,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),

        /// Show badge only when name is valid
        if (hasValidName) ...[
          SizedBox(width: 6.w),
          Image.asset(
            ImagePath.badge,
            height: 15.h,
            width: 15.w,
            fit: BoxFit.cover,
          ),
        ]
      ],
    );
  }
}
