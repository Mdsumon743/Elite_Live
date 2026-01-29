import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/helper/shared_prefarenses_helper.dart';
import '../../../core/services/socket_service.dart';

import '../presentation/widget/contributor_request_dialog.dart';



class GlobalWebSocketHandler extends GetxService {
  final WebSocketClientService webSocketService = WebSocketClientService.to;

  // Track current co-host status globally
  final RxBool isCurrentlyCoHost = false.obs;
  final RxString currentStreamId = ''.obs;
  final RxList<String> coHostIds = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    _setupGlobalListeners();
  }

  void _setupGlobalListeners() {
    // Contribution request handler
    webSocketService.setOnContributionRequest((data) {
      log("🌍 Global handler received contribution request");
      _handleContributionRequest(data);
    });

    // Co-host joined handler
    webSocketService.setOnCoHostJoined((data) {
      log("🌍 Global handler: Co-host joined");
      _handleCoHostJoined(data);
    });

    // Co-host left handler
    webSocketService.setOnCoHostLeft((data) {
      log("🌍 Global handler: Co-host left");
      _handleCoHostLeft(data);
    });

    // Host transferred handler
    webSocketService.setOnHostTransferred((data) {
      log("🌍 Global handler: Host transferred");
      _handleHostTransferred(data);
    });
  }

  void _handleContributionRequest(Map<String, dynamic> data) {
    try {
      final from = data['from'] as Map<String, dynamic>;
      final String fromUserId = from['id'] ?? '';
      final String firstName = from['firstName'] ?? '';
      final String lastName = from['lastName'] ?? '';
      final String fromUserName = '$firstName $lastName';
      final String? fromUserImage = from['profileImage'];
      final String? fromUserProfession = from['profession'];
      final String coHostLink = data['link'] ?? '';
      final String streamId = data['streamId'] ?? '';

      log("👤 Global: Invitation from: $fromUserName");
      log("🔗 Global: Co-Host Link: $coHostLink");
      log("📺 Global: Stream ID: $streamId");

      // Get current context
      final BuildContext? context = Get.context;
      if (context == null) {
        log("❌ No context available to show dialog");
        return;
      }

      // Show the contribution request dialog
      ContributorRequestDialog.show(
        context,
        fromUserId: fromUserId,
        fromUserName: fromUserName,
        fromUserImage: fromUserImage,
        fromUserProfession: fromUserProfession,
        coHostLink: coHostLink,
        streamId: streamId,
        webSocketService: webSocketService,
        onAccepted: () {
          log("🎉 User accepted co-host invitation from global handler");

          // Update global co-host status
          isCurrentlyCoHost.value = true;
          currentStreamId.value = streamId;

          if (!coHostIds.contains(fromUserId)) {
            coHostIds.add(fromUserId);
          }
        },
      );
    } catch (e) {
      log("❌ Error in global contribution request handler: $e");
    }
  }

  void _handleCoHostJoined(Map<String, dynamic> data) {
    try {
      final String coHostId = data['coHostId'] ?? '';
      final String streamId = data['streamId'] ?? '';
      final String coHostName = data['coHostName'] ?? 'Co-Host';

      if (coHostId.isNotEmpty && !coHostIds.contains(coHostId)) {
        coHostIds.add(coHostId);
        log("✅ Co-host $coHostName ($coHostId) joined stream $streamId");

        // Show notification
        Get.snackbar(
          "Co-Host Joined",
          "$coHostName has joined as co-host",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green.withOpacity(0.8),
          colorText: Colors.white,
          duration: Duration(seconds: 3),
          icon: Icon(Icons.co_present, color: Colors.white),
        );
      }
    } catch (e) {
      log("❌ Error handling co-host joined: $e");
    }
  }

  void _handleCoHostLeft(Map<String, dynamic> data) {
    try {
      final String coHostId = data['coHostId'] ?? '';
      final String streamId = data['streamId'] ?? '';

      if (coHostId.isNotEmpty) {
        coHostIds.remove(coHostId);
        log("❌ Co-host ($coHostId) left stream $streamId");

        // Check if it's the current user
        final SharedPreferencesHelper helper = SharedPreferencesHelper();
        final String? currentUserId = helper.getString('userId');

        if (currentUserId == coHostId) {
          // Current user is the one who left as co-host
          isCurrentlyCoHost.value = false;
          currentStreamId.value = '';
          log("📌 Current user left as co-host");
        } else {
          // Another co-host left
          Get.snackbar(
            "Co-Host Left",
            "A co-host has left the session",
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.orange.withOpacity(0.8),
            colorText: Colors.white,
            duration: Duration(seconds: 3),
            icon: Icon(Icons.person_remove, color: Colors.white),
          );
        }
      }
    } catch (e) {
      log("❌ Error handling co-host left: $e");
    }
  }

  void _handleHostTransferred(Map<String, dynamic> data) {
    try {
      final String oldHostId = data['oldHostId'] ?? '';
      final String newHostId = data['newHostId'] ?? '';
      final String streamId = data['streamId'] ?? '';

      log("🔄 Host transferred from $oldHostId to $newHostId in stream $streamId");

      // Check if current user is the new host
      final SharedPreferencesHelper helper = SharedPreferencesHelper();
      final String? currentUserId = helper.getString('userId');

      if (currentUserId == newHostId) {
        // Current user became the host
        isCurrentlyCoHost.value = false; // No longer co-host, now host
        currentStreamId.value = streamId;

        Get.snackbar(
          "You're Now the Host! 🎉",
          "The host role has been transferred to you. You now have full control of the session.",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.blue.withOpacity(0.95),
          colorText: Colors.white,
          duration: Duration(seconds: 5),
          icon: Icon(Icons.stars, color: Colors.yellow),
          margin: EdgeInsets.all(16),
          borderRadius: 12,
        );
      } else if (currentUserId == oldHostId) {
        // Current user was the host and transferred it
        isCurrentlyCoHost.value = false;

        Get.snackbar(
          "Host Role Transferred",
          "You have transferred the host role. You are now leaving the session.",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.blue.withOpacity(0.8),
          colorText: Colors.white,
          duration: Duration(seconds: 3),
        );
      } else {
        // Someone else became the host
        Get.snackbar(
          "New Host",
          "The host role has been transferred to another user",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.blue.withOpacity(0.8),
          colorText: Colors.white,
          duration: Duration(seconds: 3),
          icon: Icon(Icons.swap_horiz, color: Colors.white),
        );
      }
    } catch (e) {
      log("❌ Error handling host transfer: $e");
    }
  }

  /// Helper method to check if user is co-host in a stream
  bool isCoHostInStream(String streamId) {
    return isCurrentlyCoHost.value && currentStreamId.value == streamId;
  }

  /// Helper method to reset co-host status when leaving stream
  void resetCoHostStatus() {
    isCurrentlyCoHost.value = false;
    currentStreamId.value = '';
    log("🔄 Co-host status reset");
  }

  /// Helper method to get co-host count
  int getCoHostCount() {
    return coHostIds.length;
  }

  /// Helper method to check if there are any co-hosts
  bool hasCoHosts() {
    return coHostIds.isNotEmpty;
  }

  /// Clear all co-hosts (when session ends)
  void clearCoHosts() {
    coHostIds.clear();
    log("🗑️ All co-hosts cleared");
  }
}
