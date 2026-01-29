import 'package:elites_live/core/global_widget/custom_elevated_button.dart';

import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';


import '../../../../core/global_widget/custom_text_view.dart';
import '../../../../core/utils/constants/app_colors.dart';

class EventDetailsSection extends StatelessWidget {
  const EventDetailsSection({
    super.key,
    required this.eventDetails,
    required this.joiningFee,
    required this.eventTitle,
    required this.isOwner,
    required this.isPayment,
    this.hostLink,
    this.audienceLink,
    this.onTap,
  });

  final String eventDetails;
  final String joiningFee;
  final String eventTitle;
  final bool isOwner;
  final bool isPayment;
  final String? hostLink;
  final String? audienceLink;
  final VoidCallback? onTap;



  @override
  Widget build(BuildContext context) {


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Event Title
        CustomTextView(
          text: eventTitle,
          fontWeight: FontWeight.w400,
          fontSize: 14.sp,
          color: AppColors.liveText,
        ),
        SizedBox(height: 10.h),

        /// Event Details
        CustomTextView(
          text: eventDetails,
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          color: AppColors.textBody,
        ),
        SizedBox(height: 10.h),

        /// ======================
        /// LINK SECTION (MOVED UP)
        /// ======================
       /* if (displayLink != null && displayLink.isNotEmpty)
          GestureDetector(
            onTap: () => _copyToClipboard(displayLink),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextView(
                    text: "$linkLabel:",
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryColor,
                  ),
                  SizedBox(height: 5.h),

                  GestureDetector(
                    onTap: () => onTap?.call(),
                    child: CustomTextView(
                      text: displayLink,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.linkColor,
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
            ),
          ),*/

        SizedBox(height: 20.h),

        /// ==========================
        /// BOTTOM: JOIN / PAY BUTTON
        /// ==========================
        _buildBottomActionButton(),
      ],
    );
  }

  Widget _buildBottomActionButton() {
    final hasLive = hostLink != null && hostLink!.isNotEmpty;

    /// OWNER ACTIONS
    if (isOwner) {
      if (!hasLive) {
        return CustomElevatedButton(
          text: "Start Live",
          ontap: (){
            onTap!();
          },
        );
      }
      return CustomElevatedButton(
        text: "Join as Host",
        ontap: (){
          onTap!();
        },
      );
    }

    /// AUDIENCE: PAY FIRST (UPDATED TO BUTTON)
    if (!isPayment) {
      return CustomElevatedButton(
        text: "Pay \$$joiningFee",
        ontap: (){
          onTap!();
        },
         // optional: remove if your CustomElevatedButton handles default color
        textColor: Colors.white,
      );
    }

    /// AUDIENCE: JOIN AFTER PAYMENT
    return CustomElevatedButton(
      text: "Join Now",
      ontap: (){
        onTap!();
      },
    );
  }

}
