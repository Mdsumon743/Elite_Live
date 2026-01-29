
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/global_widget/custom_snackbar.dart';
import '../../../../core/global_widget/custom_text_view.dart';
import '../../../../core/helper/shared_prefarenses_helper.dart';
import '../../../../core/services/socket_service.dart';
import '../../../../core/utils/constants/app_colors.dart';


import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';



/*
class ContributorRequestDialog {
  static void show(
      BuildContext context, {
        required String fromUserId,
        required String fromUserName,
        required String? fromUserImage,
        required String? fromUserProfession,
        required String coHostLink,
        required String streamId,
        required WebSocketClientService webSocketService,
        required VoidCallback onAccepted, // NEW: Callback to update role
      }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _ContributorRequestDialogContent(
        fromUserId: fromUserId,
        fromUserName: fromUserName,
        fromUserImage: fromUserImage,
        fromUserProfession: fromUserProfession,
        coHostLink: coHostLink,
        streamId: streamId,
        webSocketService: webSocketService,
        onAccepted: onAccepted,
      ),
    );
  }
}

class _ContributorRequestDialogContent extends StatefulWidget {
  final String fromUserId;
  final String fromUserName;
  final String? fromUserImage;
  final String? fromUserProfession;
  final String coHostLink;
  final String streamId;
  final WebSocketClientService webSocketService;
  final VoidCallback onAccepted;

  const _ContributorRequestDialogContent({
    required this.fromUserId,
    required this.fromUserName,
    required this.fromUserImage,
    required this.fromUserProfession,
    required this.coHostLink,
    required this.streamId,
    required this.webSocketService,
    required this.onAccepted,
  });

  @override
  State<_ContributorRequestDialogContent> createState() =>
      _ContributorRequestDialogContentState();
}

class _ContributorRequestDialogContentState
    extends State<_ContributorRequestDialogContent> {
  bool _isProcessing = false;

  void _handleAccept() async {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      log("✅ Accepting contributor invitation");
      log("🔗 Co-Host Link: ${widget.coHostLink}");
      log("📺 Stream ID: ${widget.streamId}");

      // Send acceptance message via WebSocket
      widget.webSocketService.sendMessage({
        "type": "accept-contribution",
        "streamId": widget.streamId,
        "fromUserId": widget.fromUserId,
      });

      // Close the dialog
      Get.back();

      // Switch to co-host role in the current stream
      _switchToCoHostRole();

      // Trigger callback to update parent widget
      widget.onAccepted();

      Get.snackbar(
        "Success",
        "You are now a co-host in this live stream",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      log("🎉 Successfully switched to co-host role");
    } catch (e) {
      log("❌ Error accepting invitation: $e");
      Get.snackbar(
        "Error",
        "Failed to accept invitation: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );

      setState(() {
        _isProcessing = false;
      });
    }
  }

  void _switchToCoHostRole() {
    try {
      // Enable camera and microphone for co-host
      ZegoUIKit().turnCameraOn(true);
      ZegoUIKit().turnMicrophoneOn(true);

      log("🎤 Camera and microphone enabled for co-host");
    } catch (e) {
      log("⚠️ Error enabling camera/microphone: $e");
    }
  }

  void _handleReject() async {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      log("❌ Rejecting contributor invitation");

      // Send rejection message via WebSocket
      widget.webSocketService.sendMessage({
        "type": "reject-contribution",
        "streamId": widget.streamId,
        "fromUserId": widget.fromUserId,
      });

      // Close the dialog
      Get.back();

      Get.snackbar(
        "Invitation Declined",
        "You have declined the co-host invitation",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );

      log("✅ Successfully rejected invitation");
    } catch (e) {
      log("❌ Error rejecting invitation: $e");
      Get.snackbar(
        "Error",
        "Failed to reject invitation: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );

      setState(() {
        _isProcessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.r),
      ),
      backgroundColor: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Invitation Icon
            Container(
              width: 64.w,
              height: 64.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryColor.withValues(alpha: 0.2),
                    AppColors.secondaryColor.withValues(alpha: 0.2),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.person_add,
                size: 32.sp,
                color: AppColors.primaryColor,
              ),
            ),
            SizedBox(height: 20.h),

            // Title
            CustomTextView(
              text: "Co-Host Invitation",
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textHeader,
            ),
            SizedBox(height: 16.h),

            // User Profile Image
            if (widget.fromUserImage != null && widget.fromUserImage!.isNotEmpty)
              CircleAvatar(
                radius: 40.r,
                backgroundImage: NetworkImage(widget.fromUserImage!),
                backgroundColor: AppColors.lightGrey,
              )
            else
              CircleAvatar(
                radius: 40.r,
                backgroundColor: AppColors.lightGrey,
                child: Icon(
                  Icons.person,
                  size: 40.sp,
                  color: Colors.white,
                ),
              ),
            SizedBox(height: 16.h),

            // Message
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(
                  fontSize: 16.sp,
                  color: AppColors.textBody,
                  height: 1.5,
                ),
                children: [
                  TextSpan(
                    text: widget.fromUserName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  TextSpan(
                    text: " has invited you to join as a ",
                  ),
                  TextSpan(
                    text: "co-host",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  TextSpan(
                    text: " in their live stream",
                  ),
                ],
              ),
            ),

            // Profession (if available)
            if (widget.fromUserProfession != null &&
                widget.fromUserProfession!.isNotEmpty) ...[
              SizedBox(height: 8.h),
              CustomTextView(
                text: widget.fromUserProfession!,
                fontSize: 14.sp,
                color: AppColors.textBody.withOpacity(0.7),
              ),
            ],

            SizedBox(height: 32.h),

            // Action Buttons
            if (_isProcessing)
              Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(AppColors.primaryColor),
                ),
              )
            else
              Row(
                children: [
                  // Reject Button
                  Expanded(
                    child: GestureDetector(
                      onTap: _handleReject,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Center(
                          child: CustomTextView(
                            text: "Reject",
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textBody,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),

                  // Accept Button
                  Expanded(
                    child: GestureDetector(
                      onTap: _handleAccept,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primaryColor,
                              AppColors.secondaryColor,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Center(
                          child: CustomTextView(
                            text: "Accept",
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textWhite,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}*/



