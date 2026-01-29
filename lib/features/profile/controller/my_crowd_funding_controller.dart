import 'dart:developer';
import 'package:get/get.dart';
import 'dart:convert';
import '../../../core/helper/shared_prefarenses_helper.dart';
import '../../../core/services/network_caller/repository/network_caller.dart';
import '../../../core/utils/constants/app_urls.dart';
import '../data/my_crowd_funding_data_model.dart';

class MyCrowdFundController extends GetxController {
  var isLoading = false.obs;

  // THIS IS THE KEY: We store only the List<Event> directly!
  // No more wrapping in MyCrowdResult → eliminates all confusion
  var events = <Event>[].obs;
  RxList<MyCrowdResult> myCrowd = <MyCrowdResult>[].obs;
  final NetworkCaller networkCaller = NetworkCaller();
  final SharedPreferencesHelper helper = SharedPreferencesHelper();

  @override
  void onInit() {
    super.onInit();
    log("Controller initialized → calling API");
    getMyCrowdEvent();

  }

  Future<void> getMyCrowdEvent() async {
    String? token = helper.getString('userToken');
    log("the token during get single user $token");
    try {
      var response = await networkCaller.getRequest(
        AppUrls.getMyCrowdFund,
        token: token,
      );
      log("Response isSuccess: ${response.isSuccess}");
      log("Response data type: ${response.responseData.runtimeType}");
      if (response.isSuccess && response.responseData != null) {
        log("Raw API response: ${response.responseData}");
        Map<String, dynamic> resultData;

        if (response.responseData is String) {
          log("Response is String, decoding...");
          resultData = json.decode(response.responseData);
        } else if (response.responseData is Map) {
          log("Response is already a Map");
          resultData = Map<String, dynamic>.from(response.responseData);
        } else {
          log("Unexpected response type: ${response.responseData.runtimeType}");
          throw Exception("Unexpected response type");
        }
        log("Result data: $resultData");
        final userResult = MyCrowdResult.fromJson(resultData);
        myCrowd.value = [userResult];
      } else {
        log("Response not successful or data is null");
      }
    } catch (e, stackTrace) {
      log("Exception: ${e.toString()}");
      log("Stack trace: $stackTrace");
    } finally {
      isLoading.value = false;
      log("Loading completed, isLoading: ${isLoading.value}");
    }
  }
}
