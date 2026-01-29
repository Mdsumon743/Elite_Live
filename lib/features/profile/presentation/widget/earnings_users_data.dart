import 'package:elites_live/features/profile/controller/earning_overview_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

class EarningListCard extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> items;

  EarningListCard({
    super.key,
    required this.title,
    required this.items,
  });

  final EarningsController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 12.h),
        Column(
          children: items.map((e) => _earningItem(e)).toList(),
        ),
      ],
    );
  }

  Widget _earningItem(Map<String, dynamic> data) {
    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      padding: EdgeInsets.symmetric(vertical: 8.h),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.black12)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: Image.asset(
              data["image"],
              height: 48.h,
              width: 48.w,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 12.w),

          /// TEXT CONTENT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TITLE
                Text(
                  data["title"],
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),

                // SUBTITLE
                SizedBox(height: 4.h),
                Text(
                  data["subtitle"],
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.black45,
                  ),
                ),

                SizedBox(height: 6.h),

                // ** PAYMENT FOR TAG BADGE **
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    data["paymentFor"],
                    style: GoogleFonts.inter(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// AMOUNT
          Text(
            data["amount"],
            style: GoogleFonts.inter(
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

}
