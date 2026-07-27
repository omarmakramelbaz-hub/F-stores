class ReportsModel {
  List<int>? chartOrders;
  List<Orders>? orders;
  int? ordersCount;
  num? notTransferCashOrders;
  num? transferCashOrders;
  num? totalCashOrder;
  num? totalGainFromApp;

  ReportsModel({
    this.chartOrders,
    this.orders,
    this.ordersCount,
    this.notTransferCashOrders,
    this.transferCashOrders,
    this.totalCashOrder,
    this.totalGainFromApp,
  });

  ReportsModel.fromJson(Map<String, dynamic> json) {
    chartOrders = json['chart_orders'].cast<int>();
    if (json['orders'] != null) {
      orders = <Orders>[];
      json['orders'].forEach((v) {
        orders!.add(Orders.fromJson(v));
      });
    }
    ordersCount = json['orders_count'];
    notTransferCashOrders = json['not_transfer_cash_orders'];
    transferCashOrders = json['transfer_cash_orders'];
    totalCashOrder = json['total_cash_order'];
    totalGainFromApp = json['total_gain_from_app'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['chart_orders'] = chartOrders;
    if (orders != null) {
      data['orders'] = orders!.map((v) => v.toJson()).toList();
    }
    data['orders_count'] = ordersCount;
    data['not_transfer_cash_orders'] = notTransferCashOrders;
    data['transfer_cash_orders'] = transferCashOrders;
    data['total_cash_order'] = totalCashOrder;
    data['total_gain_from_app'] = totalGainFromApp;
    return data;
  }
}

class Orders {
  int? id;
  String? orderNo;
  int? resturantId;
  String? resturantName;
  List<ResturantAreas>? resturantAreas;
  String? resturantPhone;
  String? resturantLogo;
  String? resturantLocation;
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
  String? scheduleDate;
  String? paymentType;
  num? deliveryPrice;
  num? tax;
  num? totalItemPrice;
  num? updatedTotalItemPrice;
  int? userAddressId;
  UserAddress? userAddress;
  List<Items>? items;
  String? createdAt;
  int? ordersCount;
  String? delegateFromOut;
  int? hasRatedBefore;
  int? hasCommissionedBefore;
  int? hasTransferedBefore;
  int? totalVendorOrders;
  int? totalDelegateOrders;
  num? serviceFees;
  num? vendorPercentage;
  num? appPercentage;
  num? appToVendorPercentage;
  num? grandTotal;

  Orders({
    this.id,
    this.orderNo,
    this.resturantId,
    this.resturantName,
    this.resturantAreas,
    this.resturantPhone,
    this.resturantLogo,
    this.resturantLocation,
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
    this.scheduleDate,
    this.paymentType,
    this.deliveryPrice,
    this.tax,
    this.totalItemPrice,
    this.updatedTotalItemPrice,
    this.userAddressId,
    this.userAddress,
    this.items,
    this.createdAt,
    this.ordersCount,
    this.delegateFromOut,
    this.hasRatedBefore,
    this.hasCommissionedBefore,
    this.hasTransferedBefore,
    this.totalVendorOrders,
    this.totalDelegateOrders,
    this.serviceFees,
    this.vendorPercentage,
    this.appPercentage,
    this.appToVendorPercentage,
    this.grandTotal,
  });

  Orders.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderNo = json['order_no'];
    resturantId = json['resturant_id'];
    resturantName = json['resturant_name'];
    if (json['resturant_areas'] != null) {
      resturantAreas = <ResturantAreas>[];
      json['resturant_areas'].forEach((v) {
        resturantAreas!.add(ResturantAreas.fromJson(v));
      });
    }
    resturantPhone = json['resturant_phone'];
    resturantLogo = json['resturant_logo'];
    resturantLocation = json['resturant_location'];
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
    scheduleDate = json['schedule_date'];
    paymentType = json['payment_type'];
    deliveryPrice = json['delivery_price'];
    tax = json['tax'];
    totalItemPrice = json['total_item_price'];
    updatedTotalItemPrice = json['updated_total_item_price'];
    userAddressId = json['user_address_id'];
    userAddress = json['user_address'] != null ? UserAddress.fromJson(json['user_address']) : null;
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(Items.fromJson(v));
      });
    }
    createdAt = json['created_at'];
    ordersCount = json['orders_count'];
    delegateFromOut = json['delegate_from_out'];
    hasRatedBefore = json['has_rated_before'];
    hasCommissionedBefore = json['has_commissioned_before'];
    hasTransferedBefore = json['has_transfered_before'];
    totalVendorOrders = json['total_vendor_orders'];
    totalDelegateOrders = json['total_delegate_orders'];
    serviceFees = json['service_fees'];
    vendorPercentage = json['vendor_percentage'];
    appPercentage = json['app_percentage'];
    appToVendorPercentage = json['app_to_vendor_percentage'];
    grandTotal = json['grand_total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['order_no'] = orderNo;
    data['resturant_id'] = resturantId;
    data['resturant_name'] = resturantName;
    if (resturantAreas != null) {
      data['resturant_areas'] = resturantAreas!.map((v) => v.toJson()).toList();
    }
    data['resturant_phone'] = resturantPhone;
    data['resturant_logo'] = resturantLogo;
    data['resturant_location'] = resturantLocation;
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
    data['schedule_date'] = scheduleDate;
    data['payment_type'] = paymentType;
    data['delivery_price'] = deliveryPrice;
    data['tax'] = tax;
    data['total_item_price'] = totalItemPrice;
    data['updated_total_item_price'] = updatedTotalItemPrice;
    data['user_address_id'] = userAddressId;
    if (userAddress != null) {
      data['user_address'] = userAddress!.toJson();
    }
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    data['created_at'] = createdAt;
    data['orders_count'] = ordersCount;
    data['delegate_from_out'] = delegateFromOut;
    data['has_rated_before'] = hasRatedBefore;
    data['has_commissioned_before'] = hasCommissionedBefore;
    data['has_transfered_before'] = hasTransferedBefore;
    data['total_vendor_orders'] = totalVendorOrders;
    data['total_delegate_orders'] = totalDelegateOrders;
    data['service_fees'] = serviceFees;
    data['vendor_percentage'] = vendorPercentage;
    data['app_percentage'] = appPercentage;
    data['app_to_vendor_percentage'] = appToVendorPercentage;
    data['grand_total'] = grandTotal;
    return data;
  }
}

