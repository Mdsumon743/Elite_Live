import 'package:elites_live/features/profile/controller/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../controller/logout_controller.dart';


void showDeleteBottomSheet(BuildContext context) {
  Get.bottomSheet(
    DeleteBottomSheet(),
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(44.r)),
    ),
    isDismissible: true,
  );
}

class DeleteBottomSheet extends StatelessWidget {
  final LogoutController controller = Get.put(LogoutController());
  final SettingsController settingsController = Get.put(SettingsController());
  DeleteBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          SizedBox(height: 15.h),
          Text(
            "Delete",
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w600,
              foreground: Paint()
                ..shader = AppColors.primaryGradient.createShader(
                  Rect.fromLTWH(0.0, 0.0, 200.0, 70.0),
                ),
            ),
          ),

          SizedBox(height: 8.h),
          Text("Are you sure you want\nto Delete ?",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
              color: Color(0xFF2D2D2D),
            ),
          ),
          SizedBox(height: 20.h),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 48.h,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(40.r),
                  ),
                  padding: EdgeInsets.all(1.5), // Border width
                  child: ElevatedButton(
                    onPressed: () => Get.back(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      elevation: 0,
                      shadowColor: Colors.transparent,
                    ),
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        foreground: Paint()
                          ..shader = AppColors.primaryGradient.createShader(
                            Rect.fromLTWH(0.0, 0.0, 200.0, 70.0),
                          ),
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(width: 10.w),
              Expanded(
                child: Container(
                  height: 48.h,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(40.r),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                   settingsController.deleteAccount();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                    ),
                    child: Text(
                      "Yes, Delete",
                      style: GoogleFonts.poppins(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),

            ],
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }
}
