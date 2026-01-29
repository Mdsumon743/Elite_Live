// To parse this JSON data, do
//
//     final otherScheduleEventDataDataModel = otherScheduleEventDataDataModelFromJson(jsonString);

import 'dart:convert';

OtherScheduleEventDataDataModel otherScheduleEventDataDataModelFromJson(String str) =>
    OtherScheduleEventDataDataModel.fromJson(json.decode(str));

String otherScheduleEventDataDataModelToJson(OtherScheduleEventDataDataModel data) =>
    json.encode(data.toJson());

class OtherScheduleEventDataDataModel {
  bool success;
  String message;
  OthersUserScheduleEventResult result;

  OtherScheduleEventDataDataModel({
    required this.success,
    required this.message,
    required this.result,
  });

  factory OtherScheduleEventDataDataModel.fromJson(Map<String, dynamic> json) =>
      OtherScheduleEventDataDataModel(
        success: json["success"],
        message: json["message"],
        result: OthersUserScheduleEventResult.fromJson(json["result"]),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "result": result.toJson(),
  };
}

class OthersUserScheduleEventResult {
  int totalCount;
  int totalPages;
  int currentPage;
  List<Event> events;

  OthersUserScheduleEventResult({
    required this.totalCount,
    required this.totalPages,
    required this.currentPage,
    required this.events,
  });

  factory OthersUserScheduleEventResult.fromJson(Map<String, dynamic> json) =>
      OthersUserScheduleEventResult(
        totalCount: json["totalCount"],
        totalPages: json["totalPages"],
        currentPage: json["currentPage"],
        events: List<Event>.from(json["events"].map((x) => Event.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "totalCount": totalCount,
    "totalPages": totalPages,
    "currentPage": currentPage,
    "events": List<dynamic>.from(events.map((x) => x.toJson())),
  };
}

class Event {
  String id;
  String userId;
  String streamId;
  String eventType;
  String title;
  String text;
  DateTime scheduleDate;
  int payAmount;
  String recordedLink;
  DateTime createdAt;
  DateTime updatedAt;
  User user;
  Count count;
  List<dynamic> eventLike;
  Stream stream;
  bool isLiked;
  bool isOwner;
  bool isPayment;


  Event({
    required this.id,
    required this.userId,
    required this.streamId,
    required this.eventType,
    required this.title,
    required this.text,
    required this.scheduleDate,
    required this.payAmount,
    required this.recordedLink,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
    required this.count,
    required this.eventLike,
    required this.stream,
    required this.isLiked,
    required this.isOwner,
    required this.isPayment,
  });

  factory Event.fromJson(Map<String, dynamic> json) => Event(
    id: json["id"],
    userId: json["userId"],
    streamId: json["streamId"],
    eventType: json["eventType"],
    title: json["title"],
    text: json["text"],
    scheduleDate: DateTime.parse(json["scheduleDate"]),
    payAmount: json["payAmount"],
    recordedLink: json["recordedLink"] ?? "https://storage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4",
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    user: User.fromJson(json["user"]),
    count: Count.fromJson(json["_count"]),
    eventLike: List<dynamic>.from(json["EventLike"].map((x) => x)),
    stream: Stream.fromJson(json["stream"]),
    isLiked: json["isLiked"],
    isOwner: json["isOwner"],
    isPayment: json["isPayment"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "userId": userId,
    "streamId": streamId,
    "eventType": eventType,
    "title": title,
    "text": text,
    "scheduleDate": scheduleDate.toIso8601String(),
    "payAmount": payAmount,
    'recordedLink': recordedLink,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "user": user.toJson(),
    "_count": count.toJson(),
    "EventLike": List<dynamic>.from(eventLike.map((x) => x)),
    "stream": stream.toJson(),
    "isLiked": isLiked,
    "isOwner": isOwner,
    "isPayment": isPayment,
  };
}

class Count {
  int eventLike;
  int eventComment;

  Count({
    required this.eventLike,
    required this.eventComment,
  });

  factory Count.fromJson(Map<String, dynamic> json) => Count(
    eventLike: json["EventLike"],
    eventComment: json["EventComment"],
  );

  Map<String, dynamic> toJson() => {
    "EventLike": eventLike,
    "EventComment": eventComment,
  };
}

class Stream {
  String id;
  bool isLive;
  String hostLink;
  String coHostLink;
  String audienceLink;

  Stream({
    required this.id,
    required this.isLive,
    required this.hostLink,
    required this.coHostLink,
    required this.audienceLink,
  });

  factory Stream.fromJson(Map<String, dynamic> json) => Stream(
    id: json["id"],
    isLive: json["isLive"],
    hostLink: json["hostLink"],
    coHostLink: json["coHostLink"],
    audienceLink: json["audienceLink"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "isLive": isLive,
    "hostLink": hostLink,
    "coHostLink": coHostLink,
    "audienceLink": audienceLink,
  };
}

class User {
  String id;
  String firstName;
  String lastName;
  dynamic profileImage;
  dynamic profession;
  bool isFollow;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.profileImage,
    required this.profession,
    required this.isFollow,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    profileImage: json["profileImage"],
    profession: json["profession"],
    isFollow: json["isFollow"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "firstName": firstName,
    "lastName": lastName,
    "profileImage": profileImage,
    "profession": profession,
    "isFollow": isFollow,
  };
}