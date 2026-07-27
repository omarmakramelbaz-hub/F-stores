import 'dart:io';

import 'package:dio/dio.dart';
import '../../../../../helpers/routes/app_routers_import.dart';
import 'package:flutter/material.dart';

import '../../../../../helpers/networking/api_helper.dart';
import '../../../../../helpers/networking/urls.dart';
import '../../../../../helpers/utils/common_methods.dart';
import '../model/category_model.dart';
import '../model/product_model.dart';
import '../model/single_product_model.dart';
import '../model/vendor_single_product_model.dart';

class ProductController extends ChangeNotifier {
  //=============================== get all items ====================
  List<ProductModel> _products = [];
  List<ProductModel> get products => _products;

  Set<dynamic> _productCategory = {};
  Set<dynamic> get productCategory => _productCategory;

  void initialProducts() {
    _productsResponse = ApiResponse(state: ResponseState.sleep, data: null);
    _products = [];
    _productCategory = {};
    notifyListeners();
  }

  ApiResponse _productsResponse = ApiResponse(state: ResponseState.sleep, data: null);
  ApiResponse get productsResponse => _productsResponse;

  Future<void> getProducts({int? parentId}) async {
    _productsResponse = ApiResponse(state: ResponseState.loading, data: null);
    _products = [];
    _productCategory = {};
    notifyListeners();

    _productsResponse = await ApiHelper.instance.get(
      Urls.getItems,
      queryParameters: {if (parentId != null) 'parent_id': parentId},
    );
    notifyListeners();

    if (_productsResponse.state == ResponseState.complete) {
      Iterable iterable = _productsResponse.data['data'];
      // Iterable iterable2 = _productsResponse.data['data']['category_id'];

      _products = iterable.map((e) => ProductModel.fromJson(e)).toList();
      // _productCategory = iterable2.map((e) => e).toSet();

      notifyListeners();
    }
  }

  //=============================== get all Categories =================
  void initialCategories() {
    _categoryResponse = ApiResponse(state: ResponseState.sleep, data: null);
    _category = [];
    notifyListeners();
  }

  ApiResponse _categoryResponse = ApiResponse(state: ResponseState.sleep, data: null);
  ApiResponse get categoryResponse => _categoryResponse;

  List<CategoryModel> _category = [];
  List<CategoryModel> get category => _category;

  Future<void> getCategories({int? parentId}) async {
    _categoryResponse = ApiResponse(state: ResponseState.loading, data: null);
    _category = [];
    notifyListeners();
    _categoryResponse = await ApiHelper.instance.get(
      Urls.getCategories,
      queryParameters: {if (parentId != null) 'parent_id': parentId},
    );
    notifyListeners();

    if (_categoryResponse.state == ResponseState.complete) {
      Iterable iterable = _categoryResponse.data['data'];
      _category = iterable.map((e) => CategoryModel.fromJson(e)).toList();
      notifyListeners();
    }
  }

  // ================================= product class (الصنف)  =============================
  void initialProductClasses() {
    _productClassesResponse = ApiResponse(state: ResponseState.sleep, data: null);
    _productClasses = [];
    notifyListeners();
  }

  ApiResponse _productClassesResponse = ApiResponse(state: ResponseState.sleep, data: null);
  ApiResponse get productClassesResponse => _productClassesResponse;

  List<CategoryModel> _productClasses = [];
  List<CategoryModel> get productClasses => _productClasses;

  Future<void> getProductClasses({required num categoryId, num? subcategoryId}) async {
    _productClassesResponse = ApiResponse(state: ResponseState.loading, data: null);
    _productClasses = [];
    notifyListeners();
    _productClassesResponse = await ApiHelper.instance.get(
      Urls.productClasses,
      queryParameters: {'category_id': categoryId, if (subcategoryId != null) 'subcategory_id': subcategoryId},
    );
    notifyListeners();

    if (_productClassesResponse.state == ResponseState.complete) {
      Iterable iterable = _productClassesResponse.data['data'];
      _productClasses = iterable.map((e) => CategoryModel.fromJson(e)).toList();
      notifyListeners();
    }
  }

  //================================== sub categories ======================
  void initialSubCategories() {
    _subCategoryResponse = ApiResponse(state: ResponseState.sleep, data: null);
    _subCategory = [];
    notifyListeners();
  }

