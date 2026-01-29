import 'package:elites_live/core/global_widget/custom_loading.dart';
import 'package:elites_live/core/global_widget/custom_text_view.dart';
import 'package:elites_live/core/utils/constants/app_colors.dart';
import 'package:elites_live/features/event/controller/schedule_controller.dart';
import 'package:elites_live/features/profile/controller/my_schedule_event_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'dart:developer';

import '../../../../core/global_widget/custom_comment_sheet.dart';
import '../../../../core/global_widget/custom_snackbar.dart';
import '../../../../routes/app_routing.dart';
import '../../../event/presentation/widget/user_interaction_section.dart';
import '../../../home/presentation/widget/donation_sheet.dart';
import '../../../live/controller/live_screen_controller.dart';
import '../../controller/profile_controller.dart';



class EventScheduleTab extends StatelessWidget {
  const EventScheduleTab({super.key});

  // -----------------------
  // Safe access helper utils
  // -----------------------
  bool _safeBool(dynamic obj, List<String> candidates, {bool fallback = false}) {
    for (final name in candidates) {
      try {
        final value = _getProperty(obj, name);
        if (value is bool) return value;
        if (value is int) return value != 0;
        if (value is String) {
          final lower = value.toLowerCase();
          if (lower == 'true' || lower == '1') return true;
          if (lower == 'false' || lower == '0') return false;
        }
      } catch (_) {
        // ignore and try next
      }
    }
    return fallback;
  }

  String? _safeString(dynamic obj, List<String> candidates) {
    for (final name in candidates) {
      try {
        final value = _getProperty(obj, name);
        if (value != null) return value.toString();
      } catch (_) {}
    }
    return null;
  }

  num _safeNum(dynamic obj, List<String> candidates, {num fallback = 0}) {
    for (final name in candidates) {
      try {
        final value = _getProperty(obj, name);
        if (value is num) return value;
        if (value is String) return num.tryParse(value) ?? fallback;
      } catch (_) {}
    }
    return fallback;
  }

  dynamic _getProperty(dynamic obj, String name) {
    // Access property via dynamic getter. This will throw if property doesn't exist — the caller wraps it.
    // Example: return obj.someProperty;
    // We implement using no mirrors — we rely on Dart's dynamic dispatch.
    switch (name) {
    // common event props
      case 'id':
        return obj.id;
      case 'isPayment':
        return obj.isPayment;
      case 'isPaid':
        return obj.isPaid;
      case 'payment':
        return obj.payment;
      case 'is_owner':
        return obj.is_owner;
      case 'isOwner':
        return obj.isOwner;
      case 'payAmount':
        return obj.payAmount;
      case 'pay_amount':
        return obj.pay_amount;
      case 'streamId':
        return obj.streamId;
      case 'stream_id':
        return obj.stream_id;
      case 'stream':
        return obj.stream;
      case 'userId':
        return obj.userId;
      case 'user_id':
        return obj.user_id;
      case 'eventType':
        return obj.eventType;
      case 'title':
        return obj.title;
      case 'text':
        return obj.text;
      case 'scheduleDate':
        return obj.scheduleDate;
      case 'schedule_date':
        return obj.schedule_date;
      case 'user':
        return obj.user;
      case 'isLiked':
        return obj.isLiked;
      case 'count':
        return obj.count;
      default:
      // Fallback dynamic try: attempt to access via indexer (for map-like objects)
        try {
          if (obj is Map) return obj[name];
        } catch (_) {}
        // If unknown, attempt a direct member access via `obj.name` using no reflection -> will throw to caller.
        // Use a small manual attempt using a Function that reads the property by using `obj.name` in code above.
        throw NoSuchMethodError.withInvocation(obj, Invocation.getter(Symbol(name)));
    }
  }

  // stream object helpers
  String? _getStreamLink(dynamic streamObj, List<String> candidates) {
    if (streamObj == null) return null;
    for (final name in candidates) {
      try {
        final v = _getProperty(streamObj, name);
        if (v != null) return v.toString();
      } catch (_) {}
    }
    return null;
  }

