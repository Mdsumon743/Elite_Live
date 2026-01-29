import 'package:elites_live/core/global_widget/custom_text_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../routes/app_routing.dart';
import '../../controller/profile_controller.dart';
import '../../controller/settings_controller.dart';
import 'delete.dart';
import 'logout.dart';
import 'package:intl/intl.dart';

class SettingsPage extends StatelessWidget {
  final SettingsController controller = Get.put(SettingsController());
  final ProfileController profileController = Get.find();


  SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor, // Yellow background
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top header + profile image
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
                  child:     Row(
                    children: [
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: const Icon(Icons.arrow_back,color: Colors.white,),
                      ),
                      SizedBox(width: 20.w),
                      Text('Settings',
                        style: GoogleFonts.inter(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                // White section with rounded corners
                Container(
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
                    children: [
                      SizedBox(height: 30.h), // for profile image overlap


                      // Go Premium Card
                      InkWell(
                        onTap: (){
                       Get.toNamed(AppRoute.premium);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                          decoration: BoxDecoration(
                            color: Color(0xFFF8F8F8),
                            borderRadius: BorderRadius.circular(12.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Text(
                                'Go Premium',
                                style: GoogleFonts.poppins(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF2D2D2D),
                                ),
                              ),
                              Spacer(),
                              Icon(Icons.arrow_forward_ios, size: 16.sp),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 40.h),

                      // About Me Section
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'About Me',
                          style: GoogleFonts.poppins(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF2D2D2D),
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Obx(() {
                        final user = profileController.userinfo.value;

                        if (user == null || user.bio.trim().isEmpty) {
                          return CustomTextView(
                                  text:  "No bio available",
                            fontWeight: FontWeight.w500,fontSize: 18.sp,color: AppColors.textBody,

                          );
                        }

                        return CustomTextView(       text: user.bio, fontWeight: FontWeight.w500,fontSize: 18.sp,color: AppColors.textBody,);
                      }),

                      SizedBox(height: 40.h),

                      // Personal Info Section
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Personal Information',
                          style: GoogleFonts.poppins(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF2D2D2D),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset("assets/icons/mail.png", height: 24.h, width: 24.w),
                          SizedBox(width: 10.w),
                          Expanded(
                            child:  Obx(() {
                              final user = profileController.userinfo.value;

                              if (user == null || user.email.trim().isEmpty) {
                                return CustomTextView(
                                      text:    "example@gmail.com",
                                  fontWeight: FontWeight.w500,fontSize: 18.sp,color: AppColors.textBody,

                                );
                              }

                              return CustomTextView(       text: user.email, fontWeight: FontWeight.w500,fontSize: 18.sp,color: AppColors.textBody,);
                            }),
                          ),
                        ],
                      ),SizedBox(height: 18.h,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset("assets/icons/profile2.png", height: 24.h, width: 24.w),
                          SizedBox(width: 10.w),
                          Expanded(
                            child:  Obx(() {
                              final user = profileController.userinfo.value;

                              if (user == null || user.gender.trim().isEmpty) {
                                return CustomTextView(
                                      text:    "example@gmail.com",
                                  fontWeight: FontWeight.w500,fontSize: 18.sp,color: AppColors.textBody,

                                );
                              }

                              return CustomTextView(       text: user.gender, fontWeight: FontWeight.w500,fontSize: 18.sp,color: AppColors.textBody,);
                            }),
                          ),
                        ],
                      ),
                      SizedBox(height: 18.h,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset("assets/icons/dob.png", height: 24.h, width: 24.w),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Obx(() {
                              final user = profileController.userinfo.value;

                              if (user == null) {
                                return CustomTextView(
                                        text:  "New York USA",
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18.sp,
                                  color: AppColors.textBody,
                                );
                              }

                              final formattedDob = DateFormat('yyyy-MM-dd').format(user.dob);
                              final age = calculateAge(user.dob);

                              return CustomTextView(
                                   text:     "$formattedDob ($age)",
                                fontWeight: FontWeight.w500,
                                fontSize: 18.sp,
                                color: AppColors.textBody,
                              );
                            }),
                          ),
                        ],
                      ),

                      SizedBox(height: 18.h,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset("assets/icons/pin.png", height: 24.h, width: 24.w),
                          SizedBox(width: 10.w),
                          Expanded(
                            child:  Obx(() {
                              final user = profileController.userinfo.value;

                              if (user == null || user.address.trim().isEmpty) {
                                return CustomTextView(
                                     text:    "New York USA",
                                  fontWeight: FontWeight.w500,fontSize: 18.sp,color: AppColors.textBody,

                                );
                              }

                              return CustomTextView(       text: user.address, fontWeight: FontWeight.w500,fontSize: 18.sp,color: AppColors.textBody,);
                            }),
                          ),
                        ],
                      ),





                      SizedBox(height: 40.h),

                      // Settings Section
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Settings',
                          style: GoogleFonts.poppins(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF2D2D2D),
                          ),
                        ),
                      ),

                      SizedBox(height: 12.h,),
                      Container(height: 1.5.h, width: 310, color: Color(0xFFF8F8FB),),
                      SizedBox(height: 12.h),
                      settingTile(
                        'assets/icons/edit_profile2.png',
                        'Moderator',
                        showArrow: true,
                        color: Color(0xFF2D2D2D), // icon color
                        textColor: Color(0xFF2D2D2D), // text color
                        onTap: (){Get.toNamed(AppRoute.moderator);},
                      ),

                      settingTile(
                        'assets/icons/earnings.png',
                        'Earning',
                        showArrow: true,
                        color: Color(0xFF191919), // icon color
                        textColor: Color(0xFF191919), // text color
                       onTap: () {Get.toNamed(AppRoute.earnings);},
                      ),

                      settingTile(
                        'assets/icons/wallet.png',
                        'Wallet',
                        showArrow: true,
                        color: Color(0xFF191919), // icon color
                        textColor: Color(0xFF191919), // text color
                        onTap: () => Get.toNamed(AppRoute.wallet),
                      ),

                      settingTile(
                        'assets/icons/subscription.png',
                        'Subscription',
                        showArrow: true,
                        color: Color(0xFF191919), // icon color
                        textColor: Color(0xFF191919), // text color
                        onTap: (){Get.toNamed(AppRoute.subscription);},
                      ),

                      settingTile(
                        'assets/icons/change_pass.png',
                        'Change Password',
                        showArrow: true,
                        color: Color(0xFF191919), // icon color
                        textColor: Color(0xFF191919), // text color
                        onTap: (){Get.toNamed(AppRoute.changePass);},
                      ),

                     /* settingTile(
                        'assets/icons/bank.png',
                        'Bank Information',
                        showArrow: true,
                        color: Color(0xFF191919), // icon color
                        textColor: Color(0xFF191919), // text color
                         onTap: (){Get.toNamed(AppRoute.bank);},
                      ),
*/
                      settingTile(
                        'assets/icons/subscription.png',
                        'Delete Account',
                        color: Color(0xFFDC0132), // icon color
                        textColor: Color(0xFFDC0132), // text color
                        onTap: () {
                          showDeleteBottomSheet(Get.context!);
                        },
                      ),

                      settingTile(
                        'assets/icons/logout.png',
                        'Logout',
                        color: Color(0xFFDC0132), // icon color
                        textColor: Color(0xFFDC0132), // text color
                        onTap: () {
                          showLogoutBottomSheet(Get.context!);
                        },
                      ),
                      SizedBox(height: 40.h),

                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String calculateAge(DateTime dob) {
    final now = DateTime.now();

    int years = now.year - dob.year;
    int months = now.month - dob.month;
    int days = now.day - dob.day;

    if (days < 0) {
      final prevMonth = DateTime(now.year, now.month, 0);
      days += prevMonth.day;
      months--;
    }

    if (months < 0) {
      months += 12;
      years--;
    }

    return "${years}y ${months}m ${days}d";
  }


  Widget infoTile(String iconPath, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(iconPath, height: 24.h, width: 24.w),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  text,
                  style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF191919)
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 15.h,),
          Container(height: 1.5.h, width: 310, color: Color(0xFFF8F8FB),),
        ],
      ),
    );
  }


  Widget settingTile(
      String iconPath,
      String title, {
        Color color = AppColors.bgColor,
        Color textColor = Colors.black,
        VoidCallback? onTap,
        bool showArrow = false,
      }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Column(
          children: [
            Row(
              children: [
                Image.asset(iconPath, height: 20.h, width: 20.w, color: color),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: textColor,
                    ),
                  ),
                ),
                if (showArrow)
                  Icon(Icons.arrow_forward_ios, size: 20.sp, color: Color(0xFF334155)),
              ],
            ),
            SizedBox(height: 15.h,),
            Container(height: 1.5.h, width: 310, color: Color(0xFFF8F8FB),),
          ],
        ),
      ),
    );
  }


}
