
// To parse this JSON data, do
//
//     final createLiveResponseModel = createLiveResponseModelFromJson(jsonString);

import 'dart:convert';

CreateLiveResponseModel createLiveResponseModelFromJson(String str) =>
    CreateLiveResponseModel.fromJson(json.decode(str));

String createLiveResponseModelToJson(CreateLiveResponseModel data) =>
    json.encode(data.toJson());

class CreateLiveResponseModel {
  bool success;
  String message;
  LiveResult result;

  CreateLiveResponseModel({
    required this.success,
    required this.message,
    required this.result,
  });

  factory CreateLiveResponseModel.fromJson(Map<String, dynamic> json) =>
      CreateLiveResponseModel(
        success: json["success"] ?? false,
        message: json["message"] ?? '',
        result: LiveResult.fromJson(json["result"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "result": result.toJson(),
  };
}

class LiveResult {
  String id;
  String userId;
  String hostLink;
  String coHostLink;
  String audienceLink;
  bool isLive;
  DateTime createdAt;
  DateTime updatedAt;

  LiveResult({
    required this.id,
    required this.userId,
    required this.hostLink,
    required this.coHostLink,
    required this.audienceLink,
    required this.isLive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LiveResult.fromJson(Map<String, dynamic> json) => LiveResult(
    id: json["id"] ?? '',
    userId: json["userId"] ?? '',
    hostLink: json["hostLink"] ?? '',
    coHostLink: json["coHostLink"] ?? '',
    audienceLink: json["audienceLink"] ?? '',
    isLive: json["isLive"] ?? false,
    createdAt: json["createdAt"] != null
        ? DateTime.parse(json["createdAt"])
        : DateTime.now(),
    updatedAt: json["updatedAt"] != null
        ? DateTime.parse(json["updatedAt"])
        : DateTime.now(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "userId": userId,
    "hostLink": hostLink,
    "coHostLink": coHostLink,
    "audienceLink": audienceLink,
    "isLive": isLive,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
  };
}