import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:faskhaninja_vendor/helpers/networking/api_helper.dart';
import 'package:faskhaninja_vendor/helpers/networking/urls.dart';
import 'package:faskhaninja_vendor/helpers/routes/app_routers_import.dart';
import 'package:faskhaninja_vendor/view/layout/vendor/auth/controller/auth_controller.dart';

class _Request {
  _Request(this.url, this.headers, this.hasToken, this.redirectOnUnauthorized);

  final String url;
  final Map<String, String> headers;
  final bool hasToken;
  final bool redirectOnUnauthorized;
  final result = Completer<ApiResponse>();
}

class _Session {
  String? token = 'session-a';
  int clears = 0;
  final profileRequests = <_Request>[];
  final logoutRequests = <_Request>[];
  final loading = <bool>[];
  final feedback = <ApiResponse>[];

  Future<ApiResponse> _request(
    List<_Request> calls,
    String url,
    Map<String, String> headers,
    bool hasToken,
    bool redirectOnUnauthorized,
  ) {
    final call = _Request(url, Map.of(headers), hasToken, redirectOnUnauthorized);
    calls.add(call);
    return call.result.future;
  }

  AuthController controller() => AuthController(
        readSession: () => token,
        clearSession: () {
          clears++;
          token = null;
        },
        profileRequest: (url, {required headers, required hasToken, required redirectOnUnauthorized}) =>
            _request(profileRequests, url, headers, hasToken, redirectOnUnauthorized),
        logoutRequest: (url, {required headers, required hasToken, required redirectOnUnauthorized}) =>
            _request(logoutRequests, url, headers, hasToken, redirectOnUnauthorized),
        setLogoutLoading: loading.add,
        logoutFeedback: feedback.add,
      );

  Future<void> loadProfile(AuthController controller, int id) async {
    final request = controller.getProfile();
    profileRequests.last.result.complete(_profile(id));
    await request;
  }
}

ApiResponse _profile(int id) => ApiResponse(
      state: ResponseState.complete,
      data: {
        'data': {'id': id, 'token': 'profile-session-$id', 'balance': id},
      },
    );

ApiResponse _reply(ResponseState state, [String message = 'server reply']) =>
    ApiResponse(state: state, data: {'message': message});

class _NavigatorSpy extends NavigatorState {
  int redirects = 0;

  @override
  Future<T?> pushNamedAndRemoveUntil<T extends Object?>(
    String newRouteName,
    RoutePredicate predicate, {
    Object? arguments,
  }) {
    redirects++;
    return Future<T?>.value();
  }
}

class _NavigatorKey extends GlobalKey<NavigatorState> {
  const _NavigatorKey(this.navigator) : super.constructor();
  final _NavigatorSpy navigator;

  @override
  NavigatorState get currentState => navigator;

  @override
  BuildContext? get currentContext => null;
}

