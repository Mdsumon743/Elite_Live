
// To parse this JSON data, do
//
//     final postInformationDataModel = postInformationDataModelFromJson(jsonString);

import 'dart:convert';

PostInformationDataModel postInformationDataModelFromJson(String str) => PostInformationDataModel.fromJson(json.decode(str));

String postInformationDataModelToJson(PostInformationDataModel data) => json.encode(data.toJson());

class PostInformationDataModel {
  bool success;
  String message;
  PostInfoResult result;

  PostInformationDataModel({
    required this.success,
    required this.message,
    required this.result,
  });

  factory PostInformationDataModel.fromJson(Map<String, dynamic> json) => PostInformationDataModel(
    success: json["success"],
    message: json["message"],
    result: PostInfoResult.fromJson(json["result"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "result": result.toJson(),
  };
}

class PostInfoResult {
  String id;
  String content;
  String userId;
  User user;
  List<CommentGroupPost> commentGroupPost;
  Count count;
  List<dynamic> likeGroupPost;
  DateTime createdAt;
  bool isLiked;

  PostInfoResult({
    required this.id,
    required this.content,
    required this.userId,
    required this.user,
    required this.commentGroupPost,
    required this.count,
    required this.likeGroupPost,
    required this.createdAt,
    required this.isLiked,
  });

  factory PostInfoResult.fromJson(Map<String, dynamic> json) => PostInfoResult(
    id: json["id"],
    content: json["content"],
    userId: json["userId"],
    user: User.fromJson(json["user"]),
    commentGroupPost: List<CommentGroupPost>.from(json["commentGroupPost"].map((x) => CommentGroupPost.fromJson(x))),
    count: Count.fromJson(json["_count"]),
    likeGroupPost: List<dynamic>.from(json["likeGroupPost"].map((x) => x)),
    createdAt: DateTime.parse(json["createdAt"]),
    isLiked: json["isLiked"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "content": content,
    "userId": userId,
    "user": user.toJson(),
    "commentGroupPost": List<dynamic>.from(commentGroupPost.map((x) => x.toJson())),
    "_count": count.toJson(),
    "likeGroupPost": List<dynamic>.from(likeGroupPost.map((x) => x)),
    "createdAt": createdAt.toIso8601String(),
    "isLiked": isLiked,
  };
}

class CommentGroupPost {
  String id;
  User user;
  String comment;
  List<ReplyCommentGroupPost> replyCommentGroupPost;
  DateTime createdAt;

  CommentGroupPost({
    required this.id,
    required this.user,
    required this.comment,
    required this.replyCommentGroupPost,
    required this.createdAt,
  });

  factory CommentGroupPost.fromJson(Map<String, dynamic> json) => CommentGroupPost(
    id: json["id"],
    user: User.fromJson(json["user"]),
    comment: json["comment"],
    replyCommentGroupPost: List<ReplyCommentGroupPost>.from(json["replyCommentGroupPost"].map((x) => ReplyCommentGroupPost.fromJson(x))),
    createdAt: DateTime.parse(json["createdAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user": user.toJson(),
    "comment": comment,
    "replyCommentGroupPost": List<dynamic>.from(replyCommentGroupPost.map((x) => x.toJson())),
    "createdAt": createdAt.toIso8601String(),
  };
}

class ReplyCommentGroupPost {
  String id;
  User user;
  String replyComment;
  DateTime createdAt;

  ReplyCommentGroupPost({
    required this.id,
    required this.user,
    required this.replyComment,
    required this.createdAt,
  });

  factory ReplyCommentGroupPost.fromJson(Map<String, dynamic> json) => ReplyCommentGroupPost(
    id: json["id"],
    user: User.fromJson(json["user"]),
    replyComment: json["replyComment"],
    createdAt: DateTime.parse(json["createdAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user": user.toJson(),
    "replyComment": replyComment,
    "createdAt": createdAt.toIso8601String(),
  };
}

class User {
  String id;
  String firstName;
  String lastName;
  dynamic profileImage;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.profileImage,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    profileImage: json["profileImage"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "firstName": firstName,
    "lastName": lastName,
    "profileImage": profileImage,
  };
}

class Count {
  int commentGroupPost;
  int likeGroupPost;

  Count({
    required this.commentGroupPost,
    required this.likeGroupPost,
  });

  factory Count.fromJson(Map<String, dynamic> json) => Count(
    commentGroupPost: json["commentGroupPost"],
    likeGroupPost: json["likeGroupPost"],
  );

  Map<String, dynamic> toJson() => {
    "commentGroupPost": commentGroupPost,
    "likeGroupPost": likeGroupPost,
  };
}
