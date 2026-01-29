
// To parse this JSON data, do
//
//     final connectAccountBalanceDataModel = connectAccountBalanceDataModelFromJson(jsonString);

import 'dart:convert';

ConnectAccountBalanceDataModel connectAccountBalanceDataModelFromJson(String str) => ConnectAccountBalanceDataModel.fromJson(json.decode(str));

String connectAccountBalanceDataModelToJson(ConnectAccountBalanceDataModel data) => json.encode(data.toJson());

class ConnectAccountBalanceDataModel {
  bool success;
  String message;
  ConnectedAccountBalanceResult result;

  ConnectAccountBalanceDataModel({
    required this.success,
    required this.message,
    required this.result,
  });

  factory ConnectAccountBalanceDataModel.fromJson(Map<String, dynamic> json) => ConnectAccountBalanceDataModel(
    success: json["success"],
    message: json["message"],
    result: ConnectedAccountBalanceResult.fromJson(json["result"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "result": result.toJson(),
  };
}

class ConnectedAccountBalanceResult {
  int available;
  double withdrawable;
  double pendingBalance;
  int totalTransactions;
  int completedTransactions;
  int pendingTransactions;
  List<TransactionHistory> transactionHistory;

  ConnectedAccountBalanceResult({
    required this.available,
    required this.withdrawable,
    required this.pendingBalance,
    required this.totalTransactions,
    required this.completedTransactions,
    required this.pendingTransactions,
    required this.transactionHistory,
  });

  factory ConnectedAccountBalanceResult.fromJson(Map<String, dynamic> json) => ConnectedAccountBalanceResult(
    available: json["available"],
    withdrawable: json["withdrawable"]?.toDouble(),
    pendingBalance: json["pendingBalance"]?.toDouble(),
    totalTransactions: json["totalTransactions"],
    completedTransactions: json["completedTransactions"],
    pendingTransactions: json["pendingTransactions"],
    transactionHistory: List<TransactionHistory>.from(json["transactionHistory"].map((x) => TransactionHistory.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "available": available,
    "withdrawable": withdrawable,
    "pendingBalance": pendingBalance,
    "totalTransactions": totalTransactions,
    "completedTransactions": completedTransactions,
    "pendingTransactions": pendingTransactions,
    "transactionHistory": List<dynamic>.from(transactionHistory.map((x) => x.toJson())),
  };
}

class TransactionHistory {
  String id;
  String status;
  int amount;
  String method;
  String paymentFor; // <-- NEW FIELD
  Event event;

  TransactionHistory({
    required this.id,
    required this.status,
    required this.amount,
    required this.method,
    required this.paymentFor, // <-- NEW FIELD
    required this.event,
  });

  factory TransactionHistory.fromJson(Map<String, dynamic> json) =>
      TransactionHistory(
        id: json["id"],
        status: json["status"],
        amount: json["amount"],
        method: json["method"],
        paymentFor: json["paymentFor"] ?? "", // <-- PARSE IT
        event: Event.fromJson(json["event"]),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "status": status,
    "amount": amount,
    "method": method,
    "paymentFor": paymentFor, // <-- ADD IT BACK
    "event": event.toJson(),
  };
}


class Event {
  String id;
  String title;
  String text;

  Event({
    required this.id,
    required this.title,
    required this.text,
  });

  factory Event.fromJson(Map<String, dynamic> json) => Event(
    id: json["id"],
    title: json["title"],
    text: json["text"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "text": text,
  };
}
