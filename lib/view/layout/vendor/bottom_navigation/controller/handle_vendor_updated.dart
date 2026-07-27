import 'dart:convert';
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

import '../../../../../helpers/locale/app_locale_key.dart';
import '../../../../../helpers/notification_helper/sound_notification.dart';
import '../../../../../helpers/utils/common_methods.dart';

void handleVendorUpdated(PusherEvent event, BuildContext context) {
  try {
    var jsonData = jsonDecode(event.data) as Map<String, dynamic>;

    if (context.mounted) {
      var status = jsonData['order_id']['status']?.toString();

      var orderNo = jsonData['order_id']['order_no']?.toString();
      log('*************************************************************');
      log(jsonData.toString());

      if (status != null && status == 'pending') {
        SoundNotification.playLongSound();
        CommonMethods.showToast(message: '${AppLocaleKey.thereIsANewOrder.tr()} $orderNo');
      } else {
        CommonMethods.showToast(message: '${AppLocaleKey.thereIsANewOrderWithStatus.tr()} $orderNo');
      }
    }
  } catch (e, stackTrace) {
    log('Error handling Pusher event: $e');
    log('Stack trace: $stackTrace');
  }
}
