


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/global_widget/custom_text_view.dart';
import '../../../../core/global_widget/custombuttonwhite.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../routes/app_routing.dart';
import '../../controller/edit_profile_controller.dart';
import '../../controller/profile_controller.dart';
import '../widget/profile_tab_widget.dart';

class ProfilePage extends StatelessWidget {
  final ProfileController controller = Get.find();
  final EditProfileController editProfileController = Get.find();


  ProfilePage({super.key});

  // Method to show bottom sheet for image selection
  void _showImageSourceBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r),
              topRight: Radius.circular(20.r),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(20.r),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handle bar
                  Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // Title
                  Text(
                    'Select Image Source',
                    style: GoogleFonts.inter(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2D2D2D),
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // Camera Option
                  ListTile(
                    leading: Container(
                      padding: EdgeInsets.all(10.r),
                      decoration: BoxDecoration(
                        color: AppColors.primaryGradient.colors[0].withValues(
                          alpha: 0.1,
                        ),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Icon(
                        Icons.camera_alt,
                        color: AppColors.primaryGradient.colors[0],
                        size: 24.sp,
                      ),
                    ),
                    title: Text(
                      'Camera',
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF2D2D2D),
                      ),
                    ),
                    onTap: () async {
                      Navigator.pop(context);
                      await editProfileController.pickImageFromCamera();
                    },
                  ),

                  SizedBox(height: 8.h),

                  // Gallery Option
                  ListTile(
                    leading: Container(
                      padding: EdgeInsets.all(10.r),
                      decoration: BoxDecoration(
                        color: AppColors.primaryGradient.colors[0].withValues(
                          alpha: 0.1,
                        ),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Icon(
                        Icons.photo_library,
                        color: AppColors.primaryGradient.colors[0],
                        size: 24.sp,
                      ),
                    ),
                    title: Text(
                      'Gallery',
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF2D2D2D),
                      ),
                    ),
                    onTap: () async {
                      Navigator.pop(context);
                      await editProfileController.pickImageFromGallery();
                    },
                  ),

                  SizedBox(height: 16.h),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SingleChildScrollView(
        child: Column(
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
                      Text(
                        "Profile",
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 20.sp,
                        ),
                      ),
                      SizedBox(width: 240.w),
                      InkWell(
                        onTap: () {
                          Get.toNamed(AppRoute.settings);
                        },
                        child: Image.asset(
                          "assets/icons/settings.png",
                          height: 24.h,
                          width: 24.w,
                        ),
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
                      SizedBox(height: 60.h),
                      Obx(() {
                        final user = controller.userinfo.value;

                        if (user == null) {
                          return Text(
                            'Jolie Topley',
                            style: GoogleFonts.inter(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF2D2D2D),
                            ),
                          );
                        }

                        return user.firstName.isNotEmpty
                            ? CustomTextView(
                              text: "${user.firstName} ${user.lastName}",
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textBody,
                            )
                            : Text(
                              'Jolie Topley',
                              style: GoogleFonts.inter(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF2D2D2D),
                              ),
                            );
                      }),

                      Obx(() {
                        final user = controller.userinfo.value;

                        if (user == null) {
                          return CustomTextView(
                            text: 'Jolie Topley',
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF2D2D2D),
                          );
                        }

                        return user.profession.isNotEmpty
                            ? CustomTextView(
                              text: user.profession,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textBody,
                            )
                            : CustomTextView(
                              text: 'Model',
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textBody,
                            );
                      }),

                      SizedBox(height: 24.h),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [

                              Obx(() {
                                final follower = controller.userinfo.value?.followersCount?.toString() ?? "0";

                                return CustomTextView(
                                  text: follower,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18.sp,
                                  color: AppColors.textHeader,
                                );
                              }),

                              CustomTextView(
                                text: "Followers",

                                fontWeight: FontWeight.w400,
                                fontSize: 14.sp,
                                color: AppColors.textColor,
                              ),
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              left: 24.0,
                              right: 24,
                            ),
                            child: Container(
                              height: 46.h,
                              width: 1.w,
                              color: Color(0xFFF0F0F0),
                            ),
                          ),
                          Column(
                            children: [
                              Obx(() {
                                final user = controller.userinfo.value;

                                final count = user?.followingCount?.toString() ?? "0";

                                return CustomTextView(
                                  text: count,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18.sp,
                                  color: AppColors.textHeader,
                                );
                              }),

                              CustomTextView(
                               text:  "Following",

                                  fontWeight: FontWeight.w400,
                                  fontSize: 14.sp,
                                  color: AppColors.textColor,

                              ),
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              left: 24.0,
                              right: 24,
                            ),
                            child: Container(
                              height: 46.h,
                              width: 1.w,
                              color: Color(0xFFF0F0F0),
                            ),
                          ),
                          Column(
                            children: [
                              Obx(() {
                                // Force rebuild by accessing the list
                                final count =
                                controller.userinfo.value?.count.event;


                                return CustomTextView(
                                  text:  count.toString(),

                                  fontWeight: FontWeight.w600,
                                  fontSize: 18.sp,
                                  color: AppColors.textHeader,

                                );
                              }),
                              Text(
                                "Posts",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14.sp,
                                  color: AppColors.textColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),
                      CustomButtonWhite(
                        text: 'Edit Profile',
                        onPressed: () {
                          Get.toNamed(AppRoute.editProfile);
                        },
                      ),
                      SizedBox(height: 15.h),

                      ProfileTabsWidget(),
                    ],
                  ),
                ),

                //* Profile Image + edit image
                Positioned(
                  top: 100.h,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Obx(() {
                          final user = controller.userinfo.value;

                          if (user == null) {
                            return CircleAvatar(
                              radius: 50.r,
                              backgroundImage: const AssetImage(
                                'assets/images/profile_image.jpg',
                              ),
                            );
                          }

                          return CircleAvatar(
                            radius: 50.r,
                            backgroundImage:
                                user.profileImage != null &&
                                        user.profileImage!.isNotEmpty
                                    ? NetworkImage(user.profileImage!)
                                    : const AssetImage(
                                          'assets/images/profile_image.jpg',
                                        )
                                        as ImageProvider,
                          );
                        }),

                        // Edit button with tap functionality
                        Positioned(
                          bottom: -3,
                          right: 3,
                          child: InkWell(
                            onTap: () => _showImageSourceBottomSheet(context),
                            child: Image.asset(
                              'assets/icons/edit_profile.png',
                              width: 27.w,
                              height: 27.h,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
