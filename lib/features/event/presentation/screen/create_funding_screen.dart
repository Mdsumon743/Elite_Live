import 'package:elites_live/features/event/controller/schedule_controller.dart';
import 'package:elites_live/features/profile/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/global_widget/custom_text_field.dart';
import '../../../../core/global_widget/custom_text_view.dart';
import '../../../../core/global_widget/custom_elevated_button.dart';
import '../../../../core/utils/constants/app_colors.dart';


class CreateFundingScreen extends StatelessWidget {
   CreateFundingScreen({super.key});
  final ProfileController profileController = Get.find();
  final ScheduleController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Column(
        children: [
          /// Gradient Header
          Container(
            height: 130.h,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 24.sp,
                      ),
                    ),
                    SizedBox(width: 32.h),
                    CustomTextView(
                      text:     "Create Schedule",
                      fontWeight: FontWeight.w600,
                      fontSize: 20.sp,
                      color: AppColors.white,
                    ),
                  ],
                ),
              ),
            ),
          ),

          /// White Card Container
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Obx(() {
                          final user = profileController.userinfo.value;

                          if (user == null) {
                            return CircleAvatar(
                              ///radius: 50.r,
                              backgroundImage: const AssetImage('assets/images/profile_image.jpg'),
                            );
                          }

                          return CircleAvatar(
                            //radius: 50.r,
                            backgroundImage: user.profileImage != null && user.profileImage!.isNotEmpty
                                ? NetworkImage(user.profileImage!)
                                : const AssetImage('assets/images/profile_image.jpg') as ImageProvider,
                          );
                        }),
                        SizedBox(width: 8.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(() {
                              final user = profileController.userinfo.value;

                              if (user == null) {
                                return Text(
                                  'Jolie Topley',
                                  style: GoogleFonts.inter(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF2D2D2D),
                                  ),
                                );
                              }

                              return user.firstName.isNotEmpty
                                  ? CustomTextView(
                                text:   "${user.firstName} ${user.lastName}",
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textBody,
                              )
                                  : Text(
                                'Jolie Topley',
                                style: GoogleFonts.inter(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF2D2D2D),
                                ),
                              );
                            }),

                            Obx(() {
                              final user = profileController.userinfo.value;

                              if (user == null) {
                                return CustomTextView(
                                  text:   'Jolie Topley',
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF2D2D2D),
                                );
                              }

                              return user.profession.isNotEmpty
                                  ? CustomTextView(
                                text:   user.profession,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textBody,
                              )
                                  : CustomTextView(
                                text:    'Model',
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textBody,
                              );
                            }),

                          ],
                        ),
                      ],
                    ),

                    // ... avatar and name ...
                    SizedBox(height: 32.h),
                    CustomTextView(text: "Title", fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.liveText,),
                    SizedBox(height: 8.h),
                    CustomTextField(
                      controller: controller.crowdFundTitleController,
                    ),

                    SizedBox(height: 12.h,),
                    CustomTextView(text: "Description", fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.liveText,),
                    CustomTextField(
                      controller: controller.descriptionController,
                      hintText: "Write something here",
                      maxLines: 10,
                    ),



                    SizedBox(height: 12.h),


                    SizedBox(height: 32.h),
                    CustomElevatedButton(
                      ontap: () {
                        controller.createCrowdFunding();
                        // Access the selected values

                      },
                      text: "Post",
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
