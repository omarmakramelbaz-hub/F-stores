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
    await _firebaseMessaging!.setForegroundNotificationPresentationOptions(
      alert: false,
      badge: true,
      sound: false,
    );

    await localNotification();
    await firebaseCloudMessagingListeners();
    _isConfigured = true;

    scheduleNotificationPermission(
      request: () async {
        if (Platform.isIOS) {
          await _firebaseMessaging!.requestPermission(
            alert: true,
            announcement: true,
            badge: true,
            sound: true,
          );
        } else if (Platform.isAndroid) {
          await Permission.notification.request();
        }
        // APNS may become available only after the permission dialog closes.
        await getToken();
      },
      onError: (_, __) => log('Unable to request notification permission.'),
    );
  }

  static String? fcmToken;
  static Future<void> getToken() async {
    if (_firebaseMessaging == null) return;

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
    } catch (e) {
      log('Error getting device token: $e');
    }
  }

  static Future<void> firebaseCloudMessagingListeners() async {
    getToken();
    FirebaseMessaging.onMessage.listen((RemoteMessage data) {
      if (Platform.isAndroid) scheduleNotification(data);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage data) {
      NotificationResponse response = NotificationResponse(
        id: 0,
        payload: json.encode(data.data),
        notificationResponseType: NotificationResponseType.selectedNotification,
      );
      handlePath(response);
    });

    _notificationsPlugin!.getNotificationAppLaunchDetails().then((
      NotificationAppLaunchDetails? data,
    ) {
      if (data?.notificationResponse?.payload != null &&
          data?.notificationResponse?.payload != '') {
        handlePath(data!.notificationResponse!);
      }
    });
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    log('--- Background Message Received ---');
    await localNotification();
    await scheduleNotification(message);
  } catch (e) {
    log('Error in background handler: $e');
  }
}
