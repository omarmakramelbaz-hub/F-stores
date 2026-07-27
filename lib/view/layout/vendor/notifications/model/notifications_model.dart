class NotificationsModel {
  String? type;
  String? id;
  Data? data;
  String? createdAt;

  NotificationsModel({this.type, this.id, this.data, this.createdAt});

  NotificationsModel.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    id = json['id'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['id'] = id;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['created_at'] = createdAt;
    return data;
  }
}

class Data {
  String? title;
  String? logo;
  String? text;
  String? createdAt;
  NotificationData? notificationData;

  Data({this.title, this.logo, this.text, this.createdAt, this.notificationData});

  Data.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    logo = json['logo'];
    text = json['text'];
    createdAt = json['created_at'];
    notificationData = json['data'] != null ? NotificationData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['logo'] = logo;
    data['text'] = text;
    data['created_at'] = createdAt;
    if (notificationData != null) {
      data['data'] = notificationData!.toJson();
    }
    return data;
  }
}

class NotificationData {
  int? notificationType;
  dynamic orderId;
  dynamic resturantId;
  int? userId;
  String? orderType;

  NotificationData({this.notificationType, this.orderId, this.resturantId, this.userId});

  NotificationData.fromJson(Map<String, dynamic> json) {
    notificationType = json['notification_type'];

    if (json['order_id'] is int) {
      orderId = json['order_id'];
    } else if (json['order_id'] is String) {
      orderId = int.tryParse(json['order_id']) ?? json['order_id'];
    }

    resturantId = json['resturant_id'];
    userId = json['user_id'];
    orderType = json['order_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['notification_type'] = notificationType;
    data['order_id'] = orderId;
    data['resturant_id'] = resturantId;
    data['user_id'] = userId;
    data['order_type'] = orderType;
    return data;
  }
}
