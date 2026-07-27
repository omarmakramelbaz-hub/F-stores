class RequestDelegateOrderModel {
  int? id;
  String? orderNo;
  int? delegateId;
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
  String? resturantVendorFcmId;
  String? resturantVendorDeviceToken;
  String? userFcmId;
  String? delegateFcmId;

  RequestDelegateOrderModel({
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
    this.resturantVendorFcmId,
    this.resturantVendorDeviceToken,
    this.userFcmId,
    this.delegateFcmId,
  });

  RequestDelegateOrderModel.fromJson(Map<String, dynamic> json) {
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
    resturantVendorFcmId = json['resturant_vendor_fcm_id'];
    resturantVendorDeviceToken = json['resturant_vendor_device_token'];
    userFcmId = json['user_fcm_id'];
    delegateFcmId = json['delegate_fcm_id'];
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
    data['resturant_vendor_fcm_id'] = resturantVendorFcmId;
    data['resturant_vendor_device_token'] = resturantVendorDeviceToken;
    data['user_fcm_id'] = userFcmId;
    data['delegate_fcm_id'] = delegateFcmId;

    return data;
  }
}
