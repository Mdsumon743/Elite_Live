import 'dart:developer';
import 'dart:io';
import 'package:elites_live/core/global_widget/custom_loading.dart';
import 'package:elites_live/core/global_widget/custom_snackbar.dart';
import 'package:elites_live/core/helper/shared_prefarenses_helper.dart';
import 'package:elites_live/core/utils/constants/app_colors.dart';
import 'package:elites_live/core/utils/constants/app_urls.dart';
import 'package:elites_live/features/event/data/schedule_event_data_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/services/network_caller/repository/network_caller.dart';
import '../../../core/utils/constants/image_path.dart';
import '../../home/data/comment_data_model.dart';

class EventController extends GetxController {
  final NetworkCaller networkCaller = NetworkCaller();
  final SharedPreferencesHelper sharedPreferencesHelper =
      SharedPreferencesHelper();

  var isLoading = false.obs;
  var searchText = ''.obs;
  var selectedTab = 0.obs;
  var commentText = ''.obs;
  var selectedDonationAmount = 0.0.obs;

  RxList<LiveEvent> eventList = <LiveEvent>[].obs;

  RxInt currentPage = 1.obs;
  RxInt limit = 10.obs;
  RxInt totalPages = 1.obs;
  RxBool hasMoreData = true.obs;
  RxBool isPaginationLoading = false.obs;

  // Scroll controller for pagination
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    getAllEvent(currentPage.value, limit.value);
    scrollController.addListener(_scrollListener);
    super.onInit();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  // Scroll listener for pagination
  void _scrollListener() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent * 0.9) {
      if (!isPaginationLoading.value && hasMoreData.value) {
        loadMoreEvents();
      }
    }
  }

  /// follow unfollow
  Future<void> followUnFlow(String userId) async {
    isLoading.value = true;

    // SHOW LOADER
    Get.dialog(
      CustomLoading(color: AppColors.primaryColor),
      barrierDismissible: false,
    );

    String? token = sharedPreferencesHelper.getString("userToken");
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
        await getAllEvent(currentPage.value, limit.value);
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


  /// Get all events (initial load)
  Future<void> getAllEvent(int page, int limit) async {
    isLoading.value = true;
    String? token = sharedPreferencesHelper.getString("userToken");

    try {
      var response = await networkCaller.getRequest(
        AppUrls.getAllEvent(page, limit),
        token: token,
      );

      if (response.statusCode == 200 && response.isSuccess) {
        final data = response.responseData;

        final List<dynamic> eventsJson = data['events'] ?? [];

        final List<LiveEvent> events =
            eventsJson.map((json) => LiveEvent.fromJson(json)).toList();

        totalPages.value = data['totalPages'] ?? 1;
        currentPage.value = data['currentPage'] ?? 1;
        hasMoreData.value = currentPage.value < totalPages.value;

        // FIXED: Assign individual events, not wrapped result
        eventList.assignAll(events);
      }
    } catch (e) {
      log("Exception: ${e.toString()}");
      CustomSnackBar.error(title: "Error", message: "Failed to Load Events");

    } finally {
      isLoading.value = false;
    }
  }

  /// Load more events (pagination)
  Future<void> loadMoreEvents() async {
    if (!hasMoreData.value || isPaginationLoading.value) return;

    isPaginationLoading.value = true;
    final nextPage = currentPage.value + 1;
    String? token = sharedPreferencesHelper.getString("userToken");

    try {
      var response = await networkCaller.getRequest(
        AppUrls.getAllEvent(nextPage, limit.value),
        token: token,
      );

      if (response.statusCode == 200 && response.isSuccess) {
        final data = response.responseData;
        final List<dynamic> eventsJson = data['events'] ?? [];

        final List<LiveEvent> newEvents =
            eventsJson.map((json) => LiveEvent.fromJson(json)).toList();

        totalPages.value = data['totalPages'] ?? 1;
        currentPage.value = data['currentPage'] ?? 1;
        hasMoreData.value = currentPage.value < totalPages.value;

        eventList.addAll(newEvents);
      }
    } catch (e) {
      log("Pagination exception: ${e.toString()}");
    } finally {
      isPaginationLoading.value = false;
    }
  }

  Future<void> refreshEvents() async {
    currentPage.value = 1;
    hasMoreData.value = true;
    await getAllEvent(currentPage.value, limit.value);
  }

  // Other existing methods...
  List<bool> isLive = [true, false, true, true, true];
  List<bool> isFollow = [true, false, true, true, true];
  var commentImage = Rx<File?>(null);
  var isEmojiVisible = false.obs;
  final commentController = TextEditingController();
  var comments = <Comment>[].obs;

  void onTabSelected(int index) => selectedTab.value = index;
  void onSearchChanged(String value) => searchText.value = value;
  void toggleEmojiKeyboard() => isEmojiVisible.value = !isEmojiVisible.value;

  void processDonation(double amount) {
    selectedDonationAmount.value = amount;
    CustomSnackBar.success(title: "Donation", message: 'Processing donation of \$${amount.toStringAsFixed(2)}',);

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
}
