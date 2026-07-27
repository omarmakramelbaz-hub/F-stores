import 'dart:io';

import 'package:dio/dio.dart';
import '../../../../../helpers/routes/app_routers_import.dart';
import 'package:flutter/material.dart';

import '../../../../../helpers/networking/api_helper.dart';
import '../../../../../helpers/networking/urls.dart';
import '../../../../../helpers/utils/common_methods.dart';
import '../model/contract_model.dart';

class VendorAndDeliveryController extends ChangeNotifier {
  Future<void> vendorRegister({
    required String fullName,
    required String ownerName,
    required int branchesNo,
    int? nationalId,
    String? commercialRegistrationNo,
    File? nationalIdImage,
    File? commercialRegistrationNoImage,
    String? taxNo,
    File? taxNoImage,
    required String estMobile,
    String? sndMobile,
    String? vodafoneCashMobile,
    required String email,
    required VoidCallback onSuccess,
  }) async {
    NamedNavigatorImpl.loading();
    FormData body = FormData.fromMap({
      'type': 'vendor',
      'full_name': fullName,
      'owner_name': ownerName,
      'branches_no': branchesNo,
      if (nationalId != null) 'national_id': nationalId,
      if (commercialRegistrationNo != null) 'commercial_registration_no': commercialRegistrationNo,
      if (nationalIdImage != null) 'national_id_image': await MultipartFile.fromFile(nationalIdImage.path),
      if (commercialRegistrationNoImage != null)
        'commercial_registration_no_image': await MultipartFile.fromFile(commercialRegistrationNoImage.path),
      if (taxNo != null) 'tax_no': taxNo,
      if (taxNoImage != null) 'tax_no_image': await MultipartFile.fromFile(taxNoImage.path),
      'mobile': estMobile,
      if (sndMobile != null) 'another_mobile': sndMobile,
      if (vodafoneCashMobile != null) 'vodafone_cash_mobile': vodafoneCashMobile,
      'email': email,
    });
    final response = await ApiHelper.instance.post(Urls.vendorSignUp, body: body);
    NamedNavigatorImpl.loadingOff();
    if (response.state == ResponseState.complete) {
      CommonMethods.showToast(message: response.data['message']);

      notifyListeners();
      onSuccess.call();
    } else {
      CommonMethods.showError(message: response.data['message'], apiResponse: response);
    }
  }

  //    ===============>get Contract ==============

  ApiResponse _contractApiResponse = ApiResponse(state: ResponseState.sleep, data: null);
  ApiResponse get contractApiResponse => _contractApiResponse;

  void initialContract() {
    _contractApiResponse = ApiResponse(state: ResponseState.sleep, data: null);
    _contract = null;
    notifyListeners();
  }

  ContractModel? _contract;
  ContractModel? get contract => _contract;
  Future<void> getContract({required String typeContract}) async {
    _contractApiResponse = ApiResponse(state: ResponseState.loading, data: null);
    _contract = null;
    notifyListeners();
    _contractApiResponse = await ApiHelper.instance.get('${Urls.contract}$typeContract');
    notifyListeners();
    if (_contractApiResponse.state == ResponseState.complete) {
      _contract = ContractModel.fromJson(_contractApiResponse.data['data']);

      notifyListeners();
    }
  }
}