import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';

class ContributorRequestDialog {
  static void show(
      BuildContext context, {
        required String fromUserId,
        required String fromUserName,
        required String? fromUserImage,
        required String? fromUserProfession,
        required String coHostLink,
        required String streamId,
        required WebSocketClientService webSocketService,
        required VoidCallback onAccepted,
      }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _ContributorRequestDialogContent(
        fromUserId: fromUserId,
        fromUserName: fromUserName,
        fromUserImage: fromUserImage,
        fromUserProfession: fromUserProfession,
        coHostLink: coHostLink,
        streamId: streamId,
        webSocketService: webSocketService,
        onAccepted: onAccepted,
      ),
    );
  }
}

class _ContributorRequestDialogContent extends StatefulWidget {
  final String fromUserId;
  final String fromUserName;
  final String? fromUserImage;
  final String? fromUserProfession;
  final String coHostLink;
  final String streamId;
  final WebSocketClientService webSocketService;
  final VoidCallback onAccepted;

  const _ContributorRequestDialogContent({
    required this.fromUserId,
    required this.fromUserName,
    required this.fromUserImage,
    required this.fromUserProfession,
    required this.coHostLink,
    required this.streamId,
    required this.webSocketService,
    required this.onAccepted,
  });

  @override
  State<_ContributorRequestDialogContent> createState() =>
      _ContributorRequestDialogContentState();
}