class ResturantAreas {
  int? id;
  int? addedBy;
  int? resturantId;
  String? expectedDelivery;
  String? createdAt;
  String? updatedAt;
  int? areaId;
  String? type;

  ResturantAreas({
    this.id,
    this.addedBy,
    this.resturantId,
    this.expectedDelivery,
    this.createdAt,
    this.updatedAt,
    this.areaId,
    this.type,
  });

  ResturantAreas.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    addedBy = json['added_by'];
    resturantId = json['resturant_id'];
    expectedDelivery = json['expected_delivery'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    areaId = json['area_id'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['added_by'] = addedBy;
    data['resturant_id'] = resturantId;
    data['expected_delivery'] = expectedDelivery;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['area_id'] = areaId;
    data['type'] = type;
    return data;
  }
}

class UserAddress {
  int? id;
  String? areaName;
  String? mobile;
  String? apartmentNo;
  String? floorNo;
  String? streetName;
  String? badge;
  String? addressName;
  String? type;
  String? lat;
  String? lng;
  String? countryName;
  String? cityName;
  String? address;
  int? cityId;
  String? cityname;
  String? createdAt;

  UserAddress({
    this.id,
    this.areaName,
    this.mobile,
    this.apartmentNo,
    this.floorNo,
    this.streetName,
    this.badge,
    this.addressName,
    this.type,
    this.lat,
    this.lng,
    this.countryName,
    this.cityName,
    this.address,
    this.cityId,
    this.cityname,
    this.createdAt,
  });

  UserAddress.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    areaName = json['area_name'];
    mobile = json['mobile'];
    apartmentNo = json['apartment_no'];
    floorNo = json['floor_no'];
    streetName = json['street_name'];
    badge = json['badge'];
    addressName = json['address_name'];
    type = json['type'];
    lat = json['lat'];
    lng = json['lng'];
    countryName = json['country_name'];
    cityName = json['city_name'];
    address = json['address'];
    cityId = json['city_id'];
    cityname = json['cityname'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['area_name'] = areaName;
    data['mobile'] = mobile;
    data['apartment_no'] = apartmentNo;
    data['floor_no'] = floorNo;
    data['street_name'] = streetName;
    data['badge'] = badge;
    data['address_name'] = addressName;
    data['type'] = type;
    data['lat'] = lat;
    data['lng'] = lng;
    data['country_name'] = countryName;
    data['city_name'] = cityName;
    data['address'] = address;
    data['city_id'] = cityId;
    data['cityname'] = cityname;
    data['created_at'] = createdAt;
    return data;
  }
}

class Items {
  int? id;
  ResturantProduct? resturantProduct;
  int? resturantId;
  String? resturantName;
  String? resturantLat;
  String? resturantLng;
  String? resturantCityName;
  String? resturantDeliveryTime;
  int? orderId;
  num? price;
  int? qty;
  int? productFeature;
  String? productFeatureName;
  String? productClean;
  String? createdAt;
  num? minOrderPrice;
  num? total;
  num? updatedTotal;
  String? reasonUpdateTotal;

