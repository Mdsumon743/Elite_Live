import 'dart:developer';
import 'dart:convert';
import 'package:elites_live/core/helper/shared_prefarenses_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/services/socket_service.dart';
import '../presentation/widget/contributor_dialog.dart';


class LiveStreamController extends GetxController {
  final webSocketService = WebSocketClientService.to;
  final SharedPreferencesHelper helper = SharedPreferencesHelper();

  String? streamId;
  String? coHostLink;
  final isWebSocketConnected = false.obs;
  final isInitializing = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Listen to WebSocket connection state changes
    ever(webSocketService.isConnected, (connected) {
      isWebSocketConnected.value = connected;
      log("🔄 WebSocket state changed: $connected");
    });

    initializeWebSocket();
  }

  Future<void> initializeWebSocket() async {
    if (isInitializing.value) {
      log("⚠️ WebSocket initialization already in progress");
      return;
    }

    try {
      isInitializing.value = true;
      log("🚀 Starting WebSocket initialization...");

      final authToken = await _getAuthToken();
      if (authToken == null || authToken.isEmpty) {
        log("❌ No auth token found");
        Get.snackbar(
          "Authentication Error",
          "Please login again",
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      final socketUrl = "wss://api.elites-livestream.com";

      // Connect and wait for connection or timeout
      await webSocketService.connect(socketUrl, authToken);

      // Wait for connection to establish with timeout
      int attempts = 0;
      const maxAttempts = 10; // 5 seconds total
      while (attempts < maxAttempts && !webSocketService.isConnected.value) {
        await Future.delayed(Duration(milliseconds: 500));
        attempts++;
        log("⏳ Waiting for connection... attempt $attempts/$maxAttempts");
      }

      isWebSocketConnected.value = webSocketService.isConnected.value;

      if (webSocketService.isConnected.value) {
        log("✅ WebSocket connected successfully");

        webSocketService.setOnMessageReceived((message) {
          handleWebSocketMessage(message);
        });
      } else {
        log("❌ WebSocket failed to connect after ${attempts * 500}ms");
        Get.snackbar(
          "Connection Failed",
          "Unable to connect to server. Please check your internet connection.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      log("❌ WebSocket initialization error: $e");
      isWebSocketConnected.value = false;
      Get.snackbar(
        "Connection Error",
        "Failed to connect: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isInitializing.value = false;
    }
  }

  Future<String?> _getAuthToken() async {
  String? token =    helper.getString("userToken");
  log("token in socket");

    // TODO: Replace with actual token retrieval from secure storage
    // Example: return await SecureStorage.read('auth_token');
    return token;
  }

  void handleWebSocketMessage(String message) {
    try {
      log("📨 Received message: $message");
      final decoded = jsonDecode(message);

      switch (decoded['type']) {
        case 'contributor-added':
          Get.snackbar(
            "Success",
            "Contributor joined the stream",
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          break;
        case 'contributor-left':
          Get.snackbar(
            "Info",
            "Contributor left the stream",
            snackPosition: SnackPosition.TOP,
          );
          break;
        case 'error':
          log("❌ Server error: ${decoded['message']}");
          Get.snackbar(
            "Server Error",
            decoded['message'] ?? "An error occurred",
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          break;
        default:
          log("ℹ️ Unhandled message type: ${decoded['type']}");
      }
    } catch (e) {
      log("❌ Error handling WebSocket message: $e");
    }
  }

  Future<void> openAddContributorDialog(BuildContext context) async {
    log("🎯 Opening Add Contributor dialog...");
    log("🔍 Stream ID: $streamId");
    log("🔍 WebSocket connected: ${webSocketService.isConnected.value}");

    if (streamId == null || streamId!.isEmpty) {
      Get.snackbar(
        "Error",
        "Stream ID not available",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // If not connected, try to reconnect
    if (!webSocketService.isConnected.value) {
      Get.snackbar(
        "Connecting",
        "Please wait while we establish connection...",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );

      await initializeWebSocket();

      // Check again after reconnection attempt
      if (!webSocketService.isConnected.value) {
        Get.snackbar(
          "Connection Failed",
          "Unable to connect to server. Please try again.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }
    }

    // Only show dialog if connected
    _showDialog(context);
  }

  void _showDialog(BuildContext context) {
    AddContributorDialog.show(
      context,
      streamId: streamId!,
      coHostLink: coHostLink ?? "https://join.com",
      webSocketService: webSocketService,
    );
  }

  @override
  void onClose() {
    log("🔌 Cleaning up WebSocket...");
    webSocketService.disconnect();
    super.onClose();
  }
}
