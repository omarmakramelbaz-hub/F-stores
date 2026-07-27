import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';

class ChatMessageModel {
  String? id;
  String? userId;
  DateTime? messageTime;
  String? message;
  ChatMessageTypeEnum? messageType;

  ChatMessageModel({this.id, this.userId, this.message, this.messageTime, this.messageType});

  ChatMessageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    messageTime = json['messageTime'] is! Timestamp ? null : (json['messageTime'] as Timestamp).toDate();
    message = json['message'];
    messageType = ChatMessageTypeEnum.getByValue(json['messageType']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != null) {
      data['id'] = id;
    }
    if (userId != null) {
      data['userId'] = userId;
    }
    if (message != null) {
      data['message'] = message;
    }
    if (messageType != null) {
      data['messageType'] = messageType?.value;
    }
    if (messageTime != null) {
      data['messageTime'] = Timestamp.fromDate(messageTime!);
    }

    return data;
  }
}

enum ChatMessageTypeEnum {
  text(0);

  final int value;
  const ChatMessageTypeEnum(this.value);
  static ChatMessageTypeEnum? getByValue(int? i) {
    return ChatMessageTypeEnum.values.firstWhereOrNull((x) => x.value == i);
  }
}
