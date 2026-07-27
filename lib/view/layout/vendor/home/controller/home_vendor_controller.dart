import '../../../../../helpers/networking/api_helper.dart';
import '../../../../../helpers/networking/urls.dart';
import '../../order/model/vendor_orders_model.dart';
import '../../order/model/vendor_pagination_model.dart';
import 'package:flutter/material.dart';

class HomeVendorController extends ChangeNotifier {
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
  void initialCurrentVendorOrdersHome() {
    _currentVendorOrdersHomeResponse = ApiResponse(state: ResponseState.sleep, data: null);
    _currentVendorOrdersHome = null;
    notifyListeners();
  }

  ApiResponse _currentVendorOrdersHomeResponse = ApiResponse(state: ResponseState.sleep, data: null);
  ApiResponse get currentVendorOrdersHomeResponse => _currentVendorOrdersHomeResponse;

  VendorOrdersModel? _currentVendorOrdersHome;
  VendorOrdersModel? get currentVendorOrdersHome => _currentVendorOrdersHome;
  Future<void> getCurrentVendorOrdersHome() async {
    _currentVendorOrdersHomeResponse = ApiResponse(state: ResponseState.loading, data: null);
    notifyListeners();
    _currentVendorOrdersHomeResponse = await ApiHelper.instance.get(Urls.currentOrdersHome);
    notifyListeners();
    if (_currentVendorOrdersHomeResponse.state == ResponseState.complete) {
      _currentVendorOrdersHome = VendorOrdersModel.fromJson(_currentVendorOrdersHomeResponse.data['data']);
      notifyListeners();
    }
  }

  //============================ ongoing orders ==============================
  void initialOngoingVendorOrdersHome() {
    _ongoingVendorOrdersHomeResponse = ApiResponse(state: ResponseState.sleep, data: null);
    _ongoingVendorOrdersHome = null;
    notifyListeners();
  }

  ApiResponse _ongoingVendorOrdersHomeResponse = ApiResponse(state: ResponseState.sleep, data: null);
  ApiResponse get ongoingVendorOrdersHomeResponse => _ongoingVendorOrdersHomeResponse;

  VendorOrdersModel? _ongoingVendorOrdersHome;
  VendorOrdersModel? get ongoingVendorOrdersHome => _ongoingVendorOrdersHome;

  Future<void> getOngoingVendorOrdersHome() async {
    _ongoingVendorOrdersHomeResponse = ApiResponse(state: ResponseState.loading, data: null);
    notifyListeners();
    _ongoingVendorOrdersHomeResponse = await ApiHelper.instance.get(Urls.ongoingOrdersHome);
    notifyListeners();
    if (_ongoingVendorOrdersHomeResponse.state == ResponseState.complete) {
      _ongoingVendorOrdersHome = VendorOrdersModel.fromJson(_ongoingVendorOrdersHomeResponse.data['data']);
      notifyListeners();
    }
  }
}
