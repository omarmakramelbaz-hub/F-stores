class DelegateOnMapModel {
  List<UserData>? userData;
  int? shippingOrderId;
  OrderData? orderData;
  int? shippingMinPricePrecentage;
  int? shippingKmPrice;
  int? goDriveBlock;

  DelegateOnMapModel({
    this.userData,
    this.shippingOrderId,
    this.orderData,
    this.shippingMinPricePrecentage,
    this.shippingKmPrice,
    this.goDriveBlock,
  });

  DelegateOnMapModel.fromJson(Map<String, dynamic> json) {
    if (json['user_data'] != null) {
      userData = <UserData>[];
      json['user_data'].forEach((v) {
        userData!.add(UserData.fromJson(v));
      });
    }
    shippingOrderId = json['shipping_order_id'];
    orderData = json['order_data'] != null ? OrderData.fromJson(json['order_data']) : null;
    shippingMinPricePrecentage = json['shipping_min_price_precentage'];
    shippingKmPrice = json['shipping_km_price'];
    goDriveBlock = json['go_drive_block'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (userData != null) {
      data['user_data'] = userData!.map((v) => v.toJson()).toList();
    }
    data['shipping_order_id'] = shippingOrderId;
    if (orderData != null) {
      data['order_data'] = orderData!.toJson();
    }
    data['shipping_min_price_precentage'] = shippingMinPricePrecentage;
    data['shipping_km_price'] = shippingKmPrice;
    data['go_drive_block'] = goDriveBlock;
    return data;
  }
}

class UserData {
  int? id;
  String? name;
  String? accountType;
  String? lat;
  String? lng;
  String? photoProfile;
  int? completedOrdersCount;

  UserData({this.id, this.name, this.accountType, this.lat, this.lng, this.photoProfile, this.completedOrdersCount});

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    accountType = json['account_type'];
    lat = json['lat'];
    lng = json['lng'];
    photoProfile = json['photo_profile'];
    completedOrdersCount = json['completed_orders_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['account_type'] = accountType;
    data['lat'] = lat;
    data['lng'] = lng;
    data['photo_profile'] = photoProfile;
    data['completed_orders_count'] = completedOrdersCount;
    return data;
  }
}

class OrderData {
  int? id;
  String? orderNo;
  String? delegateId;
  String? delegateName;
  String? delegateMobile;
  String? delegateLogo;
  int? userId;
  String? userName;
  String? userMobile;
  String? userLocation;
  String? userLogo;
  String? status;
  String? type;
  String? orderType;
  String? paymentType;
  String? createdAt;
  String? updatedAt;
  String? description;
  String? fromLat;
  String? fromLng;
  String? toLat;
  String? toLng;
  String? fromAddress;
  String? toAddress;
  int? actualPrice;
  int? expectedPrice;
  int? admin;
  String? settingMobile;

  OrderData({
    this.id,
    this.orderNo,
    this.delegateId,
    this.delegateName,
    this.delegateMobile,
    this.delegateLogo,
    this.userId,
    this.userName,
    this.userMobile,
    this.userLocation,
    this.userLogo,
    this.status,
    this.type,
    this.orderType,
    this.paymentType,
    this.createdAt,
    this.updatedAt,
    this.description,
    this.fromLat,
    this.fromLng,
    this.toLat,
    this.toLng,
    this.fromAddress,
    this.toAddress,
    this.actualPrice,
    this.expectedPrice,
    this.admin,
    this.settingMobile,
  });

  OrderData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderNo = json['order_no'];
    delegateId = json['delegate_id'];
    delegateName = json['delegate_name'];
    delegateMobile = json['delegate_mobile'];
    delegateLogo = json['delegate_logo'];
    userId = json['user_id'];
    userName = json['user_name'];
    userMobile = json['user_mobile'];
    userLocation = json['user_location'];
    userLogo = json['user_logo'];
    status = json['status'];
    type = json['type'];
    orderType = json['order_type'];
    paymentType = json['payment_type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    description = json['description'];
    fromLat = json['from_lat'];
    fromLng = json['from_lng'];
    toLat = json['to_lat'];
    toLng = json['to_lng'];
    fromAddress = json['from_address'];
    toAddress = json['to_address'];
    actualPrice = json['actual_price'];
    expectedPrice = json['expected_price'];
    admin = json['admin'];
    settingMobile = json['setting_mobile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['order_no'] = orderNo;
    data['delegate_id'] = delegateId;
    data['delegate_name'] = delegateName;
    data['delegate_mobile'] = delegateMobile;
    data['delegate_logo'] = delegateLogo;
    data['user_id'] = userId;
    data['user_name'] = userName;
    data['user_mobile'] = userMobile;
    data['user_location'] = userLocation;
    data['user_logo'] = userLogo;
    data['status'] = status;
    data['type'] = type;
    data['order_type'] = orderType;
    data['payment_type'] = paymentType;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['description'] = description;
    data['from_lat'] = fromLat;
    data['from_lng'] = fromLng;
    data['to_lat'] = toLat;
    data['to_lng'] = toLng;
    data['from_address'] = fromAddress;
    data['to_address'] = toAddress;
    data['actual_price'] = actualPrice;
    data['expected_price'] = expectedPrice;
    data['admin'] = admin;
    data['setting_mobile'] = settingMobile;
    return data;
  }
}
