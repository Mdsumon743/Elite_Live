
import 'dart:developer';

import 'package:elites_live/core/global_widget/custom_snackbar.dart';
import 'package:elites_live/core/services/auth_service.dart';
import 'package:elites_live/routes/app_routing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';


import '../../../../core/global_widget/custom_text_view.dart';
import '../../../../core/global_widget/custom_elevated_button.dart';
import '../../../../core/services/network_caller/repository/network_caller.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/app_urls.dart';



class SignUpOtpController extends GetxController {
  AuthService preferencesHelper = AuthService();
  final TextEditingController otpController = TextEditingController();
  var otp = ''.obs;
  var name = ''.obs;

  var password = ''.obs;
  RxBool isLoading = false.obs;
  final email = Get.arguments['email'];

  @override
  Future<void> onInit() async {
    debugPrint(Get.arguments);
    if (Get.arguments != null) {
      var data = Get.arguments;
      name.value = data['name'] ?? '';
      email.value = data['email'] ?? '';
      log("the email is $email");
      password.value = data['password'] ?? '';
    } else {
      debugPrint("Error: Get.arguments is null");
    }
    await AuthService().init();
    super.onInit();
  }

  Future<void> verifyOtp() async {
    Map<String, dynamic> data = {
      "otp": otpController.text.trim(),
      "email": email,

    };
    try {
      isLoading.value = true;

      String url = AppUrls.verifyOtp;

      final response = await NetworkCaller().postRequest(url, body: data);
      if (response.isSuccess) {
        Get.offAllNamed(AppRoute.signIn);

      } else {
        CustomSnackBar.error(title: "Error", message: response.errorMessage);

      }
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resendOtp() async {
    Map<String, dynamic> signUpData = {
      "fullName": name.value,
      "email": email.value,
      "password": password.value,
    };

    try {
      isLoading.value = true;

      String url = AppUrls.registerUrl;

      final response = await NetworkCaller().postRequest(url, body: signUpData);
      if (response.isSuccess) {
        otpController.text = "";
        CustomSnackBar.success(title: "Success", message: "Resend Code successfully");

      } else {
        CustomSnackBar.error(title: "Error", message: response.errorMessage);

      }
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void clearOtp() {
    otp.value = '';
    otpController.clear();
  }

  @override
  void onClose() {
    otpController.dispose();
    super.onClose();
  }

  void showSuccessDialog() {
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          backgroundColor: AppColors.white,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 80.h,
                  width: 80.h,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.verified_user,
                    color: Colors.white,
                    size: 40.sp,
                  ),
                ),
                SizedBox(height: 20.h),
                CustomTextView(
                 text:      'Account verified\nSuccessfully',
                  textAlign: TextAlign.center,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
                SizedBox(height: 25.h),
                SizedBox(
                  width: double.infinity,
                  height: 48.h,
                  child: CustomElevatedButton(
                    ontap: () {
                      Get.back();
                      // Get.offAllNamed(AppRoute.signIn);
                    },
                    text: "Done",
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
