import 'dart:developer';

import 'package:elites_live/core/helper/shared_prefarenses_helper.dart';
import 'package:elites_live/core/services/network_caller/repository/network_caller.dart';
import 'package:elites_live/routes/app_routing.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/global_widget/custom_loading.dart';
import '../../../core/utils/constants/app_colors.dart';
import '../../../core/utils/constants/app_urls.dart';


class ChangePasswordController extends GetxController {


  final TextEditingController passwordController = TextEditingController();
  final TextEditingController newPasswordController  = TextEditingController();
  final TextEditingController confirmPasswordController  = TextEditingController();
  final NetworkCaller networkCaller = NetworkCaller();
  final SharedPreferencesHelper helper = SharedPreferencesHelper();
  final formKey = GlobalKey<FormState>();
  var isLoading = false.obs;


  Future<void> changePassword() async {
    isLoading.value = true;
    Get.dialog(
      CustomLoading(color: AppColors.primaryColor),
      barrierDismissible: false,
    );

    String? token = helper.getString("userToken");
    log("The token during change password is $token");

    try {
      var response = await networkCaller.patchRequest(
        AppUrls.changePassword,
        body: {
          "oldPassword": passwordController.text.trim(),
          "newPassword": newPasswordController.text.trim(),
        },
        token: token,
      );

      // Close loading dialog properly
      if (Get.isDialogOpen == true) Get.back();

      if (response.isSuccess) {
        Get.snackbar("Success", "The password was successfully changed");
        Get.offAllNamed(AppRoute.signIn);        // safer navigation
      } else {
        Get.snackbar("Error", response.errorMessage);
      }
    } catch (e) {
      if (Get.isDialogOpen == true) Get.back();
      log("The exception is: ${e.toString()}");

      Get.snackbar("Error", "Something went wrong. Try again later");
    } finally {
      isLoading.value = false;
    }
  }


  @override
  Future<void> onInit() async {
    super.onInit();
  }




  @override
  void dispose() {
    passwordController.clear();
    super.dispose();
  }
}
