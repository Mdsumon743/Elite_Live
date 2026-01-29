import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/global_widget/custom_text_view.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../data/crowd_funding_data_model.dart';

class CloudFundingDetails extends StatelessWidget {
  final String eventDescription;
  final String title;
  final CrowdFundingEvent event;

  const CloudFundingDetails({
    super.key,
    required this.eventDescription,
    required this.title,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    final StreamData? stream = event.stream;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextView(text: title, fontWeight: FontWeight.w400, color: AppColors.textHeader),
        SizedBox(height: 10.h),
        CustomTextView(text: eventDescription, color: AppColors.textBody,),
        SizedBox(height: 10.h),
       /* if (stream != null)
          CustomTextView(
           text: event.isOwner ? "Host Link: ${stream.hostLink}" : "Audience Link: ${stream.audienceLink}",
          color: Colors.blue,
          ),*/
      ],
    );
  }
}
