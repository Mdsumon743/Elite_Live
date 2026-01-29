import 'dart:developer';

import 'package:elites_live/core/global_widget/custom_loading.dart';
import 'package:elites_live/core/utils/constants/app_colors.dart';
import 'package:elites_live/core/utils/constants/app_urls.dart';
import 'package:get/get.dart';

import '../../../core/helper/shared_prefarenses_helper.dart';
import '../../../core/services/network_caller/repository/network_caller.dart';
import '../../../routes/app_routing.dart';

class SettingsController extends GetxController {
  RxBool isDiscoveryVisible = false.obs;
  final NetworkCaller networkCaller = NetworkCaller();
  final SharedPreferencesHelper helper = SharedPreferencesHelper();

  var isLoading = false.obs;

  void toggleDiscoveryVisibility() {
    isDiscoveryVisible.value = !isDiscoveryVisible.value;
  }


  /// delete account
   Future<void> deleteAccount()async{
    isLoading.value = true;
    Get.dialog(CustomLoading(color: AppColors.primaryColor,), barrierDismissible: false);
    String? token = helper.getString("userToken");
    log("The token during delete account  is $token");

    try{

      var response = await networkCaller.deleteRequest(AppUrls.deleteAccount, token);

      if (Get.isDialogOpen == true) Get.back();

      if (response.isSuccess) {
        Get.snackbar("Success", "The password was successfully changed");
        Get.offAllNamed(AppRoute.splash);        // safer navigation
      } else {
        Get.snackbar("Error", response.errorMessage);
      }


    }
    catch(e){
      if (Get.isDialogOpen == true) Get.back();
      log("The exception is: ${e.toString()}");

      Get.snackbar("Error", "Something went wrong. Try again later");

    }

    finally{
      isLoading.value = false;
    }

   }





}
