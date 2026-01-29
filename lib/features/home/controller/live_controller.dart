import 'dart:async';

import 'package:elites_live/core/global_widget/custom_snackbar.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../data/comment_data_model.dart';
import '../data/live_stream_data_model.dart';
import '../data/pool_data_model.dart';


class LiveController extends GetxController {
  final comments = <Comment>[].obs;
  final currentPoll = Rxn<Poll>();
  final showPollSheet = false.obs;
  final showVoteSheet = false.obs;
  final messageController = TextEditingController();
  final selectedPollOption = Rxn<int>();
  final selectedVoteFilter = Rxn<int>();
  final liveStreamInfo = Rxn<LiveStreamInfo>();
  final replyingTo = Rxn<Comment>();
  final voteDetails = <VoteDetail>[].obs;

  final showAd = true.obs;
  final adCountdown = 10.obs;
  Timer? _adTimer;

  @override
  void onInit() {
    super.onInit();
    _initializeDummyData();
    _startAdTimer();
  }

  void _startAdTimer() {
    _adTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (adCountdown.value > 0) {
        adCountdown.value--;
      } else {
        showAd.value = false;
        timer.cancel();
      }
    });
  }

  void dismissAd() {
    showAd.value = false;
    _adTimer?.cancel();
  }




  void _initializeDummyData() {
    // Initialize Live Stream Info
    liveStreamInfo.value = LiveStreamInfo(
      hostName: 'Williamson',
      hostImage: 'https://i.pravatar.cc/150?img=3',
      hostBio: 'Tell me what excites you and makes you smile. Only good conversations—no bad...',
      isFollowing: true,
      isVerified: true,
      viewerCount: 5600,
    );

    // Initialize Comments
    comments.value = [
      Comment(
        id: '1',
        userName: 'Mobbin Design',
        userImage: 'https://i.pravatar.cc/150?img=1',
        text: '',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      Comment(
        id: '2',
        userName: 'Mobben',
        userImage: 'https://i.pravatar.cc/150?img=2',
        text: 'Would you like to play a game?',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      ),
    ];

    // Initialize Poll
    currentPoll.value = Poll(
      id: 'poll_1',
      question: 'How Would rate my singing?',
      options: [
        PollOption(text: 'Good', votes: 45),
        PollOption(text: 'Intermediate', votes: 28),
        PollOption(text: 'Bad', votes: 12),
      ],
    );

    // Initialize dummy vote details
    _initializeDummyVotes();
  }

  void selectVoteFilter(int? index) {
    selectedVoteFilter.value = index;
  }


  void _initializeDummyVotes() {
    voteDetails.value = [
      VoteDetail(
        userName: 'Sarah Johnson',
        userImage: 'https://i.pravatar.cc/150?img=10',
        selectedOptionIndex: 0,
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        isVerified: true,
      ),
      VoteDetail(
        userName: 'Mike Ross',
        userImage: 'https://i.pravatar.cc/150?img=11',
        selectedOptionIndex: 0,
        timestamp: DateTime.now().subtract(const Duration(minutes: 8)),
      ),
      VoteDetail(
        userName: 'Emily Davis',
        userImage: 'https://i.pravatar.cc/150?img=12',
        selectedOptionIndex: 1,
        timestamp: DateTime.now().subtract(const Duration(minutes: 12)),
        isVerified: true,
      ),
      VoteDetail(
        userName: 'James Wilson',
        userImage: 'https://i.pravatar.cc/150?img=13',
        selectedOptionIndex: 0,
        timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
      ),
      VoteDetail(
        userName: 'Lisa Anderson',
        userImage: 'https://i.pravatar.cc/150?img=14',
        selectedOptionIndex: 1,
        timestamp: DateTime.now().subtract(const Duration(minutes: 20)),
      ),
      VoteDetail(
        userName: 'David Brown',
        userImage: 'https://i.pravatar.cc/150?img=15',
        selectedOptionIndex: 2,
        timestamp: DateTime.now().subtract(const Duration(minutes: 25)),
      ),
      VoteDetail(
        userName: 'Jennifer Taylor',
        userImage: 'https://i.pravatar.cc/150?img=16',
        selectedOptionIndex: 0,
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
        isVerified: true,
      ),
      VoteDetail(
        userName: 'Robert Martinez',
        userImage: 'https://i.pravatar.cc/150?img=17',
        selectedOptionIndex: 1,
        timestamp: DateTime.now().subtract(const Duration(minutes: 35)),
      ),
    ];
  }

  String getTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d';
    } else {
      return '${(difference.inDays / 7).floor()}w';
    }
  }

  void openPollSheet() {
    showPollSheet.value = true;
    if (currentPoll.value?.hasVoted == true) {
      selectedPollOption.value = currentPoll.value?.selectedOptionIndex;
    } else {
      selectedPollOption.value = null;
    }
  }

  void closePollSheet() {
    showPollSheet.value = false;
  }

  void openVoteSheet() {
    closePollSheet();
    showVoteSheet.value = true;
  }

  void closeVoteSheet() {
    showVoteSheet.value = false;
  }

  void selectPollOption(int index) {
    if (currentPoll.value?.hasVoted != true) {
      selectedPollOption.value = index;
    }
  }

  void submitVote() {
    if (selectedPollOption.value != null && currentPoll.value != null) {
      final poll = currentPoll.value!;
      if (!poll.hasVoted) {
        poll.options[selectedPollOption.value!].votes++;
        poll.hasVoted = true;
        poll.selectedOptionIndex = selectedPollOption.value;
        currentPoll.refresh();

        // Add user's vote to vote details
        voteDetails.insert(
          0,
          VoteDetail(
            userName: 'You',
            userImage: 'https://i.pravatar.cc/150?img=5',
            selectedOptionIndex: selectedPollOption.value!,
            timestamp: DateTime.now(),
          ),
        );
        CustomSnackBar.success(title: "Vote Submitted", message: "Your vote has been recorded!");


      }
      closePollSheet();
    }
  }

  void sendMessage() {
    if (messageController.text.trim().isEmpty) return;

    final newComment = Comment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userName: 'You',
      userImage: 'https://i.pravatar.cc/150?img=5',
      text: messageController.text.trim(),
      timestamp: DateTime.now(),
    );

    if (replyingTo.value != null) {
      // Add as reply
      final parentIndex = comments.indexWhere((c) => c.id == replyingTo.value!.id);
      if (parentIndex != -1) {
        comments[parentIndex].replies.add(newComment);
        comments.refresh();
      }
      replyingTo.value = null;
    } else {
      // Add as new comment
      comments.add(newComment);
    }

    messageController.clear();
  }

  void toggleLike(Comment comment) {
    comment.isLiked.value = !comment.isLiked.value;
  }

  void setReplyingTo(Comment comment) {
    replyingTo.value = comment;
    messageController.text = '@${comment.userName} ';
  }

  void cancelReply() {
    replyingTo.value = null;
    messageController.clear();
  }

  int get totalPollVotes {
    if (currentPoll.value == null) return 0;
    return currentPoll.value!.options.fold(0, (sum, option) => sum + option.votes);
  }

  @override
  void onClose() {
    messageController.dispose();
    _adTimer?.cancel();
    super.onClose();
  }
}