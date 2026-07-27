import 'dart:developer';

import 'package:dio/dio.dart';
import '../../../../../helpers/routes/app_routers_import.dart';
import 'package:flutter/material.dart';

import '../../../../../helpers/networking/api_helper.dart';
import '../../../../../helpers/networking/urls.dart';
import '../../../../../helpers/utils/common_methods.dart';
import '../model/vendor_orders_model.dart';
import '../model/vendor_pagination_model.dart';

class OrderController extends ChangeNotifier {
  //======================================= pusher ===============================
  void addPendingHomeOrderToTop(VendorOrdersModel vendorOrdersModel) {
    // Check if the order already exists in the list
    final exists = _pendingVendorOrders.any((order) => order.id == vendorOrdersModel.id);

    if (!exists) {
      updateTotalPendingHome((pendingOrders?.meta?.total ?? 0) + 1);
      _pendingVendorOrders.insert(0, vendorOrdersModel);
      // Update the total count (if required)
      pendingOrders?.meta?.total = (pendingOrders?.meta?.total ?? 0) + 1;
      notifyListeners(); // Notify listeners to update the UI
    } else if (vendorOrdersModel.status == 'cancelled' || vendorOrdersModel.status == 'declined') {
      _pendingVendorOrders.removeWhere((e) => e.id == vendorOrdersModel.id);
      totalPendingHome--;
      notifyListeners();
    } else {
      log('Order with ID ${vendorOrdersModel.id} already exists.');
    }
  }

  int totalPendingHome = 0;

  void updateTotalPendingHome(int value) {
    totalPendingHome = value;
    notifyListeners(); // Notify the UI to rebuild
  }

  //==============================================================================
  void addWaitingOrderToTop(VendorOrdersModel vendorOrdersModel) {
    // Check if the order already exists in the list
    final exists = _vendorWaitingOrders.any((order) => order.id == vendorOrdersModel.id);

    if (!exists) {
      updateTotalPending((waitingOrders?.meta?.total ?? 0) + 1);
      _vendorWaitingOrders.insert(0, vendorOrdersModel);
      // Update the total count (if required)
      waitingOrders?.meta?.total = (waitingOrders?.meta?.total ?? 0) + 1;
      notifyListeners(); // Notify listeners to update the UI
    } else {
      log('Order with ID ${vendorOrdersModel.id} already exists.');
    }
  }

  int totalPending = 0;

  void updateTotalPending(int value) {
    totalPending = value;
    notifyListeners(); // Notify the UI to rebuild
  }

  //==========================================================
  void initialVendorWaitingOrders() {
    _vendorWaitingOrdersResponse = ApiResponse(state: ResponseState.sleep, data: null);
    _vendorWaitingOrders = [];
    _waitingOrders = null;
    _waitingOrderPage = 1;
    _waitingOrdersHasPagination = true;
    _waitingIsPaginating = false;
    notifyListeners();
  }

  ApiResponse _vendorWaitingOrdersResponse = ApiResponse(state: ResponseState.sleep, data: null);
  ApiResponse get vendorWaitingOrdersResponse => _vendorWaitingOrdersResponse;

  List<VendorOrdersModel> _vendorWaitingOrders = [];
  List<VendorOrdersModel> get vendorWaitingOrders => _vendorWaitingOrders;
  VendorModel? _waitingOrders;
  VendorModel? get waitingOrders => _waitingOrders;

  int _waitingOrderPage = 1;
  int get waitingOrderPage => _waitingOrderPage;

  set waitingOrderPage(int value) {
    _waitingOrderPage = value;
    notifyListeners();
  }

  bool _waitingOrdersHasPagination = true;
  bool get waitingOrdersHasPagination => _waitingOrdersHasPagination;
  bool _waitingIsPaginating = false;
  bool get waitingIsPaginating => _waitingIsPaginating;