  ApiResponse _subCategoryResponse = ApiResponse(state: ResponseState.sleep, data: null);
  ApiResponse get subCategoryResponse => _subCategoryResponse;

  List<CategoryModel> _subCategory = [];
  List<CategoryModel> get subCategory => _subCategory;

  Future<void> getSubCategories({required num parentId}) async {
    _subCategoryResponse = ApiResponse(state: ResponseState.loading, data: null);
    _subCategory = [];
    notifyListeners();
    _subCategoryResponse = await ApiHelper.instance.get(Urls.getCategories, queryParameters: {'parent_id': parentId});
    notifyListeners();

    if (_subCategoryResponse.state == ResponseState.complete) {
      Iterable iterable = _subCategoryResponse.data['data'];
      _subCategory = iterable.map((e) => CategoryModel.fromJson(e)).toList();
      notifyListeners();
    }
  }

  //=============================== create new item ====================
  Future<void> createItem({
    required int productId,
    required String productName,
    required String productDescription,
    required File productImage,
    num? productPrice,
    num? extraClearPrice,
    num? extraCleanPrice,
    num? extraVacuumPrice,
    num? extraComboPrice,
    num? extraMediumPrice,
    num? extraLargePrice,
    required int resturantId,
    required int categoryId,
    required VoidCallback onSuccess,
  }) async {
    NamedNavigatorImpl.loading();

    FormData body = FormData.fromMap({
      'product_id': productId,
      'product_name': productName,
      'product_description': productDescription,
      'product_image': await MultipartFile.fromFile(productImage.path),
      'product_price': productPrice,
      if (extraClearPrice != null) 'extra_clear': extraClearPrice,
      if (extraCleanPrice != null) 'extra_clean': extraCleanPrice,
      if (extraVacuumPrice != null) 'extra_vacuim': extraVacuumPrice,
      if (extraComboPrice != null) 'extra_combo': extraComboPrice,
      if (extraMediumPrice != null) 'extra_medium': extraMediumPrice,
      if (extraLargePrice != null) 'extra_large': extraLargePrice,
      'resturant_id': resturantId,
      'category_id': categoryId,
    });
    final response = await ApiHelper.instance.post(Urls.createItem, body: body);
    NamedNavigatorImpl.loadingOff();
    if (response.state == ResponseState.complete) {
      CommonMethods.showToast(message: response.data['message']);

      onSuccess.call();
      notifyListeners();
    } else {
      CommonMethods.showError(message: response.data['message'], apiResponse: response);
    }
  }

  //=================================update item============================
  Future<void> updateItem({
    required int id,
    required int productId,
    required String productName,
    required String productDescription,
    File? productImage,
    num? productPrice,
    num? extraClearPrice,
    num? extraCleanPrice,
    num? extraVacuum,
    num? extraComboPrice,
    num? extraMediumPrice,
    num? extraLargePrice,
    required int resturantId,
    required num categoryId,
    required VoidCallback onSuccess,
  }) async {
    NamedNavigatorImpl.loading();

    FormData body = FormData.fromMap({
      'product_id': productId,
      'product_name': productName,
      'product_description': productDescription,
      if (productImage != null) 'product_image': await MultipartFile.fromFile(productImage.path),
      'product_price': productPrice,
      if (extraClearPrice != null) 'extra_clear': extraClearPrice,
      if (extraCleanPrice != null) 'extra_clean': extraCleanPrice,
      if (extraComboPrice != null) 'extra_combo': extraComboPrice,
      if (extraMediumPrice != null) 'extra_medium': extraMediumPrice,
      if (extraLargePrice != null) 'extra_large': extraLargePrice,
      'resturant_id': resturantId,
      'category_id': categoryId,
    });
    final response = await ApiHelper.instance.post('${Urls.updateItem}$id', body: body);
    NamedNavigatorImpl.loadingOff();
    if (response.state == ResponseState.complete) {
      CommonMethods.showToast(message: response.data['message']);

      onSuccess.call();
      notifyListeners();
    } else {
      CommonMethods.showError(message: response.data['message'], apiResponse: response);
    }
  }

  //=================================== add to main menu ===========================
  final List<int> _selectedProductIds = [];
  List<int> get selectedProductIds => _selectedProductIds;
  void addItemToMenu({required int index}) {
    _selectedProductIds.add(_products[index].id!);
    notifyListeners();
  }