  // -----------------------
  // Widget build
  // -----------------------
  @override
  Widget build(BuildContext context) {
    final MyScheduleEventController controller = Get.find();
    final ScheduleController scheduleController = Get.find();

    return Obx(() {
      log(
        'EventScheduleTab rebuild - isLoading: ${controller.isLoading.value}',
      );
      log(
        'EventScheduleTab rebuild - list length: ${controller.myEventScheduleList.length}',
      );

      if (controller.isLoading.value) {
        return SizedBox(
          height: 200.h,
          child: Center(child: CustomLoading(color: AppColors.primaryColor)),
        );
      }

      if (controller.myEventScheduleList.isEmpty) {
        log('EventScheduleTab: List is empty, showing empty state');
        return SizedBox(
          height: 200.h,
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 40.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.event_busy, size: 64.sp, color: Colors.grey[400]),
                  SizedBox(height: 16.h),
                  Text(
                    "No Schedule Available",
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "Your scheduled events will appear here",
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }

      // Get the first schedule result
      final scheduleResult = controller.myEventScheduleList.first;
      log('EventScheduleTab: Events count: ${scheduleResult.events.length}');

      if (scheduleResult.events.isEmpty) {
        return SizedBox(
          height: 200.h,
          child: Center(
            child: Text(
              "No events found",
              style: GoogleFonts.inter(fontSize: 14.sp),
            ),
          ),
        );
      }

      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        itemCount: scheduleResult.events.length,
        separatorBuilder: (context, index) => SizedBox(height: 16.h),
        itemBuilder: (context, index) {
          final event = scheduleResult.events[index];

          // Safe property reads
          final scheduleDate = _safeString(event, ['scheduleDate', 'schedule_date']) != null
              ? ( _getProperty(event, 'scheduleDate') ?? _getProperty(event, 'schedule_date') )
              : null;
          DateTime parsedScheduleDate;
          try {
            if (scheduleDate is DateTime) {
              parsedScheduleDate = scheduleDate;
            } else if (scheduleDate is String) {
              parsedScheduleDate = DateTime.tryParse(scheduleDate) ?? DateTime.now();
            } else {
              parsedScheduleDate = event.scheduleDate ?? DateTime.now();
            }
          } catch (_) {
            parsedScheduleDate = DateTime.now();
          }

          // Format date and time
          String formattedDate = DateFormat('dd-MM-yyyy').format(parsedScheduleDate);
          String formattedTime = DateFormat('hh:mm a').format(parsedScheduleDate);

          // Other safe fields
          final eventTitle = _safeString(event, ['eventType', 'title']) ?? '';
          final eventText = _safeString(event, ['text']) ?? '';
          final payAmount = _safeNum(event, ['payAmount', 'pay_amount'], fallback: 0);
          final isOwner = _safeBool(event, ['isOwner', 'is_owner'], fallback: false);
          final isPayment = _safeBool(event, ['isPayment', 'isPaid', 'payment'], fallback: true);
          final eventIdValue = _safeNum(event, ['id'], fallback: 0).toInt();
          final hostId = _safeString(event, ['userId', 'user_id']) ?? '';
          final streamId = _safeString(event, ['streamId', 'stream_id']) ?? _safeString(event, ['stream_id', 'streamId']) ?? '';
          final streamObj = (() {
            try {
              return _getProperty(event, 'stream');
            } catch (e) {
              return null;
            }
          })();

          final hostLink = _getStreamLink(streamObj, ['hostLink', 'host_link']);
          final audienceLink = _getStreamLink(streamObj, ['audienceLink', 'audience_link']);
          final coHostLink = _getStreamLink(streamObj, ['coHostLink', 'co_host_link', 'cohostLink']);

          return Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: const Color(0xFFE8E8E8), width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Date and Time Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomTextView(
                      text: formattedDate,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textHeader,
                    ),
                    CustomTextView(
                      text: formattedTime,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textHeader,
                    ),
                  ],
                ),

                SizedBox(height: 12.h),

                /// Event Title
                CustomTextView(
                  text: eventTitle,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textHeader,
                ),

                SizedBox(height: 8.h),

                /// Event Description
                CustomTextView(
                  text: eventText,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textBody,
                ),

                SizedBox(height: 12.h),

                /// Pay Amount
                if (payAmount > 0) ...[
                  Text(
                    "Pay \$${payAmount.toStringAsFixed(payAmount % 1 == 0 ? 0 : 2)}",
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF191919),
                    ),
                  ),
                  SizedBox(height: 8.h),
                ],

                /// Go to Live Event Link (clickable)
                RichText(
                  text: TextSpan(
                    text: "Go to Live Event: ",
                    style: GoogleFonts.inter(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF191919),
                    ),
                    children: [
                      WidgetSpan(
                        child: GestureDetector(
                          onTap: () {
                            _handleJoinClick(
                              context: context,
                              event: event,
                              scheduleController: scheduleController,
                            );
                          },
                          child: Text(
                            "Click here to join",
                            style: GoogleFonts.inter(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF007AFF),
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 16.h),

                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                  child: UserInteractionSection(
                    onLikeTap: () {
                      scheduleController.createLike(eventIdValue.toString());
                    },
                    eventType: eventTitle,
                    isLiked: _safeBool(event, ['isLiked'], fallback: false),
                    likeCount: (() {
                      try {
                        final cnt = _getProperty(event, 'count');
                        // try common patterns
                        final likes = cnt?.eventLike ?? cnt?['eventLike'] ?? cnt?['likes'] ?? cnt?.likes;
                        return likes?.toString() ?? '0';
                      } catch (_) {
                        return '0';
                      }
                    })(),
                    commentCount: (() {
                      try {
                        final cnt = _getProperty(event, 'count');
                        final com = cnt?.eventComment ?? cnt?['eventComment'] ?? cnt?['comments'] ?? cnt?.comments;
                        return com ?? 0;
                      } catch (_) {
                        return 0;
                      }
                    })(),
                    onCommentTap: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return CommentSheet(
                              scheduleController: scheduleController,
                              eventId: eventIdValue.toString(),
                            );
                          });
                    },
                    isOwner: isOwner,
                  ),
                ),
              ],
            ),
          );
        },
      );
    });
  }

  void _handleJoinClick({
    required BuildContext context,
    required dynamic event,
    required ScheduleController scheduleController,
  }) {
    final LiveScreenController controller = Get.find();
    final ProfileController profileController = Get.find();

    // Resolve fields safely
    final isOwner = _safeBool(event, ['isOwner', 'is_owner'], fallback: false);
    final isPayment = _safeBool(event, ['isPayment', 'isPaid', 'payment'], fallback: true);
    final streamObj = (() {
      try {
        return _getProperty(event, 'stream');
      } catch (_) {
        return null;
      }
    })();
    final hostLink = _getStreamLink(streamObj, ['hostLink', 'host_link']);
    final audienceLink = _getStreamLink(streamObj, ['audienceLink', 'audience_link']);
    final cohostLink = _getStreamLink(streamObj, ['coHostLink', 'co_host_link', 'cohostLink']);
    final streamId = _safeString(event, ['streamId', 'stream_id']) ?? '';
    final hostId = _safeString(event, ['userId', 'user_id']) ?? '';
    final eventId = _safeNum(event, ['id'], fallback: 0).toInt();

    final currentUserName =
    "${profileController.userinfo.value?.firstName ?? ''} ${profileController.userinfo.value?.lastName ?? ''}"
        .trim();

    log("Join Click -> eventId: $eventId, streamId: $streamId, isOwner: $isOwner, isPayment: $isPayment");

    // OWNER ACTIONS
    if (isOwner) {
      if (hostLink == null || hostLink.isEmpty) {
        // create and navigate
        try {
          controller.createAndNavigateToLive(
            isPaid: false,
            isHost: isOwner,
          );
        } catch (e) {
          log("Error creating live: $e");
          CustomSnackBar.error(title: "Error", message: "Unable to create live session");
        }
        return;
      }

      // join existing host session
      if (streamId.isNotEmpty) {
        try {
          controller.startLive(streamId);
        } catch (e) {
          log("startLive error: $e");
        }
      }

      Get.toNamed(AppRoute.myLive, arguments: {
        'roomId': streamId,
        'eventId': eventId,
        'userName': currentUserName,
        'isHost': true,
        'hostLink': hostLink,
        'audienceLink': audienceLink,
        'hostId': hostId,
        'coHostLink': cohostLink,
      });
      return;
    }

    // AUDIENCE: Payment Needed
    if (!isPayment) {
      DonationSheet.show(context, eventId: eventId.toString());
      return;
    }

    // AUDIENCE: Join Live
    if (audienceLink != null && audienceLink.isNotEmpty && streamId.isNotEmpty) {
      try {
        controller.startLive(streamId);
      } catch (e) {
        log("startLive error: $e");
      }

      Get.toNamed(AppRoute.myLive, arguments: {
        'roomId': streamId,
        'eventId': eventId,
        'userName': currentUserName,
        'isHost': false,
        'hostLink': hostLink,
        'audienceLink': audienceLink,
        'hostId': hostId,
        'coHostLink': cohostLink,
      });
      return;
    }

    // Not available
    CustomSnackBar.warning(
      title: "Not Available",
      message: "The live event hasn't started yet.",
    );
  }

/// Helper method to format large numbers (4.5M, 25.2K, etc.)
}

