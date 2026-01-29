import 'dart:developer';

import 'package:elites_live/core/global_widget/custom_loading.dart';
import 'package:elites_live/core/helper/shared_prefarenses_helper.dart';
import 'package:elites_live/core/services/network_caller/repository/network_caller.dart';
import 'package:elites_live/core/utils/constants/app_colors.dart';
import 'package:elites_live/core/utils/constants/app_urls.dart';
import 'package:elites_live/features/group/data/discoverGroup_data_model.dart';
import 'package:elites_live/features/group/data/joined_group_data_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class GroupController extends GetxController{
  final NetworkCaller networkCaller = NetworkCaller();
  final SharedPreferencesHelper helper = SharedPreferencesHelper();
  RxList<DiscoverGroupResult> discoverGroupList = <DiscoverGroupResult>[].obs;
  RxList<JoinedGroupResultResult> joinedGroupList = <JoinedGroupResultResult>[].obs;
  final TextEditingController searchTermController = TextEditingController();


  var isLoading = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    discoverGroup();
  }
  
  Future<void> joinedGroup()async{
    isLoading.value = true;
    String?token = helper.getString("userToken");
    log("the token during fetch my joined group  $token");
    try{
      var response = await networkCaller.getRequest(AppUrls.joinedGroup, token: token);
      if(response.isSuccess){
        log("the api response is ${response.responseData}");
        final myGroup = JoinedGroupDataModel.fromJson(response.responseData);
        joinedGroupList.assignAll(myGroup.result);
      }

    }

    catch(e){
      log("the exception is ${e.toString()}");
    }
    finally{
      isLoading.value = false;
    }
  }

  Future<void> discoverGroup() async {
    isLoading.value = true;
    String? token = helper.getString("userToken");
    log("the token during discover group $token");

    try {
      var response = await networkCaller.getRequest(AppUrls.discoverGroup, token: token);

      if (response.isSuccess) {
        log("the api response is ${response.responseData}");

        final data = response.responseData;

        // Handle both possible response types: Map or List
        if (data is Map<String, dynamic>) {
          // If wrapped inside an object with "result"
          if (data.containsKey("result") && data["result"] is List) {
            final List<dynamic> resultList = data["result"];
            discoverGroupList.assignAll(
              resultList.map((x) => DiscoverGroupResult.fromJson(x)).toList(),
            );
          } else {
            log("Unexpected Map format in API response: $data");
          }
        } else if (data is List) {
          // If API directly returns a list of groups
          discoverGroupList.assignAll(
            data.map((x) => DiscoverGroupResult.fromJson(x)).toList(),
          );
        } else {
          log("Unexpected data type in API response: ${data.runtimeType}");
        }
      } else {
        log("API call failed with message: ${response.errorMessage}");
      }
    } catch (e) {
      log("the exception is ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  /// search group
  Future<void> searchGroup(String search) async {
    isLoading.value = true;

    String? token = helper.getString("userToken");
    log("token during search group is $token");

    try {
      var response = await networkCaller.getRequest(AppUrls.searchGroup(search), token: token);

      if (response.isSuccess) {
        log("the api response is ${response.responseData}");

        final data = response.responseData;

        // Handle if API returns list directly
        if (data is List) {
          discoverGroupList.assignAll(
            data.map((x) => DiscoverGroupResult.fromJson(x)).toList(),
          );
        }

        // Handle if wrapped inside a map (fallback)
        else if (data is Map<String, dynamic> && data.containsKey("result")) {
          discoverGroupList.assignAll(
            (data["result"] as List)
                .map((x) => DiscoverGroupResult.fromJson(x))
                .toList(),
          );
        } else {
          log("Unexpected search API format: ${data.runtimeType}");
        }
      }
    } catch (e) {
      log("Exception in searchGroup: $e");
    } finally {
      isLoading.value = false;
    }
  }

  
  /// join group 
  Future<void> joinGroup(String groupId) async {
    isLoading.value = true;
    Get.dialog(
      CustomLoading(color: AppColors.primaryColor),
      barrierDismissible: false,
    );

    String? token = helper.getString("userToken");
    log("token during join group is $token");

    try {
      var response = await networkCaller.postRequest(
        AppUrls.joinGroup(groupId),
        body: {},
        token: token,
      );

      if (response.isSuccess) {
        await discoverGroup();
        // Close dialog on success
        if (Get.isDialogOpen ?? false) {
          Get.back();
        }
        // Optional: Show success message
        Get.snackbar(
          'Success',
          'Successfully joined the group',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        // Close dialog on failure
        if (Get.isDialogOpen ?? false) {
          Get.back();
        }
        // Optional: Show error message
        Get.snackbar(
          'Error',
          'Failed to join group',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      log("the exception is ${e.toString()}");
      // Close dialog on exception
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
      // Optional: Show error message
      Get.snackbar(
        'Error',
        'An error occurred: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }




}