
import 'dart:developer';
import 'dart:io';
import 'package:elites_live/core/helper/shared_prefarenses_helper.dart';
import 'package:elites_live/core/services/network_caller/repository/network_caller.dart';
import 'package:elites_live/core/utils/constants/app_urls.dart';
import 'package:elites_live/core/utils/constants/image_path.dart';
import 'package:elites_live/features/home/data/all_stream_data_model.dart';
import 'package:elites_live/features/home/data/top_influencer_live_data_model.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../data/comment_data_model.dart';
import '../data/following_recorded_data_model.dart';



class HomeController extends GetxController {
  var searchText = ''.obs;
  var selectedTab = 0.obs;
  var commentText = ''.obs;
  var selectedDonationAmount = 0.0.obs;
  var isLoading = false.obs;
  final NetworkCaller networkCaller = NetworkCaller();
  final SharedPreferencesHelper helper = SharedPreferencesHelper();
  RxList<Event> allStreamList = <Event>[].obs;
  RxList<FollowingEvent> followingStreamList = <FollowingEvent>[].obs;
  RxList<TopInfluencerLiveResult> topInfluencerLiveList = <TopInfluencerLiveResult>[].obs;
  RxInt currentPage = 1.obs;
  RxInt limit = 10.obs;

  @override
  void onInit() {
    super.onInit();
    topInfluencerLiveLive();

    getAllRecordedLive(currentPage.value, limit.value);
  }

