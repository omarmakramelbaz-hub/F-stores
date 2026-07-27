import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'helpers/notification_helper/firebase_options.dart';
import 'helpers/notification_helper/notification_helper.dart';
import 'helpers/notification_helper/sound_notification.dart';
import 'helpers/theme/theme_enum.dart';

Future<void> initServices() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(name: 'fasakhaninjatest', options: DefaultFirebaseOptions.currentPlatform);
  await EasyLocalization.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage((RemoteMessage message) async => SoundNotification.playLongSound());
  await FirebaseNotifications.setUpFirebase();
  await Hive.initFlutter();
  Hive.registerAdapter(ThemeEnumAdapter());
  await Hive.openBox('app');
  timeago.setLocaleMessages('en', timeago.EnMessages());
  timeago.setLocaleMessages('en_short', timeago.EnShortMessages());
  timeago.setLocaleMessages('ar', timeago.ArMessages());
  timeago.setLocaleMessages('ar_short', timeago.ArShortMessages());
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  HttpOverrides.global = MyHttpOverrides();
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
