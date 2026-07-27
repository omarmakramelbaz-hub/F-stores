import 'package:dio/dio.dart';
import '../../../../../helpers/routes/app_routers_import.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../helpers/networking/api_helper.dart';
import '../../../../../helpers/networking/urls.dart';
import '../../../../../helpers/utils/common_methods.dart';
import '../../home/screen/home_vendor_screen.dart';
import '../../my_account/screen/my_account_screen.dart';
import '../../notifications/controller/notifications_controller.dart';
import '../../notifications/screen/notifications_screen.dart';
import '../../order/screen/orders_screen.dart';
import '../../products/screen/products_screen.dart';

class VendorBottomNavigationController extends ChangeNotifier {
  int _screenIndex = 0;
  int get screenIndex => _screenIndex;

  void updateIndex(int index) {
    _screenIndex = index;

    notifyListeners();
  }

  void onWillPop(bool pop) {
    if (screenIndex != 0) {
      updateIndex(0);
      notifyListeners();
    } else {
      NamedNavigatorImpl.pop;
    }
  }

  Future<void> changeStatusOnline({required int id, required String status, required VoidCallback onSuccess}) async {
    FormData body = FormData.fromMap({'status': status});
    NamedNavigatorImpl.loading();
    final response = await ApiHelper.instance.post('${Urls.changeStatus}/$id', body: body);
    NamedNavigatorImpl.loadingOff();
    if (response.state == ResponseState.complete) {
      CommonMethods.showToast(message: response.data['message']);
      onSuccess.call();
      notifyListeners();
    } else {
      CommonMethods.showError(apiResponse: response, message: response.data['message']);
    }
  }

  final List<Widget> screensList = [
    const HomeVendorScreen(),
    const OrdersScreen(),
    const ProductsScreen(),
    ChangeNotifierProvider(
      create: (context) => NotificationsController()
        ..initialNotifications()
        ..getNotifications(),
      child: const NotificationsScreen(),
    ),
    const MyAccountScreen(),
  ];
}
