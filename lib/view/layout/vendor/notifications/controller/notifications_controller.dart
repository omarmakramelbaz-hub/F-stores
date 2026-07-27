import '../../../../../helpers/networking/api_helper.dart';
import '../../../../../helpers/networking/urls.dart';
import '../model/notifications_model.dart';
import 'package:flutter/material.dart';

class NotificationsController extends ChangeNotifier {
  void addNotificationToTop(NotificationsModel notification) {
    notifications.insert(0, notification);
    notifyListeners();
  }

  void initialNotifications() {
    _notificationsResponse = ApiResponse(state: ResponseState.sleep, data: null);
    _notifications = [];
    notifyListeners();
  }

  ApiResponse _notificationsResponse = ApiResponse(state: ResponseState.sleep, data: null);
  ApiResponse get notificationsResponse => _notificationsResponse;
  List<NotificationsModel> _notifications = [];
  List<NotificationsModel> get notifications => _notifications;

  Future<void> getNotifications() async {
    _notificationsResponse = ApiResponse(state: ResponseState.loading, data: null);
    _notifications = [];
    notifyListeners();
    _notificationsResponse = await ApiHelper.instance.get(Urls.vendorNotifications);
    notifyListeners();
    if (_notificationsResponse.state == ResponseState.complete) {
      Iterable iterable = _notificationsResponse.data['data'];
      _notifications = iterable.map((e) => NotificationsModel.fromJson(e)).toList();
      notifyListeners();
    }
  }
}
