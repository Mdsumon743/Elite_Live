import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/global_widget/custom_text_view.dart';
import '../../../../core/utils/constants/app_colors.dart';


class LiveIndicatorSection extends StatelessWidget {
  const LiveIndicatorSection({
    super.key,
    required this.influencerProfile,
    this.isLive = false,
    this.onTap,
  });

  final String? influencerProfile; // allow nullable
  final bool isLive;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    // Fallback image if null, empty or "null"
    final String fallbackImage =
        "https://www.pngall.com/wp-content/uploads/5/Profile-Male-PNG.png";

    String imageUrl = (influencerProfile == null ||
        influencerProfile!.isEmpty ||
        influencerProfile!.toLowerCase() == "null")
        ? fallbackImage
        : influencerProfile!;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTap: onTap,
          child: CircleAvatar(
            radius: 30.r,
            backgroundColor: Colors.grey[200],
            child: ClipOval(
              child: Image.network(
                imageUrl,
                width: 60.r,
                height: 60.r,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // Show fallback image if network fails
                  return Image.network(
                    fallbackImage,
                    width: 60.r,
                    height: 60.r,
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
          ),
        ),

        /// LIVE BADGE
        if (isLive)
          Positioned(
            bottom: -6.h,
            left: 15.w,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 8.h,
                vertical: 4.h,
              ),
              decoration: BoxDecoration(
                color: AppColors.liveColor,
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: CustomTextView(
                text: 'Live',
                color: AppColors.white,
                fontWeight: FontWeight.w500,
                fontSize: 14.sp,
              ),
            ),
          ),
      ],
    );
  }
}

