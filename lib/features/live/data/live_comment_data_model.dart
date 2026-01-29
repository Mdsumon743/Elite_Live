

// lib/features/live/data/live_comment_data_model.dart

class LiveComment {
  final String id;
  final String userId;
  final String userName;
  final String userImage;
  final String comment;
  final DateTime timestamp;

  LiveComment({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userImage,
    required this.comment,
    required this.timestamp,
  });

  /// ✅ FIXED: Handle both single comment and comment from array
  factory LiveComment.fromJson(Map<String, dynamic> json) {
    // Handle nested message structure from backend
    final messageData = json['message'] ?? json;

    // ✅ NEW: Check if this is a comment from EventComment array
    final commentData = json['user'] != null ? json : messageData;

    // Extract user data (might be nested in 'user' object)
    final userData = commentData['user'] ?? commentData;

    // Build userName from firstName and lastName
    final firstName = userData['firstName'] ?? commentData['firstName'] ?? '';
    final lastName = userData['lastName'] ?? commentData['lastName'] ?? '';
    final userName = '$firstName $lastName'.trim();

    return LiveComment(
      id: commentData['id'] ?? commentData['_id'] ?? '',
      userId: userData['id'] ?? userData['userId'] ?? commentData['userId'] ?? '',
      userName: userName.isNotEmpty ? userName : (userData['userName'] ?? commentData['userName'] ?? 'User'),
      userImage: userData['profileImage'] ?? commentData['profileImage'] ?? userData['userImage'] ?? commentData['userImage'] ?? '',
      comment: commentData['comment'] ?? '',
      timestamp: commentData['createdAt'] != null
          ? DateTime.parse(commentData['createdAt'])
          : (commentData['timestamp'] != null
          ? DateTime.parse(commentData['timestamp'])
          : DateTime.now()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'userImage': userImage,
      'comment': comment,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

// WebSocket Message Types
class WebSocketMessageType {
  static const String joinStreamingFree = 'join-streaming-free';
  static const String joinStreaming = 'join-streaming';
  static const String chatStreamingFree = 'chat-streaming-free';
  static const String chatStreaming = 'chat-streaming';
  static const String leaveStreaming = 'leave-streaming';
  static const String leaveStreamingFree = 'leave-streaming-free';

  // Response message types from backend
  static const String chatStreamingComment = 'chat-streaming-comment';
  static const String chatStreamingFreeComment = 'chat-streaming-free-comment';
  static const String newComment = 'new-comment';
  static const String commentHistory = 'comment-history';
  static const String joinSuccess = 'join-success';
  static const String error = 'error';
}

// WebSocket Request Models
class JoinStreamingRequest {
  final String type;
  final String? eventId;
  final String? streamId;

  JoinStreamingRequest({
    required this.type,
    this.eventId,
    this.streamId,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {'type': type};
    if (eventId != null) data['eventId'] = eventId;
    if (streamId != null) data['streamId'] = streamId;
    return data;
  }
}

class ChatStreamingRequest {
  final String type;
  final String? eventId;
  final String? streamId;
  final String comment;

  ChatStreamingRequest({
    required this.type,
    this.eventId,
    this.streamId,
    required this.comment,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'type': type,
      'comment': comment,
    };
    if (eventId != null) data['eventId'] = eventId;
    if (streamId != null) data['streamId'] = streamId;
    return data;
  }
}