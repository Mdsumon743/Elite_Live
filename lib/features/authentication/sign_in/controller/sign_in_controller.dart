import 'dart:developer';

import 'package:elites_live/core/global_widget/custom_snackbar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/helper/shared_prefarenses_helper.dart';

import '../../../../core/services/google_signin_helper.dart';
import '../../../../core/services/network_caller/repository/network_caller.dart';
import '../../../../core/utils/constants/app_urls.dart';
import '../../../../routes/app_routing.dart';



class SignInController extends GetxController {
  final _helper = GoogleSignInHelper.instance;

  SharedPreferencesHelper preferencesHelper = SharedPreferencesHelper();
  RxBool isLoading = false.obs;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String fcmToken = "";

  @override
  Future<void> onInit() async {
    await preferencesHelper.init();
    super.onInit();
  }

  Future<void> signIn() async {
    String? token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      fcmToken = token; // ✅ Assign it here
      log("FCM Token: $token");
    } else {
      log("❌ Failed to get FCM token.");
    }
    Map<String, dynamic> registration = {
      "email": emailController.text,
      "password": passwordController.text,
      "fcmToken": token,
    };
    log("the fcm token is $token");

    try {
      isLoading.value = true;

      String url = AppUrls.loginUrl;

      final response = await NetworkCaller().postRequest(
        url,
        body: registration,
      );

      if (response.isSuccess) {
        preferencesHelper.setString(
          "userToken",
          response.responseData['accessToken'],
        );
        log("the user id after login is ${response.responseData['id']}");
        preferencesHelper.setString('userId', response.responseData['id']);
        log("the user id after save is ${preferencesHelper.getString('userId')}");
        log("the api response is ${response.responseData}");
        Get.offAllNamed(AppRoute.setupProfile, arguments: {});
        final isSetup = response.responseData['isSetup'];
        if (isSetup) {
          preferencesHelper.setBool("isSetup", isSetup);
          CustomSnackBar.success(title: "Success", message: "User logged in successfully");


          Get.offAllNamed(AppRoute.mainView);
        } else {
          preferencesHelper.setBool("isSetup", isSetup);
          CustomSnackBar.success(title: "Success", message: "User logged in successfully");
          // Get.offAllNamed(AppRoute.settingGoalScreen);
        }
      } else {
        CustomSnackBar.error(title: "Error", message: response.errorMessage);
      }
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<Map<String, dynamic>?> continueWithGoogle() async {
    final user = await _helper.signInWithGoogle();
    if (user != null) {
      debugPrint("Name: ${user['name']}");
      debugPrint("Email: ${user['email']}");
      debugPrint("Photo URL: ${user['photoUrl']}");
      await sendToBackEnd(user['name'], user['email'], user['photoUrl']);
    }
    return null;
  }

  Future<void> sendToBackEnd(
    String name,
    String email,
    String? profileImage,
  ) async {
    isLoading.value = true;
    Map<String, dynamic> signInData = {
      "fullName": name,
      "email": email,
      "profileImage": profileImage ?? "",
    };
    try {
      var response = await NetworkCaller().postRequest(
        AppUrls.socialLogin,
        body: signInData,
      );

      if (response.isSuccess) {
        preferencesHelper.setString(
          "userToken",
          response.responseData['accessToken'],
        );
        final isSetup = response.responseData['isSetup'];
        if (isSetup) {
          preferencesHelper.setBool("isSetup", isSetup);
          CustomSnackBar.success(title: "Success", message: "User logged in successfully");

          // Get.offAllNamed(AppRoute.mainView);
        } else {
          preferencesHelper.setBool("isSetup", isSetup);
          CustomSnackBar.success(title: "Success", message: "User logged in successfully");
          // Get.offAllNamed(AppRoute.settingGoalScreen);
        }
      } else {
        CustomSnackBar.error(title: "Error", message: response.errorMessage);

      }
    } catch (e) {
      CustomSnackBar.error(title: "Error", message: e.toString());

    } finally {
      isLoading.value = false;
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