class _ContributorRequestDialogContentState
    extends State<_ContributorRequestDialogContent> {
  bool _isProcessing = false;
  final SharedPreferencesHelper _helper = SharedPreferencesHelper();

  void _handleAccept() async {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      log("✅ Accepting contributor invitation");
      log("🔗 Co-Host Link: ${widget.coHostLink}");
      log("📺 Stream ID: ${widget.streamId}");

      // Get current user info
      final String? currentUserId = _helper.getString('userId');
      final String? currentUserName = _helper.getString('userName') ?? 'Co-Host';

      // Send acceptance message via WebSocket
      widget.webSocketService.sendMessage({
        "type": "accept-contribution",
        "streamId": widget.streamId,
        "fromUserId": widget.fromUserId,
        "acceptedBy": currentUserId,
      });

      // Notify that co-host joined
      widget.webSocketService.notifyCoHostJoined(
        widget.streamId,
        currentUserId ?? '',
        currentUserName!,
      );

      // Close the dialog
      Get.back();

      // Switch to co-host role in the current stream
      _switchToCoHostRole();

      // Trigger callback to update parent widget
      widget.onAccepted();

      CustomSnackBar.success(
        title: "Success",
        message: "You are now a co-host in this live stream",
      );

      log("🎉 Successfully switched to co-host role");
    } catch (e) {
      log("❌ Error accepting invitation: $e");
      CustomSnackBar.error(
        title: "Error",
        message: "Failed to accept invitation: $e",
      );

      setState(() {
        _isProcessing = false;
      });
    }
  }

  void _switchToCoHostRole() {
    try {
      // Enable camera and microphone for co-host
      ZegoUIKit().turnCameraOn(true);
      ZegoUIKit().turnMicrophoneOn(true);

      log("🎤 Camera and microphone enabled for co-host");
    } catch (e) {
      log("⚠️ Error enabling camera/microphone: $e");
    }
  }

  void _handleReject() async {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      log("❌ Rejecting contributor invitation");

      // Get current user info
      final String? currentUserId = _helper.getString('userId');

      // Send rejection message via WebSocket
      widget.webSocketService.sendMessage({
        "type": "reject-contribution",
        "streamId": widget.streamId,
        "fromUserId": widget.fromUserId,
        "rejectedBy": currentUserId,
      });

      // Close the dialog
      Get.back();

      CustomSnackBar.warning(
        title: "Invitation Declined",
        message: "You have declined the co-host invitation",
      );

      log("✅ Successfully rejected invitation");
    } catch (e) {
      log("❌ Error rejecting invitation: $e");
      CustomSnackBar.error(
        title: "Error",
        message: "Failed to reject invitation: $e",
      );

      setState(() {
        _isProcessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.r),
      ),
      backgroundColor: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Invitation Icon
            Container(
              width: 64.w,
              height: 64.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryColor.withValues(alpha: 0.2),
                    AppColors.secondaryColor.withValues(alpha: 0.2),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.person_add,
                size: 32.sp,
                color: AppColors.primaryColor,
              ),
            ),
            SizedBox(height: 20.h),

            // Title
            CustomTextView(
              text: "Co-Host Invitation",
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textHeader,
            ),
            SizedBox(height: 16.h),

            // User Profile Image
            if (widget.fromUserImage != null && widget.fromUserImage!.isNotEmpty)
              CircleAvatar(
                radius: 40.r,
                backgroundImage: NetworkImage(widget.fromUserImage!),
                backgroundColor: AppColors.lightGrey,
              )
            else
              CircleAvatar(
                radius: 40.r,
                backgroundColor: AppColors.lightGrey,
                child: Icon(
                  Icons.person,
                  size: 40.sp,
                  color: Colors.white,
                ),
              ),
            SizedBox(height: 16.h),

            // Message
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(
                  fontSize: 16.sp,
                  color: AppColors.textBody,
                  height: 1.5,
                ),
                children: [
                  TextSpan(
                    text: widget.fromUserName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  TextSpan(
                    text: " has invited you to join as a ",
                  ),
                  TextSpan(
                    text: "co-host",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  TextSpan(
                    text: " in their live stream",
                  ),
                ],
              ),
            ),

            // Profession (if available)
            if (widget.fromUserProfession != null &&
                widget.fromUserProfession!.isNotEmpty) ...[
              SizedBox(height: 8.h),
              CustomTextView(
                text: widget.fromUserProfession!,
                fontSize: 14.sp,
                color: AppColors.textBody.withOpacity(0.7),
              ),
            ],

            SizedBox(height: 32.h),

            // Co-Host Permissions Info
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue, size: 20.sp),
                      SizedBox(width: 8.w),
                      CustomTextView(
                        text: "Co-Host Permissions:",
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue,
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  _buildPermissionItem("✓ Screen sharing"),
                  _buildPermissionItem("✓ Recording control"),
                  _buildPermissionItem("✓ End session"),
                  _buildPermissionItem("✗ Cannot add contributors"),
                ],
              ),
            ),

            SizedBox(height: 24.h),

            // Action Buttons
            if (_isProcessing)
              Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(AppColors.primaryColor),
                ),
              )
            else
              Row(
                children: [
                  // Reject Button
                  Expanded(
                    child: GestureDetector(
                      onTap: _handleReject,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Center(
                          child: CustomTextView(
                            text: "Reject",
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textBody,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),

                  // Accept Button
                  Expanded(
                    child: GestureDetector(
                      onTap: _handleAccept,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primaryColor,
                              AppColors.secondaryColor,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Center(
                          child: CustomTextView(
                            text: "Accept",
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textWhite,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionItem(String text) {
    return Padding(
      padding: EdgeInsets.only(left: 8.w, top: 4.h),
      child: CustomTextView(
        text: text,
        fontSize: 12.sp,
        color: Colors.grey[700]!,
      ),
    );
  }
}