  Future<void> getVendorWaitingOrders({int? pageNumber, int? orderNo}) async {
    if (_waitingOrderPage == 1) {
      _vendorWaitingOrdersResponse = ApiResponse(state: ResponseState.loading, data: null);
      _vendorWaitingOrders = [];
      _waitingOrders = null;
      notifyListeners();
    } else {
      _waitingIsPaginating = true;
      notifyListeners();
    }
    _vendorWaitingOrdersResponse = await ApiHelper.instance.get(
      Urls.waitingOrders,
      queryParameters: {'page': pageNumber ?? _waitingOrderPage, if (orderNo != null) 'order_no': orderNo},
    );
    notifyListeners();

    if (_vendorWaitingOrdersResponse.state == ResponseState.complete) {
      Iterable iterable = _vendorWaitingOrdersResponse.data['data']['data'];
      totalPending = _vendorWaitingOrdersResponse.data['data']['meta']['total'];
      if (_waitingOrderPage == _vendorWaitingOrdersResponse.data['data']['meta']['last_page']) {
        _waitingOrdersHasPagination = false;
        // CommonMethods.showToast(message: "No more orders");
        notifyListeners();
      } else {
        _waitingOrderPage++;
        _waitingOrdersHasPagination = true;
        notifyListeners();
      }
      _vendorWaitingOrders.addAll(iterable.map((e) => VendorOrdersModel.fromJson(e)).toList());
      _waitingOrders = VendorModel.fromJson(_vendorWaitingOrdersResponse.data['data']);
      //notifyListeners();

      // _vendorwaitingOrders =
      //     iterable.map((e) => VendorOrdersModel.fromJson(e)).toList();
      notifyListeners();
    }

    _waitingIsPaginating = false;
    notifyListeners();
  }

  //==========================================================================================
  void initialVendorOngoingOrders() {
    _vendorOngoingOrdersResponse = ApiResponse(state: ResponseState.sleep, data: null);
    _vendorOngoingOrders = [];
    _ongoingOrders = null;
    _ongoingOrderPage = 1;
    _onGoingOrdersHasPagination = true;
    _onGoingIsPaginating = false;
    notifyListeners();
  }

  ApiResponse _vendorOngoingOrdersResponse = ApiResponse(state: ResponseState.sleep, data: null);
  ApiResponse get vendorOngoingOrdersResponse => _vendorOngoingOrdersResponse;

  List<VendorOrdersModel> _vendorOngoingOrders = [];
  List<VendorOrdersModel> get vendorOngoingOrders => _vendorOngoingOrders;
  VendorModel? _ongoingOrders;
  VendorModel? get ongoingOrders => _ongoingOrders;

  int _ongoingOrderPage = 1;
  int get ongoingOrderPage => _ongoingOrderPage;

  set ongoingOrderPage(int value) {
    _ongoingOrderPage = value;
    notifyListeners();
  }

  bool _onGoingOrdersHasPagination = true;
  bool get onGoingOrdersHasPagination => _onGoingOrdersHasPagination;
  bool _onGoingIsPaginating = false;
  bool get onGoingIsPaginating => _onGoingIsPaginating;

  Future<void> getVendorOngoingOrders({
    int? pageNumber,
    int? orderNo,
    String? delegateFromOut,
    String? type,
    String? date,
  }) async {
    if (_ongoingOrderPage == 1) {
      _vendorOngoingOrdersResponse = ApiResponse(state: ResponseState.loading, data: null);
      _vendorOngoingOrders = [];
      _ongoingOrders = null;
      notifyListeners();
    } else {
      _onGoingIsPaginating = true;
      notifyListeners();
    }
    _vendorOngoingOrdersResponse = await ApiHelper.instance.get(
      Urls.currentOrders,
      queryParameters: {
        'page': pageNumber ?? _ongoingOrderPage,
        if (orderNo != null) 'order_no': orderNo,
        if (delegateFromOut != null) 'delegate_from_out': delegateFromOut,
        if (type != null) 'type': type,
        if (date != null && date != '') 'date': date,
      },
    );
    notifyListeners();

    if (_vendorOngoingOrdersResponse.state == ResponseState.complete) {
      Iterable iterable = _vendorOngoingOrdersResponse.data['data']['data'];
      if (_ongoingOrderPage == _vendorOngoingOrdersResponse.data['data']['meta']['last_page']) {
        _onGoingOrdersHasPagination = false;
        // CommonMethods.showToast(message: "No more orders");
        notifyListeners();
      } else {
        _ongoingOrderPage++;
        _onGoingOrdersHasPagination = true;
        notifyListeners();
      }
      _vendorOngoingOrders.addAll(iterable.map((e) => VendorOrdersModel.fromJson(e)).toList());
      _ongoingOrders = VendorModel.fromJson(_vendorOngoingOrdersResponse.data['data']);
      notifyListeners();
      // _vendorOngoingOrders =
      //     iterable.map((e) => VendorOrdersModel.fromJson(e)).toList();
      // notifyListeners();
    }

    _onGoingIsPaginating = false;
    notifyListeners();
  }

