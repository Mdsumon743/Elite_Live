// To parse this JSON data, do
//
//     final allFollowingEventDataModel = allFollowingEventDataModelFromJson(jsonString);

import 'dart:convert';

AllFollowingEventDataModel allFollowingEventDataModelFromJson(String str) =>
    AllFollowingEventDataModel.fromJson(json.decode(str));

String allFollowingEventDataModelToJson(AllFollowingEventDataModel data) =>
    json.encode(data.toJson());

class AllFollowingEventDataModel {
  bool success;
  String message;
  AllFollowingEventResult result;

  AllFollowingEventDataModel({
    required this.success,
    required this.message,
    required this.result,
  });

  factory AllFollowingEventDataModel.fromJson(Map<String, dynamic> json) =>
      AllFollowingEventDataModel(
        success: json["success"] ?? false,
        message: json["message"] ?? "",
        result: AllFollowingEventResult.fromJson(json["result"]),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "result": result.toJson(),
  };
}

class AllFollowingEventResult {
  int totalCount;
  int totalPages;
  int currentPage;
  List<FollowingEvent> events;

  AllFollowingEventResult({
    required this.totalCount,
    required this.totalPages,
    required this.currentPage,
    required this.events,
  });

  factory AllFollowingEventResult.fromJson(Map<String, dynamic> json) =>
      AllFollowingEventResult(
        totalCount: json["totalCount"] ?? 0,
        totalPages: json["totalPages"] ?? 0,
        currentPage: json["currentPage"] ?? 1,
        events: json["events"] == null
            ? []
            : List<FollowingEvent>.from(
            json["events"].map((x) => FollowingEvent.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "totalCount": totalCount,
    "totalPages": totalPages,
    "currentPage": currentPage,
    "events": List<dynamic>.from(events.map((x) => x.toJson())),
  };
}

class FollowingEvent {
  String id;
  String userId;
  String streamId;
  String eventType;
  String title;
  String text;
  DateTime? scheduleDate;
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

  FollowingEvent({
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

  factory FollowingEvent.fromJson(Map<String, dynamic> json) => FollowingEvent(
    id: json["id"] ?? "",
    userId: json["userId"] ?? "",
    streamId: json["streamId"] ?? "",
    eventType: json["eventType"] ?? "",
    title: json["title"] ?? "",
    text: json["text"] ?? "",
    scheduleDate: json["scheduleDate"] == null
        ? null
        : DateTime.tryParse(json["scheduleDate"]),
    payAmount: json["payAmount"] ?? 0,
    recordedLink: json["recordedLink"] ??
        "https://www.pexels.com/download/video/6521834/",
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    user: User.fromJson(json["user"]),
    count: Count.fromJson(json["_count"]),
    eventLike: json["EventLike"] == null
        ? []
        : List<dynamic>.from(json["EventLike"].map((x) => x)),
    stream: Stream.fromJson(json["stream"]),
    isLiked: json["isLiked"] ?? false,
    isOwner: json["isOwner"] ?? false,
    isPayment: json["isPayment"] ?? false,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "userId": userId,
    "streamId": streamId,
    "eventType": eventType,
    "title": title,
    "text": text,
    "scheduleDate": scheduleDate?.toIso8601String(),
    "payAmount": payAmount,
    "recordedLink": recordedLink,
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
    eventLike: json["EventLike"] ?? 0,
    eventComment: json["EventComment"] ?? 0,
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
    id: json["id"] ?? "",
    isLive: json["isLive"] ?? false,
    hostLink: json["hostLink"] ?? "",
    coHostLink: json["coHostLink"] ?? "",
    audienceLink: json["audienceLink"] ?? "",
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
  String profileImage;
  String profession;
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
    id: json["id"] ?? "",
    firstName: json["firstName"] ?? "",
    lastName: json["lastName"] ?? "",
    profileImage: json["profileImage"] ??
        "https://png.pngtree.com/png-clipart/20230927/original/pngtree-man-avatar-image-for-profile-png-image_13001877.png",
    profession: json["profession"] ?? "N/A",
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
