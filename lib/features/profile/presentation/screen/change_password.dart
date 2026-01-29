import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/global_widget/custom_elevated_button.dart';
import '../../../../core/global_widget/custom_password_field.dart';
import '../../../../core/global_widget/custom_text_view.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/validation/password_validation.dart';
import '../../controller/change_password_controller.dart';

class ChangePassword extends StatelessWidget {
  const ChangePassword({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChangePasswordController());
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
                  child:     Row(
                    children: [
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: const Icon(Icons.arrow_back,color: Colors.white,),
                      ),
                      SizedBox(width: 20.w),
                      Text('Change Password',
                        style: GoogleFonts.inter(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Form(
                  key: controller.formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Container(
                    width: double.maxFinite,
                    margin: EdgeInsets.only(top: 160.h),
                    padding: EdgeInsets.symmetric(horizontal: 25.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24.r),
                        topRight: Radius.circular(24.r),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                         SizedBox(height: 32.h,),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: CustomTextView(
                               text:       "Old Password",
                              fontSize: 16.sp,
                              color: AppColors.textColorBlack,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 5.h),
                          CustomPasswordField(
                            hints: "Enter Old Password",
                            controller: controller.passwordController,
                            validator: validatePassword,
                          ),
                          SizedBox(height: 16.h),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: CustomTextView(
                                  text:    "New Password",
                              fontSize: 16.sp,
                              color: AppColors.textColorBlack,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 5.h),
                          CustomPasswordField(
                            hints: "Enter New Password",
                            controller: controller.newPasswordController,
                            validator: validatePassword,
                          ),
                          SizedBox(height: 16.h),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: CustomTextView(
                                    text: "Confirm New Password",
                              fontSize: 16.sp,
                              color: AppColors.textColorBlack,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 5.h),
                          CustomPasswordField(
                            hints: "Confirm New Password",
                            controller: controller.confirmPasswordController,
                            validator: (value) =>
                                validateConfirmPassword(value, controller.newPasswordController.text),
                          ),
                         SizedBox(height: 280.h,),
                          CustomElevatedButton(ontap: (){
                            if (controller.formKey.currentState!.validate()) {
                              controller.changePassword();
                            }


                          }, text: "Change Now"),
                          SizedBox(height: 16.h),
                        ],
                      ),
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