  // ====================================================Completed Orders ============================================================

  void initialVendorCompletedOrders() {
    _vendorCompletedOrdersResponse = ApiResponse(state: ResponseState.sleep, data: null);
    _vendorCompletedOrders = [];
    _completedOrders = null;
    _completedOrderPage = 1;
    _completedOrdersHasPagination = true;
    _completedIsPaginating = false;
    notifyListeners();
  }

  ApiResponse _vendorCompletedOrdersResponse = ApiResponse(state: ResponseState.sleep, data: null);
  ApiResponse get vendorCompletedOrdersResponse => _vendorCompletedOrdersResponse;

  List<VendorOrdersModel> _vendorCompletedOrders = [];
  List<VendorOrdersModel> get vendorCompletedOrders => _vendorCompletedOrders;
  VendorModel? _completedOrders;
  VendorModel? get completedOrders => _completedOrders;

  int _completedOrderPage = 1;
  int get completedOrderPage => _completedOrderPage;

  set completedOrderPage(int value) {
    _completedOrderPage = value;
    notifyListeners();
  }

  bool _completedOrdersHasPagination = true;
  bool get completedOrdersHasPagination => _completedOrdersHasPagination;
  bool _completedIsPaginating = false;
  bool get completedIsPaginating => _completedIsPaginating;

  Future<void> getVendorCompletedOrders({int? pageNumber, int? orderNo}) async {
    if (_completedOrderPage == 1) {
      _vendorCompletedOrdersResponse = ApiResponse(state: ResponseState.loading, data: null);
      _vendorCompletedOrders = [];
      _completedOrders = null;
      notifyListeners();
    } else {
      _completedIsPaginating = true;
      notifyListeners();
    }
    _vendorCompletedOrdersResponse = await ApiHelper.instance.get(
      Urls.completedOrders,
      queryParameters: {'page': _completedOrderPage, 'order_no': orderNo},
    );
    notifyListeners();

    if (_vendorCompletedOrdersResponse.state == ResponseState.complete) {
      Iterable iterable = _vendorCompletedOrdersResponse.data['data']['data'];
      if (_completedOrderPage == _vendorCompletedOrdersResponse.data['data']['meta']['last_page']) {
        _completedOrdersHasPagination = false;
      } else {
        _completedOrderPage++;
        _completedOrdersHasPagination = true;
        notifyListeners();
      }
      _vendorCompletedOrders.addAll(iterable.map((e) => VendorOrdersModel.fromJson(e)).toList());
      _completedOrders = VendorModel.fromJson(_vendorCompletedOrdersResponse.data['data']);

      notifyListeners();
    }

    _completedIsPaginating = false;
    notifyListeners();
  }

  //=====================================================Single Order ============================================================

  void initialSingleOrder() {
    _singleOrderResponse = ApiResponse(state: ResponseState.sleep, data: null);
    _singleOrder = null;
    notifyListeners();
  }

  ApiResponse _singleOrderResponse = ApiResponse(state: ResponseState.sleep, data: null);
  ApiResponse get singleOrderResponse => _singleOrderResponse;

