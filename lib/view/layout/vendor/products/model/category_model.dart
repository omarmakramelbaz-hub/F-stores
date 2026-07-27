class CategoryModel {
  int? id;
  String? name;
  int? parentId;
  String? parentName;
  int? resturantProductsCount;
  String? createdAt;

  CategoryModel({this.id, this.name, this.parentId, this.parentName, this.resturantProductsCount, this.createdAt});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    parentId = json['parent_id'];
    parentName = json['parent_name'];
    resturantProductsCount = json['resturant_products_count'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['parent_id'] = parentId;
    data['parent_name'] = parentName;
    data['resturant_products_count'] = resturantProductsCount;
    data['created_at'] = createdAt;
    return data;
  }
}
