import 'dart:developer';

import 'package:elites_live/core/helper/shared_prefarenses_helper.dart';

import 'package:elites_live/core/utils/constants/app_urls.dart';
import 'package:elites_live/features/profile/data/my_following_data_model.dart';
import 'package:elites_live/features/profile/data/user_data_model.dart';
import 'package:get/get.dart';

import '../../../core/services/network_caller/repository/network_caller.dart';

class ProfileController extends GetxController {
  RxBool isDiscoveryVisible = false.obs;
  var isLoading = false.obs;
  final NetworkCaller networkCaller = NetworkCaller();
  final SharedPreferencesHelper sharedPreferencesHelper = SharedPreferencesHelper();
  /// create a variable for user data
  /// var userData = Rxn<UserResult>();
   var userinfo = Rxn<UserResult>();



  final List<String> imageList = [
    'assets/images/event1.png',
    'assets/images/live2.png',
    'assets/images/live3.png',
    'assets/images/live4.png',
    'assets/images/live5.png',
    'assets/images/live6.png',
  ];
  @override
  void onInit() {
    // TODO: implement onInit

    getMyProfile();

    super.onInit();
  }

  void toggleDiscoveryVisibility() {
    isDiscoveryVisible.value = !isDiscoveryVisible.value;
  }

  /// get user profile
  Future<void> getMyProfile() async {
    isLoading.value = true;
    String? token = sharedPreferencesHelper.getString('userToken');
    log("the user token is $token");
    try {
      var response = await networkCaller.getRequest(AppUrls.user, token: token);
      if (response.statusCode == 200 && response.isSuccess) { // ✅ Check isSuccess
        log("the api response is ${response.responseData}");
        // ✅ Directly parse the result since responseData already contains only the result
        userinfo.value = UserResult.fromJson(response.responseData);
      }
    } catch (e) {
      log("the exception is ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  /// my following



}