void main() {
  test('successful logout clears local state before IO and sends the captured token', () async {
    final session = _Session();
    final controller = session.controller();
    addTearDown(controller.dispose);
    await session.loadProfile(controller, 1);
    var navigations = 0;

    final logout = controller.logout(onSuccess: () => navigations++);
    expect(session.token, isNull);
    expect(controller.profile, isNull);
    expect(controller.profileResponse.state, ResponseState.sleep);
    expect(session.clears, 1);
    expect(session.loading, [true]);
    final call = session.logoutRequests.single;
    expect(call.url, Urls.vendorLogout);
    expect(call.headers, {'Authorization': 'Bearer session-a'});
    expect(call.hasToken, isFalse);
    expect(call.redirectOnUnauthorized, isFalse);
    expect(navigations, 0);

    call.result.complete(_reply(ResponseState.complete, 'Logged out'));
    await logout;
    expect(navigations, 1);
    expect(session.loading, [true, false]);
    expect(session.feedback.single.data['message'], 'Logged out');
    expect(session.token, isNull);
  });

  test('a server failure still logs out locally and reports revocation failure honestly', () async {
    final session = _Session();
    final controller = session.controller();
    addTearDown(controller.dispose);
    await session.loadProfile(controller, 1);
    var navigations = 0;

    final logout = controller.logout(onSuccess: () => navigations++);
    session.logoutRequests.single.result.complete(_reply(ResponseState.offline, 'Network unavailable'));
    await logout;

    expect(session.token, isNull);
    expect(controller.profile, isNull);
    expect(controller.profileResponse.state, ResponseState.sleep);
    expect(navigations, 1);
    expect(session.feedback.single.state, ResponseState.offline);
    expect(session.feedback.single.data['message'], contains('تعذر تأكيد إنهاء الجلسة على الخادم'));
    expect(session.feedback.single.data['message'], contains('Network unavailable'));
    expect(session.loading, [true, false]);
  });

  test('an unexpected logout exception does not preserve the local session', () async {
    final session = _Session();
    final controller = session.controller();
    addTearDown(controller.dispose);
    var navigations = 0;

    final logout = controller.logout(onSuccess: () => navigations++);
    session.logoutRequests.single.result.completeError(StateError('request failed'));
    await logout;

    expect(session.token, isNull);
    expect(navigations, 1);
    expect(session.feedback.single.state, ResponseState.error);
    expect(session.loading, [true, false]);
  });

  test('a profile result after logout cannot restore state or invoke callbacks', () async {
    final session = _Session();
    final controller = session.controller();
    addTearDown(controller.dispose);
    var callbacks = 0;
    final profile = controller.getProfile(onSuccess: () => callbacks++, onHaveIdANDToken: (_, __) => callbacks++);
    final logout = controller.logout(onSuccess: () {});
    var updates = 0;
    controller.addListener(() => updates++);
    session.profileRequests.single.result.complete(_profile(1));
    await profile;

    expect(controller.profile, isNull);
    expect(controller.profileResponse.state, ResponseState.sleep);
    expect(updates, 0);
    expect(callbacks, 0);
    session.logoutRequests.single.result.complete(_reply(ResponseState.complete));
    await logout;
  });

  test('account switching hides cached profile data before another request starts', () async {
    final session = _Session();
    final controller = session.controller();
    addTearDown(controller.dispose);
    await session.loadProfile(controller, 1);
    session.token = 'session-b';

    expect(controller.profile, isNull);
    expect(controller.profileResponse.state, ResponseState.sleep);
    expect(session.profileRequests.length, 1);
  });

  test('a new account profile wins over an earlier request', () async {
    final session = _Session();
    final controller = session.controller();
    addTearDown(controller.dispose);
    var oldCallbacks = 0;
    final old = controller.getProfile(onSuccess: () => oldCallbacks++);
    session.token = 'session-b';
    final fresh = controller.getProfile();
    expect(session.profileRequests.last.headers, {'Authorization': 'Bearer session-b'});
    session.profileRequests.last.result.complete(_profile(2));
    await fresh;
    session.profileRequests.first.result.complete(_profile(1));
    await old;

    expect(controller.profile?.id, 2);
    expect(oldCallbacks, 0);
  });

  testWidgets('a late logout 401 cannot clear a new account or navigate away', (tester) async {
    final previousKey = NamedNavigatorImpl.navigatorState;
    final navigator = _NavigatorSpy();
    NamedNavigatorImpl.navigatorState = _NavigatorKey(navigator);
    addTearDown(() => NamedNavigatorImpl.navigatorState = previousKey);
    final session = _Session();
    final controller = session.controller();
    addTearDown(controller.dispose);
    var navigations = 0;
    final logout = controller.logout(onSuccess: () => navigations++);
    session.token = 'session-b';
    await session.loadProfile(controller, 2);
    final call = session.logoutRequests.single;
    call.result.complete(
      ApiHelper.instance.buildResponseForTesting(
        Response(
          statusCode: 401,
          data: {'message': 'Expired'},
          requestOptions: RequestOptions(path: call.url),
        ),
        redirectOnUnauthorized: call.redirectOnUnauthorized,
      ),
    );
    await logout;
    await tester.pump(const Duration(milliseconds: 1));

    expect(session.token, 'session-b');
    expect(controller.profile?.id, 2);
    expect(session.clears, 1);
    expect(navigations, 0);
    expect(navigator.redirects, 0);
    expect(session.feedback, isEmpty);
  });

  test('a late successful logout does not navigate or close the new account loading state', () async {
    final session = _Session();
    final controller = session.controller();
    addTearDown(controller.dispose);
    var navigations = 0;
    final logout = controller.logout(onSuccess: () => navigations++);
    session.token = 'session-b';
    await session.loadProfile(controller, 2);
    session.logoutRequests.single.result.complete(_reply(ResponseState.complete));
    await logout;

    expect(session.token, 'session-b');
    expect(controller.profile?.id, 2);
    expect(navigations, 0);
    expect(session.loading, [true]);
    expect(session.feedback, isEmpty);
  });

  test('disposing drops late profile updates and callbacks', () async {
    final session = _Session();
    final controller = session.controller();
    var callbacks = 0;
    final profile = controller.getProfile(onSuccess: () => callbacks++);
    controller.dispose();
    session.profileRequests.single.result.complete(_profile(1));
    await profile;
    expect(callbacks, 0);
  });

  testWidgets('a stale profile 401 does not redirect or replace the new account', (tester) async {
    final previousKey = NamedNavigatorImpl.navigatorState;
    final navigator = _NavigatorSpy();
    NamedNavigatorImpl.navigatorState = _NavigatorKey(navigator);
    addTearDown(() => NamedNavigatorImpl.navigatorState = previousKey);
    final session = _Session();
    final controller = session.controller();
    addTearDown(controller.dispose);
    var unauthenticated = 0;
    final old = controller.getProfile(onUnauthenticated: () => unauthenticated++);
    final oldRequest = session.profileRequests.single;
    session.token = 'session-b';
    await session.loadProfile(controller, 2);
    final unauthorized = ApiHelper.instance.buildResponseForTesting(
      Response(
        statusCode: 401,
        data: {'message': 'Expired'},
        requestOptions: RequestOptions(path: oldRequest.url),
      ),
      redirectOnUnauthorized: oldRequest.redirectOnUnauthorized,
    );
    oldRequest.result.complete(unauthorized);
    await old;
    await tester.pump(const Duration(milliseconds: 1));

    expect(oldRequest.hasToken, isFalse);
    expect(oldRequest.redirectOnUnauthorized, isFalse);
    expect(oldRequest.headers, {'Authorization': 'Bearer session-a'});
    expect(navigator.redirects, 0);
    expect(unauthenticated, 0);
    expect(session.token, 'session-b');
    expect(controller.profile?.id, 2);
  });

  testWidgets('a current profile 401 redirects when the caller has no callback', (tester) async {
    final previousKey = NamedNavigatorImpl.navigatorState;
    final navigator = _NavigatorSpy();
    NamedNavigatorImpl.navigatorState = _NavigatorKey(navigator);
    addTearDown(() => NamedNavigatorImpl.navigatorState = previousKey);
    final session = _Session();
    final controller = session.controller();
    addTearDown(controller.dispose);

    final profile = controller.getProfile();
    session.profileRequests.single.result.complete(_reply(ResponseState.unauthorized));
    await profile;
    await tester.pump(const Duration(milliseconds: 1));

    expect(navigator.redirects, 1);
    expect(controller.profileResponse.state, ResponseState.unauthorized);
  });

  testWidgets('a queued profile 401 redirect rechecks the session before navigating', (tester) async {
    final previousKey = NamedNavigatorImpl.navigatorState;
    final navigator = _NavigatorSpy();
    NamedNavigatorImpl.navigatorState = _NavigatorKey(navigator);
    addTearDown(() => NamedNavigatorImpl.navigatorState = previousKey);
    final session = _Session();
    final controller = session.controller();
    addTearDown(controller.dispose);

    final profile = controller.getProfile();
    session.profileRequests.single.result.complete(_reply(ResponseState.unauthorized));
    await profile;
    session.token = 'session-b';
    await tester.pump(const Duration(milliseconds: 1));

    expect(navigator.redirects, 0);
    expect(session.token, 'session-b');
    expect(controller.profileResponse.state, ResponseState.sleep);
  });

  testWidgets('default API 401 navigation is preserved for other callers', (tester) async {
    final previousKey = NamedNavigatorImpl.navigatorState;
    final navigator = _NavigatorSpy();
    NamedNavigatorImpl.navigatorState = _NavigatorKey(navigator);
    addTearDown(() => NamedNavigatorImpl.navigatorState = previousKey);
    final result = ApiHelper.instance.buildResponseForTesting(
      Response(
        statusCode: 401,
        data: {'message': 'Expired'},
        requestOptions: RequestOptions(path: '/profile'),
      ),
    );
    expect(result.state, ResponseState.unauthorized);
    await tester.pump(const Duration(milliseconds: 1));
    expect(navigator.redirects, 1);
  });
}
