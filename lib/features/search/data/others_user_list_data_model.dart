// To parse this JSON data, do
//
//     final othersUserList = othersUserListFromJson(jsonString);

import 'dart:convert';

OthersUserList othersUserListFromJson(String str) => OthersUserList.fromJson(json.decode(str));

String othersUserListToJson(OthersUserList data) => json.encode(data.toJson());

class OthersUserList {
  bool success;
  String message;
  List<OthersUserListResult> result;

  OthersUserList({
    required this.success,
    required this.message,
    required this.result,
  });

  factory OthersUserList.fromJson(Map<String, dynamic> json) => OthersUserList(
    success: json["success"],
    message: json["message"],
    result: List<OthersUserListResult>.from(json["result"].map((x) => OthersUserListResult.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "result": List<dynamic>.from(result.map((x) => x.toJson())),
  };
}

class OthersUserListResult {
  String id;
  String firstName;
  String lastName;
  String? profileImage;
  String? profession;
  int totalFollowers;

  OthersUserListResult({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.profileImage,
    required this.profession,
    required this.totalFollowers,
  });

  factory OthersUserListResult.fromJson(Map<String, dynamic> json) => OthersUserListResult(
    id: json["id"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    profileImage: json["profileImage"],
    profession: json["profession"],
    totalFollowers: json["totalFollowers"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "firstName": firstName,
    "lastName": lastName,
    "profileImage": profileImage,
    "profession": profession,
    "totalFollowers": totalFollowers,
  };
}
