import 'dart:developer';

import 'package:elites_live/core/global_widget/custom_loading.dart';
import 'package:elites_live/core/global_widget/custom_snackbar.dart';
import 'package:elites_live/core/helper/shared_prefarenses_helper.dart';
import 'package:elites_live/core/services/network_caller/repository/network_caller.dart';
import 'package:elites_live/core/utils/constants/app_colors.dart';
import 'package:elites_live/core/utils/constants/app_urls.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/my_following_data_model.dart';



import 'dart:developer';

import 'package:elites_live/core/global_widget/custom_loading.dart';
import 'package:elites_live/core/global_widget/custom_snackbar.dart';
import 'package:elites_live/core/helper/shared_prefarenses_helper.dart';
import 'package:elites_live/core/services/network_caller/repository/network_caller.dart';
import 'package:elites_live/core/utils/constants/app_colors.dart';
import 'package:elites_live/core/utils/constants/app_urls.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/my_following_data_model.dart';

class ModeratorController extends GetxController {
  // FIXED: must be nullable
  final Rx<String?> selectedSlowMode = Rx<String?>(null);

  var isLoading = false.obs;

  final SharedPreferencesHelper helper = SharedPreferencesHelper();
  final NetworkCaller networkCaller = NetworkCaller();

  // selected moderator model
  var selectedModerator = Rxn<MyFollowingResult>();

  // Slow mode options
  final slowModes = ['5 Minutes', '10 Minutes', '15 Minutes', '30 Minutes'];

  // Map for converting labels to seconds
  final Map<String, int> slowModeSeconds = {
    '5 Minutes': 300,
    '10 Minutes': 600,
    '15 Minutes': 900,
    '30 Minutes': 1800,
  };

  // Toggles
  var userBanned = false.obs;
  var subOnly = false.obs;

  /// Add moderator
  Future<void> addModerator(String userId) async {
    if (selectedSlowMode.value == null) {
      Get.snackbar(
        'Error',
        'Please select moderator access duration',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    Get.dialog(
      CustomLoading(color: AppColors.primaryColor),
      barrierDismissible: false,
    );

    String? token = helper.getString("userToken");
    String? id = helper.getString("userId");

    log("Token: $token | App UserId: $id");

    try {
      int slowModeValue = slowModeSeconds[selectedSlowMode.value] ?? 300;

      var response = await networkCaller.postRequest(
        AppUrls.addModerator(userId),
        body: {
          "slowMode": slowModeValue,
          "isBanned": userBanned.value,
          "isSubOnly": subOnly.value,
        },
        token: token,
      );

      Get.back();

      if (response.isSuccess && response.statusCode == 201) {
        CustomSnackBar.success(
            title: "Success", message: "Moderator added successfully");

        resetForm();
        Get.back();
      } else {
        Get.snackbar(
          'Error',
          response.errorMessage,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade600,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.back();
      log("Error adding moderator: $e");
      CustomSnackBar.error(
          title: "Error", message: "An error occurred while adding moderator");
    } finally {
      isLoading.value = false;
    }
  }

  void resetForm() {
    selectedSlowMode.value = null; // FIXED
    userBanned.value = false;
    subOnly.value = false;
    selectedModerator.value = null; // optional reset
  }
}

