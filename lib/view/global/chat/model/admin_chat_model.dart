import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart'; // for firstWhereOrNull

class AdminChatMessageModel {
  String? message; // "message" from the screenshot
  String? receiverName; // "receiver_name" from the screenshot
  String? senderId; // "sender_id" from the screenshot
  String? senderName; // "sender_name" from the screenshot
  DateTime? messageTime; // "timestamp" from the screenshot
  String? userId; // "user_id" from the screenshot
  AdminChatMessageTypeEnum? messageType; // Assuming we still want to keep the message type logic

  AdminChatMessageModel({
    this.message,
    this.receiverName,
    this.senderId,
    this.senderName,
    this.messageTime,
    this.userId,
    this.messageType,
  });

  AdminChatMessageModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    receiverName = json['receiver_name'];
    senderId = json['sender_id'];
    senderName = json['sender_name'];

    // Parsing the "timestamp" field to DateTime
    messageTime = json['timestamp'] is! Timestamp ? null : (json['timestamp'] as Timestamp).toDate();

    userId = json['user_id'];

    // Assuming messageType is still being used
    messageType = AdminChatMessageTypeEnum.getByValue(json['messageType']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['receiver_name'] = receiverName;
    data['sender_id'] = senderId;
    data['sender_name'] = senderName;

    if (messageTime != null) {
      data['timestamp'] = Timestamp.fromDate(messageTime!);
    }

    data['user_id'] = userId;

    // Handling the messageType field
    if (messageType != null) {
      data['messageType'] = messageType?.value;
    }

    return data;
  }
}

enum AdminChatMessageTypeEnum {
  text(0);

  final int value;
  const AdminChatMessageTypeEnum(this.value);

  static AdminChatMessageTypeEnum? getByValue(int? i) {
    return AdminChatMessageTypeEnum.values.firstWhereOrNull((x) => x.value == i);
  }
}
