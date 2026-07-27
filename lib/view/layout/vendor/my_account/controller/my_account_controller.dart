import 'dart:io';

import 'package:dio/dio.dart';
import '../../../../../helpers/routes/app_routers_import.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../helpers/networking/api_helper.dart';
import '../../../../../helpers/networking/urls.dart';
import '../../../../../helpers/utils/common_methods.dart';
import '../model/help_model.dart';
import '../model/reports_model.dart';
import '../model/setting_model.dart';

class MyAccountController extends ChangeNotifier {
  //            Help               //
  void initialHelp() {
    _helpResponse = ApiResponse(state: ResponseState.sleep, data: null);
    _help = [];
    notifyListeners();
  }

  ApiResponse _helpResponse = ApiResponse(state: ResponseState.sleep, data: null);
  ApiResponse get helpResponse => _helpResponse;
  List<HelpModel> _help = [];
  List<HelpModel> get help => _help;

  Future<void> getHelp() async {
    _helpResponse = ApiResponse(state: ResponseState.loading, data: null);
    _help = [];
    notifyListeners();
    _helpResponse = await ApiHelper.instance.get(Urls.vendorHelp);
    notifyListeners();
    if (_helpResponse.state == ResponseState.complete) {
      Iterable iterable = _helpResponse.data['data'];
      _help = iterable.map((e) => HelpModel.fromJson(e)).toList();
      notifyListeners();
    }
  }

  //                 Setting               //
  void initialSetting() {
    _settingResponse = ApiResponse(state: ResponseState.sleep, data: null);
    _setting = null;
    notifyListeners();
  }

  ApiResponse _settingResponse = ApiResponse(state: ResponseState.sleep, data: null);
  ApiResponse get settingResponse => _settingResponse;
  SettingModel? _setting;
  SettingModel? get setting => _setting;

  Future<void> getSetting() async {
    _settingResponse = ApiResponse(state: ResponseState.loading, data: null);
    _setting = null;
    notifyListeners();
    _settingResponse = await ApiHelper.instance.get(Urls.vendorSetting);
    notifyListeners();
    if (_settingResponse.state == ResponseState.complete) {
      _setting = SettingModel.fromJson(_settingResponse.data['data']);
      notifyListeners();
    }
  }

  Future<void> storeContact({
    required String name,
    required String email,
    required String message,
    required VoidCallback onSuccess,
  }) async {
    NamedNavigatorImpl.loading();
    FormData body = FormData.fromMap({'name': name, 'email': email, 'message': message});
    final response = await ApiHelper.instance.post(Urls.vendorStoreContact, body: body);
    NamedNavigatorImpl.loadingOff();
    if (response.state == ResponseState.complete) {
      CommonMethods.showToast(message: response.data['message']);
      onSuccess.call();
    } else {
      CommonMethods.showError(message: response.data['message'], apiResponse: response);
    }
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String passwordConfirmation,
    required VoidCallback onSuccess,
  }) async {
    NamedNavigatorImpl.loading();
    FormData body = FormData.fromMap({
      'current_password': currentPassword,
      'password': newPassword,
      'password_confirmation': passwordConfirmation,
    });
    final response = await ApiHelper.instance.post(Urls.vendorChangePassword, body: body);
    NamedNavigatorImpl.loadingOff();
    if (response.state == ResponseState.complete) {
      CommonMethods.showToast(message: response.data['message']);
      onSuccess.call();
    } else {
      CommonMethods.showError(message: response.data['message'], apiResponse: response);
    }
  }
  //======================================= reports ============================

  void initialReports() {
    _reportsResponse = ApiResponse(state: ResponseState.sleep, data: null);
    _reports = null;
    notifyListeners();
  }

  ApiResponse _reportsResponse = ApiResponse(state: ResponseState.sleep, data: null);
  ApiResponse get reportsResponse => _reportsResponse;

  ReportsModel? _reports;
  ReportsModel? get reports => _reports;
  Future<void> getReports({required String reportType}) async {
    _reportsResponse = ApiResponse(state: ResponseState.loading, data: null);
    notifyListeners();
    _reportsResponse = await ApiHelper.instance.get(Urls.reports, queryParameters: {'report_type': reportType});
    notifyListeners();
    if (_reportsResponse.state == ResponseState.complete) {
      _reports = ReportsModel.fromJson(_reportsResponse.data['data']);
      notifyListeners();
    }
  }

  // ========================== update profile info ==============================

  Future<void> updateVendorProfileInfo({
    required String name,
    File? restaurantLogo,
    File? restaurantCover,
    required String restaurantName,
    required String email,
    required String restaurantPhone,
    DateTime? openAt,
    DateTime? closeAt,
    required num minOrderPrice,
    required int restaurantAreaId,
    required VoidCallback onSuccess,
  }) async {
    NamedNavigatorImpl.loading();
    String formattedOpenAt = DateFormat('HH:mm:ss').format(openAt ?? DateTime.now());
    String formattedCloseAt = DateFormat('HH:mm:ss').format(closeAt ?? DateTime.now());
    FormData body = FormData.fromMap({
      'name': name,
      if (restaurantLogo != null) 'logo': await MultipartFile.fromFile(restaurantLogo.path),
      if (restaurantCover != null) 'bg_image': await MultipartFile.fromFile(restaurantCover.path),
      'resturant_name': restaurantName,
      'resturant_area_id': restaurantAreaId,
      'email': email,
      'resturant_phone': restaurantPhone,
      if (openAt != null) 'open_at': formattedOpenAt,
      if (closeAt != null) 'close_at': formattedCloseAt,
      'min_order_price': minOrderPrice,
    });
    final response = await ApiHelper.instance.post(Urls.updateVendorProfile, body: body);
    NamedNavigatorImpl.loadingOff();
    if (response.state == ResponseState.complete) {
      CommonMethods.showToast(message: response.data['message']);

      onSuccess.call();
      notifyListeners();
    } else {
      CommonMethods.showError(message: response.data['message'], apiResponse: response);
    }
  }

  /// update deleverytime
  ///
  Future<void> updateDeliveryTime({
    required String deliveryTime,
    required int restaurantId,
    required VoidCallback onSuccess,
  }) async {
    NamedNavigatorImpl.loading();
    FormData body = FormData.fromMap({'delivery_time': deliveryTime});
    final response = await ApiHelper.instance.post('${Urls.updateDeliveryTime}$restaurantId/update', body: body);
    NamedNavigatorImpl.loadingOff();
    if (response.state == ResponseState.complete) {
      CommonMethods.showToast(message: response.data['message']);

      onSuccess.call();
      notifyListeners();
    } else {
      CommonMethods.showError(message: response.data['message'], apiResponse: response);
    }
  }

  Future<void> changePhoneNumber({
    required String phoneNumber,
    required String password,
    required VoidCallback onSuccess,
  }) async {
    NamedNavigatorImpl.loading();

    FormData body = FormData.fromMap({'mobile': phoneNumber, 'current_password': password});
    final response = await ApiHelper.instance.post(Urls.changePhoneNumber, body: body);
    NamedNavigatorImpl.loadingOff();
    if (response.state == ResponseState.complete) {
      CommonMethods.showToast(message: response.data['message']);
      onSuccess.call();
    } else {
      CommonMethods.showError(message: response.data['message'], apiResponse: response);
    }
  }
}
