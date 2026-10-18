import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import '../../../../../helpers/routes/app_routers_import.dart';
import 'package:flutter/material.dart';

import '../../../../../helpers/networking/api_helper.dart';
import '../../../../../helpers/hive/hive_methods.dart';
import '../../../../../helpers/networking/urls.dart';
import '../../../../../helpers/utils/common_methods.dart';
import '../../auth/screen/login_screen.dart';
import '../model/vendor_orders_model.dart';
import '../model/vendor_pagination_model.dart';
import 'home_orders_feed.dart';

class OrderController extends ChangeNotifier {
  OrderController({
    HomeOrdersRequest? homeOrdersRequest,
    String? Function()? homeOrdersSession,
    void Function()? homeOrdersUnauthenticated,
  }) {
    final request = homeOrdersRequest ?? _requestHomeOrders;
    final session = homeOrdersSession ?? HiveMethods.getToken;
    _homeOrdersSession = session;
    final unauthenticated = homeOrdersUnauthenticated ?? _redirectHomeUnauthorized;
    _pendingHome = HomeOrdersFeed(
      url: Urls.pendingOrdersHome,
      request: request,
      onChanged: _notifyHomeOrdersChanged,
      sessionKey: session,
      onUnauthorized: unauthenticated,
      onReset: () => totalPendingHome = 0,
      onLoaded: (model) => totalPendingHome = model.meta?.total ?? 0,
    );
    _currentHome = HomeOrdersFeed(
      url: Urls.currentHomeOrders,
      request: request,
      onChanged: _notifyHomeOrdersChanged,
      sessionKey: session,
      onUnauthorized: unauthenticated,
    );
  }

  static Future<ApiResponse> _requestHomeOrders(
    String url, {
    Map<String, dynamic>? queryParameters,
  }) => ApiHelper.instance.get(url, queryParameters: queryParameters, redirectOnUnauthorized: false);

  late final HomeOrdersFeed _pendingHome;
  late final HomeOrdersFeed _currentHome;
  late final String? Function() _homeOrdersSession;
  String? _homeRefreshSession;
  int _homeRefreshGeneration = 0;
  Future<void>? _homeRefresh;
  bool _homeRefreshQueued = false;
  bool _homeDisposed = false;

  void _redirectHomeUnauthorized() {
    final session = _homeOrdersSession();
    Future<void>.delayed(Duration.zero, () {
      if (_homeDisposed || session != _homeOrdersSession()) return;
      NamedNavigatorImpl.navigatorState.currentState?.pushNamedAndRemoveUntil(
        LoginScreen.routeName,
        (route) => false,
      );
    });
  }

  void _ensureHomeSession() {
    _pendingHome.ensureSession();
    _currentHome.ensureSession();
  }

  HomeOrdersFeed get _pendingHomeForSession {
    _ensureHomeSession();
    return _pendingHome;
  }

  HomeOrdersFeed get _currentHomeForSession {
    _ensureHomeSession();
    return _currentHome;
  }

  void _notifyHomeOrdersChanged() {
    if (!_homeDisposed) notifyListeners();
  }

  @override
  void dispose() {
    _homeDisposed = true;
    _pendingHome.reset();
    _currentHome.reset();
    super.dispose();
  }

  /// Refresh immediately, then run one trailing round for overlapping updates.
  Future<void> refreshHomeOrders() {
    if (_homeDisposed) return Future.value();
    _ensureHomeSession();
    final session = _homeOrdersSession();
    if (_homeRefresh != null && session == _homeRefreshSession) {
      _homeRefreshQueued = true;
      return _homeRefresh!;
    }
    final completer = Completer<void>();
    final generation = ++_homeRefreshGeneration;
    _homeRefreshSession = session;
    _homeRefresh = completer.future;
    _refreshHomeOrders(generation).then(
      (_) {
        if (identical(_homeRefresh, completer.future)) _homeRefresh = null;
        completer.complete();
      },
      onError: (Object error, StackTrace stackTrace) {
        if (identical(_homeRefresh, completer.future)) _homeRefresh = null;
        completer.completeError(error, stackTrace);
      },
    );
    return completer.future;
  }

