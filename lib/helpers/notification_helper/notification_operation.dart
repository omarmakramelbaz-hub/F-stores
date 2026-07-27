part of 'notification_helper.dart';

Future<void> scheduleNotification(RemoteMessage message) async {
  var rng = math.Random();
  var android = const AndroidNotificationDetails(
    'faskhaninja_channel_id',
    'FaskhaNinja Notifications',
    channelDescription: 'faskhaninja description',
    importance: Importance.max,
    priority: Priority.max,
    colorized: true,
    color: Color(0xff469D8F),
    playSound: true,
    sound: RawResourceAndroidNotificationSound('lastSound'),
  );
  var ios = const DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
    sound: 'lastSound.wav',
  );
  await _notificationsPlugin!.show(
    rng.nextInt(100000),
    message.notification!.title,
    message.notification!.body,
    NotificationDetails(android: android, iOS: ios),
    payload: json.encode(message.data),
  );
  if (message.data['notification_sound'] == 'long') {
    switch (message.data['notificationType'].toString()) {
      case '1':
        SoundNotification.playLongSound();
        break;
      case '10':
        SoundNotification.playLongSound();
        break;
      default:
        SoundNotification.playLongSound();
    }
  }
}

void iOSPermission() {
  _firebaseMessaging!.requestPermission(alert: true, announcement: true, badge: true, sound: true);
}

void handlePath(NotificationResponse dataMap) {
  final String? payload = dataMap.payload;
  if (payload != null) {
    log('Notification tapped with payload: $payload');
    final data = json.decode(payload);
    _onNotificationTaped(RemoteMessage(data: data));
  }
}

void _onNotificationTaped(RemoteMessage message) {
  final msg = json.encode(message.data);
  var body = json.decode(msg);
  log('Notification tapped with payload: $body');

  SoundNotification.stopSound();

  final data = NotificationFromFirebaseMode.fromJson(body);

  switch (data.notificationType.toString()) {
    case '1':
      if (data.orderType.toString() == 'shipping') {
        NamedNavigatorImpl.pushNamed(NamedNavigatorImpl.context, RequestDelegateScreen.routeName);
      } else {
        NamedNavigatorImpl.pushNamed(
          NamedNavigatorImpl.context,
          OrderDetailsScreen.routeName,
          arguments: OrderDetailsScreenArgs(orderId: int.parse(data.orderId.toString()), fromHome: true),
        );
      }
      break;

    case '3':
      NamedNavigatorImpl.pushNamed(NamedNavigatorImpl.context, WalletScreen.routeName);
      break;

    case '8':
      NamedNavigatorImpl.pushNamed(
        NamedNavigatorImpl.context,
        ChatScreen.routeName,
        arguments: ChatScreenArgs(
          senderDeviceToken: data.receiverDeviceToken.toString(),
          accountType: data.accountType.toString(),
          isVendor: false,
          vendorDeviceToken: data.receiverDeviceToken.toString(),
          receiverDeviceToken: data.senderDeviceToken.toString(),
          senderName: data.receiverName.toString(),
          receiverName: data.senderName.toString(),
          orderId: data.orderId.toString(),
        ),
      );
      break;

    case '10':
      NamedNavigatorImpl.pushNamed(
        NamedNavigatorImpl.context,
        AdminChatScreen.routeName,
        arguments: AdminChatScreenArgs(
          senderId: data.receiverId.toString(),
          receiverId: data.senderId.toString(),
          receiverDeviceToken: data.senderDeviceToken.toString(),
          senderDeviceToken: data.receiverDeviceToken.toString(),
          senderName: data.receiverName.toString(),
          receiverName: data.senderName.toString(),
          accountType: data.accountType.toString(),
          isToVendor: true,
          vendorDeviceToken: data.receiverDeviceToken.toString(),
        ),
      );
      break;

    default:
      NamedNavigatorImpl.pushNamed(NamedNavigatorImpl.context, VendorBottomNavigationBarScreen.routeName);
  }
}
