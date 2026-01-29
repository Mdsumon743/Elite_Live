
// To parse this JSON data, do
//
//     final joinedGroupDataModel = joinedGroupDataModelFromJson(jsonString);

import 'dart:convert';

JoinedGroupDataModel joinedGroupDataModelFromJson(String str) => JoinedGroupDataModel.fromJson(json.decode(str));

String joinedGroupDataModelToJson(JoinedGroupDataModel data) => json.encode(data.toJson());

class JoinedGroupDataModel {
  bool success;
  String message;
  List<JoinedGroupResultResult> result;

  JoinedGroupDataModel({
    required this.success,
    required this.message,
    required this.result,
  });

  factory JoinedGroupDataModel.fromJson(Map<String, dynamic> json) => JoinedGroupDataModel(
    success: json["success"],
    message: json["message"],
    result: List<JoinedGroupResultResult>.from(json["result"].map((x) => JoinedGroupResultResult.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "result": List<dynamic>.from(result.map((x) => x.toJson())),
  };
}

class JoinedGroupResultResult {
  String id;
  String groupName;
  String photo;
  bool isPublic;
  DateTime createdAt;
  Count count;

  JoinedGroupResultResult({
    required this.id,
    required this.groupName,
    required this.photo,
    required this.isPublic,
    required this.createdAt,
    required this.count,
  });

  factory JoinedGroupResultResult.fromJson(Map<String, dynamic> json) => JoinedGroupResultResult(
    id: json["id"],
    groupName: json["groupName"],
    photo: json["photo"],
    isPublic: json["isPublic"],
    createdAt: DateTime.parse(json["createdAt"]),
    count: Count.fromJson(json["_count"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "groupName": groupName,
    "photo": photo,
    "isPublic": isPublic,
    "createdAt": createdAt.toIso8601String(),
    "_count": count.toJson(),
  };
}

class Count {
  int groupMember;

  Count({
    required this.groupMember,
  });

  factory Count.fromJson(Map<String, dynamic> json) => Count(
    groupMember: json["groupMember"],
  );

  Map<String, dynamic> toJson() => {
    "groupMember": groupMember,
  };
}
