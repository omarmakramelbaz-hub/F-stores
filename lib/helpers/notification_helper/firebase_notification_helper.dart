part of 'notification_helper.dart';

FirebaseMessaging? _firebaseMessaging;

class FirebaseNotifications {
  static FirebaseNotifications? _instance;

  FirebaseNotifications._internal();

  factory FirebaseNotifications() {
    _instance ??= FirebaseNotifications._internal();
    return _instance!;
  }

  static bool _isConfigured = false;

  static Future<void> setUpFirebase() async {
    if (_isConfigured) return;
    WidgetsFlutterBinding.ensureInitialized();

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    _firebaseMessaging = FirebaseMessaging.instance;
    await _firebaseMessaging!.setAutoInitEnabled(true);

    // Disable automatic foreground presentation to prevent double notifications on iOS
    await _firebaseMessaging!.setForegroundNotificationPresentationOptions(alert: false, badge: true, sound: false);

    await localNotification();
    await firebaseCloudMessagingListeners();
    _isConfigured = true;

    // Request notification permissions last so it doesn't block setup
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        await [Permission.notification].request();
      }
    } catch (e) {
      log('Error requesting permissions: $e');
    }
  }

  static String? fcmToken;
  static Future<void> getToken() async {
    if (_firebaseMessaging == null) return;

    log('-----------Device Token--------------');

    // Attempt to get token with retry for iOS/APNS
    try {
      if (Platform.isIOS) {
        String? apnsToken;
        for (int i = 0; i < 5; i++) {
          apnsToken = await _firebaseMessaging!.getAPNSToken();
          if (apnsToken != null) break;
          await Future.delayed(const Duration(seconds: 1));
        }
      }

      fcmToken = await _firebaseMessaging!.getToken();
      log('Device Token => \n$fcmToken');
    } catch (e) {
      log('Error getting device token: $e');
    }
  }

  static Future<void> firebaseCloudMessagingListeners() async {
    if (Platform.isIOS) iOSPermission();
    getToken();
    FirebaseMessaging.onMessage.listen((RemoteMessage data) {
      log('on Message notification ${data.notification?.toMap()}');
      log('on Message notification ${data.toMap()}');
      log('on Message data ${data.data}');
      log('on Message body ${data.notification?.body}');
      log('${data.data}');
      if (Platform.isAndroid) scheduleNotification(data);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage data) {
      log('on Opened ${data.data}');
      NotificationResponse response = NotificationResponse(
        id: 0,
        payload: json.encode(data.data),
        notificationResponseType: NotificationResponseType.selectedNotification,
      );
      handlePath(response);
    });

    _notificationsPlugin!.getNotificationAppLaunchDetails().then((NotificationAppLaunchDetails? data) {
      if (data?.notificationResponse?.payload != null && data?.notificationResponse?.payload != '') {
        log('on Opened From Notification ${data!.notificationResponse?.payload}');
        handlePath(data.notificationResponse!);
      }
    });
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    log('--- Background Message Received ---');
    await localNotification();
    await scheduleNotification(message);
  } catch (e) {
    log('Error in background handler: $e');
  }
}
