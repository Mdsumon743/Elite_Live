
import 'package:elites_live/core/global_widget/custom_elevated_button.dart';

import 'package:elites_live/features/profile/data/my_following_data_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../controller/following_follwer_controller.dart';
import '../../controller/moderator_controller.dart';

class ModeratorPage extends StatelessWidget {
  final ModeratorController controller = Get.put(ModeratorController());

  final FollowingFollwerController followerController = Get.find();

  ModeratorPage({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 190.h,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: AppColors.primaryGradient,
                ),
              ),
              Positioned(
                top: 50.h,
                left: 20.w,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    SizedBox(width: 20.w),
                    Text(
                      'Add Moderator',
                      style: GoogleFonts.inter(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              // Body section
              Container(
                height: 650.h,
                margin: EdgeInsets.only(top: 160.h),
                padding: EdgeInsets.symmetric(horizontal: 25.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24.r),
                    topRight: Radius.circular(24.r),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 30.h),

                    _labelText("Add Moderator"),
                    SizedBox(height: 8.h),

                    /// ----- FIXED DROPDOWN -----
                    Obx(() => moderatorDropdown(
                      controller.selectedModerator.value,
                      followerController.myFollowing,
                          (val) => controller.selectedModerator.value = val,
                    )),

                    SizedBox(height: 24.h),

                    _labelText("Moderator Access"),
                    SizedBox(height: 8.h),

                    Obx(() => _buildDropdown(
                      controller.selectedSlowMode.value,
                      controller.slowModes,
                          (val) => controller.selectedSlowMode.value = val!,
                    )),

                    SizedBox(height: 24.h),


                    _toggleTile("User Banned", controller.userBanned),
                    SizedBox(height: 10.h),
                    _toggleTile("Sub Only", controller.subOnly),

                    SizedBox(height: 50.h),

                    /// ---------- SAVE BUTTON ----------
                    Obx(() => CustomElevatedButton(
                      ontap: controller.isLoading.value
                          ? () {}
                          : () {
                        final moderator = controller.selectedModerator.value;

                        if (moderator == null) {
                          Get.snackbar("Error", "Please select a moderator",
                              backgroundColor:
                              Colors.red.shade600,
                              colorText: Colors.white);
                          return;
                        }

                        /// extract actual ID here
                        final moderatorId = moderator.user.id; // change if needed

                        controller.addModerator(moderatorId);
                      },
                      text: "Save",
                    )),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// -------------------------------------------------------------
  /// LABEL TEXT
  Widget _labelText(String title) => Text(
    title,
    style: TextStyle(
      fontSize: 15.sp,
      fontWeight: FontWeight.w600,
      color: Colors.black87,
    ),
  );

  /// -------------------------------------------------------------
  /// GENERIC STRING DROPDOWN
  Widget _buildDropdown(
      String? value, List<String> items, Function(String?) onChanged) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: DropdownButton<String>(
        value: value,
        isExpanded: true,
        underline: const SizedBox(),
        hint: Text(
          "Select access duration...",
          style: TextStyle(color: Colors.grey.shade500, fontSize: 14.sp),
        ),
        items: items
            .map((e) => DropdownMenuItem<String>(
          value: e,
          child: Text(e, style: TextStyle(fontSize: 14.sp)),
        ))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  /// -------------------------------------------------------------
  /// FIXED MODERATOR DROPDOWN (NO TYPE ERRORS)
  Widget moderatorDropdown(MyFollowingResult? value,
      List<MyFollowingResult> items, Function(MyFollowingResult?) onChanged) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: DropdownButton<MyFollowingResult>(
        value: value,
        isExpanded: true,
        underline: const SizedBox(),
        hint: Text(
          "Select moderator...",
          style: TextStyle(color: Colors.grey.shade500, fontSize: 14.sp),
        ),
        items: items.map((e) {
          return DropdownMenuItem<MyFollowingResult>(
            value: e,
            child: Text(
             "${e.user.firstName } ${e.user.lastName}" ,
              style: TextStyle(fontSize: 14.sp),
            ),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  /// -------------------------------------------------------------
  /// TOGGLE TILE
  Widget _toggleTile(String title, RxBool value) {
    return Obx(
          () => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: 15.sp,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500)),
          Switch(
            value: value.value,
            onChanged: (val) => value.value = val,
            activeThumbColor: Colors.white,
            activeTrackColor: AppColors.primaryColor,
          ),
        ],
      ),
    );
  }
}
