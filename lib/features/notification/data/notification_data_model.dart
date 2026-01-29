
import 'dart:convert';

NotificationDataModel notificationDataResultFromJson(String str) =>
    NotificationDataModel.fromJson(json.decode(str));

String notificationDataResultToJson(NotificationDataModel data) =>
    json.encode(data.toJson());

class NotificationDataModel {
  final bool success;
  final String message;
  final List<NotificationResult> result;

  NotificationDataModel({
    required this.success,
    required this.message,
    required this.result,
  });

  factory NotificationDataModel.fromJson(Map<String, dynamic> json) {
    return NotificationDataModel(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      result: json["result"] == null
          ? []
          : List<NotificationResult>.from(
        json["result"].map((x) => NotificationResult.fromJson(x)),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "result": List<dynamic>.from(result.map((x) => x.toJson())),
  };
}

class NotificationResult {
  final String id;
  final String userId;
  final String? senderId;
  final String title;
  final String body;
  final bool isRead;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Sender? sender;

  NotificationResult({
    required this.id,
    required this.userId,
    required this.senderId,
    required this.title,
    required this.body,
    required this.isRead,
    required this.createdAt,
    required this.updatedAt,
    required this.sender,
  });

  factory NotificationResult.fromJson(Map<String, dynamic> json) {
    return NotificationResult(
      id: json["id"] ?? "",
      userId: json["userId"] ?? "",
      senderId: json["senderId"],
      title: json["title"] ?? "",
      body: json["body"] ?? "",
      isRead: json["isRead"] ?? false,
      createdAt: DateTime.parse(json["createdAt"]),
      updatedAt: DateTime.parse(json["updatedAt"]),
      sender: json["sender"] == null ? null : Sender.fromJson(json["sender"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "userId": userId,
    "senderId": senderId,
    "title": title,
    "body": body,
    "isRead": isRead,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "sender": sender?.toJson(),
  };
}

class Sender {
  final String? firstName;
  final String? lastName;
  final String? profileImage;

  Sender({
    required this.firstName,
    required this.lastName,
    required this.profileImage,
  });

  factory Sender.fromJson(Map<String, dynamic> json) {
    return Sender(
      firstName: json["firstName"],
      lastName: json["lastName"],
      profileImage: json["profileImage"],
    );
  }

  Map<String, dynamic> toJson() => {
    "firstName": firstName,
    "lastName": lastName,
    "profileImage": profileImage,
  };
}
