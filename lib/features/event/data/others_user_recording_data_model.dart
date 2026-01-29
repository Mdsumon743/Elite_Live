// To parse this JSON data, do
//
//     final othersRecordingDataModel = othersRecordingDataModelFromJson(jsonString);

import 'dart:convert';

OthersRecordingDataModel othersRecordingDataModelFromJson(String str) => OthersRecordingDataModel.fromJson(json.decode(str));

String othersRecordingDataModelToJson(OthersRecordingDataModel data) => json.encode(data.toJson());

class OthersRecordingDataModel {
  bool success;
  String message;
  List<OtherUserRecordingResult> result;

  OthersRecordingDataModel({
    required this.success,
    required this.message,
    required this.result,
  });

  factory OthersRecordingDataModel.fromJson(Map<String, dynamic> json) => OthersRecordingDataModel(
    success: json["success"],
    message: json["message"],
    result: List<OtherUserRecordingResult>.from(json["result"].map((x) => OtherUserRecordingResult.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "result": List<dynamic>.from(result.map((x) => x.toJson())),
  };
}

class OtherUserRecordingResult {
  String id;
  String recordingLink;
  int watchCount;

  OtherUserRecordingResult({
    required this.id,
    required this.recordingLink,
    required this.watchCount,
  });

  factory OtherUserRecordingResult.fromJson(Map<String, dynamic> json) => OtherUserRecordingResult(
    id: json["id"],
    recordingLink: json["recordingLink"],
    watchCount: json["watchCount"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "recordingLink": recordingLink,
    "watchCount": watchCount,
  };
}