  /// get all recording
  Future<void> getAllRecordedLive(int currentPage, int limit) async {
    isLoading.value = true;



    String? token = helper.getString("userToken");

    try {
      var response = await networkCaller.getRequest(
        AppUrls.getAllRecordedLive(currentPage, limit),
        token: token,
      );

      if (response.isSuccess) {
        log("The recorded live is ${response.responseData}");


        final result = AllStreamResult.fromJson(response.responseData);

        allStreamList.clear();
        allStreamList.assignAll(result.events);

        log("Total events loaded: ${allStreamList.length}");
        allStreamList.refresh();

      } else {
        log("API Error: ${response.errorMessage}");
        Get.snackbar(
          'Error',
          response.errorMessage ?? 'Failed to load events',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e, stackTrace) {
      log("Exception: ${e.toString()}");
      log("StackTrace: ${stackTrace.toString()}");
      Get.snackbar(
        'Error',
        'Something went wrong: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;


    }
  }
  /// get following recorded live
  Future<void> getFollowingRecordedLive(int currentPage, int limit) async {
    isLoading.value = true;



    String? token = helper.getString("userToken");

    try {
      var response = await networkCaller.getRequest(
        AppUrls.getAllFollowingRecordedLive(currentPage, limit),
        token: token,
      );

      if (response.isSuccess) {
        log("The recorded live is ${response.responseData}");


        final result = AllFollowingEventResult.fromJson(response.responseData);

        followingStreamList.clear();
        followingStreamList.assignAll(result.events);

        log("Total events loaded: ${followingStreamList.length}");
        followingStreamList.refresh();

      } else {
        log("API Error: ${response.errorMessage}");
        Get.snackbar(
          'Error',
          response.errorMessage ?? 'Failed to load events',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e, stackTrace) {
      log("Exception: ${e.toString()}");
      log("StackTrace: ${stackTrace.toString()}");
      Get.snackbar(
        'Error',
        'Something went wrong: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;


    }
  }

  /// top influencer Live
  Future<void> topInfluencerLiveLive() async {
    isLoading.value = true;

    String? token = helper.getString("userToken");

    try {
      var response = await networkCaller.getRequest(
        AppUrls.topInfluencerLive,
        token: token,
      );

      if (response.isSuccess) {
        log("The top influencer live is ${response.responseData}");

        // Check if response is a List or Map
        if (response.responseData is List) {
          // Direct list of results
          final List<dynamic> dataList = response.responseData;
          topInfluencerLiveList.clear();
          topInfluencerLiveList.assignAll(
              dataList.map((item) => TopInfluencerLiveResult.fromJson(item)).toList()
          );
        } else if (response.responseData is Map<String, dynamic>) {
          // Wrapped in success/message/result structure
          final result = TopInfluencerLiveDataModel.fromJson(response.responseData);
          topInfluencerLiveList.clear();
          topInfluencerLiveList.assignAll(result.result);
        }

        log("Total events loaded: ${topInfluencerLiveList.length}");
        topInfluencerLiveList.refresh();

      } else {
        log("API Error: ${response.errorMessage}");
        Get.snackbar(
          'Error',
          response.errorMessage ?? 'Failed to load events',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e, stackTrace) {
      log("Exception: ${e.toString()}");
      log("StackTrace: ${stackTrace.toString()}");
      Get.snackbar(
        'Error',
        'Something went wrong: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Method to get filtered events based on tab
  List<Event> get filteredEvents {
    if (searchText.value.isEmpty) {
      return allStreamList;
    }

    return allStreamList.where((event) {
      final searchLower = searchText.value.toLowerCase();
      return event.title.toLowerCase().contains(searchLower) ||
          event.text.toLowerCase().contains(searchLower) ||
          event.user.firstName.toLowerCase().contains(searchLower) ||
          event.user.lastName.toLowerCase().contains(searchLower);
    }).toList();
  }

  // Get live events only
  List<Event> get liveEvents {
    return allStreamList.where((event) => event.stream.isLive).toList();
  }

  // Get recorded events only
  List<Event> get recordedEvents {
    return allStreamList.where((event) => !event.stream.isLive).toList();
  }

  // Get scheduled events
  List<Event> get scheduledEvents {
    return allStreamList.where((event) => event.eventType == 'Schedule').toList();
  }

  // Get funding events
  List<Event> get fundingEvents {
    return allStreamList.where((event) => event.eventType == 'Funding').toList();
  }

  var commentImage = Rx<File?>(null);
  var isEmojiVisible = false.obs;
  final commentController = TextEditingController();
  var comments = <Comment>[].obs;

  // Tab control
  void onTabSelected(int index) => selectedTab.value = index;

  void onSearchChanged(String value) => searchText.value = value;

  void toggleEmojiKeyboard() {
    isEmojiVisible.value = !isEmojiVisible.value;
  }

  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source, imageQuality: 75);
    if (picked != null) {
      commentImage.value = File(picked.path);
    }
  }

  void clearCommentState() {
    commentController.clear();
    commentImage.value = null;
    isEmojiVisible.value = false;
  }

  void submitComment(String text, {String? replyToId}) {
    if (text.trim().isEmpty && commentImage.value == null) return;

    final newComment = Comment(
      id: UniqueKey().toString(),
      userName: 'You',
      userImage: ImagePath.user,
      text: text,
      imagePath: commentImage.value?.path,
      timestamp: DateTime.now(),
    );

    if (replyToId != null) {
      final parentIndex = comments.indexWhere((c) => c.id == replyToId);
      if (parentIndex != -1) {
        comments[parentIndex].replies.add(newComment);
        comments.refresh();
        clearCommentState();
        return;
      }
    }

    comments.insert(0, newComment);
    clearCommentState();
  }

  void toggleLike(String commentId, {String? parentId}) {
    if (parentId != null) {
      final parent = comments.firstWhere((c) => c.id == parentId);
      final reply = parent.replies.firstWhere((r) => r.id == commentId);
      reply.isLiked.value = !reply.isLiked.value;
    } else {
      final comment = comments.firstWhere((c) => c.id == commentId);
      comment.isLiked.value = !comment.isLiked.value;
    }
    comments.refresh();
  }

  // Refresh method for pull-to-refresh
  Future<void> refreshEvents() async {
    currentPage.value = 1;
    await getAllRecordedLive(currentPage.value, limit.value);
  }

  // Load more for pagination
  Future<void> loadMore() async {
    if (!isLoading.value) {
      currentPage.value++;
      await getAllRecordedLive(currentPage.value, limit.value);
    }
  }

  @override
  void onClose() {
    commentController.dispose();
    super.onClose();
  }
}