  void removeItemFromMenu({required int index}) {
    _selectedProductIds.remove(_products[index].id!);
    notifyListeners();
  }

  //=================================== copy main menu =============================

  Future<void> copyMainMenu({required VoidCallback onSuccess, required int resturantId}) async {
    if (_selectedProductIds.isEmpty) {
      return;
    }
    NamedNavigatorImpl.loading();
    FormData body = FormData.fromMap({'resturant_id': resturantId});
    for (int productId in selectedProductIds) {
      int id = _products.firstWhere((item) => item.id == productId).id ?? 0;
      body.fields.add(MapEntry('restraunt_product[$productId]', '$id'));
    }
    final response = await ApiHelper.instance.post(Urls.copeMainMenu, body: body);
    NamedNavigatorImpl.loadingOff();
    if (response.state == ResponseState.complete) {
      CommonMethods.showToast(message: response.data['message']);
      selectedProductIds.clear();

      notifyListeners();
      onSuccess.call();
    } else {
      CommonMethods.showError(message: response.data['message'], apiResponse: response);
    }
  }
  // =============================== get single Product ============================

  void initialSingleProduct() {
    _singleProductResponse = ApiResponse(state: ResponseState.sleep, data: null);
    _singleProduct = null;
    notifyListeners();
  }

  ApiResponse _singleProductResponse = ApiResponse(state: ResponseState.sleep, data: null);
  ApiResponse get singleProductResponse => _singleProductResponse;

  SingleProductModel? _singleProduct;
  SingleProductModel? get singleProduct => _singleProduct;
  Future<void> getSingleProduct({required int productId}) async {
    _singleProductResponse = ApiResponse(state: ResponseState.loading, data: null);
    notifyListeners();
    _singleProductResponse = await ApiHelper.instance.get('${Urls.singleProduct}$productId');
    notifyListeners();
    if (_singleProductResponse.state == ResponseState.complete) {
      _singleProduct = SingleProductModel.fromJson(_singleProductResponse.data['data']);
      notifyListeners();
    }
  }

  //================================= vendor single product =============================
  void initialVendorSingleProduct() {
    _vendorSingleProductResponse = ApiResponse(state: ResponseState.sleep, data: null);
    _vendorSingleProduct = null;
    notifyListeners();
  }

  ApiResponse _vendorSingleProductResponse = ApiResponse(state: ResponseState.sleep, data: null);
  ApiResponse get vendorSingleProductResponse => _vendorSingleProductResponse;

  VendorSingleProductModel? _vendorSingleProduct;
  VendorSingleProductModel? get vendorSingleProduct => _vendorSingleProduct;
  Future<void> getVendorSingleProduct({required int productId}) async {
    _vendorSingleProductResponse = ApiResponse(state: ResponseState.loading, data: null);
    notifyListeners();
    _vendorSingleProductResponse = await ApiHelper.instance.get('${Urls.vendorSingleProduct}$productId');
    notifyListeners();
    if (_vendorSingleProductResponse.state == ResponseState.complete) {
      _vendorSingleProduct = VendorSingleProductModel.fromJson(_vendorSingleProductResponse.data['data']);
      notifyListeners();
    }
  }

  // ==============================delete Product===========
  Future<void> deleteProduct({required int id, required VoidCallback onSuccess}) async {
    NamedNavigatorImpl.loading();

    final response = await ApiHelper.instance.delete('${Urls.deleteItem}$id');
    NamedNavigatorImpl.loadingOff();
    if (response.state == ResponseState.complete) {
      CommonMethods.showToast(message: response.data['message']);
      onSuccess.call();

      notifyListeners();
    } else {
      CommonMethods.showError(message: response.data['message'], apiResponse: response);
    }
  }
  //=> change product status

  Future<void> changeProductStatus({required int id, required String status, required VoidCallback onSuccess}) async {
    NamedNavigatorImpl.loading();
    final response = await ApiHelper.instance.put(Urls.changeProductStatus(id), queryParameters: {'status': status});
    NamedNavigatorImpl.loadingOff();
    if (response.state == ResponseState.complete) {
      CommonMethods.showToast(message: response.data['message']);
      onSuccess.call();
      notifyListeners();
    } else {
      CommonMethods.showError(apiResponse: response, message: response.data['message']);
    }
  }
}