  VendorOrdersModel? _singleOrder;
  VendorOrdersModel? get singleOrder => _singleOrder;
  Future<void> getSingleOrder({required int id}) async {
    _singleOrderResponse = ApiResponse(state: ResponseState.loading, data: null);
    notifyListeners();

    _singleOrderResponse = await ApiHelper.instance.get('${Urls.orderDetails}$id');
    notifyListeners();

    if (_singleOrderResponse.state == ResponseState.complete) {
      if (_singleOrderResponse.data is Map<String, dynamic>) {
        // Assuming 'data' is a Map containing the order details
        _singleOrder = VendorOrdersModel.fromJson(_singleOrderResponse.data['data']);
      } else if (_singleOrderResponse.data is List) {
        // If 'data' is a List, handle it accordingly
        // Assuming you're interested in the first item
        _singleOrder = VendorOrdersModel.fromJson(_singleOrderResponse.data.first);
      }
      notifyListeners();
    }
  }

  //======================================================== chose delver order from or out restaurant =====================
  Future<void> delverOrderFromOrOut({
    required String type,
    int? delegateId,
    required int orderId,
    required int restaurantId,
    required VoidCallback onSuccess,
  }) async {
    NamedNavigatorImpl.loading();

    FormData body = FormData.fromMap({
      'type': type, //in_resturant , out_resturant
      if (delegateId != null) 'delegate_id': delegateId,
      'order_id': orderId,
      'resturant_id': restaurantId,
    });
    final response = await ApiHelper.instance.post('${Urls.fromOrOut}$orderId/update', body: body);
    NamedNavigatorImpl.loadingOff();
    if (response.state == ResponseState.complete) {
      CommonMethods.showToast(message: response.data['message']);
      onSuccess.call();
      notifyListeners();
    } else {
      CommonMethods.showError(message: response.data['message'], apiResponse: response);
    }
  }

  //======================================================== update order status =====================
  Future<void> updateOrderStatus({
    required int orderId,
    required String status,
    required VoidCallback onSuccess,
  }) async {
    NamedNavigatorImpl.loading();

    FormData body = FormData.fromMap({'status': status, 'order_id': orderId});
    final response = await ApiHelper.instance.post('${Urls.updateOrderStatus}$orderId/status', body: body);
    NamedNavigatorImpl.loadingOff();
    if (response.state == ResponseState.complete) {
      CommonMethods.showToast(message: response.data['message']);
      onSuccess.call();
      notifyListeners();
    } else {
      CommonMethods.showError(message: response.data['message'], apiResponse: response);
    }
  }

  //=========================================== home orders ==========
  void initialCurrentVendorOrders() {
    _currentVendorOrdersResponse = ApiResponse(state: ResponseState.sleep, data: null);
    _currentVendorOrders = [];
    _currentOrders = null;
    _currentOrderPage = 1;
    _currentOrdersHasPagination = true;
    _currentIsPaginating = false;
    notifyListeners();
  }

  ApiResponse _currentVendorOrdersResponse = ApiResponse(state: ResponseState.sleep, data: null);
  ApiResponse get vendorOrdersResponse => _currentVendorOrdersResponse;

  List<VendorOrdersModel> _currentVendorOrders = [];
  List<VendorOrdersModel> get currentVendorOrders => _currentVendorOrders;
  VendorModel? _currentOrders;
  VendorModel? get currentOrders => _currentOrders;

  int _currentOrderPage = 1;
  int get currentOrderPage => _currentOrderPage;

  set currentOrderPage(int value) {
    _currentOrderPage = value;
  }

  bool _currentOrdersHasPagination = true;
  bool get currentOrdersHasPagination => _currentOrdersHasPagination;
  bool _currentIsPaginating = false;
  bool get currentIsPaginating => _currentIsPaginating;

