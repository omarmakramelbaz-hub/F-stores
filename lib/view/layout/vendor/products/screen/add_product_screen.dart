import 'dart:developer';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import '../../../../../helpers/locale/app_locale_key.dart';
import '../../../../../helpers/theme/app_colors.dart';
import '../../../../../helpers/theme/app_text_style.dart';
import '../../../../../helpers/utils/common_methods.dart';
import '../../../../custom_widgets/api_response_widget/api_response_widget.dart';
import '../../../../custom_widgets/buttons/custom_button.dart';
import '../../../../custom_widgets/custom_app_bar/custom_app_bar.dart';
import '../../../../custom_widgets/custom_form_field/custom_form_field.dart';
import '../../../../custom_widgets/custom_select/custom_select_item.dart';
import '../../../../custom_widgets/custom_select/custom_single_select.dart';
import '../../../../custom_widgets/validation/validation_mixin.dart';
import '../../../../global/widget/custom_image_container.dart';
import '../../auth/controller/auth_controller.dart';
import '../controller/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddProductScreen extends StatefulWidget {
  static const String routeName = 'AddProductScreen';
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> with ValidationMixin {
  // final List<String> products = ["فسيخ", "رنجة", "سردين"];

  final _formKey = GlobalKey<FormState>();

  int? _mainCategoryId;
  int? _selectedCategoryId;
  int? _selectedSubCategoryId;
  int? _productClassId;
  int? _subCategoryId;
  File? _productImage;
  int? totalPrice;
  int? selectedProductId;
  final _productNameEC = TextEditingController();
  final _totalPriceEC = TextEditingController();
  final _cleanPriceEC = TextEditingController();
  final _clearPriceEC = TextEditingController();
  final _vacuumPriceEC = TextEditingController();
  final _mediumPriceEC = TextEditingController();
  final _largePriceEC = TextEditingController();
  final _compoPriceEC = TextEditingController();
  final _productDescriptionEC = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<ProductController>(context, listen: false).initialCategories();
      Provider.of<ProductController>(context, listen: false).getCategories();
    });
    super.initState();
  }

  @override
  void dispose() {
    _productNameEC.dispose();
    _totalPriceEC.dispose();
    _cleanPriceEC.dispose();
    _clearPriceEC.dispose();
    _vacuumPriceEC.dispose();
    _mediumPriceEC.dispose();
    _largePriceEC.dispose();
    _compoPriceEC.dispose();
    _productDescriptionEC.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductController>(
      builder: (context, productController, _) {
        return Scaffold(
          appBar: CustomAppBar(
            context,
            height: 80,
            centerTitle: false,
            leadingPadding: 40,
            title: Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Text(AppLocaleKey.addProduct.tr(), style: AppTextStyle.text20BW(context)),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomSingleSelect(
                      apiResponse: productController.categoryResponse,
                      title: AppLocaleKey.mainCategory.tr(),
                      validator: validateEmptyDropDown,
                      value: _mainCategoryId,
                      onReload: () => productController.getCategories(),
                      onChanged: (value) {
                        setState(() {
                          _mainCategoryId = value;
                          productController.getSubCategories(parentId: value);
                          _selectedCategoryId = productController.category
                              .where((e) => e.id == value)
                              .map((e) => e.id)
                              .first;
                          int? selectedClass = productController.category
                              .where((e) => e.id == value)
                              .map((e) => e.id)
                              .first;
                          productController.getProductClasses(categoryId: selectedClass!);
                        });
                      },
                      items: productController.category
                          .map((e) => CustomSelectItem(value: e.id, name: e.name ?? ''))
                          .toList(),
                    ),
                    const SizedBox(height: 20),
                    productController.subCategory.isNotEmpty
                        ? CustomSingleSelect(
                            apiResponse: productController.subCategoryResponse,
                            onReload: () => productController.getSubCategories(parentId: _selectedCategoryId!),
                            title: AppLocaleKey.subCategory.tr(),
                            validator: validateEmptyDropDown,
                            value: _subCategoryId,
                            onChanged: (value) {
                              setState(() {
                                _subCategoryId = value;
                                productController.getProductClasses(
                                  categoryId: _selectedCategoryId!,
                                  subcategoryId: value,
                                );
                              });
                              _selectedSubCategoryId = productController.subCategory
                                  .where((e) => e.id == _subCategoryId)
                                  .map((e) => e.parentId)
                                  .first;
                            },
                            items: productController.subCategory
                                .map((e) => CustomSelectItem(value: e.id, name: e.name ?? ''))
                                .toList(),
                          )
                        : const SizedBox(),
                    const SizedBox(height: 10),
                    CustomSingleSelect(
                      apiResponse: productController.productClassesResponse,
                      onReload: () => productController.getProductClasses(
                        categoryId: _selectedCategoryId!,
                        subcategoryId: _selectedSubCategoryId!,
                      ),
                      title: AppLocaleKey.chooseClass.tr(),
                      validator: validateEmptyDropDown,
                      value: _productClassId,
                      onChanged: (value) {
                        setState(() {
                          _productClassId = value;
                          selectedProductId = productController.productClasses
                              .where((e) => e.id == value)
                              .map((e) => e.id)
                              .first;
                          productController.getSingleProduct(productId: selectedProductId!);
                        });
                      },
                      items: productController.productClasses
                          .map((e) => CustomSelectItem(value: e.id, name: e.name ?? ''))
                          .toList(),
                    ),
                    const SizedBox(height: 20),

                    //========================================== end of single select ===========================================
                    CustomFormField(
                      controller: _productNameEC,
                      title: AppLocaleKey.productName.tr(),
                      validator: validateEmptyField,
                    ),
                    const SizedBox(height: 20),
                    //========================================== product Price ===========================================
                    CustomFormField(
                      controller: _totalPriceEC,
                      title: AppLocaleKey.totalProductPrice.tr(),
                      validator: validateEmptyField,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          totalPrice = int.tryParse(value) ?? 0;
                          log(totalPrice.toString());
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    totalPrice != null && _totalPriceEC.text.isNotEmpty
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (productController.singleProduct?.productFeatures?.any(
                                    (element) => element.name == 'half',
                                  ) ==
                                  true)
                                Expanded(
                                  child: CustomButton(
                                    borderColor: AppColor.textFormBorderColor(context),
                                    color: AppColor.whiteColor(context),
                                    text: AppLocaleKey.halfKiloPrice.tr().replaceAll('{}', '${(totalPrice ?? 0) / 2}'),
                                    style: AppTextStyle.text16RS(context),
                                  ),
                                ),
                              const SizedBox(width: 20),
                              if (productController.singleProduct?.productFeatures?.any(
                                    (element) => element.name == 'quarter',
                                  ) ==
                                  true)
                                Expanded(
                                  child: CustomButton(
                                    borderColor: AppColor.textFormBorderColor(context),
                                    color: AppColor.whiteColor(context),
                                    text: AppLocaleKey.quarterKiloPrice.tr().replaceAll(
                                      '{}',
                                      '${(totalPrice ?? 0) / 4}',
                                    ),
                                    style: AppTextStyle.text16RS(context),
                                  ),
                                ),
                            ],
                          )
                        : const SizedBox(),
                    const SizedBox(height: 10),

                    //========================================= Product Prices Column ==========================================
                    ApiResponseWidget(
                      apiResponse: productController.singleProductResponse,
                      onReload: () => productController.getSingleProduct(productId: selectedProductId!),
                      isEmpty: productController.singleProduct == null,
                      child: Column(
                        children: [
                          productController.singleProduct?.hasClean == 1
                              ? Column(
                                  children: [
                                    const SizedBox(height: 10),
                                    CustomFormField(
                                      controller: _cleanPriceEC,
                                      title: ' ext / ${AppLocaleKey.priceWithCleaning.tr()}',
                                      validator: validateEmptyField,
                                      keyboardType: TextInputType.number,
                                    ),
                                    const SizedBox(height: 20),
                                    CustomFormField(
                                      controller: _clearPriceEC,
                                      title: '  ext / ${AppLocaleKey.emptyFromBonsPrice.tr()}',
                                      validator: validateEmptyField,
                                      keyboardType: TextInputType.number,
                                    ),
                                    const SizedBox(height: 20),
                                    CustomFormField(
                                      controller: _vacuumPriceEC,
                                      title: ' ext / ${AppLocaleKey.vacuum.tr()}',
                                      validator: validateEmptyField,
                                      keyboardType: TextInputType.number,
                                    ),
                                  ],
                                )
                              : const SizedBox(),
                          //========================================= features column ================================
                          Column(
                            children: [
                              // const SizedBox(height: 10),
                              if (productController.singleProduct?.productFeatures?.any(
                                    (element) => element.name == 'combo',
                                  ) ==
                                  true)
                                CustomFormField(
                                  controller: _compoPriceEC,
                                  title: AppLocaleKey.combo.tr(),
                                  validator: validateEmptyField,
                                  keyboardType: TextInputType.number,
                                ),
                              const SizedBox(height: 20),
                              if (productController.singleProduct?.productFeatures?.any(
                                    (element) => element.name == 'large',
                                  ) ==
                                  true)
                                CustomFormField(
                                  controller: _largePriceEC,
                                  title: AppLocaleKey.large.tr(),
                                  validator: validateEmptyField,
                                  keyboardType: TextInputType.number,
                                ),
                              const SizedBox(height: 20),
                              if (productController.singleProduct?.productFeatures?.any(
                                    (element) => element.name == 'medium',
                                  ) ==
                                  true)
                                CustomFormField(
                                  controller: _mediumPriceEC,
                                  title: AppLocaleKey.medium.tr(),
                                  validator: validateEmptyField,
                                  keyboardType: TextInputType.number,
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                    Text(AppLocaleKey.addProductImage.tr(), style: AppTextStyle.formTitleStyle(context)),
                    const SizedBox(height: 20),
                    CustomImageContainer(
                      image: _productImage,
                      onSuccess: (v) {
                        setState(() {
                          _productImage = v;
                        });
                      },
                    ),
                    const SizedBox(height: 25),
                    CustomFormField(
                      controller: _productDescriptionEC,
                      title: AppLocaleKey.addDescription.tr(),
                      validator: validateEmptyField,
                      radius: 20,
                      maxLines: 8,
                    ),
                    const SizedBox(height: 25),
                    CustomButton(
                      text: AppLocaleKey.add.tr(),
                      onPressed: () {
                        if (_productImage == null) {
                          CommonMethods.showError(message: AppLocaleKey.selectImage.tr());
                        } else if (_formKey.currentState!.validate()) {
                          productController.createItem(
                            productId: productController.singleProduct?.id ?? 0,
                            productName: _productNameEC.text,
                            productDescription: _productDescriptionEC.text,
                            productImage: _productImage!,
                            productPrice: int.tryParse(_totalPriceEC.text) ?? 0,
                            extraClearPrice: int.tryParse(_clearPriceEC.text) ?? 0,
                            extraCleanPrice: int.tryParse(_clearPriceEC.text) ?? 0,
                            extraVacuumPrice: int.tryParse(_vacuumPriceEC.text) ?? 0,
                            extraComboPrice: int.tryParse(_compoPriceEC.text) ?? 0,
                            extraMediumPrice: int.tryParse(_mediumPriceEC.text) ?? 0,
                            extraLargePrice: int.tryParse(_largePriceEC.text) ?? 0,
                            resturantId: context.read<AuthController>().profile?.resturantId ?? 0,
                            categoryId: _selectedCategoryId!,
                            onSuccess: () {
                              _clearPriceEC.clear();
                              _cleanPriceEC.clear();
                              _compoPriceEC.clear();
                              _largePriceEC.clear();
                              _mediumPriceEC.clear();
                              Provider.of<ProductController>(context, listen: false).getProducts(
                                // parentId: context
                                //         .read<AuthController>()
                                //         .profile
                                //         ?.resturantParentId ??
                                //     0
                              );
                              Navigator.pop(context);
                            },
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 25),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
