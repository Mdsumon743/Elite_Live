import 'dart:developer';

import 'package:elites_live/core/helper/shared_prefarenses_helper.dart';
import 'package:elites_live/core/services/network_caller/repository/network_caller.dart';
import 'package:elites_live/core/utils/constants/app_urls.dart';
import 'package:elites_live/features/profile/data/connected_account_balance_data_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EarningsController extends GetxController {
  // 0 = Ads Revenue, 1 = Funding


  // Example summary data (these can be fetched later)
  final double totalEarnings = 16.18;
  final int transactions = 12;
  final int progress = 8;
  final int waiting = 4;
  final NetworkCaller networkCaller = NetworkCaller();
  final SharedPreferencesHelper helper = SharedPreferencesHelper();
  var isLoading = false.obs;
  RxList<ConnectedAccountBalanceResult> balanceHistory = <ConnectedAccountBalanceResult>[].obs;
  final TextEditingController amountController = TextEditingController();

  @override
  void onInit() {
    // TODO: implement onInit
    getConnectedAccountBalance();
    super.onInit();
  }


  /// get Connected Account Balance
  Future<void> getConnectedAccountBalance() async {
    isLoading.value = true;
    String? token = helper.getString('userToken');

    log("token during fetch connected Balance: $token");

    try {
      var response = await networkCaller.getRequest(
        AppUrls.getConnectedAccountBalance,
        token: token,
      );

      if (!response.isSuccess) {
        log("❌ API returned error: ${response.errorMessage}");
        return;
      }

      if (response.responseData == null) {
        log("❌ responseData is NULL");
        return;
      }

      // SAFETY CHECK → ensure result exists
      if (response.responseData is! Map<String, dynamic>) {
        log("❌ Invalid response format");
        return;
      }

      final Map<String, dynamic> resultMap = response.responseData;

      if (!resultMap.containsKey("available") ||
          !resultMap.containsKey("withdrawable")) {
        log("❌ Missing balance keys — API changed?");
        return;
      }

      // Parse safely
      final currentBalance =
      ConnectedAccountBalanceResult.fromJson(resultMap);

      // SAFETY CHECK → ensure list is not null
      currentBalance.transactionHistory =
          currentBalance.transactionHistory ?? [];

      // Update observable list
      balanceHistory.assignAll([currentBalance]);

      log("✅ Balance updated successfully");

    } catch (e) {
      log("❌ Exception inside getConnectedAccountBalance(): $e");
    } finally {
      isLoading.value = false;
    }
  }



  Future<void> instantPayout() async {
    if (isLoading.value) return; // prevent double call

    final withdrawable = balanceHistory.first.withdrawable;

    String amountText = amountController.text.trim();
    if (amountText.isEmpty) {
      Get.snackbar("Enter Amount", "Please enter an amount to withdraw.");
      return;
    }

    double? amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) {
      Get.snackbar("Invalid Amount", "Please enter a valid amount.");
      return;
    }

    if (amount > withdrawable) {
      Get.snackbar("Insufficient Balance",
          "You cannot withdraw more than available withdrawable balance.");
      return;
    }

    isLoading.value = true;

    try {
      final token = helper.getString("userToken");

      var response = await networkCaller.postRequest(
        AppUrls.instantPayout,
        body: {"amount": amount},
        token: token,
      );

      if (response.isSuccess) {
        Get.back(); // close sheet
        amountController.clear();

        Get.snackbar(
          "Success",
          "Withdrawal request submitted successfully.",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        getConnectedAccountBalance();
      } else {
        Get.snackbar(
          "Error",
          response.errorMessage ?? "Failed to process payout.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar("Exception", e.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }


}