  Future<void> getCurrentVendorOrders({int? pageNumber}) async {
    if (_currentOrderPage == 1) {
      _currentVendorOrdersResponse = ApiResponse(state: ResponseState.loading, data: null);
      _currentVendorOrders = [];
      _currentOrders = null;
      notifyListeners();
    } else {
      _currentIsPaginating = true;
      notifyListeners();
    }

    _currentVendorOrdersResponse = await ApiHelper.instance.get(
      Urls.currentOrders,
      queryParameters: {'page': pageNumber ?? _currentOrderPage},
    );
    notifyListeners();

    if (_currentVendorOrdersResponse.state == ResponseState.complete) {
      Iterable iterable = _currentVendorOrdersResponse.data['data']['data'];

      _currentOrders = VendorModel.fromJson(_currentVendorOrdersResponse.data['data']);

      if (_currentOrderPage == _currentVendorOrdersResponse.data['data']['meta']['last_page']) {
        _currentOrdersHasPagination = false;
        // CommonMethods.showToast(message: "No more orders");
        // notifyListeners();
      } else {
        _currentOrderPage++;
        _currentOrdersHasPagination = true;
        notifyListeners();
      }
      _currentVendorOrders.addAll(iterable.map((e) => VendorOrdersModel.fromJson(e)).toList());

      notifyListeners();
    }

    _currentIsPaginating = false;
    notifyListeners();
  }

  //============================ home current orders orders ===================================
  // void initialCurrentVendorOrdersHome() {
  //   _currentVendorOrdersHomeResponse = ApiResponse(
  //     state: ResponseState.sleep,
  //     data: null,
  //   );
  //   _currentVendorOrdersHome = null;
  //   notifyListeners();
  // }

  // ApiResponse _currentVendorOrdersHomeResponse = ApiResponse(
  //   state: ResponseState.sleep,
  //   data: null,
  // );
  // ApiResponse get currentVendorOrdersHomeResponse =>
  //     _currentVendorOrdersHomeResponse;

  // VendorOrdersModel? _currentVendorOrdersHome;
  // VendorOrdersModel? get currentVendorOrdersHome => _currentVendorOrdersHome;
  // Future<void> getCurrentVendorOrdersHome() async {
  //   _currentVendorOrdersHomeResponse = ApiResponse(
  //     state: ResponseState.loading,
  //     data: null,
  //   );
  //   notifyListeners();
  //   _currentVendorOrdersHomeResponse =
  //       await ApiHelper.instance.get(Urls.currentOrdersHome);
  //   notifyListeners();
  //   if (_currentVendorOrdersHomeResponse.state == ResponseState.complete) {
  //     _currentVendorOrdersHome =
  //         _currentVendorOrdersHomeResponse.data['data'] != null
  //             ? VendorOrdersModel.fromJson(
  //                 _currentVendorOrdersHomeResponse.data['data'])
  //             : null;
  //     notifyListeners();
  //   }
  // }

  // //============================ ongoing orders ==============================
  // void initialOngoingVendorOrdersHome() {
  //   _ongoingVendorOrdersHomeResponse = ApiResponse(
  //     state: ResponseState.sleep,
  //     data: null,
  //   );
  //   _ongoingVendorOrdersHome = null;
  //   notifyListeners();
  // }

  // ApiResponse _ongoingVendorOrdersHomeResponse = ApiResponse(
  //   state: ResponseState.sleep,
  //   data: null,
  // );
  // ApiResponse get ongoingVendorOrdersHomeResponse =>
  //     _ongoingVendorOrdersHomeResponse;

  // VendorOrdersModel? _ongoingVendorOrdersHome;
  // VendorOrdersModel? get ongoingVendorOrdersHome => _ongoingVendorOrdersHome;

  // Future<void> getOngoingVendorOrdersHome() async {
  //   _ongoingVendorOrdersHomeResponse = ApiResponse(
  //     state: ResponseState.loading,
  //     data: null,
  //   );
  //   notifyListeners();
  //   _ongoingVendorOrdersHomeResponse =
  //       await ApiHelper.instance.get(Urls.ongoingOrdersHome);
  //   notifyListeners();
  //   if (_ongoingVendorOrdersHomeResponse.state == ResponseState.complete) {
  //     _ongoingVendorOrdersHome =
  //         _ongoingVendorOrdersHomeResponse.data['data'] != null
  //             ? VendorOrdersModel.fromJson(
  //                 _ongoingVendorOrdersHomeResponse.data['data'])
  //             : null;
  //     notifyListeners();
  //   }
  // }

