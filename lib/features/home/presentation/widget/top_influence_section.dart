import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/global_widget/custom_text_view.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/image_path.dart';


class TopInfluenceSection extends StatelessWidget {
  const TopInfluenceSection({
    super.key,
    required this.watchCount,
    required this.eventName,
  });
  final String watchCount;
  final String eventName;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180.w,
      margin: EdgeInsets.only(right: 12.w,),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image container with LIVE badge
          Container(
            height: 200.h,
            width: 180.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
              color: Colors.grey[200],
            ),
            child: Stack(
              children: [
                // Column of three images
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
                  child: Column(
                    children: [
                      Expanded(
                        child: Image.asset(
                          ImagePath.one, // top image
                          width: 180.w,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Expanded(
                        child: Image.asset(
                          ImagePath.two, // middle image
                          width: 180.w,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Expanded(
                        child: Image.asset(
                          ImagePath.three, // bottom image
                          width: 180.w,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),

                // LIVE badge
                Positioned(
                  top: 8.h,
                  left: 8.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                    decoration: BoxDecoration(
                      color: Color(0xFFFF3B30),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 5.w,
                          height: 5.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          'LIVE',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),


          // Text content
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextView(
                       text:   eventName,
                  fontWeight: FontWeight.w500,
                  fontSize: 13.sp,
                  color: AppColors.textHeader,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                CustomTextView(
                     text:    watchCount,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textBody,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}