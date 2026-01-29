import 'dart:developer';
import 'package:elites_live/core/global_widget/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:elites_live/core/helper/shared_prefarenses_helper.dart';
import 'package:elites_live/core/services/network_caller/repository/network_caller.dart';
import 'package:elites_live/core/utils/constants/app_urls.dart';
import 'package:get/get.dart';


import '../data/others_user_list_data_model.dart';
import '../data/recorded_live_event.dart';
import '../data/user_tab_data_model.dart';
import '../data/video _tab_model.dart';

class SearchScreenController extends GetxController {
  var searchText = ''.obs;
  var selectedTab = 0.obs; // 0 = All, 1 = Live, 2 = Video, 3 = User
  RxList<OthersUserListResult> othersList = <OthersUserListResult>[].obs;
  var isLoading = false.obs;
  final NetworkCaller networkCaller = NetworkCaller();
  final SharedPreferencesHelper helper = SharedPreferencesHelper();
  final TextEditingController searchController = TextEditingController();
  RxList<AllRecordingResult> allRecordingList = <AllRecordingResult>[].obs;

  @override
  void onInit() {
    // TODO: implement onInit
    getOtherUserList();
    getAllRecordingList();
    super.onInit();
  }

  /// get all recording
  Future<void> getAllRecordingList() async {
    isLoading.value = true;

    String? token = helper.getString('userToken');
    log("the token during fetch othersList: $token");

    try {
      var response = await networkCaller.getRequest(AppUrls.getAllRecordingVideo, token: token);

      if (response.isSuccess) {
        log("the api response of all recording list  ${response.responseData}");

        // Fix: Check if responseData is already the full JSON or just the result array
        if (response.responseData is Map<String, dynamic>) {
          // If it's a Map, parse normally
          final others = AllRecordingDataModel.fromJson(response.responseData);
          allRecordingList.assignAll(others.result);
        } else if (response.responseData is List) {
          // If it's a List, create the wrapper manually
          final resultList = List<AllRecordingResult>.from(
              response.responseData.map((x) => AllRecordingResult.fromJson(x))
          );
          allRecordingList.assignAll(resultList);
        }

        log("Successfully loaded ${allRecordingList.length} users");
      } else {

        log("API request failed: ${response.statusCode}");
      }
    } catch (e) {

      log("the exception is ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }


  /// get others user

  Future<void> getOtherUserList() async {
    isLoading.value = true;

    String? token = helper.getString('userToken');
    log("the token during fetch othersList: $token");

    try {
      var response = await networkCaller.getRequest(AppUrls.getOtherUser, token: token);

      if (response.isSuccess) {
        log("the api response is ${response.responseData}");

        // Fix: Check if responseData is already the full JSON or just the result array
        if (response.responseData is Map<String, dynamic>) {
          // If it's a Map, parse normally
          final others = OthersUserList.fromJson(response.responseData);
          othersList.assignAll(others.result);
        } else if (response.responseData is List) {
          // If it's a List, create the wrapper manually
          final resultList = List<OthersUserListResult>.from(
              response.responseData.map((x) => OthersUserListResult.fromJson(x))
          );
          othersList.assignAll(resultList);
        }

        log("Successfully loaded ${othersList.length} users");
      } else {

        log("API request failed: ${response.statusCode}");
      }
    } catch (e) {

      log("the exception is ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }
  
  /// search user 
  Future<void> searchOtherUser(String search) async {
    isLoading.value = true;

    String? token = helper.getString('userToken');
    log("the token during fetch othersList: $token");

    try {
      var response = await networkCaller.getRequest(AppUrls.searchOtherUser(search), token: token);

      if (response.isSuccess) {
        log("the api response is ${response.responseData}");

        // Fix: Check if responseData is already the full JSON or just the result array
        if (response.responseData is Map<String, dynamic>) {
          // If it's a Map, parse normally
          final others = OthersUserList.fromJson(response.responseData);
          othersList.assignAll(others.result);
        } else if (response.responseData is List) {
          // If it's a List, create the wrapper manually
          final resultList = List<OthersUserListResult>.from(
              response.responseData.map((x) => OthersUserListResult.fromJson(x))
          );
          othersList.assignAll(resultList);
        }

        log("Successfully loaded ${othersList.length} users");
      } else {

        log("API request failed: ${response.statusCode}");
      }
    } catch (e) {

      log("the exception is ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  /// follow unfollow user
  Future<void> followUnFlow(String userId) async {
    isLoading.value = true;

    // SHOW LOADER
    /*Get.dialog(
      CustomLoading(color: AppColors.primaryColor),
      barrierDismissible: false,
    );
*/
    String? token = helper.getString("userToken");
    log("token during follow user is $token");

    try {
      var response = await networkCaller.postRequest(
        AppUrls.followUser(userId),
        body: {},
        token: token,
      );

      // ALWAYS CLOSE LOADING
      if (Get.isDialogOpen ?? false) Get.back();

      if (response.isSuccess) {
        log("the api response is ${response.responseData}");

        // SUCCESS SNACK


        // REFRESH LIST
        await getOtherUserList();
      } else {
        // ERROR SNACK
        CustomSnackBar.error(title: "Failed", message: response.errorMessage);


      }
    } catch (e) {
      log("Exception: ${e.toString()}");

      // ENSURE LOADING CLOSED ON ERROR
      if (Get.isDialogOpen ?? false) Get.back();
      CustomSnackBar.error(title: "Error", message: e.toString());


    } finally {
      isLoading.value = false;
    }
  }



  // Tab control
  void onTabSelected(int index) => selectedTab.value = index;
  void onSearchChanged(String value) => searchText.value = value;

  // Recent actions
  void removeRecentItem(String name) => recentList.remove(name);
  void clearHistory() => recentList.clear();



  // Recent and Suggested
  var recentList = <String>[
    "Theresa Webb",
    "Cameron Williamson",
    "Floyd Miles",
    "Savannah Nguyen",
    "Savannah Nguyen",
    "Savannah Nguyen",
  ].obs;

  var suggestedList = <String>[
    "Theresa Webb",
    "Cameron Williamson",
    "Savannah Nguyen",
    "Floyd Miles"
  ].obs;



  // Live Tab Data
  var liveList = <Map<String, dynamic>>[
    {
      'image': 'assets/images/live1.png',
      'viewers': '5.6k',
    },
    {
      'image': 'assets/images/live2.png',
      'viewers': '5.8k',
    },
    {
      'image': 'assets/images/live3.png',
      'viewers': '5.1k',
    },
    {
      'image': 'assets/images/live4.png',
      'viewers': '5.9k',
    },
    {
      'image': 'assets/images/live5.png',
      'viewers': '6.2k',
    },
    {
      'image': 'assets/images/live6.png',
      'viewers': '6.5k',
    },
    {
      'image': 'assets/images/live6.png',
      'viewers': '6.5k',
    },
    {
      'image': 'assets/images/live6.png',
      'viewers': '6.5k',
    },
    {
      'image': 'assets/images/live6.png',
      'viewers': '6.5k',
    },
    {
      'image': 'assets/images/live6.png',
      'viewers': '6.5k',
    },
  ].obs;


  // Video tab data using model
  var videoList = <VideoModel>[
    VideoModel(
      name: 'Ariana Grande',
      username: '@arianagrande',
      views: '728.5k',
      time: '05:00',
      image: 'assets/images/live1.png',
    ),
    VideoModel(
      name: 'Taylor Swift',
      username: '@taylorswift',
      views: '1.2M',
      time: '08:20',
      image: 'assets/images/live2.png',
    ),
    VideoModel(
      name: 'Selena Gomez',
      username: '@selenagomez',
      views: '985.3k',
      time: '03:50',
      image: 'assets/images/live3.png',
    ),
    VideoModel(
      name: 'Justin Bieber',
      username: '@justinbieber',
      views: '875.1k',
      time: '06:40',
      image: 'assets/images/live4.png',
    ),
    VideoModel(
      name: 'Justin Bieber',
      username: '@justinbieber',
      views: '875.1k',
      time: '06:40',
      image: 'assets/images/live5.png',
    ),
    VideoModel(
      name: 'Justin Bieber',
      username: '@justinbieber',
      views: '875.1k',
      time: '06:40',
      image: 'assets/images/live6.png',
    ),
  ].obs;


  //user_tab_data
  var userList = <UserTabDataModel>[
    UserTabDataModel(
      name: 'Marvin McKinney',
      username: 'Arianagrande',
      followers: '200k Followers',
      image: 'assets/images/live6.png',
    ),
    UserTabDataModel(
      name: 'Darrell Steward',
      username: 'Arianagrande',
      followers: '200k Followers',
      image: 'assets/images/live5.png',
    ),
    UserTabDataModel(
      name: 'Darlene Robertson',
      username: 'Arianagrande',
      followers: '200k Followers',
      image: 'assets/images/live2.png',
    ),
    UserTabDataModel(
      name: 'Guy Hawkins',
      username: 'Arianagrande',
      followers: '200k Followers',
      image: 'assets/images/live4.png',
    ),
    UserTabDataModel(
      name: 'Savannah Nguyen',
      username: 'Arianagrande',
      followers: '200k Followers',
      image: 'assets/images/live1.png',
    ),
    UserTabDataModel(
      name: 'Devon Lane',
      username: 'Arianagrande',
      followers: '200k Followers',
      image: 'assets/images/live3.png',
    ),
    UserTabDataModel(
      name: 'Jacob Jones',
      username: 'Arianagrande',
      followers: '200k Followers',
      image: 'assets/images/live2.png',
    ),
    UserTabDataModel(
      name: 'Dianne Russell',
      username: 'Arianagrande',
      followers: '200k Followers',
      image: 'assets/images/live1.png',
    ),
  ].obs;

}



