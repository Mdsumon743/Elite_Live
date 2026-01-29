import 'dart:developer';
import 'package:elites_live/core/global_widget/custom_loading.dart';
import 'package:elites_live/core/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:elites_live/core/helper/shared_prefarenses_helper.dart';
import 'package:elites_live/core/services/network_caller/repository/network_caller.dart';
import 'package:elites_live/core/utils/constants/app_urls.dart';
import 'package:get/get.dart';

class WalletController extends GetxController {
  var totalEarning = 16.18.obs;

  var isLoading = false.obs;
  final NetworkCaller networkCaller = NetworkCaller();
  final SharedPreferencesHelper helper = SharedPreferencesHelper();
  Future<void> connectedAccountSetUp() async {
    // Show loading dialog
    Get.dialog(
      Center(child: CustomLoading(color: AppColors.primaryColor,)),
      barrierDismissible: false,
    );

    isLoading.value = true;

    String? token = helper.getString('userToken');
    log("🔐 Token used to create connected account: $token");

    try {
      var response = await networkCaller.postRequest(
        AppUrls.createPayoutAccount,
        body: {},
        token: token,
      );

      if (response.isSuccess) {
        log("✅ API Response: ${response.responseData}");

        // Close loading dialog
        if (Get.isDialogOpen ?? false) Get.back();

        // Show success message
        Get.snackbar(
          "Success",
          "Stripe connected account created successfully!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          margin: const EdgeInsets.all(12),
        );
      } else {
        // Close loading dialog
        if (Get.isDialogOpen ?? false) Get.back();

        // Show error message
        Get.snackbar(
          "Error",
          response.errorMessage ?? "Failed to create connected account",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          margin: const EdgeInsets.all(12),
        );
      }
    } catch (e) {
      log("❌ Exception: ${e.toString()}");

      // Close loading dialog
      if (Get.isDialogOpen ?? false) Get.back();

      // Show error snackbar
      Get.snackbar(
        "Error",
        "Something went wrong!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
      );
    } finally {
      isLoading.value = false;
    }
  }


  var transactions = <Map<String, dynamic>>[
    {
      'title': 'Payment to ABS Fresh',
      'date': 'Sep 28, 2025 - 10:32 AM',
      'amount': 250.00,
    },
    {
      'title': 'Wallet Top-Up (Bkash)',
      'date': 'Sep 26, 2025 - 04:45 PM',
      'amount': 500.00,
    },
    {
      'title': 'Refund from ValAcademy',
      'date': 'Sep 26, 2025 - 04:45 PM',
      'amount': 500.00,
    },
    {
      'title': 'Payment to THRDZ Store',
      'date': 'Sep 20, 2025 - 09:05 PM',
      'amount': 75.00,
    },
    {
      'title': 'Payment to THRDZ Store',
      'date': 'Sep 20, 2025 - 09:05 PM',
      'amount': 75.00,
    },
    {
      'title': 'Payment to THRDZ Store',
      'date': 'Sep 20, 2025 - 09:05 PM',
      'amount': 75.00,
    },
  ].obs;
}
