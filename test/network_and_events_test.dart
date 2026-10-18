import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:faskhaninja_vendor/helpers/networking/api_error_data.dart';
import 'package:faskhaninja_vendor/helpers/networking/network_connection.dart';
import 'package:faskhaninja_vendor/helpers/pusher_service/event_listener_registry.dart';

void main() {
  group('API error data', () {
    test('non-JSON errors always provide a readable message', () {
      for (final data in <dynamic>[
        null,
        '<html>Bad gateway</html>',
        ['Invalid request'],
        {'message': null},
        {'message': 502},
        {'message': ''},
      ]) {
        expect(apiErrorData(data, fallbackMessage: 'Please try again')['message'], 'Please try again');
      }
    });

    test('keeps server validation details without mutating the response', () {
      final source = <String, dynamic>{
        'message': 'Invalid mobile number',
        'errors': {
          'mobile': ['Invalid'],
        },
      };
      final result = apiErrorData(source, fallbackMessage: 'Please try again');
      expect(result, source);
      expect(identical(result, source), isFalse);
      result['message'] = 'Changed';
      expect(source['message'], 'Invalid mobile number');
    });
  });

  group('Network connection', () {
    test('supports every transport without treating it as offline', () {
      for (final result in ConnectivityResult.values) {
        expect(hasNetworkConnection([result]), result != ConnectivityResult.none, reason: result.name);
      }
    });

    test('requires an available transport', () {
      expect(hasNetworkConnection([]), isFalse);
      expect(hasNetworkConnection([ConnectivityResult.none]), isFalse);
      expect(hasNetworkConnection([ConnectivityResult.none, ConnectivityResult.ethernet]), isTrue);
    });
  });

  group('Pusher event lifecycle', () {
    test('a removed callback is not called on later events', () {
      final registry = EventListenerRegistry<int>();
      final received = <int>[];
      void listener(int event) => received.add(event);

      registry.add('vendor.updated', listener);
      registry.dispatch('vendor.updated', 1);
      registry.remove('vendor.updated', listener);
      registry.dispatch('vendor.updated', 2);
      expect(received, [1]);
    });

    test('a listener can unsubscribe while an event is being dispatched', () {
      final registry = EventListenerRegistry<int>();
      final received = <String>[];
      late void Function(int) first;
      first = (event) {
        received.add('first:$event');
        registry.remove('vendor.updated', first);
      };
      registry.add('vendor.updated', first);
      registry.add('vendor.updated', (event) => received.add('second:$event'));

      registry.dispatch('vendor.updated', 1);
      registry.dispatch('vendor.updated', 2);
      expect(received, ['first:1', 'second:1', 'second:2']);
    });

    test('a new listener starts on the next event', () {
      final registry = EventListenerRegistry<int>();
      final received = <int>[];
      registry.add('vendor.updated', (event) {
        if (event == 1) {
          registry.add('vendor.updated', received.add);
        }
      });

      registry.dispatch('vendor.updated', 1);
      expect(received, isEmpty);
      registry.dispatch('vendor.updated', 2);
      expect(received, [2]);
    });
  });
}
