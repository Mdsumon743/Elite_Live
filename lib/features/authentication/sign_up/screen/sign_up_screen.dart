import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';




import '../../../../core/global_widget/custom_password_field.dart';
import '../../../../core/global_widget/custom_text_field.dart';
import '../../../../core/global_widget/custom_text_view.dart';

import '../../../../core/global_widget/custom_appbar.dart';
import '../../../../core/global_widget/custom_elevated_button.dart';
import '../../../../core/global_widget/social_login_button.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/image_path.dart';
import '../../../../core/validation/email_validation.dart';
import '../../../../core/validation/name_validation.dart';
import '../../../../core/validation/password_validation.dart';
import '../../../../routes/app_routing.dart';
import '../controller/sign_up_controller.dart';





class SignUpScreen extends StatelessWidget {
  final SignUpController controller = Get.find();
  final formKey = GlobalKey<FormState>();

  SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextView(
                    text:   "Create an account",
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                ),
                SizedBox(height: 5.h),
                CustomTextView(
                  text:     "Create account and enjoy all services",
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textColor,
                ),
                SizedBox(height: 25.h),

                // ===== First Name =====
                Align(
                  alignment: Alignment.centerLeft,
                  child: CustomTextView(
                    text:     "First Name",
                    fontSize: 14.sp,
                    color: AppColors.textColorBlack,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 5.h),
                CustomTextField(
                  hintText: "Enter First Name",
                  controller: controller.firstNameController,
                  keyboardType: TextInputType.text,
                  validator: validateName,
                ),
                SizedBox(height: 25.h),

                // ===== Last Name =====
                Align(
                  alignment: Alignment.centerLeft,
                  child: CustomTextView(
                     text:    "Last Name",
                    fontSize: 14.sp,
                    color: AppColors.textColorBlack,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 5.h),
                CustomTextField(
                  hintText: "Enter Last Name",
                  controller: controller.lastNameController,
                  keyboardType: TextInputType.text,
                  validator: validateName,
                ),
                SizedBox(height: 25.h),

                // ===== Email =====
                Align(
                  alignment: Alignment.centerLeft,
                  child: CustomTextView(
                    text:     "Email Address",
                    fontSize: 14.sp,
                    color: AppColors.textColorBlack,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 5.h),
                CustomTextField(
                  hintText: "Enter your email",
                  controller: controller.emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: validateEmail,
                ),
                SizedBox(height: 25.h),

                // ===== Password =====
                Align(
                  alignment: Alignment.centerLeft,
                  child: CustomTextView(
                     text:    "Password",
                    fontSize: 14.sp,
                    color: AppColors.textColorBlack,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 5.h),
                CustomPasswordField(
                  hints: "Enter Password",
                  controller: controller.passwordController,
                  validator: validatePassword,
                ),
                SizedBox(height: 25.h),

                // ===== Confirm Password =====
                Align(
                  alignment: Alignment.centerLeft,
                  child: CustomTextView(
                   text:      "Confirm Password",
                    fontSize: 14.sp,
                    color: AppColors.textColorBlack,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 5.h),
                CustomPasswordField(
                  hints: "Enter Confirm Password",
                  controller: controller.confirmPassword,
                  validator: validatePassword,
                ),
                SizedBox(height: 30.h),

                // ===== Sign Up Button =====
                Obx(() {
                  return CustomElevatedButton(
                    text: "Sign Up",
                    isLoading: controller.isLoading.value,
                    ontap: () {
                      if (formKey.currentState!.validate()) {
                        controller.registerUser(); // ✅ call API
                      }
                    },
                  );
                }),
                SizedBox(height: 25.h),

                // ===== Social Logins =====
                Row(
                  children: [
                    Expanded(child: Divider()),
                    SizedBox(width: 10.w),
                    CustomTextView(
                      text:     "Or continue with",
                      fontSize: 12.sp,
                      color: AppColors.textColor,
                      fontWeight: FontWeight.w400,
                    ),
                    SizedBox(width: 10.w),
                    Expanded(child: Divider()),
                  ],
                ),
                SizedBox(height: 25.h),

                SocialLoginButton(
                  icon: Image.asset(ImagePath.google, width: 24.w, height: 24.h),
                  text: 'Continue with Google',
                  onPressed: () {},
                ),
                SizedBox(height: 20.h),
                SocialLoginButton(
                  icon: Image.asset(ImagePath.facebook, width: 24.w, height: 24.h),
                  text: 'Continue with Facebook',
                  onPressed: () {},
                ),

                SizedBox(height: 25.h),
                Align(
                  alignment: Alignment.center,
                  child: RichText(
                    text: TextSpan(
                      text: 'Already a member? ',
                      style: GoogleFonts.andika(
                        color: Colors.grey,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                      children: [
                        TextSpan(
                          text: 'Sign In',
                          style: GoogleFonts.andika(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w400,
                            fontSize: 14.sp,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Get.toNamed(AppRoute.signIn);
                            },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 100.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

