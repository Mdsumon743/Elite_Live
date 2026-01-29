// Fixed Pool Vote Data Model with nullable fields

import 'dart:convert';

PoolVoteDataModel poolVoteDataModelFromJson(String str) =>
    PoolVoteDataModel.fromJson(json.decode(str));

String poolVoteDataModelToJson(PoolVoteDataModel data) =>
    json.encode(data.toJson());

class PoolVoteDataModel {
  bool success;
  String message;
  PoolVoteResult result;

  PoolVoteDataModel({
    required this.success,
    required this.message,
    required this.result,
  });

  factory PoolVoteDataModel.fromJson(Map<String, dynamic> json) {
    // Add null check for result
    if (json["result"] == null) {
      throw Exception("Result field is null in API response");
    }

    return PoolVoteDataModel(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      result: PoolVoteResult.fromJson(
          json["result"] is Map<String, dynamic>
              ? json["result"]
              : Map<String, dynamic>.from(json["result"])
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "result": result.toJson(),
  };
}

class PoolVoteResult {
  String id;
  String question;
  List<Option> options;
  bool isOwner;

  PoolVoteResult({
    required this.id,
    required this.question,
    required this.options,
    required this.isOwner,
  });

  factory PoolVoteResult.fromJson(Map<String, dynamic> json) {
    // Add detailed logging for debugging
    print("🔍 Parsing PoolVoteResult from: $json");

    return PoolVoteResult(
      id: json["id"]?.toString() ?? "",
      question: json["question"]?.toString() ?? "",
      options: json["options"] != null && json["options"] is List
          ? List<Option>.from(
          (json["options"] as List).map((x) {
            if (x == null) return null;
            return Option.fromJson(
                x is Map<String, dynamic> ? x : Map<String, dynamic>.from(x)
            );
          }).where((x) => x != null)
      )
          : [],
      isOwner: json["isOwner"] == true, // More explicit null handling
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "question": question,
    "options": List<dynamic>.from(options.map((x) => x.toJson())),
    "isOwner": isOwner,
  };
}

class Option {
  String option;
  int count;
  int percentage;
  List<Voter> voters;

  Option({
    required this.option,
    required this.count,
    required this.percentage,
    required this.voters,
  });

  factory Option.fromJson(Map<String, dynamic> json) {
    print("🔍 Parsing Option from: $json");

    return Option(
      option: json["option"]?.toString() ?? "",
      count: json["count"] is int ? json["count"] : (int.tryParse(json["count"]?.toString() ?? "0") ?? 0),
      percentage: json["percentage"] is int ? json["percentage"] : (int.tryParse(json["percentage"]?.toString() ?? "0") ?? 0),
      voters: json["voters"] != null && json["voters"] is List
          ? List<Voter>.from(
          (json["voters"] as List).map((x) {
            if (x == null) return null;
            return Voter.fromJson(
                x is Map<String, dynamic> ? x : Map<String, dynamic>.from(x)
            );
          }).where((x) => x != null)
      )
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
    "option": option,
    "count": count,
    "percentage": percentage,
    "voters": List<dynamic>.from(voters.map((x) => x.toJson())),
  };
}

class Voter {
  String id;
  String? profileImage; // Made nullable

  Voter({
    required this.id,
    this.profileImage, // Optional parameter
  });

  factory Voter.fromJson(Map<String, dynamic> json) {
    print("🔍 Parsing Voter from: $json");

    return Voter(
      id: json["id"]?.toString() ?? "",
      profileImage: json["profileImage"]?.toString(), // Can be null
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "profileImage": profileImage,
  };
}