  //============================ ongoing orders ==============================
  Future<void> vendorTransferOrderPrice({required int orderId, required VoidCallback onSuccess}) async {
    NamedNavigatorImpl.loading();

    final response = await ApiHelper.instance.post('${Urls.vendorTransferOrderPrice}$orderId/price');
    NamedNavigatorImpl.loadingOff();
    if (response.state == ResponseState.complete) {
      CommonMethods.showToast(message: response.data['message']);
      onSuccess.call();
      notifyListeners();
    } else {
      CommonMethods.showError(message: response.data['message'], apiResponse: response);
    }
  }

  //================================ ,,,,,,,,,,,,,,,, pending home ,,,,,,,,,,,,,,,,,,,,, ===================================================
  void initialPendingVendorHomeOrders() {
    _pendingVendorOrdersResponse = ApiResponse(state: ResponseState.sleep, data: null);
    _pendingVendorOrders = [];
    _pendingOrders = null;
    _pendingOrderPage = 1;
    _pendingOrdersHasPagination = true;
    _pendingIsPaginating = false;
    notifyListeners();
  }

  ApiResponse _pendingVendorOrdersResponse = ApiResponse(state: ResponseState.sleep, data: null);
  ApiResponse get pendingVendorOrdersResponse => _pendingVendorOrdersResponse;

  List<VendorOrdersModel> _pendingVendorOrders = [];
  List<VendorOrdersModel> get pendingVendorOrders => _pendingVendorOrders;
  VendorModel? _pendingOrders;
  VendorModel? get pendingOrders => _pendingOrders;

  int _pendingOrderPage = 1;
  int get pendingOrderPage => _pendingOrderPage;

  set pendingOrderPage(int value) {
    _pendingOrderPage = value;
  }

  bool _pendingOrdersHasPagination = true;
  bool get pendingOrdersHasPagination => _pendingOrdersHasPagination;
  bool _pendingIsPaginating = false;
  bool get pendingIsPaginating => _pendingIsPaginating;

  Future<void> getPendingVendorHomeOrders({int? pageNumber}) async {
    if (_pendingOrderPage == 1) {
      _pendingVendorOrdersResponse = ApiResponse(state: ResponseState.loading, data: null);
      _pendingVendorOrders = [];
      _pendingOrders = null;
      notifyListeners();
    } else {
      _pendingIsPaginating = true;
      notifyListeners();
    }

    _pendingVendorOrdersResponse = await ApiHelper.instance.get(
      Urls.pendingOrdersHome,
      queryParameters: {'page': pageNumber ?? _pendingOrderPage},
    );
    notifyListeners();

    if (_pendingVendorOrdersResponse.state == ResponseState.complete) {
      Iterable iterable = _pendingVendorOrdersResponse.data['data']['data'];
      totalPendingHome = _pendingVendorOrdersResponse.data['data']['meta']['total'];

      _pendingOrders = VendorModel.fromJson(_pendingVendorOrdersResponse.data['data']);

      if (_pendingOrderPage == _pendingVendorOrdersResponse.data['data']['meta']['last_page']) {
        _pendingOrdersHasPagination = false;
        // CommonMethods.showToast(message: "No more orders");
        // notifyListeners();
      } else {
        _pendingOrderPage++;
        _pendingOrdersHasPagination = true;
        notifyListeners();
      }
      _pendingVendorOrders.addAll(iterable.map((e) => VendorOrdersModel.fromJson(e)).toList());

      notifyListeners();
    }

    _pendingIsPaginating = false;
    notifyListeners();
  }

  //===================================,,,,,,,,,,,,,,,,,,,,,,,,, current home ,,,,,,,,,,,,,,,,,,,,,,,. =======================
  void initialCurrentVendorHomeOrders() {
    _currentVendorHomeOrdersResponse = ApiResponse(state: ResponseState.sleep, data: null);
    _currentVendorHomeOrders = [];
    _currentHomeOrders = null;
    _currentOrderPage = 1;
    _currentHomeOrdersHasPagination = true;
    _currentHomeIsPaginating = false;
    notifyListeners();
  }

