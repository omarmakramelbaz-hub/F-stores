class NotificationFromFirebaseMode {
  final String? notificationType;
  final String? accountType;
  final String? orderId;
  final String? icon;
  final String? clickAction;
  final String? receiverDeviceToken;
  final String? senderDeviceToken;
  final String? senderId;
  final String? receiverId;
  final String? senderAccountType;
  final String? senderFcmId;
  final String? senderName;
  final String? receiverName;
  final String? orderType;

  NotificationFromFirebaseMode({
    this.notificationType,
    this.accountType,
    this.orderId,
    this.icon,
    this.clickAction,
    this.receiverDeviceToken,
    this.senderDeviceToken,
    this.senderId,
    this.receiverId,
    this.senderAccountType,
    this.senderFcmId,
    this.senderName,
    this.receiverName,
    this.orderType,
  });

  factory NotificationFromFirebaseMode.fromJson(Map<String, dynamic> json) {
    return NotificationFromFirebaseMode(
      notificationType: json['notification_type'],
      accountType: json['account_type'] as String?,
      orderId: json['order_id'] as String?,
      icon: json['icon'] as String?,
      clickAction: json['click_action'] as String?,
      receiverDeviceToken: json['receiver_device_token'] as String?,
      senderDeviceToken: json['sender_device_token'] as String?,
      senderId: json['sender_id'] as String?,
      senderAccountType: json['sender_account_type'] as String?,
      senderFcmId: json['sender_fcm_id'] as String?,
      receiverId: json['reciever_id'] as String?,
      senderName: json['sender_name'] as String?,
      receiverName: json['receiver_name'] as String?,
      orderType: json['order_type'] as String?,
    );
  }
}
