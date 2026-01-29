import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/utils/constants/icon_path.dart';
import '../../controller/search_controller.dart';

class CustomSearchBar extends StatelessWidget {
  final controller = Get.find<SearchScreenController>();

  CustomSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 60.h, left: 25.w, right: 25.w),
      child: Container(
        height: 45.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(99.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 3),
          child: TextField(
            controller: controller.searchController,
            onChanged: (value) {
              controller.searchOtherUser(value.trim());
            },
            style: GoogleFonts.poppins(
              fontSize: 14.sp,
              color: Colors.black,
            ),
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 10.h),
              prefixIcon: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Image.asset(
                  IconPath.search1,
                  height: 18.h,
                  width: 18.w,
                ),
              ),
              prefixIconConstraints: BoxConstraints(
                minWidth: 35.w,
                minHeight: 35.h,
              ),
              hintText: "Search by Name",
              hintStyle: GoogleFonts.poppins(
                fontSize: 14.sp,
                color: const Color(0xFF94A3B8),
              ),
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }
}
