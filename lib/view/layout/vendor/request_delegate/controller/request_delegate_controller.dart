import 'dart:developer' as dev;
import 'dart:math';

import 'package:dio/dio.dart';
import '../../../../../helpers/routes/app_routers_import.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../../helpers/networking/api_helper.dart';
import '../../../../../helpers/networking/urls.dart';
import '../../../../../helpers/utils/common_methods.dart';
import '../model/accepted_delegate_model.dart';
import '../model/delegate_on_map_model.dart';
import '../model/request_delegate_order_model.dart';

class RequestDelegateController extends ChangeNotifier {
  String _selectedPayment = 'cash';
  String get selectedPayment => _selectedPayment;
  void setSelectedPayment(String value) {
    _selectedPayment = value;
    notifyListeners();
  }

  final TextEditingController _priceEC = TextEditingController();
  TextEditingController get priceEC => _priceEC;
  void setPriceEC(String value) {
    _priceEC.text = value;
    notifyListeners();
  }

  final TextEditingController _fromController = TextEditingController();
  TextEditingController get fromController => _fromController;
  void setFromController(String value) {
    _fromController.text = value;
    notifyListeners();
  }

  final TextEditingController _toController = TextEditingController();
  TextEditingController get toController => _toController;
  void setToController(String value) {
    _toController.text = value;
    notifyListeners();
  }

  final TextEditingController _descriptionEC = TextEditingController();
  TextEditingController get descriptionEC => _descriptionEC;
  void setDescriptionEC(String value) {
    _descriptionEC.text = value;
    notifyListeners();
  }

  int? _orderId;
  int? get orderId => _orderId;
  void setOrderId(int value) {
    _orderId = value;
    notifyListeners();
  }

  String _fee = 'cash';
  String get fee => _fee;
  void setFee(String value) {
    _fee = value;
    notifyListeners();
  }

  String _fromAddress = '';
  String get fromAddress => _fromAddress;
  void setFromAddress(String value) {
    _fromAddress = value;
    notifyListeners();
  }

  String _toAddress = '';
  String get toAddress => _toAddress;
  void setToAddress(String value) {
    _toAddress = value;
    notifyListeners();
  }

  String? _fromLat;
  String? get fromLat => _fromLat;
  void setFromLat(String value) {
    _fromLat = value;
    notifyListeners();
  }

  String? _fromLan;
  String? get fromLan => _fromLan;
  void setFromLan(String value) {
    _fromLan = value;
    notifyListeners();
  }

  String? _toLat;
  String? get toLat => _toLat;
  void setToLat(String value) {
    _toLat = value;
    notifyListeners();
  }

  String? _toLan;
  String? get toLan => _toLan;
  void setToLan(String value) {
    _toLan = value;
    notifyListeners();
  }

  String? _actualPrice;
  String? get actualPrice => _actualPrice;
  void setActualPrice(String value) {
    _actualPrice = value;
    notifyListeners();
  }

  double? _deliveryTime;
  double? get deliveryTime => _deliveryTime;
  void setDeliveryTime(double value) {
    _deliveryTime = value;
    notifyListeners();
  }

  double? _distance;
  double? get distance => _distance;
  void setDistance(double value) {
    _distance = value;
    notifyListeners();
  }

  LatLng? _fromLatLng;
  LatLng? get fromLatLng => _fromLatLng;
  void setFromLatLng(LatLng value) {
    _fromLatLng = value;
    notifyListeners();
  }

  LatLng? _toLatLng;
  LatLng? get toLatLng => _toLatLng;
  void setToLatLng(LatLng value) {
    _toLatLng = value;
    notifyListeners();
  }

  @override
  void dispose() {
    priceEC.dispose();
    super.dispose();
  }

  //============================================== calculate distance ================================

