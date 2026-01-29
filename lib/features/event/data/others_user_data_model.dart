// Fixed getSingleUser method



// Fixed Model with proper null safety
class OtherUserDataModel {
  bool success;
  String message;
  OthersUserResult result;

  OtherUserDataModel({
    required this.success,
    required this.message,
    required this.result,
  });

  factory OtherUserDataModel.fromJson(Map<String, dynamic> json) =>
      OtherUserDataModel(
        success: json["success"] ?? true,
        message: json["message"] ?? '',
        result: OthersUserResult.fromJson(json["result"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "result": result.toJson(),
  };
}

class OthersUserResult {
  String id;
  String firstName;
  String lastName;
  dynamic profileImage;
  String email;
  dynamic profession;
  dynamic address;
  String gender;
  dynamic dob;
  dynamic bio;
  Count count;
  dynamic stripeAccountId;
  bool isFollow;
  int followingCount;
  int followersCount;

  OthersUserResult({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.profileImage,
    required this.email,
    required this.profession,
    required this.address,
    required this.gender,
    required this.dob,
    required this.bio,
    required this.count,
    required this.stripeAccountId,
    required this.isFollow,
    required this.followingCount,
    required this.followersCount,
  });

  factory OthersUserResult.fromJson(Map<String, dynamic> json) =>
      OthersUserResult(
        id: json["id"] ?? '',
        firstName: json["firstName"] ?? '',
        lastName: json["lastName"] ?? '',
        profileImage: json["profileImage"],
        email: json["email"] ?? '',
        profession: json["profession"],
        address: json["address"],
        gender: json["gender"] ?? '',
        dob: json["dob"],
        bio: json["bio"],
        count: Count.fromJson(json["_count"] ?? {}),
        stripeAccountId: json["stripeAccountId"],
        isFollow: json["isFollow"] ?? false,
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
    "dob": dob,
    "bio": bio,
    "_count": count.toJson(),
    "stripeAccountId": stripeAccountId,
    "isFollow": isFollow,
    "followingCount": followingCount,
    "followersCount": followersCount,
  };
}

class Count {
  int event;

  Count({
    required this.event,
  });

  factory Count.fromJson(Map<String, dynamic> json) => Count(
    event: json["Event"] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "Event": event,
  };
}