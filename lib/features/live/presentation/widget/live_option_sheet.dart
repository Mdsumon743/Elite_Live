import 'dart:developer';

import 'package:elites_live/features/live/presentation/widget/pool_create_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'live_link_box.dart';
import 'live_menu_option.dart';

class LiveOptionsSheet extends StatelessWidget {
  final bool isHost;
  final String? liveId;
  final String? roomId;
  final String? coHostLink;
  final dynamic controller;

  const LiveOptionsSheet({
    super.key,
    required this.isHost,
    required this.liveId,
    required this.roomId,
    required this.coHostLink,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? data = Get.arguments;
    final String hostLink = data?["hostLink"] ?? "";
    final String audienceLink = data?["audienceLink"] ?? "";

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// Top drag handle
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(height: 20.h),

          /// Title
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              children: [
                Text(
                  "Live Options",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),

          /// Host-only shareable links
          if (isHost)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LinkBox(title: "Host Join Link", value: hostLink),
                  SizedBox(height: 10.h),
                  LinkBox(title: "Co-Host Join Link", value: coHostLink ?? ""),
                  SizedBox(height: 10.h),
                  LinkBox(title: "Audience Join Link", value: audienceLink, liveId: liveId),
                  SizedBox(height: 20.h),
                ],
              ),
            ),

          /// Host-only options
          if (isHost) ...[
            MenuOption(
              icon: Icons.screen_share,
              title: "Screen Share",
              subtitle: controller.isScreenSharing.value
                  ? "Stop sharing screen"
                  : "Share your screen",
              color: Colors.blue,
              onTap: () {
                Get.back();
                controller.toggleScreenShare();
              },
            ),
            MenuOption(
              icon: Icons.fiber_manual_record,
              title: "Recording",
              subtitle: controller.isRecording.value
                  ? "Stop recording session"
                  : "Record live session",
              color: Colors.red,
              onTap: () {
                Get.back();
                controller.toggleRecording();
              },
            ),
            MenuOption(
              icon: Icons.person_add,
              title: "Add Contributor",
              subtitle: "Invite someone to join",
              color: Colors.green,
              onTap: () {
                Get.back();
                controller.add();
              },
            ),
          ],

          /// Available to all
          MenuOption(
            icon: Icons.poll,
            title: "Create Poll",
            subtitle: "Engage with audience",
            color: Colors.orange,
            onTap: () {
              log("Create Poll button pressed");
              Get.back();
              CreatePollDialog.show(context, streamId: liveId!);
            },
          ),

          /// End Live (Host only)
          if (isHost)
            MenuOption(
              icon: Icons.call_end,
              title: "End Live",
              subtitle: "Stop live streaming",
              color: Colors.red[700]!,
              onTap: () {
                Get.back();
                controller.endCall(context, roomId!);
              },
              isDanger: true,
            ),

          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  /// Helper to show the bottom sheet
  static void show(
      BuildContext context, {
        required bool isHost,
        required String? liveId,
        required String? roomId,
        required String? coHostLink,
        required dynamic controller,
      }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => LiveOptionsSheet(
        isHost: isHost,
        liveId: liveId,
        roomId: roomId,
        coHostLink: coHostLink,
        controller: controller,
      ),
    );
  }
}