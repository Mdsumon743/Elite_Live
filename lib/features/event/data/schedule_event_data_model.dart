import 'dart:convert';

/// ===============================
/// Encoding / Decoding helpers
/// ===============================
ScheduleEventDataModel scheduleEventDataModelFromJson(String str) =>
    ScheduleEventDataModel.fromJson(json.decode(str));

String scheduleEventDataModelToJson(ScheduleEventDataModel data) =>
    json.encode(data.toJson());


/// ===============================
/// MAIN DATA MODEL
/// ===============================
class ScheduleEventDataModel {
  bool? success;
  String? message;
  ScheduleEventResult? result;

  ScheduleEventDataModel({
    required this.success,
    required this.message,
    required this.result,
  });

  factory ScheduleEventDataModel.fromJson(Map<String, dynamic> json) =>
      ScheduleEventDataModel(
        success: json["success"] ?? false,
        message: json["message"] ?? "",
        result: json["result"] != null
            ? ScheduleEventResult.fromJson(json["result"])
            : null,
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "result": result?.toJson(),
  };
}


/// ===============================
/// RESULT
/// ===============================
class ScheduleEventResult {
  int totalCount;
  int totalPages;
  int currentPage;
  List<LiveEvent> events;

  ScheduleEventResult({
    required this.totalCount,
    required this.totalPages,
    required this.currentPage,
    required this.events,
  });

  factory ScheduleEventResult.fromJson(Map<String, dynamic> json) =>
      ScheduleEventResult(
        totalCount: json["totalCount"] ?? 0,
        totalPages: json["totalPages"] ?? 0,
        currentPage: json["currentPage"] ?? 1,
        events: json["events"] == null
            ? []
            : List<LiveEvent>.from(
            json["events"].map((x) => LiveEvent.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "totalCount": totalCount,
    "totalPages": totalPages,
    "currentPage": currentPage,
    "events": List<dynamic>.from(events.map((x) => x.toJson())),
  };
}


/// ===============================
/// LIVE EVENT
/// ===============================
class LiveEvent {
  String id;
  String userId;
  String? streamId;
  String eventType;
  String title;
  String text;
  DateTime? scheduleDate;
  double payAmount;
  String recordedLink;
  DateTime? createdAt;
  DateTime? updatedAt;
  User user;
  Count count;
  List<EventLike> eventLike;
  StreamData? stream;
  bool isLiked;
  bool isOwner;
  bool isPayment;
  bool isModerator;

  LiveEvent({
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

  factory LiveEvent.fromJson(Map<String, dynamic> json) => LiveEvent(
    id: json["id"] ?? "",
    userId: json["userId"] ?? "",
    streamId: json["streamId"],
    eventType: json["eventType"] ?? "",
    title: json["title"] ?? "",
    text: json["text"] ?? "",
    scheduleDate: json["scheduleDate"] == null
        ? null
        : DateTime.parse(json["scheduleDate"]),
    payAmount: (json["payAmount"] ?? 0).toDouble(),

    /// recordedLink can be null in API → fallback to empty string
    recordedLink:
    json["recordedLink"] == null ? "" : json["recordedLink"],

    createdAt:
    json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt:
    json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),

    user: User.fromJson(json["user"] ?? {}),

    count: Count.fromJson(json["_count"] ?? {}),

    eventLike: json["EventLike"] == null
        ? []
        : List<EventLike>.from(
        json["EventLike"].map((x) => EventLike.fromJson(x))),

    stream:
    json["stream"] == null ? null : StreamData.fromJson(json["stream"]),

    isLiked: json["isLiked"] ?? false,
    isOwner: json["isOwner"] ?? false,
    isPayment: json["isPayment"] ?? false,
    isModerator: json["isModerator"] ?? false, // <-- NEW FIELD
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
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "user": user.toJson(),
    "_count": count.toJson(),
    "EventLike": List<dynamic>.from(eventLike.map((x) => x.toJson())),
    "stream": stream?.toJson(),
    "isLiked": isLiked,
    "isOwner": isOwner,
    "isPayment": isPayment,
    "isModerator": isModerator,
  };
}


/// ===============================
/// STREAM
/// ===============================
class StreamData {
  String id;
  bool isLive;
  String hostLink;
  String coHostLink;
  String audienceLink;

  StreamData({
    required this.id,
    required this.isLive,
    required this.hostLink,
    required this.coHostLink,
    required this.audienceLink,
  });

  factory StreamData.fromJson(Map<String, dynamic> json) => StreamData(
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


/// ===============================
/// COUNT
/// ===============================
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


/// ===============================
/// EVENT LIKE
/// ===============================
class EventLike {
  String id;

  EventLike({required this.id});

  factory EventLike.fromJson(Map<String, dynamic> json) => EventLike(
    id: json["id"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
  };
}


/// ===============================
/// USER
/// ===============================
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
