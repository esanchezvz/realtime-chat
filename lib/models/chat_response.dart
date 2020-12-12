import 'dart:convert';

ChatResponse chatResponseFromJson(String str) =>
    ChatResponse.fromJson(json.decode(str));

String chatResponseToJson(ChatResponse data) => json.encode(data.toJson());

class ChatResponse {
  ChatResponse({
    this.success,
    this.message,
    this.data,
  });

  bool success;
  String message;
  Data data;

  factory ChatResponse.fromJson(Map<String, dynamic> json) => ChatResponse(
        success: json["success"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data.toJson(),
      };
}

class Data {
  Data({
    this.messages,
  });

  List<Message> messages;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        messages: List<Message>.from(
            json["messages"].map((x) => Message.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "messages": List<dynamic>.from(messages.map((x) => x.toJson())),
      };
}

class Message {
  Message({
    this.to,
    this.from,
    this.message,
    this.createdAt,
    this.updatedAt,
    this.uid,
  });

  String to;
  String from;
  String message;
  DateTime createdAt;
  DateTime updatedAt;
  String uid;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        to: json["to"],
        from: json["from"],
        message: json["message"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        uid: json["uid"],
      );

  Map<String, dynamic> toJson() => {
        "to": to,
        "from": from,
        "message": message,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "uid": uid,
      };
}
