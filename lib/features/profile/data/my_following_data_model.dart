// To parse this JSON data, do
//
//     final myFollowingDataModel = myFollowingDataModelFromJson(jsonString);

import 'dart:convert';

MyFollowingDataModel myFollowingDataModelFromJson(String str) => MyFollowingDataModel.fromJson(json.decode(str));

String myFollowingDataModelToJson(MyFollowingDataModel data) => json.encode(data.toJson());

class MyFollowingDataModel {
  bool success;
  String message;
  List<MyFollowingResult> result;

  MyFollowingDataModel({
    required this.success,
    required this.message,
    required this.result,
  });

  factory MyFollowingDataModel.fromJson(Map<String, dynamic> json) => MyFollowingDataModel(
    success: json["success"],
    message: json["message"],
    result: List<MyFollowingResult>.from(json["result"].map((x) => MyFollowingResult.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "result": List<dynamic>.from(result.map((x) => x.toJson())),
  };
}

class MyFollowingResult {
  String user1Id;
  User user;

  MyFollowingResult({
    required this.user1Id,
    required this.user,
  });

  factory MyFollowingResult.fromJson(Map<String, dynamic> json) => MyFollowingResult(
    user1Id: json["user1Id"],
    user: User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "user1Id": user1Id,
    "user": user.toJson(),
  };
}

class User {
  String id;
  String firstName;
  String lastName;
  String? profileImage;
  String? profession;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.profileImage,
    required this.profession,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    profileImage: json["profileImage"],
    profession: json["profession"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "firstName": firstName,
    "lastName": lastName,
    "profileImage": profileImage,
    "profession": profession,
  };
}
