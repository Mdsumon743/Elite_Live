import 'dart:convert';

UserInformation userInformationFromJson(String str) => UserInformation.fromJson(json.decode(str));

String userInformationToJson(UserInformation data) => json.encode(data.toJson());

class UserInformation {
  bool success;
  String message;
  UserResult result;

  UserInformation({
    required this.success,
    required this.message,
    required this.result,
  });

  factory UserInformation.fromJson(Map<String, dynamic> json) => UserInformation(
    success: json["success"],
    message: json["message"],
    result: UserResult.fromJson(json["result"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "result": result.toJson(),
  };
}

class UserResult {
  String id;
  String firstName;
  String lastName;
  String? profileImage; // nullable
  String email;
  String profession;
  String address;
  String gender;
  DateTime dob;
  String bio;
  Count count;
  String stripeAccountId;
  int followingCount;
  int followersCount;

  UserResult({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.profileImage,
    required this.email,
    required this.profession,
    required this.address,
    required this.gender,
    required this.dob,
    required this.bio,
    required this.count,
    required this.stripeAccountId,
    required this.followingCount,
    required this.followersCount,
  });

  factory UserResult.fromJson(Map<String, dynamic> json) => UserResult(
    id: json["id"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    profileImage: json["profileImage"],
    email: json["email"],
    profession: json["profession"],
    address: json["address"],
    gender: json["gender"],
    dob: DateTime.parse(json["dob"]),
    bio: json["bio"],
    count: Count.fromJson(json["_count"] ?? {}),
    stripeAccountId: json['stripeAccountId']??'',
    followingCount: json["followingCount"] ?? 0,
    followersCount: json["followersCount"] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "firstName": firstName,
    "lastName": lastName,
    "profileImage": profileImage,
    "email": email,
    "profession": profession,
    "address": address,
    "gender": gender,
    "dob": dob.toIso8601String(),
    "bio": bio,
    "_count": count.toJson(),
    "stripeAccountId": stripeAccountId,
    "followingCount": followingCount,
    "followersCount": followersCount,
  };
}

/// For _count field
class Count {
  int event;

  Count({required this.event});

  factory Count.fromJson(Map<String, dynamic> json) => Count(
    event: json["Event"] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "Event": event,
  };
}
