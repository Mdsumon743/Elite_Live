import 'dart:developer';
import 'package:elites_live/core/global_widget/custom_loading.dart';
import 'package:elites_live/core/global_widget/custom_snackbar.dart';
import 'package:elites_live/core/global_widget/custom_text_view.dart';
import 'package:elites_live/core/global_widget/custom_elevated_button.dart';
import 'package:elites_live/core/helper/shared_prefarenses_helper.dart';
import 'package:elites_live/core/services/network_caller/repository/network_caller.dart';
import 'package:elites_live/core/utils/constants/app_colors.dart';
import 'package:elites_live/core/utils/constants/app_urls.dart';
import 'package:elites_live/routes/app_routing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../../core/services/screen_share_service.dart';
import '../../../core/services/socket_service.dart';
import '../data/create_live_response_data_model.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';




class LiveScreenController extends GetxController {
  var isCameraOn = true.obs;
  var isMicOn = true.obs;
  var isScreenSharing = false.obs;
  var isRecording = false.obs;
  var showMenu = false.obs;
  var viewerCount = 0.obs;
  var isLoading = false.obs;

  // Track co-hosts
  var coHostIds = <String>[].obs;

  late ZegoUIKitPrebuiltLiveStreamingController prebuiltController;



  /// Toggle screen sharing
  Future<void> toggleScreenShare() async {
    if (isScreenSharing.value) {
      // Stop screen sharing
      final success = await ScreenShareService.stopScreenShare();
      if (success) {
        isScreenSharing.value = false;
        CustomSnackBar.success(
          title: "Screen Share Stopped",
          message: "You've stopped sharing your screen",
        );
      }
    } else {
      // Start screen sharing
      final roomId = Get.arguments?['roomId'] ?? '';
      final streamId = Get.arguments?['streamId'] ?? roomId;

      if (roomId.isEmpty) {
        CustomSnackBar.error(
          title: "Error",
          message: "Room ID not available",
        );
        return;
      }

      final success = await ScreenShareService.startScreenShare(
        roomID: roomId,
        streamID: streamId,
      );

      if (success) {
        isScreenSharing.value = true;
        CustomSnackBar.success(
          title: "Screen Share Started",
          message: "You're now sharing your screen",
        );
      } else {
        CustomSnackBar.error(
          title: "Failed",
          message: "Could not start screen sharing",
        );
      }
    }
  }

  final NetworkCaller networkCaller = NetworkCaller();
  final SharedPreferencesHelper helper = SharedPreferencesHelper();
  final Uuid uuid = Uuid();

  @override
  void onInit() {
    prebuiltController = ZegoUIKitPrebuiltLiveStreamingController();
    super.onInit();
  }

  /// Add co-host
  void addCoHost(String coHostId) {
    if (!coHostIds.contains(coHostId)) {
      coHostIds.add(coHostId);
      log("✅ Co-host added: $coHostId, Total co-hosts: ${coHostIds.length}");
    }
  }

  /// Remove co-host
  void removeCoHost(String coHostId) {
    coHostIds.remove(coHostId);
    log("❌ Co-host removed: $coHostId, Total co-hosts: ${coHostIds.length}");
  }

  /// Check if there are co-hosts
  bool hasCoHosts() {
    return coHostIds.isNotEmpty;
  }

  /// Get first co-host ID
  String? getFirstCoHostId() {
    return coHostIds.isNotEmpty ? coHostIds.first : null;
  }

  /// Generate unique links
  String generateHostLink() {
    return 'host_${uuid.v4()}';
  }

  String generateCoHostLink() {
    return 'cohost_${uuid.v4()}';
  }

  String generateAudienceLink() {
    return 'audience_${uuid.v4()}';
  }

