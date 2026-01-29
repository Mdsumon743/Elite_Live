

// To parse this JSON data, do
//
//     final myFollowerDataModel = myFollowerDataModelFromJson(jsonString);

import 'dart:convert';

MyFollowerDataModel myFollowerDataModelFromJson(String str) => MyFollowerDataModel.fromJson(json.decode(str));

String myFollowerDataModelToJson(MyFollowerDataModel data) => json.encode(data.toJson());

class MyFollowerDataModel {
  bool success;
  String message;
  List<MyFollowerResult> result;

  MyFollowerDataModel({
    required this.success,
    required this.message,
    required this.result,
  });

  factory MyFollowerDataModel.fromJson(Map<String, dynamic> json) => MyFollowerDataModel(
    success: json["success"],
    message: json["message"],
    result: List<MyFollowerResult>.from(json["result"].map((x) => MyFollowerResult.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "result": List<dynamic>.from(result.map((x) => x.toJson())),
  };
}

class MyFollowerResult {
  String user1Id;
  User user;

  MyFollowerResult({
    required this.user1Id,
    required this.user,
  });

  factory MyFollowerResult.fromJson(Map<String, dynamic> json) => MyFollowerResult(
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
  dynamic profileImage;
  String profession;

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