  Future<void> _refreshHomeOrders(int generation) async {
    do {
      _homeRefreshQueued = false;
      final loads = [
        _pendingHome.load(pageNumber: 1, notify: false, forceRefresh: true),
        _currentHome.load(pageNumber: 1, notify: false, forceRefresh: true),
      ];
      _notifyHomeOrdersChanged();
      try {
        await Future.wait(loads);
      } finally {
        if (generation == _homeRefreshGeneration) _notifyHomeOrdersChanged();
      }
    } while (_homeRefreshQueued && !_homeDisposed && generation == _homeRefreshGeneration);
  }

  //======================================= pusher ===============================
  void addPendingHomeOrderToTop(VendorOrdersModel vendorOrdersModel) {
    // Check if the order already exists in the list
    final exists = _pendingHome.orders.any((order) => order.id == vendorOrdersModel.id);

    if (!exists) {
      updateTotalPendingHome((pendingOrders?.meta?.total ?? 0) + 1);
      _pendingHome.orders.insert(0, vendorOrdersModel);
      // Update the total count (if required)
      pendingOrders?.meta?.total = (pendingOrders?.meta?.total ?? 0) + 1;
      notifyListeners(); // Notify listeners to update the UI
    } else if (vendorOrdersModel.status == 'cancelled' || vendorOrdersModel.status == 'declined') {
      _pendingHome.orders.removeWhere((e) => e.id == vendorOrdersModel.id);
      totalPendingHome--;
      notifyListeners();
    } else {
      log('Order with ID ${vendorOrdersModel.id} already exists.');
    }
  }

  int _totalPendingHome = 0;
  int get totalPendingHome {
    _ensureHomeSession();
    return _totalPendingHome;
  }

  set totalPendingHome(int value) => _totalPendingHome = value;

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

  // Home feeds keep independent cursors and share the same request rules.
  void initialPendingVendorHomeOrders() {
    _pendingHome.reset();
    notifyListeners();
  }

  ApiResponse get pendingVendorOrdersResponse => _pendingHomeForSession.response;
  List<VendorOrdersModel> get pendingVendorOrders => _pendingHomeForSession.orders;
  VendorModel? get pendingOrders => _pendingHomeForSession.model;
  int get pendingOrderPage => _pendingHomeForSession.nextPage;
  set pendingOrderPage(int value) => _pendingHomeForSession.nextPage = value;
  bool get pendingOrdersHasPagination => _pendingHomeForSession.hasPagination;
  bool get pendingIsPaginating => _pendingHomeForSession.isPaginating;

  Future<void> getPendingVendorHomeOrders({int? pageNumber}) {
    if (_homeDisposed) return Future.value();
    return _pendingHome.load(pageNumber: pageNumber);
  }

  void initialCurrentVendorHomeOrders() {
    _currentHome.reset();
    notifyListeners();
  }

  ApiResponse get currentVendorHomeOrdersResponse => _currentHomeForSession.response;
  List<VendorOrdersModel> get currentVendorHomeOrders => _currentHomeForSession.orders;
  VendorModel? get currentHomeOrders => _currentHomeForSession.model;
  int get currentOrderHomePage => _currentHomeForSession.nextPage;
  set currentOrderHomePage(int value) => _currentHomeForSession.nextPage = value;
  bool get currentHomeOrdersHasPagination => _currentHomeForSession.hasPagination;
  bool get currentHomeIsPaginating => _currentHomeForSession.isPaginating;

  Future<void> getCurrentVendorHomeOrders({int? pageNumber}) {
    if (_homeDisposed) return Future.value();
    return _currentHome.load(pageNumber: pageNumber);
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
