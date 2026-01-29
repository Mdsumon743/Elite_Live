
// To parse this JSON data, do
//
//     final othersFundingEventDataDataModel = othersFundingEventDataDataModelFromJson(jsonString);

import 'dart:convert';

OthersFundingEventDataDataModel othersFundingEventDataDataModelFromJson(String str) => OthersFundingEventDataDataModel.fromJson(json.decode(str));

String othersFundingEventDataDataModelToJson(OthersFundingEventDataDataModel data) => json.encode(data.toJson());

class OthersFundingEventDataDataModel {
  bool success;
  String message;
  OthersUserFundingResult result;

  OthersFundingEventDataDataModel({
    required this.success,
    required this.message,
    required this.result,
  });

  factory OthersFundingEventDataDataModel.fromJson(Map<String, dynamic> json) => OthersFundingEventDataDataModel(
    success: json["success"],
    message: json["message"],
    result: OthersUserFundingResult.fromJson(json["result"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "result": result.toJson(),
  };
}

class OthersUserFundingResult {
  int totalCount;
  int totalPages;
  int currentPage;
  List<Event> events;

  OthersUserFundingResult({
    required this.totalCount,
    required this.totalPages,
    required this.currentPage,
    required this.events,
  });

  factory OthersUserFundingResult.fromJson(Map<String, dynamic> json) => OthersUserFundingResult(
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
  DateTime? scheduleDate;  // <-- FIXED
  int payAmount;
  DateTime createdAt;
  DateTime updatedAt;
  User user;
  Count count;
  List<EventLike> eventLike;
  Stream stream;
  bool isLiked;
  bool isOwner;

  Event({
    required this.id,
    required this.userId,
    required this.streamId,
    required this.eventType,
    required this.title,
    required this.text,
    required this.scheduleDate,
    required this.payAmount,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
    required this.count,
    required this.eventLike,
    required this.stream,
    required this.isLiked,
    required this.isOwner,
  });

  factory Event.fromJson(Map<String, dynamic> json) => Event(
    id: json["id"],
    userId: json["userId"],
    streamId: json["streamId"],
    eventType: json["eventType"],
    title: json["title"],
    text: json["text"],
    scheduleDate: json["scheduleDate"] != null
        ? DateTime.parse(json["scheduleDate"])
        : null,  // <-- FIXED
    payAmount: json["payAmount"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    user: User.fromJson(json["user"]),
    count: Count.fromJson(json["_count"]),
    eventLike: List<EventLike>.from(
        json["EventLike"].map((x) => EventLike.fromJson(x))),
    stream: Stream.fromJson(json["stream"]),
    isLiked: json["isLiked"],
    isOwner: json["isOwner"],
  );



  Map<String, dynamic> toJson() => {
    "id": id,
    "userId": userId,
    "streamId": streamId,
    "eventType": eventType,
    "title": title,
    "text": text,
    "scheduleDate": scheduleDate,
    "payAmount": payAmount,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "user": user.toJson(),
    "_count": count.toJson(),
    "EventLike": List<dynamic>.from(eventLike.map((x) => x.toJson())),
    "stream": stream.toJson(),
    "isLiked": isLiked,
    "isOwner": isOwner,
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

class EventLike {
  String id;

  EventLike({
    required this.id,
  });

  factory EventLike.fromJson(Map<String, dynamic> json) => EventLike(
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
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
  String? profileImage;
  String? profession;
  bool isFollow;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.profileImage,
    this.profession,
    required this.isFollow,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"] ?? "",
    firstName: json["firstName"] ?? "",
    lastName: json["lastName"] ?? "",
    profileImage: json["profileImage"], // null allowed
    profession: json["profession"],     // null allowed
    isFollow: json["isFollow"] ?? false,
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