  /// Start Live
  Future<void> startLive(String streamId) async {
    isLoading.value = true;
    Get.dialog(CustomLoading(color: AppColors.primaryColor,), barrierDismissible: false);
    String? token = helper.getString("userToken");
    log("Token during start live: $token");

    try {
      var response = await networkCaller.postRequest(
        AppUrls.startLive(streamId),
        body: {},
        token: token,
      );

      if (response.isSuccess) {
        log("Start live API response: ${response.responseData}");
        CustomSnackBar.success(
          title: "Live Started",
          message: "Live session started successfully",
        );
      } else {
        CustomSnackBar.error(
          title: "Error",
          message: "Failed to start live session",
        );
      }
    } catch (e) {
      log("Start live exception: ${e.toString()}");
      CustomSnackBar.error(
        title: "Error",
        message: "Failed to start live: ${e.toString()}",
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Start recording
  Future<void> startRecording(String streamId) async {
    String? token = helper.getString("userToken");
    log("Token during start recording: $token");

    try {
      var response = await networkCaller.postRequest(
        AppUrls.startRecording(streamId),
        body: {},
        token: token,
      );

      if (response.isSuccess) {
        log("✅ Start recording API response: ${response.responseData}");
      } else {
        throw Exception("Failed to start recording");
      }
    } catch (e) {
      log("❌ Start recording exception: ${e.toString()}");
      rethrow;
    }
  }

  /// Stop recording
  Future<void> stopRecording(String streamId) async {
    String? token = helper.getString("userToken");
    log("Token during stop recording: $token");

    try {
      var response = await networkCaller.postRequest(
        AppUrls.stopRecording(streamId),
        body: {},
        token: token,
      );

      if (response.isSuccess) {
        log("✅ Stop recording API response: ${response.responseData}");
      } else {
        throw Exception("Failed to stop recording");
      }
    } catch (e) {
      log("❌ Stop recording exception: ${e.toString()}");
      rethrow;
    }
  }

  /// Toggle recording
  void toggleRecording(String streamId) async {
    if (isRecording.value) {
      // STOP RECORDING
      showMenu.value = false;
      isLoading.value = true;

      try {
        await stopRecording(streamId);
        isRecording.value = false;

        Get.snackbar(
          'Recording Stopped',
          'Recording has been saved',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.black87,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      } catch (e) {
        log("Failed to stop recording: $e");
        CustomSnackBar.error(
          title: "Error",
          message: "Failed to stop recording",
        );
      } finally {
        isLoading.value = false;
      }
    } else {
      // START RECORDING
      showMenu.value = false;
      isLoading.value = true;

      try {
        await startRecording(streamId);
        isRecording.value = true;

        Get.snackbar(
          'Recording Started',
          'This session is now being recorded',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.black87,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      } catch (e) {
        log("Failed to start recording: $e");
        CustomSnackBar.error(
          title: "Error",
          message: "Failed to start recording",
        );
      } finally {
        isLoading.value = false;
      }
    }
  }

  /// Create Live Stream
  Future<Map<String, dynamic>?> createLive({
    required bool isPaid,
    double cost = 0.0,
  }) async {
    isLoading.value = true;

    Get.dialog(
      Center(child: CustomLoading(color: AppColors.primaryColor)),
      barrierDismissible: false,
    );

    String? token = helper.getString("userToken");

    if (token == null || token.isEmpty) {
      if (Get.isDialogOpen ?? false) Get.back();
      CustomSnackBar.error(
        title: "Authentication Error",
        message: "Please login again",
      );

      isLoading.value = false;
      return null;
    }

    try {
      String hostLink = generateHostLink();
      String coHostLink = generateCoHostLink();
      String audienceLink = generateAudienceLink();

      Map<String, dynamic> body = {
        "hostLink": hostLink,
        "coHostLink": coHostLink,
        "audienceLink": audienceLink,
      };

      log("🔗 Generated Links:");
      log("   Host: $hostLink");
      log("   CoHost: $coHostLink");
      log("   Audience: $audienceLink");

      var response = await networkCaller.postRequest(
        AppUrls.createLive,
        body: body,
        token: token,
      );

      if (!response.isSuccess || response.responseData == null) {
        throw Exception("Failed to create live stream");
      }

      final json = response.responseData as Map<String, dynamic>;
      LiveResult result = LiveResult.fromJson(
        json.containsKey('result') ? json['result'] : json,
      );

      final liveData = {
        "liveId": result.id,
        "roomId": result.id,
        "hostId": result.userId,
        "hostLink": result.hostLink,
        "coHostLink": result.coHostLink,
        "audienceLink": result.audienceLink,
        "isLive": result.isLive,
        "isPaid": isPaid,
        "cost": cost,
      };

      if (Get.isDialogOpen ?? false) Get.back();
      return liveData;
    } catch (e) {
      if (Get.isDialogOpen ?? false) Get.back();
      CustomSnackBar.error(title: "Error", message: e.toString());
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createAndNavigateToLive({
    required bool isPaid,
    required bool isHost,
    double cost = 0.0,
  }) async {
    log("=== createAndNavigateToLive called ===");
    log("isPaid: $isPaid, isHost: $isHost, cost: $cost");

    if (isLoading.value) {
      log("⚠️ Already loading, ignoring duplicate call");
      return;
    }

    Map<String, dynamic>? liveData = await createLive(
      isPaid: isPaid,
      cost: cost,
    );

    if (liveData != null) {
      log("🚀 Navigating to live screen...");
      log("Navigation data: $liveData");

      try {
        if (isPaid) {
          log("Navigating to premium screen");
          await Get.toNamed(AppRoute.premiumScreen, arguments: liveData);
        } else {
          log("Navigating to my live screen (FREE LIVE)");
          await Get.toNamed(
            AppRoute.myLive,
            arguments: {...liveData, 'isHost': isHost},
          );
        }
        log("✅ Navigation successful");
      } catch (e) {
        log("❌ Navigation error: $e");
        CustomSnackBar.error(
          title: "Error",
          message: "Failed to navigate to live screen",
        );
      }
    } else {
      log("❌ liveData is null, navigation cancelled");
    }
  }

  /// Join live as audience
  Future<void> joinLiveAsAudience({required String audienceLink}) async {
    log("=== joinLiveAsAudience called ===");
    log("Audience Link: $audienceLink");

    String? liveId;
    String actualAudienceLink = audienceLink;

    if (audienceLink.contains('|')) {
      final parts = audienceLink.split('|');
      liveId = parts[0];
      actualAudienceLink = parts[1];
      log("📌 Extracted liveId: $liveId");
      log("📌 Extracted audienceLink: $actualAudienceLink");
    } else {
      liveId = audienceLink;
      log("⚠️ No separator found, using entire link as liveId: $liveId");
    }

    if (liveId.isEmpty) {
      CustomSnackBar.error(
        title: "Invalid Link",
        message: "The audience link is invalid. Please check and try again.",
      );
      return;
    }

    String? userId = helper.getString('userId') ?? 'user_${uuid.v4().substring(0, 8)}';
    String? userName = helper.getString('userName') ?? 'Guest User';

    log("🚀 Joining live stream as audience...");
    log("   Live ID (Room ID): $liveId");
    log("   User ID: $userId");
    log("   User Name: $userName");

    try {
      await Get.toNamed(
        AppRoute.myLive,
        arguments: {
          'roomId': liveId,
          'liveId': liveId,
          'audienceLink': actualAudienceLink,
          'isHost': false,
          'isCoHost': false,
          'isPaid': false,
          'cost': 0.0,
          'hostId': userId,
          'hostLink': null,
          'coHostLink': null,
        },
      );
      log("✅ Successfully joined live stream");
    } catch (e) {
      log("❌ Navigation error: $e");
      CustomSnackBar.error(
        title: "Error",
        message: "Failed to join live stream. Please try again.",
      );
    }
  }

  /// End Live
  Future<void> leaveLive(String streamId) async {
    isLoading.value = true;
    String? token = helper.getString('userToken');
    try {
      var response = await networkCaller.postRequest(
        AppUrls.endLive(streamId),
        body: {"isHost": true},
        token: token,
      );
      if (response.isSuccess) {
        log("✅ Leave live API response: ${response.responseData}");
      }
    } catch (e) {
      log("❌ Leave live exception: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  void toggleCamera() {
    isCameraOn.value = !isCameraOn.value;
  }

  void toggleMic() {
    isMicOn.value = !isMicOn.value;
  }
/*
  void toggleScreenShare() async {
    if (isScreenSharing.value) {
      // STOP SCREEN SHARING
      await ZegoUIKit.instance.stopSharingScreen();
      isScreenSharing.value = false;
      CustomSnackBar.success(
        title: "Screen Sharing Stopped",
        message: "Your screen is no longer being shared",
      );
    } else {
      // START SCREEN SHARING
      try {
        await ZegoUIKit.instance.startSharingScreen();
        isScreenSharing.value = true;
        CustomSnackBar.success(
          title: "Screen Sharing Started",
          message: "Your screen is now being shared with viewers",
        );
      } catch (e) {
        log("Screen sharing failed: $e");
        CustomSnackBar.error(
          title: "Error",
          message: "Failed to start screen sharing. Please try again.",
        );
      }
    }

    showMenu.value = false;
  }*/

  void toggleMenu() {
    showMenu.value = !showMenu.value;
  }

  void closeMenu() {
    showMenu.value = false;
  }

  /// NEW: End call as HOST with options
  void endCallAsHost(BuildContext context, String streamId) {
    if (hasCoHosts()) {
      _showEndOrTransferDialog(context, streamId);
    } else {
      _showSimpleEndDialog(context, streamId);
    }
  }

  /// NEW: End call as CO-HOST
  void endCallAsCoHost(BuildContext context, String streamId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          title: CustomTextView(
            text: "Leave Session",
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textHeader,
            textAlign: TextAlign.center,
          ),
          content: CustomTextView(
            text: "Are you sure you want to leave this live session?",
            fontWeight: FontWeight.w400,
            fontSize: 14.sp,
            color: AppColors.textBody,
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CustomElevatedButton(
                    ontap: () => Get.back(),
                    text: "Cancel",
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: CustomElevatedButton(
                    ontap: () async {
                      Get.back();
                      isLoading.value = true;

                      // Notify that co-host is leaving
                      final String? currentUserId = helper.getString('userId');
                      if (currentUserId != null) {
                        final WebSocketClientService webSocketService = WebSocketClientService.to;
                        webSocketService.notifyCoHostLeft(streamId, currentUserId);
                      }

                      await leaveLive(streamId);
                      isLoading.value = false;
                      Get.back();

                      CustomSnackBar.success(
                        title: "Left Session",
                        message: "You have left the live session",
                      );
                    },
                    text: "Leave",
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  /// Dialog for host with co-hosts
  void _showEndOrTransferDialog(BuildContext context, String streamId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          title: CustomTextView(
            text: "End Session Options",
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textHeader,
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextView(
                text: "You have active co-hosts. Choose an option:",
                fontWeight: FontWeight.w400,
                fontSize: 14.sp,
                color: AppColors.textBody,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.h),

              // Option 1: End for everyone
              InkWell(
                onTap: () async {
                  Get.back();
                  isLoading.value = true;
                  await leaveLive(streamId);
                  isLoading.value = false;
                  Get.back();

                  CustomSnackBar.success(
                    title: "Session Ended",
                    message: "Live session ended for everyone",
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: Colors.red, width: 1.5),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.stop_circle, color: Colors.red, size: 24.sp),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextView(
                              text: "End Session",
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.red,
                            ),
                            SizedBox(height: 4.h),
                            CustomTextView(
                              text: "Terminate for all participants",
                              fontSize: 12.sp,
                              color: Colors.grey[600]!,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 12.h),

              // Option 2: Transfer to co-host
              InkWell(
                onTap: () async {
                  Get.back();
                  isLoading.value = true;

                  if (coHostIds.isNotEmpty) {
                    String newHostId = coHostIds.first;
                    String? currentUserId = helper.getString('userId');

                    final WebSocketClientService webSocketService = WebSocketClientService.to;
                    webSocketService.notifyHostTransferred(
                      streamId,
                      currentUserId ?? '',
                      newHostId,
                    );

                    log("🔄 Host transferred to: $newHostId");
                  }

                  isLoading.value = false;
                  Get.back();

                  CustomSnackBar.success(
                    title: "Host Transferred",
                    message: "You've left and transferred host role",
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: Colors.blue, width: 1.5),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.exit_to_app, color: Colors.blue, size: 24.sp),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextView(
                              text: "Leave & Transfer",
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue,
                            ),
                            SizedBox(height: 4.h),
                            CustomTextView(
                              text: "Make co-host the new host",
                              fontSize: 12.sp,
                              color: Colors.grey[600]!,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: CustomTextView(
                text: "Cancel",
                fontSize: 14.sp,
                color: Colors.grey[600]!,
              ),
            ),
          ],
        );
      },
    );
  }

  /// Simple end dialog (no co-hosts)
  void _showSimpleEndDialog(BuildContext context, String streamId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          title: CustomTextView(
            text: "End Session",
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textHeader,
            textAlign: TextAlign.center,
          ),
          content: CustomTextView(
            text: "Are you sure you want to end this live session?",
            fontWeight: FontWeight.w400,
            fontSize: 14.sp,
            color: AppColors.textBody,
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CustomElevatedButton(
                    ontap: () => Get.back(),
                    text: "Cancel",
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: CustomElevatedButton(
                    ontap: () async {
                      Get.back();
                      isLoading.value = true;
                      await leaveLive(streamId);
                      isLoading.value = false;
                      Get.back();

                      CustomSnackBar.success(
                        title: "Session Ended",
                        message: "Live session ended successfully",
                      );
                    },
                    text: "End",
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  /// Go back handler
  void goBack(BuildContext context, String streamId, bool isHost, bool isCoHost) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          title: CustomTextView(
            text: isCoHost ? "Leave as Co-Host" : "Leave Live Session",
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textHeader,
            textAlign: TextAlign.center,
          ),
          content: CustomTextView(
            text: isCoHost
                ? "Are you sure you want to leave? You'll be removed as co-host."
                : "Are you sure you want to leave this live session?",
            fontWeight: FontWeight.w400,
            fontSize: 14.sp,
            color: AppColors.textBody,
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            Row(
              children: [
                Expanded(
                  child: CustomElevatedButton(
                    ontap: () => Get.back(),
                    text: "Cancel",
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: CustomElevatedButton(
                    ontap: () async {
                      Get.back();

                      if (isCoHost) {
                        String? currentUserId = helper.getString('userId');
                        if (currentUserId != null) {
                          final WebSocketClientService webSocketService = WebSocketClientService.to;
                          webSocketService.notifyCoHostLeft(streamId, currentUserId);
                        }
                      }

                      if (isHost) {
                        String? currentUserId = helper.getString('userId');
                        if (currentUserId != null) {
                          final WebSocketClientService webSocketService = WebSocketClientService.to;
                          webSocketService.notifyCoHostLeft(streamId, currentUserId);
                        }
                      }

                      isLoading.value = true;
                      await leaveLive(streamId);
                      isLoading.value = false;
                      Get.back();

                      CustomSnackBar.warning(
                        title: "Left Session",
                        message: "You have left the live session",
                      );
                    },
                    text: "Leave",
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  /// Update watch count
  Future<void> updateWatchCount(String streamId) async {
    isLoading.value = true;
    String? token = helper.getString("userToken");
    log("Token during update watch count: $token");
    try {
      var response = await networkCaller.patchRequest(
        AppUrls.updateWatchCount(streamId),
        token: token,
      );
      if (response.isSuccess) {
        log("✅ Watch count updated: ${response.responseData}");
      }
    } catch (e) {
      log("❌ Update watch count exception: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }
}
