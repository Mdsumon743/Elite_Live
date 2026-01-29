// To parse this JSON data, do
//
//     final allRecordingDataModel = allRecordingDataModelFromJson(jsonString);

import 'dart:convert';

AllRecordingDataModel allRecordingDataModelFromJson(String str) => AllRecordingDataModel.fromJson(json.decode(str));

String allRecordingDataModelToJson(AllRecordingDataModel data) => json.encode(data.toJson());

class AllRecordingDataModel {
  bool success;
  String message;
  List<AllRecordingResult> result;

  AllRecordingDataModel({
    required this.success,
    required this.message,
    required this.result,
  });

  factory AllRecordingDataModel.fromJson(Map<String, dynamic> json) => AllRecordingDataModel(
    success: json["success"],
    message: json["message"],
    result: List<AllRecordingResult>.from(json["result"].map((x) => AllRecordingResult.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "result": List<dynamic>.from(result.map((x) => x.toJson())),
  };
}

class AllRecordingResult {
  String id;
  String recordingLink;
  int watchCount;
  User user;

  AllRecordingResult({
    required this.id,
    required this.recordingLink,
    required this.watchCount,
    required this.user,
  });

  factory AllRecordingResult.fromJson(Map<String, dynamic> json) => AllRecordingResult(
    id: json["id"],
    recordingLink: json["recordingLink"],
    watchCount: json["watchCount"],
    user: User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "recordingLink": recordingLink,
    "watchCount": watchCount,
    "user": user.toJson(),
  };
}

class User {
  String id;
  String firstName;
  String lastName;
  String? profileImage;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.profileImage,
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
