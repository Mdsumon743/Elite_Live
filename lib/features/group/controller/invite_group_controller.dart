import 'dart:async';
import 'dart:developer';
import 'package:elites_live/core/global_widget/custom_loading.dart';
import 'package:elites_live/core/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:elites_live/core/helper/shared_prefarenses_helper.dart';
import 'package:elites_live/core/services/network_caller/repository/network_caller.dart';
import 'package:elites_live/core/utils/constants/app_urls.dart';
import 'package:elites_live/features/group/data/group_user_data_model.dart';
import 'package:get/get.dart';
import 'dart:convert';




class InviteGroupController extends GetxController {
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  final NetworkCaller networkCaller = NetworkCaller();
  final SharedPreferencesHelper helper = SharedPreferencesHelper();
  final TextEditingController nameController = TextEditingController();
  Rx<GroupUserResult?> groupUserResult = Rx<GroupUserResult?>(null);

  Timer? _debounceTimer; // ✅ For debouncing search

  /// Debounced search - waits 500ms after user stops typing
  void debounceSearch(String groupId, String query) {
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer!.cancel();
    }

    _debounceTimer = Timer(Duration(milliseconds: 500), () {
      if (query.trim().isEmpty) {
        getUserInviteGroup(groupId);
      } else {
        searchPeople(groupId, query.trim());
      }
    });
  }

  /// Search people by name
  Future<void> searchPeople(String groupId, String search) async {
    isLoading.value = true;
    errorMessage.value = '';

    String? token = helper.getString("userToken");
    log("🔍 Searching for: $search in group: $groupId");

    try {
      var response = await networkCaller.getRequest(
        AppUrls.searchUser(groupId, search),
        token: token,
      );

      log("✅ Response isSuccess: ${response.isSuccess}");

      if (response.isSuccess && response.responseData != null) {
        log("📦 Search response: ${response.responseData}");

        Map<String, dynamic> jsonData;

        if (response.responseData is String) {
          jsonData = json.decode(response.responseData);
        } else if (response.responseData is Map<String, dynamic>) {
          jsonData = response.responseData;
        } else {
          throw Exception("Unexpected response type");
        }

        if (jsonData.containsKey('users')) {
          final userResult = GroupUserResult.fromJson(jsonData);
          groupUserResult.value = userResult;
          log("✅ Found ${userResult.users.length} users");
        } else if (jsonData.containsKey('result')) {
          final userData = GroupUserDataModel.fromJson(jsonData);
          if (userData.result != null) {
            groupUserResult.value = userData.result;
            log("✅ Found ${userData.result!.users.length} users");
          } else {
            throw Exception("Result is null");
          }
        } else {
          throw Exception("Unexpected JSON structure");
        }

        // Don't show snackbar for search, just log
        log("✅ Search completed successfully");

      } else {
        String error = response.errorMessage;
        errorMessage.value = error;
        log("❌ Search error: $error");

        Get.snackbar(
          'Search Error',
          error,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withValues(alpha: 0.8),
          colorText: Colors.white,
          duration: Duration(seconds: 2),
        );

        groupUserResult.value = null;
      }

    } catch (e, stackTrace) {
      errorMessage.value = 'Search failed: ${e.toString()}';
      log("❌ Search exception: ${e.toString()}");
      log("Stack trace: $stackTrace");

      Get.snackbar(
        'Error',
        'Search failed. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
        duration: Duration(seconds: 2),
      );

      groupUserResult.value = null;
    } finally {
      isLoading.value = false;
    }
  }

  /// Get all group users (no search filter)
  Future<void> getUserInviteGroup(String groupId) async {
    isLoading.value = true;
    errorMessage.value = '';

    String? token = helper.getString("userToken");
    log("📝 Fetching all users for group: $groupId");

    try {
      var response = await networkCaller.getRequest(
        AppUrls.groupUser(groupId),
        token: token,
      );

      if (response.isSuccess && response.responseData != null) {
        Map<String, dynamic> jsonData;

        if (response.responseData is String) {
          jsonData = json.decode(response.responseData);
        } else if (response.responseData is Map<String, dynamic>) {
          jsonData = response.responseData;
        } else {
          throw Exception("Unexpected response type");
        }

        if (jsonData.containsKey('users')) {
          final userResult = GroupUserResult.fromJson(jsonData);
          groupUserResult.value = userResult;
          log("✅ Loaded ${userResult.users.length} users");
        } else if (jsonData.containsKey('result')) {
          final userData = GroupUserDataModel.fromJson(jsonData);
          if (userData.result != null) {
            groupUserResult.value = userData.result;
            log("✅ Loaded ${userData.result!.users.length} users");
          } else {
            throw Exception("Result is null");
          }
        } else {
          throw Exception("Unexpected JSON structure");
        }

      } else {
        String error = response.errorMessage;
        errorMessage.value = error;
        log("❌ Error: $error");

        Get.snackbar(
          'Error',
          error,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withValues(alpha: 0.8),
          colorText: Colors.white,
          duration: Duration(seconds: 2),
        );

        groupUserResult.value = null;
      }

    } catch (e, stackTrace) {
      errorMessage.value = 'An error occurred: ${e.toString()}';
      log("❌ Exception: ${e.toString()}");
      log("Stack trace: $stackTrace");

      Get.snackbar(
        'Error',
        'Failed to load users. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
        duration: Duration(seconds: 2),
      );

      groupUserResult.value = null;
    } finally {
      isLoading.value = false;
    }
  }

  /// Invite user to group
  Future<void> inviteGroup(String groupId, String userId) async {
    log("📧 Inviting user ID: $userId to group: $groupId");

    // Show loading indicator
    Get.dialog(
      Center(child: CustomLoading(color: AppColors.primaryColor,)),
      barrierDismissible: false,
    );

    String? token = helper.getString("userToken");

    try {
      var response = await networkCaller.postRequest(
        AppUrls.inviteGroup(groupId, userId), // Your invite endpoint
        token: token,
        body: {
          'groupId': groupId,
          'userId': userId,
        },
      );

      // Close loading dialog
      Get.back();

      if (response.isSuccess) {
        log("✅ User invited successfully");

        Get.snackbar(
          'Success',
          'User invited successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withValues(alpha: 0.8),
          colorText: Colors.white,
          duration: Duration(seconds: 2),
        );

        // Optionally remove the invited user from the list
        if (groupUserResult.value != null) {
          final updatedUsers = groupUserResult.value!.users
              .where((user) => user.id != userId)
              .toList();

          groupUserResult.value = GroupUserResult(
            totalCount: groupUserResult.value!.totalCount - 1,
            totalPages: groupUserResult.value!.totalPages,
            currentPage: groupUserResult.value!.currentPage,
            users: updatedUsers,
          );
        }

      } else {
        String error = response.errorMessage;
        log("❌ Invite error: $error");

        Get.snackbar(
          'Error',
          error,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withValues(alpha: 0.8),
          colorText: Colors.white,
          duration: Duration(seconds: 3),
        );
      }

    } catch (e, stackTrace) {
      // Close loading dialog
      Get.back();

      log("❌ Invite exception: ${e.toString()}");
      log("Stack trace: $stackTrace");

      Get.snackbar(
        'Error',
        'Failed to invite user. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
    }
  }

  /// Retry loading users
  void retry(String groupId) {
    log("🔄 Retrying...");
    getUserInviteGroup(groupId);
  }

  /// Clear data
  void clearData() {
    groupUserResult.value = null;
    errorMessage.value = '';
    nameController.clear();
  }

  @override
  void onClose() {
    _debounceTimer?.cancel();
    nameController.dispose();
    super.onClose();
  }
}