import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:faskhaninja_vendor/helpers/networking/api_helper.dart';
import 'package:faskhaninja_vendor/helpers/networking/urls.dart';
import 'package:faskhaninja_vendor/helpers/routes/app_routers_import.dart';
import 'package:faskhaninja_vendor/view/layout/vendor/order/controller/order_controller.dart';

class _Call {
  _Call(this.url, this.page, this.session);
  final String url;
  final int page;
  final String? session;
  final result = Completer<ApiResponse>();
}

class _Gateway {
  String? session = 'store-a';
  final calls = <_Call>[];
  int unauthorized = 0;

  Future<ApiResponse> get(String url, {Map<String, dynamic>? queryParameters}) {
    final call = _Call(url, queryParameters!['page'] as int, session);
    calls.add(call);
    return call.result.future;
  }

  OrderController controller() => OrderController(
        homeOrdersRequest: get,
        homeOrdersSession: () => session,
        homeOrdersUnauthenticated: () => unauthorized++,
      );

  void finishRound(int start, {int firstId = 1}) {
    calls[start].result.complete(_page(firstId));
    calls[start + 1].result.complete(_page(firstId + 1));
  }
}

ApiResponse _page(int id, {int page = 1, int lastPage = 1, int? total}) {
  return ApiResponse(
    state: ResponseState.complete,
    data: {
      'data': {
        'data': [
          {'id': id, 'order_no': 'order-$id'},
        ],
        'meta': {'current_page': page, 'last_page': lastPage, 'total': total ?? lastPage},
      },
    },
  );
}

Future<void> _flush() => Future<void>.delayed(Duration.zero);

class _HomeNavigatorSpy extends NavigatorState {
  int redirects = 0;

  @override
  Future<T?> pushNamedAndRemoveUntil<T extends Object?>(String newRouteName, RoutePredicate predicate,
      {Object? arguments}) {
    redirects++;
    return Future<T?>.value();
  }
}

class _HomeNavigatorKey extends GlobalKey<NavigatorState> {
  const _HomeNavigatorKey(this.navigator) : super.constructor();
  final _HomeNavigatorSpy navigator;

  @override
  NavigatorState get currentState => navigator;

  @override
  BuildContext? get currentContext => null;
}

