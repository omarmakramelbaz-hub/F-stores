import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:faskhaninja_vendor/helpers/notification_helper/notification_permission.dart';

void main() {
  testWidgets('permission waits for the first frame and does not block it', (tester) async {
    final answer = Completer<void>();
    var calls = 0;
    scheduleNotificationPermission(
      request: () {
        calls++;
        return answer.future;
      },
      onError: (_, __) => fail('Permission request unexpectedly failed.'),
    );

    expect(calls, 0);
    await tester.pumpWidget(const SizedBox());
    expect(calls, 1);
    expect(answer.isCompleted, isFalse);

    answer.complete();
    await tester.pump();
    await tester.pump();
    expect(calls, 1);
  });

  testWidgets('an asynchronous permission failure is handled once', (tester) async {
    final error = StateError('permission unavailable');
    final answer = Completer<void>();
    final errors = <Object>[];
    scheduleNotificationPermission(request: () => answer.future, onError: (error, _) => errors.add(error));
    await tester.pumpWidget(const SizedBox());
    answer.completeError(error);
    await tester.pump();

    expect(errors, [error]);
    expect(tester.takeException(), isNull);
  });

  testWidgets('a synchronous permission failure is handled', (tester) async {
    final error = StateError('permission unavailable');
    final errors = <Object>[];
    scheduleNotificationPermission(request: () => throw error, onError: (error, _) => errors.add(error));
    await tester.pumpWidget(const SizedBox());

    expect(errors, [error]);
    expect(tester.takeException(), isNull);
  });
}
