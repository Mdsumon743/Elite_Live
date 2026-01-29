// To parse this JSON data, do
//
//     final groupInfoDataModel = groupInfoDataModelFromJson(jsonString);

// ============================================
// FIXED GroupInfoDataModel with Null Safety
// ============================================

import 'dart:convert';

GroupInfoDataModel groupInfoDataModelFromJson(String str) =>
    GroupInfoDataModel.fromJson(json.decode(str));

String groupInfoDataModelToJson(GroupInfoDataModel data) =>
    json.encode(data.toJson());

class GroupInfoDataModel {
  bool? success;
  String? message;
  GroupInfoResult? result; // Made nullable

  GroupInfoDataModel({
    this.success,
    this.message,
    this.result,
  });

  factory GroupInfoDataModel.fromJson(Map<String, dynamic> json) {
    return GroupInfoDataModel(
      success: json["success"] ?? false,
      message: json["message"] ?? '',
      result: json["result"] != null
          ? GroupInfoResult.fromJson(json["result"])
          : null, // ✅ FIXED: Check if result is null
    );
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "result": result?.toJson(), // Use null-aware operator
  };
}

class GroupInfoResult {
  String id;
  String groupName;
  String photo;
  String description;
  List<GroupPost> groupPost;

  GroupInfoResult({
    required this.id,
    required this.groupName,
    required this.photo,
    required this.description,
    required this.groupPost,
  });

  factory GroupInfoResult.fromJson(Map<String, dynamic> json) {
    return GroupInfoResult(
      id: json["id"] ?? '',
      groupName: json["groupName"] ?? '',
      photo: json["photo"] ?? '',
      description: json["description"] ?? '',
      groupPost: json["groupPost"] != null
          ? List<GroupPost>.from(
          json["groupPost"].map((x) => GroupPost.fromJson(x))
      )
          : [], // ✅ FIXED: Return empty list if null
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "groupName": groupName,
    "photo": photo,
    "description": description,
    "groupPost": List<dynamic>.from(groupPost.map((x) => x.toJson())),
  };
}

class GroupPost {
  String id;
  String content;
  User user;
  Count count;
  DateTime createdAt;
  bool isLike;
  bool isOwner;

  GroupPost({
    required this.id,
    required this.content,
    required this.user,
    required this.count,
    required this.createdAt,
    required this.isLike,
    required this.isOwner,
  });

  factory GroupPost.fromJson(Map<String, dynamic> json) {
    return GroupPost(
      id: json["id"] ?? '',
      content: json["content"] ?? '',
      user: json["user"] != null
          ? User.fromJson(json["user"])
          : User(
          id: '',
          firstName: 'Unknown',
          lastName: 'User',
          profileImage: null
      ), // ✅ FIXED: Provide default user if null
      count: json["_count"] != null
          ? Count.fromJson(json["_count"])
          : Count(commentGroupPost: 0, likeGroupPost: 0), // ✅ FIXED: Default count
      createdAt: json["createdAt"] != null
          ? DateTime.parse(json["createdAt"])
          : DateTime.now(), // ✅ FIXED: Default to current time
      isLike: json["isLike"] ?? false,
      isOwner: json["isOwner"] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "content": content,
    "user": user.toJson(),
    "_count": count.toJson(),
    "createdAt": createdAt.toIso8601String(),
    "isLike": isLike,
    "isOwner": isOwner,
  };
}

class Count {
  int commentGroupPost;
  int likeGroupPost;

  Count({
    required this.commentGroupPost,
    required this.likeGroupPost,
  });

  factory Count.fromJson(Map<String, dynamic> json) {
    return Count(
      commentGroupPost: json["commentGroupPost"] ?? 0,
      likeGroupPost: json["likeGroupPost"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    "commentGroupPost": commentGroupPost,
    "likeGroupPost": likeGroupPost,
  };
}

class User {
  String id;
  String firstName;
  String lastName;
  String? profileImage; // Changed from dynamic to String?

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.profileImage,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"] ?? '',
      firstName: json["firstName"] ?? 'Unknown',
      lastName: json["lastName"] ?? 'User',
      profileImage: json["profileImage"], // Can be null
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "firstName": firstName,
    "lastName": lastName,
    "profileImage": profileImage,
  };
}
