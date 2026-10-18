import 'package:dio/dio.dart';

import '../../../../../helpers/routes/app_routers_import.dart';

import 'package:flutter/material.dart';

import '../../../../../helpers/hive/hive_methods.dart';
import '../../../../../helpers/networking/api_helper.dart';
import '../../../../../helpers/networking/urls.dart';
import '../../../../../helpers/notification_helper/notification_helper.dart';
import '../../../../../helpers/utils/common_methods.dart';
import '../../my_account/model/areas_model.dart';
import '../model/profile_model.dart';
import '../screen/login_screen.dart';

typedef AuthSessionRequest = Future<ApiResponse> Function(
  String url, {
  required Map<String, String> headers,
  required bool hasToken,
  required bool redirectOnUnauthorized,
});

class AuthController extends ChangeNotifier {
  AuthController({
    AuthSessionRequest? profileRequest,
    AuthSessionRequest? logoutRequest,
    String? Function()? readSession,
    VoidCallback? clearSession,
    void Function(bool loading)? setLogoutLoading,
    void Function(ApiResponse response)? logoutFeedback,
  })  : _profileRequest = profileRequest ?? _requestProfile,
        _logoutRequest = logoutRequest ?? _requestLogout,
        _readSession = readSession ?? HiveMethods.getToken,
        _clearSession = clearSession ?? HiveMethods.deleteToken,
        _setLogoutLoading = setLogoutLoading ?? _defaultLogoutLoading,
        _logoutFeedback = logoutFeedback ?? _defaultLogoutFeedback;

  final AuthSessionRequest _profileRequest;
  final AuthSessionRequest _logoutRequest;
  final String? Function() _readSession;
  final VoidCallback _clearSession;
  final void Function(bool loading) _setLogoutLoading;
  final void Function(ApiResponse response) _logoutFeedback;
  int _profileGeneration = 0;
  int _sessionGeneration = 0;
  int _logoutGeneration = 0;
  bool _authDisposed = false;
  bool _hasProfileSession = false;
  String? _profileSession;

  static Map<String, String> _sessionHeaders(String? token) => {
        if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
      };

  static Future<ApiResponse> _requestProfile(
    String url, {
    required Map<String, String> headers,
    required bool hasToken,
    required bool redirectOnUnauthorized,
  }) =>
      ApiHelper.instance.get(url, headers: headers, hasToken: hasToken, redirectOnUnauthorized: redirectOnUnauthorized);

  static Future<ApiResponse> _requestLogout(
    String url, {
    required Map<String, String> headers,
    required bool hasToken,
    required bool redirectOnUnauthorized,
  }) =>
      ApiHelper.instance.post(
        url,
        headers: headers,
        hasToken: hasToken,
        redirectOnUnauthorized: redirectOnUnauthorized,
      );

  static void _defaultLogoutLoading(bool loading) {
    if (loading) {
      NamedNavigatorImpl.loading();
    } else {
      NamedNavigatorImpl.loadingOff();
    }
  }

  static String _responseMessage(ApiResponse response, String fallback) {
    final data = response.data;
    final message = data is Map ? data['message'] : null;
    return message is String && message.isNotEmpty ? message : fallback;
  }

  static void _defaultLogoutFeedback(ApiResponse response) {
    final message = _responseMessage(response, 'تم تسجيل الخروج');
    if (response.state == ResponseState.complete) {
      CommonMethods.showToast(message: message);
    } else {
      CommonMethods.showError(message: message, apiResponse: response);
    }
  }

  String? _syncProfileSession() {
    final session = _readSession();
    if (!_hasProfileSession || session != _profileSession) {
      _profileSession = session;
      _hasProfileSession = true;
      _sessionGeneration++;
      initialProfile();
    }
    return session;
  }

  bool _acceptProfile(int generation, String? session) {
    if (_authDisposed) return false;
    _syncProfileSession();
    return generation == _profileGeneration && session == _readSession();
  }

  void _redirectUnauthorizedProfile(int generation, String? session) {
    Future<void>.delayed(Duration.zero, () {
      if (!_acceptProfile(generation, session)) return;
      NamedNavigatorImpl.navigatorState.currentState?.pushNamedAndRemoveUntil(LoginScreen.routeName, (route) => false);
    });
  }

