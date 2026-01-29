import 'package:elites_live/features/home/presentation/widget/donation_sheet.dart';
import 'package:elites_live/features/home/presentation/widget/share_sheet.dart';
import 'package:flutter/material.dart';

import '../../controller/live_controller.dart';
import '../../data/comment_data_model.dart';


class CommentItem extends StatelessWidget {
  final Comment comment;
  final LiveController controller;

  const CommentItem({super.key,
    required this.comment,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final isHost = comment.userName == 'Mobbin Design';

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundImage: NetworkImage(comment.userImage),
                  ),
                  if (isHost)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Live',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          comment.userName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (isHost) ...[
                          const SizedBox(width: 8),
                          Text(
                            '50k',
                            style: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (comment.text.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        comment.text,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                    ],
                    if (comment.imagePath != null) ...[
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          comment.imagePath!,
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                    if (comment.emoji != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        comment.emoji!,
                        style: const TextStyle(fontSize: 24),
                      ),
                    ],
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text(
                          controller.getTimeAgo(comment.timestamp),
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(width: 16),
                        GestureDetector(
                          onTap: () => controller.toggleLike(comment),
                          child: Text(
                            'Like',
                            style: TextStyle(
                              color: comment.isLiked.value
                                  ? Colors.red.shade400
                                  : Colors.grey.shade400,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        GestureDetector(
                          onTap: () => controller.setReplyingTo(comment),
                          child: Text(
                            'Reply',
                            style: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (isHost)
                Column(
                  children: [
                    Icon(
                      comment.isLiked.value ? Icons.favorite : Icons.favorite_border,
                      color: comment.isLiked.value
                          ? Colors.red
                          : Colors.grey.shade400,
                      size: 18,
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: (){
                        DonationSheet.show(context,eventId: '');
                      },
                      child: Icon(
                        Icons.paid_outlined,
                        color: Colors.grey.shade400,
                        size: 18,
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
                        size: 18,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          // Replies
          if (comment.replies.isNotEmpty) ...[
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.only(left: 42),
              child: Column(
                children: comment.replies
                    .map((reply) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: CommentItem(
                    comment: reply,
                    controller: controller,
                  ),
                ))
                    .toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }
}