  Items({
    this.id,
    this.resturantProduct,
    this.resturantId,
    this.resturantName,
    this.resturantLat,
    this.resturantLng,
    this.resturantCityName,
    this.resturantDeliveryTime,
    this.orderId,
    this.price,
    this.qty,
    this.productFeature,
    this.productFeatureName,
    this.productClean,
    this.createdAt,
    this.minOrderPrice,
    this.total,
    this.updatedTotal,
    this.reasonUpdateTotal,
  });

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    resturantProduct = json['resturant_product'] != null ? ResturantProduct.fromJson(json['resturant_product']) : null;
    resturantId = json['resturant_id'];
    resturantName = json['resturant_name'];
    resturantLat = json['resturant_lat'];
    resturantLng = json['resturant_lng'];
    resturantCityName = json['resturant_city_name'];
    resturantDeliveryTime = json['resturant_delivery_time'];
    orderId = json['order_id'];
    price = json['price'];
    qty = json['qty'];
    productFeature = json['product_feature'];
    productFeatureName = json['product_feature_name'];
    productClean = json['product_clean'];
    createdAt = json['created_at'];
    minOrderPrice = json['min_order_price'];
    total = json['total'];
    updatedTotal = json['updated_total'];
    reasonUpdateTotal = json['reason_update_total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (resturantProduct != null) {
      data['resturant_product'] = resturantProduct!.toJson();
    }
    data['resturant_id'] = resturantId;
    data['resturant_name'] = resturantName;
    data['resturant_lat'] = resturantLat;
    data['resturant_lng'] = resturantLng;
    data['resturant_city_name'] = resturantCityName;
    data['resturant_delivery_time'] = resturantDeliveryTime;
    data['order_id'] = orderId;
    data['price'] = price;
    data['qty'] = qty;
    data['product_feature'] = productFeature;
    data['product_feature_name'] = productFeatureName;
    data['product_clean'] = productClean;
    data['created_at'] = createdAt;
    data['min_order_price'] = minOrderPrice;
    data['total'] = total;
    data['updated_total'] = updatedTotal;
    data['reason_update_total'] = reasonUpdateTotal;
    return data;
  }
}

class ResturantProduct {
  int? id;
  int? vendorId;
  String? vendorName;
  int? resturantId;
  String? resturantName;
  String? productName;
  String? productDescription;
  List<Features>? features;
  num? productPrice;
  num? extraCombo;
  num? extraLarge;
  num? extraMedium;
  num? extraClean;
  num? extraClear;
  num? extraVacuim;
  int? categoryId;
  String? categoryName;
  int? subCategoryId;
  String? subCategoryName;
  int? productId;
  String? productTitle;
  String? status;
  int? hasClean;
  String? productImage;
  String? createdAt;

  ResturantProduct({
    this.id,
    this.vendorId,
    this.vendorName,
    this.resturantId,
    this.resturantName,
    this.productName,
    this.productDescription,
    this.features,
    this.productPrice,
    this.extraCombo,
    this.extraLarge,
    this.extraMedium,
    this.extraClean,
    this.extraClear,
    this.extraVacuim,
    this.categoryId,
    this.categoryName,
    this.subCategoryId,
    this.subCategoryName,
    this.productId,
    this.productTitle,
    this.status,
    this.hasClean,
    this.productImage,
    this.createdAt,
  });

  ResturantProduct.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vendorId = json['vendor_id'];
    vendorName = json['vendor_name'];
    resturantId = json['resturant_id'];
    resturantName = json['resturant_name'];
    productName = json['product_name'];
    productDescription = json['product_description'];
    if (json['features'] != null) {
      features = <Features>[];
      json['features'].forEach((v) {
        features!.add(Features.fromJson(v));
      });
    }
    productPrice = json['product_price'];
    extraCombo = json['extra_combo'];
    extraLarge = json['extra_large'];
    extraMedium = json['extra_medium'];
    extraClean = json['extra_clean'];
    extraClear = json['extra_clear'];
    extraVacuim = json['extra_vacuim'];
    categoryId = json['category_id'];
    categoryName = json['category_name'];
    subCategoryId = json['sub_category_id'];
    subCategoryName = json['sub_category_name'];
    productId = json['product_id'];
    productTitle = json['product_title'];
    status = json['status'];
    hasClean = json['has_clean'];
    productImage = json['product_image'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['vendor_id'] = vendorId;
    data['vendor_name'] = vendorName;
    data['resturant_id'] = resturantId;
    data['resturant_name'] = resturantName;
    data['product_name'] = productName;
    data['product_description'] = productDescription;
    if (features != null) {
      data['features'] = features!.map((v) => v.toJson()).toList();
    }
    data['product_price'] = productPrice;
    data['extra_combo'] = extraCombo;
    data['extra_large'] = extraLarge;
    data['extra_medium'] = extraMedium;
    data['extra_clean'] = extraClean;
    data['extra_clear'] = extraClear;
    data['extra_vacuim'] = extraVacuim;
    data['category_id'] = categoryId;
    data['category_name'] = categoryName;
    data['sub_category_id'] = subCategoryId;
    data['sub_category_name'] = subCategoryName;
    data['product_id'] = productId;
    data['product_title'] = productTitle;
    data['status'] = status;
    data['has_clean'] = hasClean;
    data['product_image'] = productImage;
    data['created_at'] = createdAt;
    return data;
  }
}

class Features {
  int? id;
  String? name;
  String? createdAt;

  Features({this.id, this.name, this.createdAt});

  Features.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['created_at'] = createdAt;
    return data;
  }
}