  bool _acceptLogout(int generation, int sessionGeneration) {
    if (_authDisposed) return false;
    _syncProfileSession();
    return generation == _logoutGeneration && sessionGeneration == _sessionGeneration && _readSession() == null;
  }

  @override
  void dispose() {
    _authDisposed = true;
    _profileGeneration++;
    _logoutGeneration++;
    super.dispose();
  }

  void initialProfile() {
    _profileGeneration++;
    _profileResponse = ApiResponse(state: ResponseState.sleep, data: null);
    _profile = null;
  }

  ApiResponse _profileResponse = ApiResponse(state: ResponseState.sleep, data: null);
  ApiResponse get profileResponse {
    _syncProfileSession();
    return _profileResponse;
  }

  ProfileModel? _profile;
  ProfileModel? get profile {
    _syncProfileSession();
    return _profile;
  }

  Future<void> getProfile({
    VoidCallback? onSuccess,
    VoidCallback? onUnauthenticated,
    void Function(int id, String token)? onHaveIdANDToken,
  }) async {
    if (_authDisposed) return;
    final session = _syncProfileSession();
    final generation = ++_profileGeneration;
    _profileResponse = ApiResponse(state: ResponseState.loading, data: null);

    ApiResponse response;
    ProfileModel? loadedProfile;
    try {
      response = await _profileRequest(
        Urls.profile,
        headers: _sessionHeaders(session),
        hasToken: false,
        redirectOnUnauthorized: false,
      );
      if (!_acceptProfile(generation, session)) return;
      if (response.state == ResponseState.complete) {
        loadedProfile = ProfileModel.fromJson(response.data['data']);
      }
    } catch (_) {
      if (!_acceptProfile(generation, session)) return;
      response = ApiResponse(state: ResponseState.error, data: {'message': 'تعذر تحميل بيانات الحساب، حاول مرة أخرى'});
    }
    if (!_acceptProfile(generation, session)) return;
    _profileResponse = response;
    if (loadedProfile != null) _profile = loadedProfile;
    notifyListeners();
    if (!_acceptProfile(generation, session)) return;

    if (response.state == ResponseState.complete) {
      if (loadedProfile?.id != null && loadedProfile?.token != null) {
        onHaveIdANDToken?.call(loadedProfile!.id!, loadedProfile.token!);
      }
      if (_acceptProfile(generation, session)) onSuccess?.call();
    } else if (response.state == ResponseState.unauthorized) {
      if (onUnauthenticated != null) {
        onUnauthenticated();
      } else {
        _redirectUnauthorizedProfile(generation, session);
      }
    }
  }

  Future<void> login({
    required String mobile,
    required String password,
    required Function(String accountType) onSuccess,
    void Function(int id, String token)? onHaveIdANDToken,
  }) async {
    NamedNavigatorImpl.loading();

    FormData body = FormData.fromMap({
      'mobile': mobile,
      'fcm_id': FirebaseNotifications.fcmToken ?? '',
      'password': password,
      'account_type': 'vendor',
    });
    final response = await ApiHelper.instance.post(Urls.login, body: body);
    NamedNavigatorImpl.loadingOff();
    if (response.state == ResponseState.complete) {
      HiveMethods.updateToken(response.data['data']['token']);
      if (response.data['data']['id'] != null && response.data['data']['token'] != null) {
        onHaveIdANDToken?.call(response.data['data']['id'], response.data['data']['token']);
      }

      getProfile();
      CommonMethods.showToast(message: response.data['message']);

      onSuccess.call(response.data['data']['account_type']);
      HiveMethods.setIsFreeDelivery(response.data['data']['km_price'] == 0);
      notifyListeners();
    } else {
      CommonMethods.showError(message: response.data['message'], apiResponse: response);
    }
  }

