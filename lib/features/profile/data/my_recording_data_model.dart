
// To parse this JSON data, do
//
//     final myRecordingDataModel = myRecordingDataModelFromJson(jsonString);

import 'dart:convert';

MyRecordingDataModel myRecordingDataModelFromJson(String str) => MyRecordingDataModel.fromJson(json.decode(str));

String myRecordingDataModelToJson(MyRecordingDataModel data) => json.encode(data.toJson());

class MyRecordingDataModel {
  bool success;
  String message;
  List<MyRecordingResult> result;

  MyRecordingDataModel({
    required this.success,
    required this.message,
    required this.result,
  });

  factory MyRecordingDataModel.fromJson(Map<String, dynamic> json) => MyRecordingDataModel(
    success: json["success"],
    message: json["message"],
    result: List<MyRecordingResult>.from(json["result"].map((x) => MyRecordingResult.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "result": List<dynamic>.from(result.map((x) => x.toJson())),
  };
}

class MyRecordingResult {
  String id;
  String recordingLink;
  int watchCount;

  MyRecordingResult({
    required this.id,
    required this.recordingLink,
    required this.watchCount,
  });

  factory MyRecordingResult.fromJson(Map<String, dynamic> json) => MyRecordingResult(
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
