import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../core/helper/shared_prefarenses_helper.dart';
import '../../../core/services/network_caller/repository/network_caller.dart';
import '../../../core/utils/constants/app_urls.dart';
import '../data/joined_group_data_model.dart';

class MyGroupController extends GetxController {
  final NetworkCaller networkCaller = NetworkCaller();
  final SharedPreferencesHelper helper = SharedPreferencesHelper();
  final TextEditingController searchTermController = TextEditingController();

  RxList<JoinedGroupResultResult> joinedGroupList =
      <JoinedGroupResultResult>[].obs;

  var isLoading = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    joinedGroup();
    super.onInit();
  }

  Future<void> joinedGroup() async {
    isLoading.value = true;
    String? token = helper.getString("userToken");
    log("the token during fetch my joined group $token");

    try {
      var response = await networkCaller.getRequest(
        AppUrls.joinedGroup,
        token: token,
      );

      if (response.isSuccess) {
        log("the api response is ${response.responseData}");

        if (response.responseData is List) {
          joinedGroupList.assignAll(
            (response.responseData as List)
                .map(
                  (item) => JoinedGroupResultResult.fromJson(
                    item as Map<String, dynamic>,
                  ),
                )
                .toList(),
          );

          log("Successfully loaded ${joinedGroupList.length} groups");
        } else if (response.responseData is Map<String, dynamic>) {
          final myGroup = JoinedGroupDataModel.fromJson(response.responseData);
          joinedGroupList.assignAll(myGroup.result);

          log("Successfully loaded ${joinedGroupList.length} groups");
        } else {
          log("Unexpected response type: ${response.responseData.runtimeType}");
        }
      }
    } catch (e, stackTrace) {
      log("the exception is ${e.toString()}");
      log("Stack trace: $stackTrace");
    } finally {
      isLoading.value = false;
    }
  }

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
          joinedGroupList.assignAll(
            data.map((x) => JoinedGroupResultResult.fromJson(x)).toList(),
          );
        }

        // Handle if wrapped inside a map (fallback)
        else if (data is Map<String, dynamic> && data.containsKey("result")) {
          joinedGroupList.assignAll(
            (data["result"] as List)
                .map((x) => JoinedGroupResultResult.fromJson(x))
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
}
