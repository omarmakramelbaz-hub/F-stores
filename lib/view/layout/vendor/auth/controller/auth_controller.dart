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

class AuthController extends ChangeNotifier {
  void initialProfile() {
    _profileResponse = ApiResponse(state: ResponseState.sleep, data: null);
    _profile = null;
  }

  ApiResponse _profileResponse = ApiResponse(state: ResponseState.sleep, data: null);
  ApiResponse get profileResponse => _profileResponse;
  ProfileModel? _profile;
  ProfileModel? get profile => _profile;
  Future<void> getProfile({
    VoidCallback? onSuccess,
    VoidCallback? onUnauthenticated,
    void Function(int id, String token)? onHaveIdANDToken,
  }) async {
    _profileResponse = ApiResponse(state: ResponseState.loading, data: null);

    _profileResponse = await ApiHelper.instance.get(Urls.profile);
    notifyListeners();
    if (_profileResponse.state == ResponseState.complete) {
      _profile = ProfileModel.fromJson(_profileResponse.data['data']);
      if (_profile?.id != null && _profile?.token != null) {
        onHaveIdANDToken?.call(_profile!.id!, _profile!.token!);
      }
      notifyListeners();
      onSuccess?.call();
    }
    if (_profileResponse.state == ResponseState.unauthorized) {
      notifyListeners();
      onUnauthenticated?.call();
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
    NamedNavigatorImpl.loading();
    final response = await ApiHelper.instance.post(Urls.vendorLogout);
    NamedNavigatorImpl.loadingOff();
    if (response.state == ResponseState.complete) {
      CommonMethods.showToast(message: response.data['message']);
      _profile = null;

      HiveMethods.deleteToken();
      notifyListeners();
      onSuccess.call();
    } else {
      onSuccess.call();

      CommonMethods.showError(message: response.data['message'], apiResponse: response);
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
