

import 'dart:convert';
import 'dart:developer';
import 'package:elites_live/core/services/network_caller/repository/network_caller.dart';
import 'package:get/get.dart';
import 'package:elites_live/core/services/socket_service.dart';
import 'package:elites_live/core/helper/shared_prefarenses_helper.dart';
import 'package:elites_live/core/global_widget/custom_snackbar.dart';
import '../../../core/utils/constants/app_urls.dart';
import '../data/live_comment_data_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class LiveCommentController extends GetxController {
  final WebSocketClientService webSocketService = WebSocketClientService.to;
  final SharedPreferencesHelper helper = SharedPreferencesHelper();
  final NetworkCaller networkCaller = NetworkCaller();
  var isLoading = false.obs;

  // Observable comment listd
  final RxList<LiveComment> comments = <LiveComment>[].obs;
  final RxBool isJoined = false.obs;
  final RxBool isSending = false.obs;
  final RxBool isConnecting = false.obs;
  final RxString connectionError = ''.obs;

  // Warning and ban tracking
  final RxInt warningCount = 0.obs;
  final RxBool isBanned = false.obs;
  final RxString banMessage = ''.obs;

  // NEW: Track if current user is host or co-host
  final RxBool isHost = false.obs;
  final RxBool isCoHost = false.obs;

  // Stream info
  String? eventId;
  String? streamId;
  bool isFromEvent = false;

  @override
  void onInit() {
    super.onInit();
    _setupMessageListener();
    _setupBadWordWarningListener();
    _setupBannedListener();
  }

  /// Initialize for Event-based live streaming
  Future<void> initializeForEvent(String eventIdParam, {bool isHostUser = false, bool isCoHostUser = false}) async {
    eventId = eventIdParam;
    streamId = null;
    isFromEvent = true;
    isHost.value = isHostUser;
    isCoHost.value = isCoHostUser;

    log("📺 Initializing comment system for Event: $eventId");
    log("   Is Host: $isHostUser, Is Co-Host: $isCoHostUser");

    try {
      await _ensureWebSocketConnected();
      await _joinStream();
    } catch (e) {
      log("❌ Failed to initialize for event: $e");
      connectionError.value = "Failed to connect to chat server";
    }
  }

  /// Initialize for Free live streaming
  Future<void> initializeForFreeLive(String streamIdParam, {bool isHostUser = false, bool isCoHostUser = false}) async {
    streamId = streamIdParam;
    eventId = null;
    isFromEvent = false;
    isHost.value = isHostUser;
    isCoHost.value = isCoHostUser;

    log("📺 Initializing comment system for Free Live: $streamId");
    log("   Is Host: $isHostUser, Is Co-Host: $isCoHostUser");

    try {
      await _ensureWebSocketConnected();
      await _joinStream();
    } catch (e) {
      log("❌ Failed to initialize for free live: $e");
      connectionError.value = "Failed to connect to chat server";
    }
  }

  /// Ensure WebSocket is connected
  Future<void> _ensureWebSocketConnected() async {
    if (webSocketService.isConnected.value) {
      log("✅ WebSocket already connected");
      return;
    }

    if (webSocketService.isConnecting.value) {
      log("⏳ WebSocket connection already in progress, waiting...");
      int attempts = 0;
      const maxAttempts = 20;

      while (attempts < maxAttempts &&
          webSocketService.isConnecting.value &&
          !webSocketService.isConnected.value) {
        await Future.delayed(Duration(milliseconds: 500));
        attempts++;
      }

      if (webSocketService.isConnected.value) {
        log("✅ WebSocket connected (waited for existing connection)");
        return;
      }

      if (attempts >= maxAttempts) {
        throw Exception("Timeout waiting for existing connection");
      }
    }

    isConnecting.value = true;
    log("🔌 Connecting to WebSocket...");

    final authToken = helper.getString('userToken');
    if (authToken == null || authToken.isEmpty) {
      isConnecting.value = false;
      log("❌ No auth token available");
      throw Exception("Authentication token not found");
    }

    const socketUrl = "wss://api.elites-livestream.com";

    try {
      await webSocketService.connect(socketUrl, authToken);

      int attempts = 0;
      const maxAttempts = 20;

      while (attempts < maxAttempts && !webSocketService.isConnected.value) {
        await Future.delayed(Duration(milliseconds: 500));
        attempts++;
      }

      if (!webSocketService.isConnected.value) {
        throw Exception("WebSocket connection timeout");
      }

      isConnecting.value = false;
      connectionError.value = '';
      log("✅ WebSocket connected successfully");
    } catch (e) {
      isConnecting.value = false;
      connectionError.value = e.toString();
      log("❌ WebSocket connection error: $e");
      rethrow;
    }
  }

  /// Setup message listener for incoming comments
  void _setupMessageListener() {
    webSocketService.setOnMessageReceived((message) {
      try {
        final data = jsonDecode(message);
        log("📨 Received message: $data");

        final messageType = data['type'] as String?;

        if (messageType == 'chat-streaming-comment' ||
            messageType == 'chat-streaming-free-comment' ||
            messageType == 'new-comment') {
          _handleNewComment(data);
        } else if (messageType == 'comment-history') {
          _handleCommentHistory(data);
        } else if (messageType == 'join-success') {
          log("✅ Successfully joined streaming room");
        } else if (messageType == 'error') {
          log("❌ Server error: ${data['message']}");
        }
      } catch (e) {
        log("❌ Error parsing message: $e");
      }
    });
  }

  /// Setup bad word warning listener
  void _setupBadWordWarningListener() {
    webSocketService.setOnBadWordWarning((data) {
      try {
        final message = data['message'] as String? ?? 'Inappropriate language is not allowed';
        final count = data['warningCount'] as int? ?? 0;

        log("⚠️ Bad word warning received: $message (Count: $count)");

        warningCount.value = count;
        _showWarningBottomSheet(message, count);
      } catch (e) {
        log("❌ Error handling bad word warning: $e");
      }
    });
  }

  /// Setup banned listener
  void _setupBannedListener() {
    webSocketService.setOnUserBanned((data) {
      try {
        final message = data['message'] as String? ?? 'You have been banned due to repeated violations.';

        log("🚫 User banned: $message");

        isBanned.value = true;
        banMessage.value = message;

        _handleBan();
      } catch (e) {
        log("❌ Error handling ban: $e");
      }
    });
  }

  /// Show warning bottom sheet
  void _showWarningBottomSheet(String message, int count) {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80.w,
              height: 80.h,
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.warning_amber_rounded,
                color: Colors.orange,
                size: 48.sp,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'Warning!',
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.black54,
                height: 1.4,
              ),
            ),
            SizedBox(height: 16.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.red.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.block, color: Colors.red, size: 20.sp),
                  SizedBox(width: 8.w),
                  Text(
                    'Violations: $count',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                'Further violations may result in a permanent ban from this stream.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: Colors.black54,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            SizedBox(height: 20.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  'I Understand',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      isDismissible: false,
      enableDrag: false,
    );
  }

  /// NEW: Ban user API call
  Future<void> banUser(String userId, String userName, String streamId) async {
    isLoading.value = true;
    String? token = helper.getString("userToken");
    final actualStreamId = streamId;

    if (actualStreamId == null) {
      CustomSnackBar.error(
        title: "Error",
        message: "Stream ID not available",
      );
      isLoading.value = false;
      return;
    }

    log("🚫 Banning user: $userName (ID: $userId)");
    log("   Stream ID: $actualStreamId");
    log("   Token: $token");

    try {
      var response = await networkCaller.postRequest(
        AppUrls.banUser(streamId),
        body: {"banUserId": userId},
        token: token,
      );

      if (response.isSuccess) {
        log("✅ User banned successfully: ${response.responseData}");
        CustomSnackBar.success(
          title: "User Banned",
          message: "$userName has been banned from this stream.",
        );
      } else {
        log("❌ Ban API error: ${response.responseData}");
        CustomSnackBar.error(
          title: "Failed",
          message: response.errorMessage,
        );
      }
    } catch (e) {
      log("❌ Exception during ban: ${e.toString()}");
      CustomSnackBar.error(title: "Error", message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// Handle user ban
  void _handleBan() async {
    await leaveStream();
    webSocketService.disconnect();

    Get.dialog(
      WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          contentPadding: EdgeInsets.all(24.w),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 100.w,
                height: 100.h,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.block,
                  color: Colors.red,
                  size: 56.sp,
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                'Account Banned',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                banMessage.value,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.black54,
                  height: 1.4,
                ),
              ),
              SizedBox(height: 24.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.back();
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    'Exit Stream',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  void _handleNewComment(Map<String, dynamic> data) {
    try {
      log("🔍 Parsing comment from data: $data");

      final messageData = data['message'] ?? data;

      if (messageData['EventComment'] != null && messageData['EventComment'] is List) {
        log("📚 Detected EventComment array with ${(messageData['EventComment'] as List).length} comments");
        _handleCommentArray(messageData['EventComment'] as List);
        return;
      }

      final comment = LiveComment.fromJson(data);
      log("✅ Parsed single comment: ${comment.userName} - ${comment.comment}");

      comments.insert(0, comment);

      if (comments.length > 100) {
        comments.removeRange(100, comments.length);
      }

      log("💬 Comment added to list. Total comments: ${comments.length}");
    } catch (e, stackTrace) {
      log("❌ Error handling new comment: $e");
      log("Stack trace: $stackTrace");
      log("Data that failed to parse: $data");
    }
  }

  void _handleCommentArray(List commentArray) {
    try {
      log("📥 Processing ${commentArray.length} comments from array");

      final List<LiveComment> parsedComments = [];

      for (var commentData in commentArray) {
        try {
          final comment = LiveComment.fromJson(commentData);
          parsedComments.add(comment);
          log("✅ Parsed: ${comment.userName} - ${comment.comment}");
        } catch (e) {
          log("❌ Failed to parse comment: $e");
          log("Comment data: $commentData");
        }
      }

      if (parsedComments.isEmpty) {
        log("⚠️ No comments were successfully parsed");
        return;
      }

      parsedComments.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      comments.value = parsedComments;

      log("✅ Loaded ${parsedComments.length} comments from array");
      log("💬 Total comments in list: ${comments.length}");
    } catch (e, stackTrace) {
      log("❌ Error handling comment array: $e");
      log("Stack trace: $stackTrace");
    }
  }

  void _handleCommentHistory(Map<String, dynamic> data) {
    try {
      final List<dynamic> history = data['comments'] ?? [];
      final List<LiveComment> loadedComments = history
          .map((item) => LiveComment.fromJson(item))
          .toList();

      comments.value = loadedComments;
      log("📜 Loaded ${loadedComments.length} comments from history");
    } catch (e) {
      log("❌ Error handling comment history: $e");
    }
  }

  Future<void> _joinStream() async {
    if (!webSocketService.isConnected.value) {
      log("❌ Cannot join: WebSocket not connected");
      throw Exception("WebSocket not connected");
    }

    try {
      final request = isFromEvent
          ? JoinStreamingRequest(
        type: WebSocketMessageType.joinStreaming,
        eventId: eventId,
      )
          : JoinStreamingRequest(
        type: WebSocketMessageType.joinStreamingFree,
        streamId: streamId,
      );

      webSocketService.sendMessage(request.toJson());
      isJoined.value = true;

      log("✅ Joined streaming room: ${isFromEvent ? 'Event $eventId' : 'Stream $streamId'}");
    } catch (e) {
      log("❌ Error joining stream: $e");
      rethrow;
    }
  }

  Future<void> sendComment(String commentText) async {
    if (commentText.trim().isEmpty) {
      log("⚠️ Cannot send empty comment");
      return;
    }

    if (isBanned.value) {
      CustomSnackBar.error(
        title: "Banned",
        message: "You cannot send messages because you are banned.",
      );
      return;
    }

    if (!webSocketService.isConnected.value) {
      log("❌ Cannot send: WebSocket not connected");
      CustomSnackBar.error(
        title: "Connection Error",
        message: "Not connected to chat server. Please try again.",
      );
      throw Exception("Not connected to server");
    }

    if (!isJoined.value) {
      log("❌ Cannot send: Not joined to stream");
      CustomSnackBar.error(
        title: "Error",
        message: "Not joined to chat room. Please refresh.",
      );
      throw Exception("Not joined to stream");
    }

    isSending.value = true;

    try {
      final request = isFromEvent
          ? ChatStreamingRequest(
        type: WebSocketMessageType.chatStreaming,
        eventId: eventId,
        comment: commentText,
      )
          : ChatStreamingRequest(
        type: WebSocketMessageType.chatStreamingFree,
        streamId: streamId,
        comment: commentText,
      );

      webSocketService.sendMessage(request.toJson());
      log("💬 Comment sent: $commentText");
    } catch (e) {
      log("❌ Error sending comment: $e");
      CustomSnackBar.error(
        title: "Send Failed",
        message: "Failed to send comment. Please try again.",
      );
      rethrow;
    } finally {
      isSending.value = false;
    }
  }

  Future<void> retryConnection() async {
    connectionError.value = '';

    try {
      if (isFromEvent && eventId != null) {
        await initializeForEvent(eventId!, isHostUser: isHost.value, isCoHostUser: isCoHost.value);
      } else if (!isFromEvent && streamId != null) {
        await initializeForFreeLive(streamId!, isHostUser: isHost.value, isCoHostUser: isCoHost.value);
      }
    } catch (e) {
      log("❌ Retry failed: $e");
    }
  }

  Future<void> leaveStream() async {
    if (!isJoined.value) return;

    try {
      final leaveType = isFromEvent
          ? WebSocketMessageType.leaveStreaming
          : WebSocketMessageType.leaveStreamingFree;

      final request = {
        'type': leaveType,
        if (isFromEvent) 'eventId': eventId,
        if (!isFromEvent) 'streamId': streamId,
      };

      if (webSocketService.isConnected.value) {
        webSocketService.sendMessage(request);
      }

      isJoined.value = false;
      comments.clear();

      log("👋 Left streaming room");
    } catch (e) {
      log("❌ Error leaving stream: $e");
    }
  }

  @override
  void onClose() {
    leaveStream();
    super.onClose();
  }
}
