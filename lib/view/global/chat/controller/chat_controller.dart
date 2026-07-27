import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../helpers/networking/api_helper.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../model/chat_model.dart';

class ChatController extends ChangeNotifier {
  String? orderId;

  Stream<QuerySnapshot<Map<String, dynamic>>>? chatStream;
  final _firestore = FirebaseFirestore.instance;

  void initial(String id) {
    orderId = id;
    chatStream = _firestore.collection('orderChat').doc(orderId.toString()).collection('chat').snapshots();
    notifyListeners();
  }

  Future<void> send(
    String text,
    int userId,
    String receiverDeviceToken,
    String senderDeviceToken,
    String senderName,
    String receiverName,
    String vendorDeviceToken,
    bool isVendor,
    String accountType,
  ) async {
    final time = DateTime.now();
    var uuid = const Uuid();
    String id = 'orderId-${uuid.v4()}';
    final msg = ChatMessageModel(
      id: id,
      message: text,
      messageTime: time,
      messageType: ChatMessageTypeEnum.text,
      userId: userId.toString(),
    );
    await _firestore.collection('orderChat').doc(orderId.toString()).collection('chat').doc(id).set(msg.toJson()).then((
      value,
    ) {
      ApiHelper.instance.sendNotification(
        deviceToken: receiverDeviceToken,
        titleName: senderName,
        body: text,
        data: {
          'order_id': orderId,
          'notification_type': '8',
          'account_type': accountType,
          'receiver_device_token': receiverDeviceToken,
          'sender_device_token': senderDeviceToken,
          'sender_name': senderName,
          'receiver_name': receiverName,
        },
      );

      if (isVendor == true) {
        ApiHelper.instance.sendNotification(
          deviceToken: vendorDeviceToken,
          titleName: senderName,
          body: text,
          data: {
            'order_id': orderId,
            'notification_type': '8',
            'account_type': accountType,
            'receiver_device_token': receiverDeviceToken,
            'sender_device_token': senderDeviceToken,
            'sender_name': senderName,
            'receiver_name': receiverName,
          },
        );
      }
    });
  }
}
