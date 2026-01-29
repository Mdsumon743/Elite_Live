
// To parse this JSON data, do
//
//     final topInfluencerLiveDataModel = topInfluencerLiveDataModelFromJson(jsonString);

import 'dart:convert';

TopInfluencerLiveDataModel topInfluencerLiveDataModelFromJson(String str) => TopInfluencerLiveDataModel.fromJson(json.decode(str));

String topInfluencerLiveDataModelToJson(TopInfluencerLiveDataModel data) => json.encode(data.toJson());

class TopInfluencerLiveDataModel {
  bool success;
  String message;
  List<TopInfluencerLiveResult> result;

  TopInfluencerLiveDataModel({
    required this.success,
    required this.message,
    required this.result,
  });

  factory TopInfluencerLiveDataModel.fromJson(Map<String, dynamic> json) => TopInfluencerLiveDataModel(
    success: json["success"],
    message: json["message"],
    result: List<TopInfluencerLiveResult>.from(json["result"].map((x) => TopInfluencerLiveResult.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "result": List<dynamic>.from(result.map((x) => x.toJson())),
  };
}

class TopInfluencerLiveResult {
  int watchCount;
  String audienceLink;
  List<TopInfluencerLiveEvent> events;

  TopInfluencerLiveResult({
    required this.watchCount,
    required this.audienceLink,
    required this.events,
  });

  factory TopInfluencerLiveResult.fromJson(Map<String, dynamic> json) => TopInfluencerLiveResult(
    watchCount: json["watchCount"],
    audienceLink: json["audienceLink"],
    events: List<TopInfluencerLiveEvent>.from(json["events"].map((x) => TopInfluencerLiveEvent.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "watchCount": watchCount,
    "audienceLink": audienceLink,
    "events": List<dynamic>.from(events.map((x) => x.toJson())),
  };
}

class TopInfluencerLiveEvent {
  String id;
  String title;

  TopInfluencerLiveEvent({
    required this.id,
    required this.title,
  });

  factory TopInfluencerLiveEvent.fromJson(Map<String, dynamic> json) => TopInfluencerLiveEvent(
    id: json["id"],
    title: json["title"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
  };
}
