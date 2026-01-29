// To parse this JSON data:
//
//     final othersUserEventDataModel = othersUserEventDataModelFromJson(jsonString);

import 'dart:convert';

OthersUserEventDataModel othersUserEventDataModelFromJson(String str) =>
    OthersUserEventDataModel.fromJson(json.decode(str));

String othersUserEventDataModelToJson(OthersUserEventDataModel data) =>
    json.encode(data.toJson());

class OthersUserEventDataModel {
  bool success;
  String message;
  OtherUserEventResult result;

  OthersUserEventDataModel({
    required this.success,
    required this.message,
    required this.result,
  });

  /// FIXED: supports response that DOES NOT contain "result"
  factory OthersUserEventDataModel.fromJson(Map<String, dynamic> json) =>
      OthersUserEventDataModel(
        success: json["success"] ?? true,
        message: json["message"] ?? "",
        result: json["result"] != null
            ? OtherUserEventResult.fromJson(json["result"])
            : OtherUserEventResult.fromJson(json),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "result": result.toJson(),
  };
}

class OtherUserEventResult {
  int totalCount;
  int totalPages;
  int currentPage;
  List<OthersUserEvent> events;

  OtherUserEventResult({
    required this.totalCount,
    required this.totalPages,
    required this.currentPage,
    required this.events,
  });

  factory OtherUserEventResult.fromJson(Map<String, dynamic> json) =>
      OtherUserEventResult(
        totalCount: json["totalCount"] ?? 0,
        totalPages: json["totalPages"] ?? 0,
        currentPage: json["currentPage"] ?? 1,
        events: json["events"] == null
            ? []
            : List<OthersUserEvent>.from(
          json["events"].map((x) => OthersUserEvent.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
    "totalCount": totalCount,
    "totalPages": totalPages,
    "currentPage": currentPage,
    "events": List<dynamic>.from(events.map((x) => x.toJson())),
  };
}

class OthersUserEvent {
  String id;
  String userId;
  String streamId;
  String eventType;
  String title;
  String text;
  DateTime? scheduleDate;
  int payAmount;
  dynamic recordedLink;
  DateTime createdAt;
  DateTime updatedAt;
  User user;
  Count count;
  List<dynamic> eventLike;
  Stream stream;
  bool isLiked;
  bool isOwner;
  bool isPayment;
  bool isModerator;

  OthersUserEvent({
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
    required this.isModerator,
  });

  factory OthersUserEvent.fromJson(Map<String, dynamic> json) =>
      OthersUserEvent(
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
        recordedLink: json["recordedLink"],
        createdAt: DateTime.tryParse(json["createdAt"] ?? "") ??
            DateTime.now(),
        updatedAt: DateTime.tryParse(json["updatedAt"] ?? "") ??
            DateTime.now(),
        user: User.fromJson(json["user"] ?? {}),
        count: Count.fromJson(json["_count"] ?? {}),
        eventLike: json["EventLike"] == null
            ? []
            : List<dynamic>.from(json["EventLike"].map((x) => x)),
        stream: Stream.fromJson(json["stream"] ?? {}),
        isLiked: json["isLiked"] ?? false,
        isOwner: json["isOwner"] ?? false,
        isPayment: json["isPayment"] ?? false,
        isModerator: json["isModerator"] ?? false,
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
    "isModerator": isModerator,
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
  String? profileImage; // <-- nullable
  String? profession;   // <-- nullable
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
    profileImage: json["profileImage"],
    profession: json["profession"],
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
