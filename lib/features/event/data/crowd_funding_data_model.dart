import 'dart:convert';

CrowdFundingDataModel crowdFundingDataModelFromJson(String str) =>
    CrowdFundingDataModel.fromJson(json.decode(str));

String crowdFundingDataModelToJson(CrowdFundingDataModel data) =>
    json.encode(data.toJson());

/// ===============================
/// PARENT MODEL
/// ===============================
class CrowdFundingDataModel {
  bool? success;
  String? message;
  CrowdFundingResult result;

  CrowdFundingDataModel({
    required this.success,
    required this.message,
    required this.result,
  });

  factory CrowdFundingDataModel.fromJson(Map<String, dynamic> json) =>
      CrowdFundingDataModel(
        success: json["success"] ?? true,
        message: json["message"] ?? '',
        result: CrowdFundingResult.fromJson(json["result"]),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "result": result.toJson(),
  };
}

/// ===============================
/// RESULT MODEL
/// ===============================
class CrowdFundingResult {
  int totalCount;
  int totalPages;
  int currentPage;
  List<CrowdFundingEvent> events;

  CrowdFundingResult({
    required this.totalCount,
    required this.totalPages,
    required this.currentPage,
    required this.events,
  });

  factory CrowdFundingResult.fromJson(Map<String, dynamic> json) =>
      CrowdFundingResult(
        totalCount: json["totalCount"] ?? 0,
        totalPages: json["totalPages"] ?? 0,
        currentPage: json["currentPage"] ?? 1,
        events: json["events"] == null
            ? []
            : List<CrowdFundingEvent>.from(
          json["events"].map((x) => CrowdFundingEvent.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
    "totalCount": totalCount,
    "totalPages": totalPages,
    "currentPage": currentPage,
    "events": List<dynamic>.from(events.map((x) => x.toJson())),
  };
}

/// ===============================
/// EVENT MODEL
/// ===============================
class CrowdFundingEvent {
  String id;
  String userId;
  String? streamId;
  String eventType;
  String title;
  String text;
  DateTime? scheduleDate; // nullable
  double payAmount;
  DateTime createdAt;
  DateTime updatedAt;
  User user;
  Count count;
  List<EventLike> eventLike;
  StreamData? stream; // new
  bool isLiked;
  bool isOwner; // new

  CrowdFundingEvent({
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

  factory CrowdFundingEvent.fromJson(Map<String, dynamic> json) =>
      CrowdFundingEvent(
        id: json["id"] ?? '',
        userId: json["userId"] ?? '',
        streamId: json["streamId"],
        eventType: json["eventType"] ?? '',
        title: json['title'] ?? '',
        text: json["text"] ?? '',
        scheduleDate: json["scheduleDate"] == null
            ? null
            : DateTime.tryParse(json["scheduleDate"]),
        payAmount: (json["payAmount"] ?? 0).toDouble(),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        user: User.fromJson(json["user"]),
        count: Count.fromJson(json["_count"]),
        eventLike: json["EventLike"] == null
            ? []
            : List<EventLike>.from(
          json["EventLike"].map((x) => EventLike.fromJson(x)),
        ),
        stream: json["stream"] == null
            ? null
            : StreamData.fromJson(json["stream"]),
        isLiked: json["isLiked"] ?? false,
        isOwner: json["isOwner"] ?? false,
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "userId": userId,
    "streamId": streamId,
    "eventType": eventType,
    'title': title,
    "text": text,
    "scheduleDate": scheduleDate?.toIso8601String(),
    "payAmount": payAmount,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "user": user.toJson(),
    "_count": count.toJson(),
    "EventLike": List<dynamic>.from(eventLike.map((x) => x.toJson())),
    "stream": stream?.toJson(),
    "isLiked": isLiked,
    "isOwner": isOwner,
  };
}

/// ===============================
/// STREAM DATA (NEW)
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

/// ===============================
/// LIKE COUNT MODEL
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
/// EVENT LIKE MODEL
/// ===============================
class EventLike {
  String id;

  EventLike({required this.id});

  factory EventLike.fromJson(Map<String, dynamic> json) =>
      EventLike(id: json["id"] ?? '');

  Map<String, dynamic> toJson() => {"id": id};
}

/// ===============================
/// USER MODEL
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
