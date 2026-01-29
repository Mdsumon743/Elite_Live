import 'dart:developer';
import 'package:elites_live/core/helper/shared_prefarenses_helper.dart';
import 'package:elites_live/core/utils/constants/app_urls.dart';
import 'package:elites_live/features/profile/data/my_follower_data_model.dart';
import 'package:elites_live/features/profile/data/my_following_data_model.dart';
import 'package:get/get.dart';
import '../../../core/services/network_caller/repository/network_caller.dart';

class FollowingFollwerController extends GetxController {
  RxBool isDiscoveryVisible = false.obs;
  var isLoading = false.obs;
  final NetworkCaller networkCaller = NetworkCaller();
  final SharedPreferencesHelper sharedPreferencesHelper = SharedPreferencesHelper();

  // ✅ Initialize with empty observable list
  final myFollowing = <MyFollowingResult>[].obs;
  final myFollower = <MyFollowerResult>[].obs;

  @override
  void onInit() {
    super.onInit();
    log("FollowingFollwerController onInit called");
    getMyFollowing();
    getMyFollower();
    ever(searchText, (_) => filterFollowingList());
  }

  var searchText = ''.obs;
  RxList<MyFollowingResult> filteredFollowing = <MyFollowingResult>[].obs;



  // Filter following based on search
  void filterFollowingList() {
    final query = searchText.value.toLowerCase().trim();
    if (query.isEmpty) {
      filteredFollowing.assignAll(myFollowing);
    } else {
      filteredFollowing.assignAll(
        myFollowing.where((item) {
          final fullName = "${item.user.firstName ?? ""} ${item.user.lastName ?? ""}".toLowerCase();
          return fullName.contains(query);
        }).toList(),
      );
    }
  }

  void toggleDiscoveryVisibility() {
    isDiscoveryVisible.value = !isDiscoveryVisible.value;
  }




  /// my following
  Future<void> getMyFollowing() async {
    log("=== getMyFollowing started ===");

    String? token = sharedPreferencesHelper.getString("userToken");
    log("Token: $token");

    try {
      isLoading.value = true;

      var response = await networkCaller.getRequest(
        AppUrls.myFollowing,
        token: token,
      );

      log("Response status code: ${response.statusCode}");
      log("Response isSuccess: ${response.isSuccess}");
      log("Response data type: ${response.responseData.runtimeType}");
      log("Response data: ${response.responseData}");

      if (response.isSuccess && response.statusCode == 200) {

        // Check if response data exists
        if (response.responseData == null) {
          log("ERROR: responseData is null");
          myFollowing.clear();
          return;
        }

        // ✅ FIX: Check if responseData is a List or Map
        List<dynamic> resultList;

        if (response.responseData is List) {
          // Response is directly a list
          log("Response is a List");
          resultList = response.responseData;
        } else if (response.responseData is Map && response.responseData['result'] != null) {
          // Response is a map with 'result' field
          log("Response is a Map with result field");
          resultList = response.responseData['result'];
        } else {
          log("ERROR: Unexpected response format");
          myFollowing.clear();
          return;
        }

        log("Result list length from API: ${resultList.length}");

        if (resultList.isEmpty) {
          log("WARNING: Result list is empty");
          myFollowing.clear();
          return;
        }

        // Parse the list
        final List<MyFollowingResult> followingList = [];
        for (var item in resultList) {
          try {
            final following = MyFollowingResult.fromJson(item);
            followingList.add(following);
            log("Parsed user: ${following.user.firstName} ${following.user.lastName}");
          } catch (e) {
            log("ERROR parsing item: $e");
            log("Problematic item: $item");
          }
        }

        log("Total parsed following list: ${followingList.length}");

        // Assign to observable list
        myFollowing.assignAll(followingList);

        log("Successfully assigned ${myFollowing.length} following users");

        // Force refresh
        myFollowing.refresh();

      } else {
        log("API call was not successful. Status: ${response.statusCode}");
        myFollowing.clear();
      }
    } catch (e, stackTrace) {
      log("Exception in getMyFollowing: ${e.toString()}");
      log("Stack trace: $stackTrace");
      myFollowing.clear();
    } finally {
      isLoading.value = false;
      log("=== getMyFollowing completed, final count: ${myFollowing.length} ===");
    }
  }


  /// my followr
  Future<void> getMyFollower() async {
    log("=== getMyFollowing started ===");

    String? token = sharedPreferencesHelper.getString("userToken");
    log("Token: $token");

    try {
      isLoading.value = true;

      var response = await networkCaller.getRequest(
        AppUrls.myFollower,
        token: token,
      );

      log("Response status code: ${response.statusCode}");
      log("Response isSuccess: ${response.isSuccess}");
      log("Response data type: ${response.responseData.runtimeType}");
      log("Response data: ${response.responseData}");

      if (response.isSuccess && response.statusCode == 200) {

        // Check if response data exists
        if (response.responseData == null) {
          log("ERROR: responseData is null");
          myFollower.clear();
          return;
        }

        // ✅ FIX: Check if responseData is a List or Map
        List<dynamic> resultList;

        if (response.responseData is List) {
          // Response is directly a list
          log("Response is a List");
          resultList = response.responseData;
        } else if (response.responseData is Map && response.responseData['result'] != null) {
          // Response is a map with 'result' field
          log("Response is a Map with result field");
          resultList = response.responseData['result'];
        } else {
          log("ERROR: Unexpected response format");
          myFollower.clear();
          return;
        }

        log("Result list length from API: ${resultList.length}");

        if (resultList.isEmpty) {
          log("WARNING: Result list is empty");
          myFollower.clear();
          return;
        }

        // Parse the list
        final List<MyFollowerResult> followerList = [];
        for (var item in resultList) {
          try {
            final following = MyFollowerResult.fromJson(item);
            followerList.add(following);
            log("Parsed user: ${following.user.firstName} ${following.user.lastName}");
          } catch (e) {
            log("ERROR parsing item: $e");
            log("Problematic item: $item");
          }
        }

        log("Total parsed following list: ${followerList.length}");

        // Assign to observable list
        myFollower.assignAll(followerList);

        log("Successfully assigned ${myFollower.length} following users");

        // Force refresh
        myFollower.refresh();

      } else {
        log("API call was not successful. Status: ${response.statusCode}");
        myFollower.clear();
      }
    } catch (e, stackTrace) {
      log("Exception in getMyFollowing: ${e.toString()}");
      log("Stack trace: $stackTrace");
      myFollower.clear();
    } finally {
      isLoading.value = false;
      log("=== getMyFollowing completed, final count: ${myFollower.length} ===");
    }
  }
}