import 'package:elites_live/core/global_widget/custom_text_view.dart';
import 'package:elites_live/features/profile/controller/profile_controller.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';



import '../../../../core/global_widget/custom_date_time_dialogue.dart';
import '../../../../core/global_widget/custom_date_time_field.dart';
import '../../../../core/global_widget/custom_drop_down.dart';
import '../../../../core/global_widget/custom_elevated_button.dart';
import '../../../../core/global_widget/custom_text_field.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../controller/edit_profile_controller.dart';
import 'package:intl/intl.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final EditProfileController controller = Get.find();
    final ProfileController profileController = Get.find();
    final user = profileController.userinfo.value;

    return Scaffold(
      backgroundColor: Colors.white,
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
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 20.w),
                      Text(
                        'Edit Profile',
                        style: GoogleFonts.inter(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 30.h),
                      20.verticalSpace,
                      CustomTextView(
                           text:     "Gender",
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textBody,
                      ),
                      Obx(
                        () => CustomDropDown(
                          hintText: user!.gender.isNotEmpty?user.gender:"Select Gender",
                          items: ["MALE", "FEMALE"],
                          selectedValue: controller.selectedGender.value,
                          onChanged: (String? value) {
                            controller.setSelectedGender(value);
                          },
                          textStyle: GoogleFonts.poppins(),
                        ),
                      ),
                      20.verticalSpace,
                      CustomTextView(
                           text:     "Date of Birth",
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textBody,
                      ),
                      CustomDateOfBirthFiled(
                        hint: "${(user?.dob.isNullOrBlank ?? true) ? "Dob" : user!.dob}",
                        controller: controller.dateController,
                        onTap: () {
                          showModalBottomSheet(

                            context: context,
                            builder: (context) {
                              return CustomDatePicker(
                                selectedDateCallback: (DateTime selectedDate) {
                                  controller.dateController.text = DateFormat('yyyy-MM-dd').format(
                                    controller.dateTimeController.selectedDate.value,
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),

                      20.verticalSpace,
                      CustomTextView(
                            text:    "Profession",
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textBody,
                      ),

                      Obx(
                        () => CustomDropDown(
                          hintText: user!.profession.isNotEmpty?user.profession:"Select Profession",
                          items: ["Professional Model ", "Professional Model"],
                          selectedValue: controller.selectedProfession.value,
                          onChanged: (String? value) {
                            controller.setSelectedProfession(value);
                          },
                          textStyle: GoogleFonts.poppins(),
                        ),
                      ),
                      20.verticalSpace,
                      CustomTextView(
                           text:     "Location",
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textBody,
                      ),

                      CustomTextField(
                        controller: controller.addressController,
                        hintText: user!.address.isNotEmpty?user.address:"Dhaka, Bangladesh",
                      ),
                      20.verticalSpace,
                      CustomTextView(
                             text:   "Bio",
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textBody,
                      ),
                      CustomTextField(
                        controller: controller.bioController,
                        hintText: user.bio.isNotEmpty?user.bio:"Enter your bio here",
                      ),
                      30.verticalSpace,
                      CustomElevatedButton(
                        text: 'Save Changes',
                        ontap: () {
                          controller.editProfile();
                        },
                      ),
                      40.verticalSpace,
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


}
