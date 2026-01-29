
// To parse this JSON data, do
//
//     final groupUserDataModel = groupUserDataModelFromJson(jsonString);

// ============================================
// FIXED GroupUserDataModel with Null Safety
// ============================================

import 'dart:convert';
import 'dart:developer';

GroupUserDataModel groupUserDataModelFromJson(String str) =>
    GroupUserDataModel.fromJson(json.decode(str));

String groupUserDataModelToJson(GroupUserDataModel data) =>
    json.encode(data.toJson());

class GroupUserDataModel {
  bool? success;
  String? message;
  GroupUserResult? result; // Made nullable

  GroupUserDataModel({
    this.success,
    this.message,
    this.result,
  });

  factory GroupUserDataModel.fromJson(Map<String, dynamic> json) {
    return GroupUserDataModel(
      success: json["success"] ?? false,
      message: json["message"] ?? '',
      result: json["result"] != null
          ? GroupUserResult.fromJson(json["result"])
          : null, // ✅ FIXED: Check if result is null
    );
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "result": result?.toJson(),
  };
}

class GroupUserResult {
  int totalCount;
  int totalPages;
  int currentPage;
  List<InvitationUser> users;

  GroupUserResult({
    required this.totalCount,
    required this.totalPages,
    required this.currentPage,
    required this.users,
  });

  factory GroupUserResult.fromJson(Map<String, dynamic> json) {
    return GroupUserResult(
      totalCount: json["totalCount"] ?? 0,
      totalPages: json["totalPages"] ?? 0,
      currentPage: json["currentPage"] ?? 1,
      users: json["users"] != null
          ? List<InvitationUser>.from(json["users"].map((x) => InvitationUser.fromJson(x)))
          : [], // ✅ FIXED: Return empty list if null
    );
  }

  Map<String, dynamic> toJson() => {
    "totalCount": totalCount,
    "totalPages": totalPages,
    "currentPage": currentPage,
    "users": List<dynamic>.from(users.map((x) => x.toJson())),
  };
}

class InvitationUser {
  String id;
  String firstName;
  String lastName;
  String? profileImage;
  String? profession;

  InvitationUser({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.profileImage,
    this.profession,
  });

  factory InvitationUser.fromJson(Map<String, dynamic> json) {
    return InvitationUser(
      id: json["id"] ?? '',
      firstName: json["firstName"] ?? 'Unknown',
      lastName: json["lastName"] ?? 'User',
      profileImage: json["profileImage"],
      profession: json["profession"],

    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "firstName": firstName,
    "lastName": lastName,
    "profileImage": profileImage,
    "profession": profession
  };
}