  ApiResponse _currentVendorHomeOrdersResponse = ApiResponse(state: ResponseState.sleep, data: null);
  ApiResponse get currentVendorHomeOrdersResponse => _currentVendorHomeOrdersResponse;

  List<VendorOrdersModel> _currentVendorHomeOrders = [];
  List<VendorOrdersModel> get currentVendorHomeOrders => _currentVendorHomeOrders;
  VendorModel? _currentHomeOrders;
  VendorModel? get currentHomeOrders => _currentHomeOrders;

  int _currentOrderHomePage = 1;
  int get currentOrderHomePage => _currentOrderHomePage;

  set currentOrderHomePage(int value) {
    _currentOrderHomePage = value;
  }

  bool _currentHomeOrdersHasPagination = true;
  bool get currentHomeOrdersHasPagination => _currentHomeOrdersHasPagination;
  bool _currentHomeIsPaginating = false;
  bool get currentHomeIsPaginating => _currentHomeIsPaginating;

  Future<void> getCurrentVendorHomeOrders({int? pageNumber}) async {
    if (_currentOrderPage == 1) {
      _currentVendorHomeOrdersResponse = ApiResponse(state: ResponseState.loading, data: null);
      _currentVendorHomeOrders = [];
      _currentHomeOrders = null;
      notifyListeners();
    } else {
      _currentHomeIsPaginating = true;
      notifyListeners();
    }

    _currentVendorHomeOrdersResponse = await ApiHelper.instance.get(
      Urls.currentHomeOrders,
      queryParameters: {'page': pageNumber ?? _currentOrderHomePage},
    );
    notifyListeners();

    if (_currentVendorHomeOrdersResponse.state == ResponseState.complete) {
      Iterable iterable = _currentVendorHomeOrdersResponse.data['data']['data'];

      _currentHomeOrders = VendorModel.fromJson(_currentVendorHomeOrdersResponse.data['data']);

      if (_currentOrderHomePage == _currentVendorHomeOrdersResponse.data['data']['meta']['last_page']) {
        _currentHomeOrdersHasPagination = false;
        // CommonMethods.showToast(message: "No more orders");
        // notifyListeners();
      } else {
        _currentOrderHomePage++;
        _currentHomeOrdersHasPagination = true;
        notifyListeners();
      }
      _currentVendorHomeOrders.addAll(iterable.map((e) => VendorOrdersModel.fromJson(e)).toList());

      notifyListeners();
    }

    _currentHomeIsPaginating = false;
    notifyListeners();
  }

  // ==================================== update order ==================================
  Future<void> updateOrder({
    required int orderId,
    required int itemId,
    required String total,
    required String reason,
    required VoidCallback onSuccess,
  }) async {
    NamedNavigatorImpl.loading();

    FormData body = FormData.fromMap({'total': total, 'reason': reason, 'item_id': itemId});
    final response = await ApiHelper.instance.post(Urls.updateOrder(orderId), body: body);
    NamedNavigatorImpl.loadingOff();
    if (response.state == ResponseState.complete) {
      CommonMethods.showToast(message: response.data['message']);
      notifyListeners();
    } else {
      CommonMethods.showError(message: response.data['message'], apiResponse: response);
    }
  }

  //========================== acceptScheduleOrder
  Future<void> acceptScheduleOrder({required int orderId, required VoidCallback onSuccess}) async {
    NamedNavigatorImpl.loading();
    FormData body = FormData.fromMap({'status': 'accept'});

    final response = await ApiHelper.instance.post(Urls.acceptScheduleOrder(orderId), body: body);
    NamedNavigatorImpl.loadingOff();
    if (response.state == ResponseState.complete) {
      CommonMethods.showToast(message: response.data['message']);
      onSuccess.call();
      notifyListeners();
    } else {
      CommonMethods.showError(message: response.data['message'], apiResponse: response);
    }
  }
}
