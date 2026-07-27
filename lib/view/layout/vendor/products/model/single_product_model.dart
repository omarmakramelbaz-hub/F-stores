class SingleProductModel {
  int? id;
  String? name;
  int? categoryId;
  String? categoryName;
  int? subcategoryId;
  String? subcategoryName;
  String? status;
  int? hasClean;
  List<ProductFeatures>? productFeatures;
  String? createdAt;

  SingleProductModel({
    this.id,
    this.name,
    this.categoryId,
    this.categoryName,
    this.subcategoryId,
    this.subcategoryName,
    this.status,
    this.hasClean,
    this.productFeatures,
    this.createdAt,
  });

  SingleProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    categoryId = json['category_id'];
    categoryName = json['category_name'];
    subcategoryId = json['subcategory_id'];
    subcategoryName = json['subcategory_name'];
    status = json['status'];
    hasClean = json['has_clean'];
    if (json['product_features'] != null) {
      productFeatures = <ProductFeatures>[];
      json['product_features'].forEach((v) {
        productFeatures!.add(ProductFeatures.fromJson(v));
      });
    }
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['category_id'] = categoryId;
    data['category_name'] = categoryName;
    data['subcategory_id'] = subcategoryId;
    data['subcategory_name'] = subcategoryName;
    data['status'] = status;
    data['has_clean'] = hasClean;
    if (productFeatures != null) {
      data['product_features'] = productFeatures!.map((v) => v.toJson()).toList();
    }
    data['created_at'] = createdAt;
    return data;
  }
}

class ProductFeatures {
  int? id;
  String? name;
  int? productId;
  String? createdAt;

  ProductFeatures({this.id, this.name, this.productId, this.createdAt});

  ProductFeatures.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    productId = json['product_id'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['product_id'] = productId;
    data['created_at'] = createdAt;
    return data;
  }
}