  Future<void> logout({required VoidCallback onSuccess}) async {
    if (_authDisposed) return;
    final token = _syncProfileSession();
    final generation = ++_logoutGeneration;
    // Revoke the captured session on the server, even after Hive is cleared.
    _clearSession();
    initialProfile();
    _syncProfileSession();
    final sessionGeneration = _sessionGeneration;
    notifyListeners();

    _setLogoutLoading(true);
    ApiResponse response;
    try {
      response = await _logoutRequest(
        Urls.vendorLogout,
        headers: _sessionHeaders(token),
        hasToken: false,
        redirectOnUnauthorized: false,
      );
    } catch (_) {
      response = ApiResponse(state: ResponseState.error, data: null);
    } finally {
      if (_acceptLogout(generation, sessionGeneration)) _setLogoutLoading(false);
    }
    if (!_acceptLogout(generation, sessionGeneration)) return;

    if (response.state == ResponseState.complete) {
      _logoutFeedback(response);
      if (_acceptLogout(generation, sessionGeneration)) onSuccess();
    } else {
      final reason = _responseMessage(response, '');
      final failure = ApiResponse(
        state: response.state,
        data: {
          'message':
              'تم تسجيل الخروج من هذا الجهاز، لكن تعذر تأكيد إنهاء الجلسة على الخادم.${reason.isEmpty ? '' : ' $reason'}',
        },
      );
      onSuccess();
      if (_acceptLogout(generation, sessionGeneration)) _logoutFeedback(failure);
    }
  }

  void initialAreas() {
    _areasResponse = ApiResponse(state: ResponseState.sleep, data: null);
    _areas = [];
    notifyListeners();
  }

  ApiResponse _areasResponse = ApiResponse(state: ResponseState.sleep, data: null);
  ApiResponse get areasResponse => _areasResponse;

  List<AreasModel> _areas = [];
  List<AreasModel> get areas => _areas;

  Future<void> getAreas() async {
    _areasResponse = ApiResponse(state: ResponseState.loading, data: null);
    _areas = [];
    notifyListeners();
    _areasResponse = await ApiHelper.instance.get(Urls.areas);
    notifyListeners();

    if (_areasResponse.state == ResponseState.complete) {
      Iterable iterable = _areasResponse.data['data'];
      _areas = iterable.map((e) => AreasModel.fromJson(e)).toList();
      notifyListeners();
    }
  }

  Future<void> updateVendorLocation({
    required int resturantId,
    required num lat,
    required num lng,
    required String countryName,
    required String cityName,
    required String address,
    required VoidCallback onSuccess,
  }) async {
    NamedNavigatorImpl.loading();

    FormData body = FormData.fromMap({
      'lat': lat,
      'lng': lng,
      'country_name': countryName,
      'city_name': cityName,
      'address': address,
    });
    final response = await ApiHelper.instance.post(
      '${Urls.updateVendorLocation}$resturantId/resturant-location',
      body: body,
    );
    NamedNavigatorImpl.loadingOff();
    if (response.state == ResponseState.complete) {
      CommonMethods.showToast(message: response.data['message']);
      onSuccess.call();
      notifyListeners();
    } else {
      CommonMethods.showError(message: response.data['message'], apiResponse: response);
    }
  }

  Future<void> updateDelegateLocation({required num lat, required num lng, required VoidCallback onSuccess}) async {
    NamedNavigatorImpl.loading();

    FormData body = FormData.fromMap({'lat': lat, 'lng': lng});
    final response = await ApiHelper.instance.post(Urls.updatePosition, body: body);
    NamedNavigatorImpl.loadingOff();
    if (response.state == ResponseState.complete) {
      CommonMethods.showToast(message: response.data['message']);
      onSuccess.call();
      notifyListeners();
    } else {
      CommonMethods.showError(message: response.data['message'], apiResponse: response);
    }
  }

  Future<void> deleteAccount({required String mobileCode, required VoidCallback onSuccess}) async {
    NamedNavigatorImpl.loading();
    FormData body = FormData.fromMap({'password': mobileCode});
    final response = await ApiHelper.instance.post(Urls.deleteAccount, body: body);
    NamedNavigatorImpl.loadingOff();
    if (response.state == ResponseState.complete) {
      CommonMethods.showToast(message: response.data['message']);
      onSuccess.call();
    } else {
      CommonMethods.showError(message: response.data['message'], apiResponse: response);
    }
  }
}
