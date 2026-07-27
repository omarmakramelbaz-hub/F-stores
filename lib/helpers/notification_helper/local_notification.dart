part of 'notification_helper.dart';

FlutterLocalNotificationsPlugin? _notificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> localNotification() async {
  _notificationsPlugin = FlutterLocalNotificationsPlugin();

  var android = const AndroidInitializationSettings('@mipmap/ic_launcher');
  var ios = const DarwinInitializationSettings(
    defaultPresentBadge: true,
    defaultPresentAlert: true,
    defaultPresentSound: true,
  );
  var initSetting = InitializationSettings(android: android, iOS: ios);

  if (!kIsWeb) {
    await _notificationsPlugin!.initialize(
      initSetting,
      onDidReceiveNotificationResponse: (not) {
        log('onSelect Message ${not.payload}');
        handlePath(not);
      },
    );

    if (Platform.isAndroid) {
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'high_importance_channel',
        'High Importance Notifications',
        description: 'Used for important notifications',
        importance: Importance.max,
        playSound: true,
        sound: RawResourceAndroidNotificationSound('lastSound'),
      );
      await _notificationsPlugin!
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    }
  }
}