  double calculateDeliveryPrice({required num kmPrice}) {
    if (_fromLat == null || _fromLan == null || _toLat == null || _toLan == null) {
      return 0.0;
    }

    final double fromLat = double.parse(_fromLat!);
    final double fromLan = double.parse(_fromLan!);
    final double toLat = double.parse(_toLat!);
    final double toLan = double.parse(_toLan!);

    const double earthRadiusKm = 6371.0;

    final double dLat = _degreesToRadians(toLat - fromLat);
    final double dLon = _degreesToRadians(toLan - fromLan);

    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(fromLat)) * cos(_degreesToRadians(toLat)) * sin(dLon / 2) * sin(dLon / 2);

    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    if (priceEC.text.isEmpty) {
      setPriceEC((c * earthRadiusKm * kmPrice).toStringAsFixed(0));
    }
    setDistance(double.parse((c * earthRadiusKm * kmPrice).toStringAsFixed(0)));

    return earthRadiusKm * c * kmPrice;
  }

  double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  //=======================================
  double calculateDistance({required num kmPrice}) {
    if (_fromLat == null || _fromLan == null || _toLat == null || _toLan == null) {
      return 0.0;
    }

    final double fromLat = double.parse(_fromLat!);
    final double fromLan = double.parse(_fromLan!);
    final double toLat = double.parse(_toLat!);
    final double toLan = double.parse(_toLan!);

    const double earthRadiusKm = 6371.0;

    final double dLat = _degreesToRadians(toLat - fromLat);
    final double dLon = _degreesToRadians(toLan - fromLan);

    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(fromLat)) * cos(_degreesToRadians(toLat)) * sin(dLon / 2) * sin(dLon / 2);

    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    if (priceEC.text.isEmpty) {
      setPriceEC((c * earthRadiusKm * kmPrice).toStringAsFixed(0));
    }

    setPriceEC((c * earthRadiusKm * kmPrice).toStringAsFixed(0));

    return earthRadiusKm * c;
  }

  double calculateMinimumPrice({required num kmPrice, required num percentage}) {
    final double distance = calculateDistance(kmPrice: kmPrice);
    final double minAmount = distance - (distance * (percentage / 100));
    return minAmount;
  }

  //========================================== calculate Dlivery Time =================================

  double calculateDeliveryTime({required num kmTime}) {
    if (_fromLat == null || _fromLan == null || _toLat == null || _toLan == null) {
      return 0.0;
    }

    final double fromLat = double.parse(_fromLat!);
    final double fromLan = double.parse(_fromLan!);
    final double toLat = double.parse(_toLat!);
    final double toLan = double.parse(_toLan!);

    const double earthRadiusKm = 6371.0;

    final double dLat = _degreesToRadians(toLat - fromLat);
    final double dLon = _degreesToRadians(toLan - fromLan);

    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(fromLat)) * cos(_degreesToRadians(toLat)) * sin(dLon / 2) * sin(dLon / 2);

    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    setPriceEC((c * earthRadiusKm * kmTime).toStringAsFixed(0));

    return earthRadiusKm * c * kmTime;
  }

  bool isDataValid() {
    return _selectedPayment.isNotEmpty &&
        _priceEC.text.isNotEmpty &&
        _descriptionEC.text.isNotEmpty &&
        _fromAddress.isNotEmpty &&
        _toAddress.isNotEmpty &&
        _fromLat != null &&
        _fromLan != null &&
        _toLat != null &&
        _toLan != null;
  }

  void reset() {
    _selectedPayment = 'cash';
    _priceEC.clear();
    // _fromController.clear();
    _toController.clear();
    _descriptionEC.clear();
    _distance = 0.0;
    _fee = 'cash';
    _fromAddress = '';
    _toAddress = '';
    // _fromLat = null;
    // _fromLan = null;
    _toLat = null;
    _toLan = null;
    _actualPrice = null;
    _deliveryTime = null;
    // _fromLatLng = null;
    _toLatLng = null;

    notifyListeners();
  }

  //================================================== get all delegate orders =========================

  void updateShippingOrder(RequestDelegateOrderModel updatedOrder) {
    // Find the index of the order with the matching ID
    final index = _delegateOrders.indexWhere((order) => order.id == updatedOrder.id);

    if (index != -1) {
      // Update the existing order
      _delegateOrders[index] = updatedOrder;
    } else {
      // If the order doesn't exist, add it to the list
      _delegateOrders.add(updatedOrder);
    }

    // Notify listeners to update the UI
    notifyListeners();
  }

  ApiResponse _delegateOrdersApiResponse = ApiResponse(state: ResponseState.sleep, data: null);
  ApiResponse get delegateOrdersApiResponse => _delegateOrdersApiResponse;

  void initialDelegateOrders() {
    _delegateOrdersApiResponse = ApiResponse(state: ResponseState.sleep, data: null);
    _delegateOrders = [];
    notifyListeners();
  }

  List<RequestDelegateOrderModel> _delegateOrders = [];
  List<RequestDelegateOrderModel> get delegateOrders => _delegateOrders;
  Future<void> getDelegateOrders() async {
    _delegateOrdersApiResponse = ApiResponse(state: ResponseState.loading, data: null);
    notifyListeners();
    _delegateOrdersApiResponse = await ApiHelper.instance.get(Urls.delegateOrders);
    notifyListeners();
    if (_delegateOrdersApiResponse.state == ResponseState.complete) {
      Iterable iterable = _delegateOrdersApiResponse.data['data'];
      _delegateOrders = iterable.map((e) => RequestDelegateOrderModel.fromJson(e)).toList();
      notifyListeners();
    }
  }

  //================================= get single order ===================================
  ApiResponse _delegateOrderDetailsApiResponse = ApiResponse(state: ResponseState.sleep, data: null);
  ApiResponse get delegateOrderDetailsApiResponse => _delegateOrderDetailsApiResponse;

  void initialDelegateOrderDetails() {
    _delegateOrderDetailsApiResponse = ApiResponse(state: ResponseState.sleep, data: null);
    _delegateOrderDetails = null;
    notifyListeners();
  }

  RequestDelegateOrderModel? _delegateOrderDetails;
  RequestDelegateOrderModel? get delegateOrderDetails => _delegateOrderDetails;
  Future<void> getDelegateOrderDetails({required int id}) async {
    _delegateOrderDetailsApiResponse = ApiResponse(state: ResponseState.loading, data: null);
    notifyListeners();
    _delegateOrderDetailsApiResponse = await ApiHelper.instance.get('${Urls.delegateShippingOrderDetails}/$id');
    notifyListeners();
    if (_delegateOrderDetailsApiResponse.state == ResponseState.complete) {
      _delegateOrderDetails = RequestDelegateOrderModel.fromJson(_delegateOrderDetailsApiResponse.data['data']);
      notifyListeners();
    }
  }
  //=================================== get delegates on Map ==============================

  ApiResponse _delegateOnMapApiResponse = ApiResponse(state: ResponseState.sleep, data: null);
  ApiResponse get delegateOnMapApiResponse => _delegateOnMapApiResponse;

  void initialDelegatesOnMap() {
    _delegateOnMapApiResponse = ApiResponse(state: ResponseState.sleep, data: null);
    _delegatesOnMap = null;
    notifyListeners();
  }

  DelegateOnMapModel? _delegatesOnMap;
  DelegateOnMapModel? get delegatesOnMap => _delegatesOnMap;
  Future<void> getDelegatesOnMap({required String lat, required String lan}) async {
    _delegateOnMapApiResponse = ApiResponse(state: ResponseState.loading, data: null);
    notifyListeners();

    // Fetch the API response
    _delegateOnMapApiResponse = await ApiHelper.instance.get(
      Urls.delegateOnMap,
      queryParameters: {'lat': lat, 'lng': lan},
    );
    notifyListeners();

    if (_delegateOnMapApiResponse.state == ResponseState.complete) {
      _delegatesOnMap = DelegateOnMapModel.fromJson(_delegateOnMapApiResponse.data['data']);
      notifyListeners();
    }
  }

  //=============================== create new Shipping order ===============================

  Future<void> createNewShippingOrder({
    required String fromLat,
    required String fromLng,
    required String fromAddress,
    required String toLat,
    required String toLng,
    required String toAddress,
    required String description,
    required String actualPrice,
    required String expectedPrice,
    required String paymentType,
    required Function() onSuccess,
    required Function(String url) onHadeLink,
  }) async {
    NamedNavigatorImpl.loading();
    FormData body = FormData.fromMap({
      'from_lat': fromLat,
      'from_lng': fromLng,
      'from_address': fromAddress,
      'to_lat': toLat,
      'to_lng': toLng,
      'to_address': toAddress,
      'description': description,
      'actual_price': actualPrice,
      'expected_price': expectedPrice,
      'payment_type': paymentType,
    });
    final response = await ApiHelper.instance.post(Urls.createNewShipping, body: body);
    NamedNavigatorImpl.loadingOff();
    if (response.state == ResponseState.complete) {
      CommonMethods.showToast(message: response.data['message']);
      if (response.data['data']['id'] != null) {
        setOrderId(response.data['data']['id']);
        log(response.data['data']['id']);
      }
      if (paymentType == 'cash') {
        setOrderId(response.data['data']['id']);
        onSuccess.call();
      } else if (paymentType == 'wallet') {
        setOrderId(response.data['data']['id']);
        onSuccess.call();
      } else if (paymentType == 'online') {
        setOrderId(response.data['data']['order_id']);
        onHadeLink.call(response.data['data']['link']);
      } else if (paymentType == 'v_cash') {
        setOrderId(response.data['data']['order_id']);
        onHadeLink.call(response.data['data']['link']);
      }
    } else {
      CommonMethods.showError(message: response.data['message'], apiResponse: response);
    }
  }

  //=========================
  // AcceptedDelegateModel? _localDelegates;

  // bool get hasNewDelegates {
  //   if (_localDelegates == null) {
  //     return true; // First time, always update
  //   }
  //   return _localDelegates != acceptedDelegate;
  // }

  //======================================= get accepted delegates ============================

  void addAcceptedDelegateToTop(Delegates delegate) {
    _acceptedDelegate!.delegates!.insert(0, delegate);
    dev.log('acceptedDelegate========================> ${_acceptedDelegate!.delegates!.length}');
    notifyListeners();
  }

  ApiResponse _acceptedDelegateApiResponse = ApiResponse(state: ResponseState.sleep, data: null);
  ApiResponse get acceptedDelegateApiResponse => _acceptedDelegateApiResponse;

  void initialAcceptedDelegate() {
    _acceptedDelegateApiResponse = ApiResponse(state: ResponseState.sleep, data: null);
    _acceptedDelegate = null;
    notifyListeners();
  }

  AcceptedDelegateModel? _acceptedDelegate;
  AcceptedDelegateModel? get acceptedDelegate => _acceptedDelegate;

  Future<void> getAcceptedDelegate({int? delegateOrderId}) async {
    _acceptedDelegateApiResponse = ApiResponse(state: ResponseState.loading, data: null);
    notifyListeners();

    final response = await ApiHelper.instance.get(Urls.getAcceptedDelegates(delegateOrderId ?? orderId ?? 0));

    _acceptedDelegateApiResponse = response;

    if (response.state == ResponseState.complete) {
      _acceptedDelegate = AcceptedDelegateModel.fromJson(response.data['data']);
    }
    notifyListeners();
  }

  //=======================================  accepted  || declined delegates ============================
  Future<void> acceptedOrDeclinedDelegate({
    required int orderId,
    required int delegateId,
    required String status,
    required VoidCallback onSuccess,
  }) async {
    NamedNavigatorImpl.loading();
    FormData body = FormData.fromMap({'order_id': orderId, 'delegate_id': delegateId, 'status': status});
    final response = await ApiHelper.instance.post(Urls.acceptOrDeclinedDelegate, body: body);
    NamedNavigatorImpl.loadingOff();
    if (response.state == ResponseState.complete) {
      CommonMethods.showToast(message: response.data['message']);

      onSuccess.call();
    } else {
      CommonMethods.showError(message: response.data['message'], apiResponse: response);
    }
  }
  //===============================================
  //====================================== calculate distance in meters ================================

  double calculateDistanceInMeters({required String toDLat, required String toDLng}) {
    if (_fromLat == null || _fromLan == null) {
      return 0.0;
    }

    final double fromLat = double.parse(_fromLat!);
    final double fromLan = double.parse(_fromLan!);
    final double toLat = double.parse(toDLat);
    final double toLan = double.parse(toDLng);

    const double earthRadiusKm = 6371.0;

    final double dLat = _degreesToRadians(toLat - fromLat);
    final double dLon = _degreesToRadians(toLan - fromLan);

    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(fromLat)) * cos(_degreesToRadians(toLat)) * sin(dLon / 2) * sin(dLon / 2);

    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    // Distance in kilometers
    final double distanceKm = earthRadiusKm * c;

    // Convert to meters
    final double distanceMeters = distanceKm * 1000;

    // Update the distance state
    setDistance(distanceMeters);

    return distanceMeters;
  }

  //======================================= calculate expected delivery time ==============================

  double calculateExpectedDeliveryTime({
    required double averageSpeedKmPerHour,
    required String toDLat,
    required String toDLng,
  }) {
    if (_fromLat == null || _fromLan == null) {
      return 0.0;
    }

    // Calculate distance in kilometers
    final double distanceKm = calculateDistanceInMeters(toDLat: toDLat, toDLng: toDLng) / 1000.0;

    // Calculate time in hours
    final double timeInHours = distanceKm / averageSpeedKmPerHour;

    // Convert to minutes
    final double timeInMinutes = timeInHours * 60;

    // Update the delivery time state
    setDeliveryTime(timeInMinutes);

    return timeInMinutes;
  }

  //====================================== rise actual price ============================
  Future<void> riseActualPrice({required int newPrice, required VoidCallback onSuccess}) async {
    NamedNavigatorImpl.loading();
    FormData body = FormData.fromMap({'new_price': newPrice, 'order_id': orderId});
    final response = await ApiHelper.instance.post(Urls.riseActualPrice, body: body);
    NamedNavigatorImpl.loadingOff();
    if (response.state == ResponseState.complete) {
      CommonMethods.showToast(message: response.data['message']);

      onSuccess.call();
    } else {
      CommonMethods.showError(message: response.data['message'], apiResponse: response);
    }
  }

  Future<void> cancelOrder({required int orderId, required VoidCallback onSuccess}) async {
    NamedNavigatorImpl.loading();

    final response = await ApiHelper.instance.post('${Urls.cancelOrder}/$orderId');
    NamedNavigatorImpl.loadingOff();
    if (response.state == ResponseState.complete) {
      CommonMethods.showToast(message: response.data['message']);
      onSuccess.call();
    } else {
      CommonMethods.showError(message: response.data['message'], apiResponse: response);
    }
  }

  ////////////////////////////////////////////////
  double calculateExpectedPrice({
    required double kmRate,
    required double distanceInKm,
    double discountPercentage = 0.0,
  }) {
    // Calculate base price based on distance and rate per kilometer
    double basePrice = distanceInKm * kmRate;

    // Apply any discount
    double discount = basePrice * (discountPercentage / 100);
    double expectedPrice = basePrice - discount;

    // Optionally set the `expectedPrice` field to keep track
    setActualPrice(expectedPrice.toStringAsFixed(2));

    // Return the calculated expected price
    return expectedPrice;
  }
}
