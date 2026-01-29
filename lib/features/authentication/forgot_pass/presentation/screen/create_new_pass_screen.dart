import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';



import '../../../../../core/global_widget/custom_password_field.dart';
import '../../../../../core/global_widget/custom_text_view.dart';
import '../../../../../core/global_widget/custom_appbar.dart';
import '../../../../../core/global_widget/custom_elevated_button.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/validation/password_validation.dart';
import '../../../../../routes/app_routing.dart';
import '../../controller/create_new_pass_controller.dart';


class CreateNewPassScreen extends StatelessWidget {
  final CreateNewPassController controller = Get.find();
  final formKey = GlobalKey<FormState>();

  CreateNewPassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      floatingActionButton: Obx(() {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: CustomElevatedButton(
            ontap: () {
              // if (formKey.currentState!.validate()) {
              //   if (controller.passwordController.text ==
              //       controller.conPasswordController.text) {
              //     controller.resetPassword();
              //   } else {

              //   }
              // }
              Get.toNamed(AppRoute.passwordChanged);
            },
            text: "Reset Password",
            isLoading: controller.isLoading.value,
          ),
        );
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),
                CustomTextView(
                 text:      "Create New Password",
                  fontWeight: FontWeight.w600,
                  fontSize: 20.sp,
                  color: Color(0xFF2D2D2D),
                ),
                SizedBox(height: 10.h),
                CustomTextView(
                text:       "Your password must be different from previous used password",
                  fontWeight: FontWeight.w400,
                  fontSize: 14.sp,
                  color: Color(0xFF636F85),
                ),
                SizedBox(height: 30.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: CustomTextView(
                text:     "Password",
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
                SizedBox(height: 20.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: CustomTextView(
                     text:    "Confirm Password",
                    fontSize: 14.sp,
                    color: AppColors.textColorBlack,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 5.h),
                CustomPasswordField(
                  hints: "Enter Password",
                  controller: controller.conPasswordController,
                  validator: validatePassword,
                ),
                SizedBox(height: 30.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
