import 'dart:async';

import 'package:flutter/widgets.dart';

/// Show the permission prompt after the app has rendered its first frame.
/// Notification listeners can be registered before this without waiting for
/// the user to answer an operating-system dialog.
void scheduleNotificationPermission({
  required Future<void> Function() request,
  required void Function(Object, StackTrace) onError,
}) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    unawaited(_requestPermission(request, onError));
  });
}

Future<void> _requestPermission(
  Future<void> Function() request,
  void Function(Object, StackTrace) onError,
) async {
  try {
    await request();
  } catch (error, stackTrace) {
    onError(error, stackTrace);
  }
}
