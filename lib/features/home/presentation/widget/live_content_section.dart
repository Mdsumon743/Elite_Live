import 'package:elites_live/features/home/presentation/widget/donation_sheet.dart';
import 'package:elites_live/features/home/presentation/widget/pool_section.dart';
import 'package:elites_live/features/home/presentation/widget/share_sheet.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../controller/live_controller.dart';
import 'comment_item.dart';
import 'host_information.dart';

class LiveContentSection extends StatelessWidget {
  const LiveContentSection({
    super.key,
    required this.controller,
  });

  final LiveController controller;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Top Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'Live',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Obx(() {
                  final viewerCount = controller.liveStreamInfo.value?.viewerCount ?? 0;
                  String formattedCount = viewerCount >= 1000
                      ? '${(viewerCount / 1000).toStringAsFixed(1)}k'
                      : viewerCount.toString();

                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black38,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.visibility_outlined,
                          color: Colors.white,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          formattedCount,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),

          /// Video Grid (Participants)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Container(
              height: 310.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                ///border: Border.all(color: Colors.orange, width: 2),
              ),
              child: Row(
                children: [
                  // Main participant
                  Expanded(
                    flex: 3,
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.horizontal(
                          left: Radius.circular(10),
                        ),
                        image: DecorationImage(
                          image: NetworkImage(
                              'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=400'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  // Side participants
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(
                                    'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Expanded(
                          child: Container(
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(
                                    'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Expanded(
                          child: Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(10),
                              ),
                              image: DecorationImage(
                                image: NetworkImage(
                                    'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=400'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          /// Poll Section
          Obx(() {
            final poll = controller.currentPoll.value;
            if (poll == null) return const SizedBox.shrink();

            return PollSection(controller: controller, poll: poll);
          }),
          SizedBox(height: 10.h,),




          /// vote section
          Obx(() {
            final poll = controller.currentPoll.value;
            if (poll == null) return const SizedBox.shrink();

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GestureDetector(
                onTap: () => controller.openVoteSheet(),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.purple,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.how_to_vote,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'Votes',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.purple.withValues(alpha: 0.3),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    '${controller.totalPollVotes}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'View all votes',
                              style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey.shade400,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),

          const SizedBox(height: 16),

          // Comments Section
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade900.withValues(alpha: 0.95),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  // Comments List
                  Expanded(
                    child: Obx(
                          () => ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: controller.comments.length,
                        itemBuilder: (context, index) {
                          final comment = controller.comments[index];
                          return CommentItem(
                            comment: comment,
                            controller: controller,
                          );
                        },
                      ),
                    ),
                  ),

                  // Host Info
                  Obx(() {
                    final info = controller.liveStreamInfo.value;
                    if (info == null) return const SizedBox.shrink();

                    return HostInformationSection(info: info);
                  }),

                  // Reply indicator
                  Obx(() {
                    if (controller.replyingTo.value == null) {
                      return const SizedBox.shrink();
                    }
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      color: Colors.grey.shade800,
                      child: Row(
                        children: [
                          Icon(
                            Icons.reply,
                            color: Colors.grey.shade400,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Replying to ${controller.replyingTo.value!.userName}',
                              style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => controller.cancelReply(),
                            child: Icon(
                              Icons.close,
                              color: Colors.grey.shade400,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),

                  // Message Input
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade900,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade800,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: TextField(
                              controller: controller.messageController,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: 'Type a message',
                                hintStyle: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 14,
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                                suffixIcon: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.mood_outlined,
                                      color: Colors.grey.shade500,
                                      size: 22,
                                    ),
                                    const SizedBox(width: 8),
                                    Icon(
                                      Icons.card_giftcard,
                                      color: Colors.grey.shade500,
                                      size: 22,
                                    ),
                                    const SizedBox(width: 12),
                                  ],
                                ),
                              ),
                              onSubmitted: (_) => controller.sendMessage(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          children: [
                            Icon(
                              Icons.favorite_border,
                              color: Colors.grey.shade400,
                              size: 24,
                            ),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: (){
                                DonationSheet.show(context, eventId: '');
                              },

                              child: Icon(
                                Icons.paid_outlined,
                                color: Colors.grey.shade400,
                                size: 24,
                              ),
                            ),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: (){
                                ShareSheet().show(context);
                              },
                              child: Icon(
                                Icons.share_outlined,
                                color: Colors.grey.shade400,
                                size: 24,
                              ),
                            ),
                          ],
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
    );
  }
}