

import 'dart:convert';

AllRecordedEventDataModel allEventDataModelFromJson(String str) => AllRecordedEventDataModel.fromJson(json.decode(str));

String allEventDataModelToJson(AllRecordedEventDataModel data) => json.encode(data.toJson());

class AllRecordedEventDataModel {
  bool success;
  String message;
  AllStreamResult result;

  AllRecordedEventDataModel({
    required this.success,
    required this.message,
    required this.result,
  });

  factory AllRecordedEventDataModel.fromJson(Map<String, dynamic> json) {
    // Check if 'result' key exists (full response)
    if (json.containsKey('result')) {
      return AllRecordedEventDataModel(
        success: json["success"] ?? true,
        message: json["message"] ?? '',
        result: AllStreamResult.fromJson(json["result"]),
      );
    }
    // Otherwise, json is already the result object
    else {
      return AllRecordedEventDataModel(
        success: true,
        message: '',
        result: AllStreamResult.fromJson(json),
      );
    }
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "result": result.toJson(),
  };
}

class AllStreamResult {
  int totalCount;
  int totalPages;
  int currentPage;
  List<Event> events;

  AllStreamResult({
    required this.totalCount,
    required this.totalPages,
    required this.currentPage,
    required this.events,
  });

  factory AllStreamResult.fromJson(Map<String, dynamic> json) => AllStreamResult(
    totalCount: json["totalCount"] ?? 0,
    totalPages: json["totalPages"] ?? 0,
    currentPage: json["currentPage"] ?? 0,
    events: json["events"] != null
        ? List<Event>.from(json["events"].map((x) => Event.fromJson(x)))
        : [],
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
  DateTime? scheduleDate;
  int payAmount;
  String? recordedLink;
  DateTime createdAt;
  DateTime updatedAt;
  User user;
  Count count;
  List<EventLike> eventLike;
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
    this.scheduleDate,
    required this.payAmount,
    this.recordedLink,
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
    id: json["id"] ?? '',
    userId: json["userId"] ?? '',
    streamId: json["streamId"] ?? '',
    eventType: json["eventType"] ?? '',
    title: json["title"] ?? '',
    text: json["text"] ?? '',
    scheduleDate: json["scheduleDate"] != null ? DateTime.tryParse(json["scheduleDate"]) : null,
    payAmount: json["payAmount"] ?? 0,
    recordedLink: json["recordedLink"],
    createdAt: json["createdAt"] != null
        ? DateTime.parse(json["createdAt"])
        : DateTime.now(),
    updatedAt: json["updatedAt"] != null
        ? DateTime.parse(json["updatedAt"])
        : DateTime.now(),
    user: json["user"] != null
        ? User.fromJson(json["user"])
        : User(id: '', firstName: '', lastName: '', profileImage: null, profession: null, isFollow: false),
    count: json["_count"] != null
        ? Count.fromJson(json["_count"])
        : Count(eventLike: 0, eventComment: 0),
    eventLike: json["EventLike"] != null
        ? List<EventLike>.from(json["EventLike"].map((x) => EventLike.fromJson(x)))
        : [],
    stream: json["stream"] != null
        ? Stream.fromJson(json["stream"])
        : Stream(id: '', isLive: false, hostLink: '', coHostLink: '', audienceLink: ''),
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
    "EventLike": List<dynamic>.from(eventLike.map((x) => x.toJson())),
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

class EventLike {
  String id;

  EventLike({
    required this.id,
  });

  factory EventLike.fromJson(Map<String, dynamic> json) => EventLike(
    id: json["id"] ?? '',
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
    id: json["id"] ?? '',
    isLive: json["isLive"] ?? false,
    hostLink: json["hostLink"] ?? '',
    coHostLink: json["coHostLink"] ?? '',
    audienceLink: json["audienceLink"] ?? '',
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
    id: json["id"] ?? '',
    firstName: json["firstName"] ?? '',
    lastName: json["lastName"] ?? '',
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