void main() {
  test('a home refresh makes two requests and publishes two state updates', () async {
    final gateway = _Gateway();
    final controller = gateway.controller();
    addTearDown(controller.dispose);
    var updates = 0;
    controller.addListener(() => updates++);

    final refresh = controller.refreshHomeOrders();
    expect(gateway.calls.map((call) => call.url), [Urls.pendingOrdersHome, Urls.currentHomeOrders]);
    expect(updates, 1);
    expect(controller.pendingVendorOrdersResponse.state, ResponseState.loading);
    expect(controller.currentVendorHomeOrdersResponse.state, ResponseState.loading);

    gateway.finishRound(0);
    await refresh;
    expect(updates, 2);
    expect(controller.pendingVendorOrders.single.id, 1);
    expect(controller.currentVendorHomeOrders.single.id, 2);
  });

  test('bursts share a trailing round and an event during it starts another round', () async {
    final gateway = _Gateway();
    final controller = gateway.controller();
    addTearDown(controller.dispose);
    var updates = 0;
    controller.addListener(() => updates++);

    final refresh = controller.refreshHomeOrders();
    for (var i = 0; i < 20; i++) {
      expect(identical(controller.refreshHomeOrders(), refresh), isTrue);
    }
    expect(gateway.calls.length, 2);
    gateway.finishRound(0);
    await _flush();
    expect(gateway.calls.length, 4);

    controller.refreshHomeOrders(); // Arrives after the trailing round started.
    gateway.finishRound(2, firstId: 10);
    await _flush();
    expect(gateway.calls.length, 6);
    gateway.finishRound(4, firstId: 20);
    await refresh;
    expect(updates, 6);
    expect(controller.pendingVendorOrders.single.id, 20);
    expect(controller.currentVendorHomeOrders.single.id, 21);
  });

  test('duplicate pagination requests share one HTTP call and append once', () async {
    final gateway = _Gateway();
    final controller = gateway.controller();
    addTearDown(controller.dispose);

    final first = controller.getPendingVendorHomeOrders();
    expect(identical(first, controller.getPendingVendorHomeOrders()), isTrue);
    expect(gateway.calls.length, 1);
    gateway.calls[0].result.complete(_page(1, lastPage: 3));
    await first;
    final next = controller.getPendingVendorHomeOrders();
    expect(identical(next, controller.getPendingVendorHomeOrders(pageNumber: 2)), isTrue);
    expect(gateway.calls.length, 2);
    expect(gateway.calls.last.page, 2);
    gateway.calls[1].result.complete(_page(2, page: 2, lastPage: 3));
    await next;
    expect(controller.pendingVendorOrders.map((order) => order.id), [1, 2]);
    expect(controller.pendingOrderPage, 3);
  });

  test('refresh replaces the first page and ignores an older pagination response', () async {
    final gateway = _Gateway();
    final controller = gateway.controller();
    addTearDown(controller.dispose);
    final first = controller.getPendingVendorHomeOrders();
    gateway.calls[0].result.complete(_page(1, lastPage: 3));
    await first;

    final oldPage = controller.getPendingVendorHomeOrders();
    final fresh = controller.getPendingVendorHomeOrders(pageNumber: 1);
    expect(gateway.calls.map((call) => call.page), [1, 2, 1]);
    gateway.calls[2].result.complete(_page(99, lastPage: 2, total: 50));
    await fresh;
    gateway.calls[1].result.complete(_page(2, page: 2, lastPage: 3));
    await oldPage;
    expect(controller.pendingVendorOrders.single.id, 99);
    expect(controller.totalPendingHome, 50);
    expect(controller.pendingOrderPage, 2);
    expect(controller.pendingIsPaginating, isFalse);
  });

  test('current home pagination has its own cursor and appends later pages', () async {
    final gateway = _Gateway();
    final controller = gateway.controller();
    addTearDown(controller.dispose);
    controller.currentOrderPage = 7;
    controller.initialCurrentVendorHomeOrders();
    expect(controller.currentOrderPage, 7);

    final first = controller.getCurrentVendorHomeOrders();
    gateway.calls[0].result.complete(_page(1, lastPage: 3));
    await first;
    final second = controller.getCurrentVendorHomeOrders();
    expect(gateway.calls.last.page, 2);
    gateway.calls[1].result.complete(_page(2, page: 2, lastPage: 3));
    await second;
    expect(controller.currentVendorHomeOrders.map((order) => order.id), [1, 2]);
    expect(controller.currentOrderHomePage, 3);
    expect(controller.currentOrderPage, 7);
  });

  test('realtime after a pull request starts a newer read instead of joining it', () async {
    final gateway = _Gateway();
    final controller = gateway.controller();
    addTearDown(controller.dispose);
    final pull = controller.getPendingVendorHomeOrders(pageNumber: 1);
    final realtime = controller.refreshHomeOrders();
    expect(gateway.calls.length, 3);
    expect(gateway.calls.map((call) => call.page), [1, 1, 1]);
    gateway.finishRound(1, firstId: 90);
    await realtime;
    gateway.calls[0].result.complete(_page(1));
    await pull;
    expect(controller.pendingVendorOrders.single.id, 90);
  });

  test('a new account starts immediately and old responses cannot overwrite it', () async {
    final gateway = _Gateway();
    final controller = gateway.controller();
    addTearDown(controller.dispose);
    final old = controller.refreshHomeOrders();
    gateway.session = 'store-b';
    final fresh = controller.refreshHomeOrders();
    expect(identical(old, fresh), isFalse);
    expect(gateway.calls.length, 4);
    expect(gateway.calls.skip(2).map((call) => call.session), ['store-b', 'store-b']);
    expect(controller.pendingVendorOrders, isEmpty);
    expect(controller.currentVendorHomeOrders, isEmpty);
    expect(controller.totalPendingHome, 0);
    gateway.finishRound(2, firstId: 100);
    await fresh; // The new account does not wait for the previous account's HTTP request.
    expect(controller.pendingVendorOrders.single.id, 100);
    gateway.finishRound(0, firstId: 1);
    await old;
    expect(controller.pendingVendorOrders.single.id, 100);
    expect(controller.currentVendorHomeOrders.single.id, 101);
  });

  test('getters purge a completed previous account before any new refresh starts', () async {
    final gateway = _Gateway();
    final controller = gateway.controller();
    addTearDown(controller.dispose);
    final loaded = controller.refreshHomeOrders();
    gateway.finishRound(0);
    await loaded;
    expect(controller.totalPendingHome, 1);
    gateway.session = 'store-b';

    // This models the first build, before the screen's post-frame refresh.
    expect(controller.totalPendingHome, 0);
    expect(controller.pendingVendorOrders, isEmpty);
    expect(controller.currentVendorHomeOrders, isEmpty);
    expect(controller.pendingOrders, isNull);
    expect(controller.currentHomeOrders, isNull);
    expect(controller.pendingVendorOrdersResponse.state, ResponseState.sleep);
    expect(controller.currentVendorHomeOrdersResponse.state, ResponseState.sleep);
    expect(controller.pendingOrderPage, 1);
    expect(controller.currentOrderHomePage, 1);
    expect(gateway.calls.length, 2);
  });

  test('a changed token cannot publish a response even without another event', () async {
    final gateway = _Gateway();
    final controller = gateway.controller();
    addTearDown(controller.dispose);
    final refresh = controller.refreshHomeOrders();
    gateway.session = null;
    gateway.finishRound(0);
    await refresh;
    expect(controller.pendingVendorOrders, isEmpty);
    expect(controller.currentVendorHomeOrders, isEmpty);
    expect(controller.pendingVendorOrdersResponse.state, ResponseState.sleep);
    expect(controller.totalPendingHome, 0);
  });

  test('switching accounts during a trailing round schedules a clean new round', () async {
    final gateway = _Gateway();
    final controller = gateway.controller();
    addTearDown(controller.dispose);
    final refresh = controller.refreshHomeOrders();
    controller.refreshHomeOrders();
    gateway.finishRound(0);
    await _flush();
    expect(gateway.calls.length, 4);
    gateway.session = 'store-b';
    final changed = controller.refreshHomeOrders();
    gateway.finishRound(2, firstId: 10);
    await _flush();
    expect(gateway.calls.length, 6);
    expect(controller.pendingVendorOrders, isEmpty);
    expect(controller.currentVendorHomeOrders, isEmpty);
    gateway.finishRound(4, firstId: 100);
    await changed;
    await refresh;
    expect(controller.pendingVendorOrders.single.id, 100);
    expect(controller.currentVendorHomeOrders.single.id, 101);
  });

  test('a new account starts at page one even if the previous cursor was later', () async {
    final gateway = _Gateway();
    final controller = gateway.controller();
    addTearDown(controller.dispose);
    final first = controller.getPendingVendorHomeOrders();
    gateway.calls[0].result.complete(_page(1, lastPage: 3));
    await first;
    gateway.session = 'store-b';
    final changed = controller.getPendingVendorHomeOrders(pageNumber: 2);
    expect(gateway.calls.last.page, 1);
    expect(controller.pendingVendorOrders, isEmpty);
    gateway.calls[1].result.complete(_page(100, lastPage: 2));
    await changed;
    expect(controller.pendingVendorOrders.single.id, 100);
  });

  test('a late unauthorized response cannot sign out the next account', () async {
    final gateway = _Gateway();
    final controller = gateway.controller();
    addTearDown(controller.dispose);
    final old = controller.refreshHomeOrders();
    gateway.session = 'store-b';
    final fresh = controller.refreshHomeOrders();
    gateway.finishRound(2, firstId: 100);
    await fresh;
    gateway.calls[0].result.complete(ApiResponse(state: ResponseState.unauthorized, data: {'message': 'Unauthorized'}));
    gateway.calls[1].result.complete(ApiResponse(state: ResponseState.unauthorized, data: {'message': 'Unauthorized'}));
    await old;
    expect(gateway.unauthorized, 0);
    expect(controller.pendingVendorOrders.single.id, 100);
  });

  test('an unauthorized response for the active account still invokes auth handling', () async {
    final gateway = _Gateway();
    final controller = gateway.controller();
    addTearDown(controller.dispose);
    final refresh = controller.refreshHomeOrders();
    gateway.calls[0].result.complete(ApiResponse(state: ResponseState.unauthorized, data: {'message': 'Unauthorized'}));
    gateway.calls[1].result.complete(_page(2));
    await refresh;
    expect(gateway.unauthorized, 1);
    expect(controller.pendingVendorOrdersResponse.state, ResponseState.unauthorized);
  });

  testWidgets('a scheduled home 401 redirect rechecks the session before navigation', (tester) async {
    final previousKey = NamedNavigatorImpl.navigatorState;
    final navigator = _HomeNavigatorSpy();
    NamedNavigatorImpl.navigatorState = _HomeNavigatorKey(navigator);
    addTearDown(() => NamedNavigatorImpl.navigatorState = previousKey);
    final gateway = _Gateway();
    final controller = OrderController(homeOrdersRequest: gateway.get, homeOrdersSession: () => gateway.session);
    addTearDown(controller.dispose);
    final refresh = controller.refreshHomeOrders();
    gateway.calls[0].result.complete(ApiResponse(state: ResponseState.unauthorized, data: {'message': 'Unauthorized'}));
    gateway.calls[1].result.complete(_page(2));
    await refresh;
    gateway.session = 'store-b';
    await tester.pump(const Duration(milliseconds: 1));
    expect(navigator.redirects, 0);
  });

  testWidgets('a current home 401 still redirects with the default callback', (tester) async {
    final previousKey = NamedNavigatorImpl.navigatorState;
    final navigator = _HomeNavigatorSpy();
    NamedNavigatorImpl.navigatorState = _HomeNavigatorKey(navigator);
    addTearDown(() => NamedNavigatorImpl.navigatorState = previousKey);
    final gateway = _Gateway();
    final controller = OrderController(homeOrdersRequest: gateway.get, homeOrdersSession: () => gateway.session);
    addTearDown(controller.dispose);
    final refresh = controller.refreshHomeOrders();
    gateway.calls[0].result.complete(ApiResponse(state: ResponseState.unauthorized, data: {'message': 'Unauthorized'}));
    gateway.calls[1].result.complete(_page(2));
    await refresh;
    await tester.pump(const Duration(milliseconds: 1));
    expect(navigator.redirects, 1);
  });

  test('exceptions and malformed responses become retryable error states', () async {
    final gateway = _Gateway();
    final controller = gateway.controller();
    addTearDown(controller.dispose);
    final failed = controller.refreshHomeOrders();
    gateway.calls[0].result.completeError(StateError('request failed'));
    gateway.calls[1].result.completeError(StateError('request failed'));
    await failed;
    expect(controller.pendingVendorOrdersResponse.state, ResponseState.error);
    expect(controller.currentVendorHomeOrdersResponse.state, ResponseState.error);

    final malformed = controller.refreshHomeOrders();
    gateway.calls[2].result.complete(ApiResponse(state: ResponseState.complete, data: '<html>Bad gateway</html>'));
    gateway.calls[3].result.complete(_page(10));
    await malformed;
    expect(controller.pendingVendorOrdersResponse.state, ResponseState.error);
    final recovered = controller.refreshHomeOrders();
    gateway.finishRound(4, firstId: 20);
    await recovered;
    expect(controller.pendingVendorOrders.single.id, 20);
    expect(controller.currentVendorHomeOrders.single.id, 21);
  });

  test('an event queued during a failed round still gets a fresh read', () async {
    final gateway = _Gateway();
    final controller = gateway.controller();
    addTearDown(controller.dispose);
    final refresh = controller.refreshHomeOrders();
    controller.refreshHomeOrders();
    gateway.calls[0].result.completeError(StateError('request failed'));
    gateway.calls[1].result.completeError(StateError('request failed'));
    await _flush();
    expect(gateway.calls.length, 4);
    gateway.finishRound(2, firstId: 100);
    await refresh;
    expect(controller.pendingVendorOrders.single.id, 100);
    expect(controller.currentVendorHomeOrders.single.id, 101);
  });

  test('background refresh keeps already loaded orders visible until replacement', () async {
    final gateway = _Gateway();
    final controller = gateway.controller();
    addTearDown(controller.dispose);
    final first = controller.refreshHomeOrders();
    gateway.finishRound(0);
    await first;
    final fresh = controller.refreshHomeOrders();
    expect(controller.pendingVendorOrders.single.id, 1);
    expect(controller.pendingVendorOrdersResponse.state, ResponseState.complete);
    gateway.finishRound(2, firstId: 10);
    await fresh;
    expect(controller.pendingVendorOrders.single.id, 10);
  });

  test('disposing the controller drops late data and cancels queued refreshes', () async {
    final gateway = _Gateway();
    final controller = gateway.controller();
    final refresh = controller.refreshHomeOrders();
    controller.refreshHomeOrders();
    controller.dispose();
    gateway.finishRound(0);
    await refresh;
    expect(gateway.calls.length, 2);
    expect(controller.pendingVendorOrders, isEmpty);
    expect(controller.currentVendorHomeOrders, isEmpty);
    await controller.refreshHomeOrders();
    expect(gateway.calls.length, 2);
  });

  test('end-of-feed skips extra pagination but allows explicit page-one refresh', () async {
    final gateway = _Gateway();
    final controller = gateway.controller();
    addTearDown(controller.dispose);
    final first = controller.getPendingVendorHomeOrders();
    gateway.calls[0].result.complete(_page(1));
    await first;
    await controller.getPendingVendorHomeOrders(pageNumber: 2);
    expect(gateway.calls.length, 1);
    final fresh = controller.getPendingVendorHomeOrders(pageNumber: 1);
    gateway.calls[1].result.complete(_page(2));
    await fresh;
    expect(controller.pendingVendorOrders.single.id, 2);
  });
}
