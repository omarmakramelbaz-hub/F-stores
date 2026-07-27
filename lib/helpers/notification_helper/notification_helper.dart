import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../view/global/chat/screen/admin_chat_screen.dart';
import '../../view/global/chat/screen/chat_screen.dart';
import '../../view/layout/vendor/bottom_navigation/screen/bottom_navigation_bar_screen.dart';
import '../../view/layout/vendor/notifications/model/notfication_from_firebase_model.dart';
import '../../view/layout/vendor/order/screen/order_details_screen.dart';
import '../../view/layout/vendor/request_delegate/screen/request_delegate_screen.dart';
import '../../view/layout/vendor/wallet/screen/wallet_screen.dart';
import '../routes/app_routers_import.dart';
import 'firebase_options.dart';
import 'sound_notification.dart';

part 'firebase_notification_helper.dart';
part 'local_notification.dart';
part 'notification_operation.dart';
