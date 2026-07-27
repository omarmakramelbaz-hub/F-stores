import 'dart:developer';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../helpers/locale/app_locale_key.dart';
import '../../../../../helpers/theme/app_colors.dart';
import '../../../../../helpers/theme/app_text_style.dart';
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

class ProductDetailsScreenArgs {
  final int productId;
  final VoidCallback onSuccess;

  ProductDetailsScreenArgs({required this.productId, required this.onSuccess});
}

class ProductDetailsScreen extends StatefulWidget {
  static const String routeName = 'ProductDetailsScreen';
  final ProductDetailsScreenArgs args;

  const ProductDetailsScreen({super.key, required this.args});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetailsScreen> with ValidationMixin {
  final _formKey = GlobalKey<FormState>();
  // final GlobalKey _accKey = GlobalKey();
  num? _mainCategoryId;
  num? _selectedCategoryId;
  num? _selectedSubCategoryId;
  num? _productClassId;
  num? _subCategoryId;
  File? _productImage;
  num? totalPrice;
  int? selectedProductId;
  bool? switchValue;
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
  initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<ProductController>().initialVendorSingleProduct();
      context.read<ProductController>().getVendorSingleProduct(productId: widget.args.productId).then((v) {
        context.read<ProductController>().initialCategories();
        context.read<ProductController>().getCategories();
        context.read<ProductController>().initialSubCategories();
        context.read<ProductController>().getSubCategories(
          parentId: context.read<ProductController>().vendorSingleProduct?.categoryId ?? 0,
        );
        context.read<ProductController>().initialProductClasses();
        context.read<ProductController>().getProductClasses(
          categoryId: context.read<ProductController>().vendorSingleProduct?.categoryId ?? 0,
          subcategoryId: context.read<ProductController>().vendorSingleProduct?.subCategoryId ?? 0,
        );
        _productNameEC.text = context.read<ProductController>().vendorSingleProduct?.productName ?? '';
        _productDescriptionEC.text = context.read<ProductController>().vendorSingleProduct?.productDescription ?? '';
        _totalPriceEC.text = context.read<ProductController>().vendorSingleProduct?.productPrice.toString() ?? '';
        _cleanPriceEC.text = context.read<ProductController>().vendorSingleProduct?.extraClean.toString() ?? '';
        _clearPriceEC.text = context.read<ProductController>().vendorSingleProduct?.extraClear.toString() ?? '';
        _vacuumPriceEC.text = context.read<ProductController>().vendorSingleProduct?.extraVacuim.toString() ?? '';
        _mediumPriceEC.text = context.read<ProductController>().vendorSingleProduct?.extraMedium.toString() ?? '';
        _largePriceEC.text = context.read<ProductController>().vendorSingleProduct?.extraLarge.toString() ?? '';
        _compoPriceEC.text = context.read<ProductController>().vendorSingleProduct?.extraCombo.toString() ?? '';

        _productClassId = context.read<ProductController>().vendorSingleProduct?.productId;
        _subCategoryId = context.read<ProductController>().vendorSingleProduct?.subCategoryId;
        selectedProductId = context.read<ProductController>().vendorSingleProduct?.id;
        _mainCategoryId = context.read<ProductController>().vendorSingleProduct?.categoryId;
        // _selectedCategoryId =
        //     context.read<ProductController>().vendorSingleProduct?.categoryId;
        // _selectedSubCategoryId = context
        //     .read<ProductController>()
        //     .vendorSingleProduct
        //     ?.subCategoryId;
        // _productImage = File(context
        //         .read<ProductController>()
        //         .vendorSingleProduct
        //         ?.productImage ??
        //     "");
        if (context.read<ProductController>().vendorSingleProduct?.status == 'hide') {
          switchValue = false;
        } else {
          switchValue = true;
        }
      });
    });
    super.initState();
    log(_productImage.toString());
    log(_selectedSubCategoryId.toString());
    log(_selectedCategoryId.toString());
    log(_mainCategoryId.toString());
    log(_productClassId.toString());
    log(_productNameEC.text.toString());
  }

  // @override
  // void dispose() {
  //   _productNameEC.dispose();
  //   _totalPriceEC.dispose();
  //   _cleanPriceEC.dispose();
  //   _clearPriceEC.dispose();
  //   _vacuumPriceEC.dispose();
  //   _mediumPriceEC.dispose();
  //   _largePriceEC.dispose();
  //   _compoPriceEC.dispose();
  //   _productDescriptionEC.dispose();

  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductController>(
      builder: (context, productController, _) {
        return Container(
          color: AppColor.whiteColor(context),
          child: ApiResponseWidget(
            apiResponse: productController.vendorSingleProductResponse,
            onReload: () => productController.getVendorSingleProduct(productId: widget.args.productId),
            isEmpty: productController.vendorSingleProduct == null,
            child: Scaffold(
              appBar: CustomAppBar(
                context,
                centerTitle: false,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: AppColor.blackColor(context)),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                appBarColor: AppColor.whiteColor(context),
                title: Text(
                  '${productController.vendorSingleProduct?.productName}',
                  style: AppTextStyle.text20BS(context),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Column(
                      children: [
                        CustomButton(
                          width: 100,
                          height: 40,
                          radius: 10,
                          color: AppColor.mainAppColor(context),
                          prefixIcon: Icon(Icons.delete_outline_outlined, color: AppColor.whiteColor(context)),
                          text: AppLocaleKey.delete.tr(),
                          onPressed: () {
                            productController.deleteProduct(
                              id: widget.args.productId,
                              onSuccess: () {
                                Navigator.pop(context);
                                Provider.of<ProductController>(context, listen: false).getProducts(
                                  // parentId: context
                                  //         .read<AuthController>()
                                  //         .profile
                                  //         ?.resturantParentId ??
                                  //     0
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(
                  //       left: 21, bottom: 30, right: 21, top: 20),
                  //   child: IconButton(
                  //       key: _accKey,
                  //       onPressed: () {
                  //         final RenderBox renderBox = _accKey.currentContext
                  //             ?.findRenderObject() as RenderBox;
                  //         final Size size = renderBox.size;
                  //         final Offset offset =
                  //             renderBox.localToGlobal(Offset.zero);
                  //         showMenu(
                  //             context: context,
                  //             shape: RoundedRectangleBorder(
                  //               borderRadius: BorderRadius.circular(10.0),
                  //             ),
                  //             position: RelativeRect.fromLTRB(
                  //                 offset.dx,
                  //                 offset.dy + size.height,
                  //                 offset.dx + size.width,
                  //                 offset.dy + size.height),
                  //             items: [
                  //               // PopupMenuItem<String>(
                  //               //     value: '1',
                  //               //     child: GestureDetector(
                  //               //         onTap: () {
                  //               //           setState(() {
                  //               //             //_editable = false;
                  //               //           });
                  //               //           Navigator.pop(context);
                  //               //         },
                  //               //         child: SizedBox(
                  //               //           height: 25,
                  //               //           child: Center(
                  //               //               child: Text(
                  //               //             AppLocaleKey.update.tr(),
                  //               //           )),
                  //               //         ))),
                  //               PopupMenuItem<String>(
                  //                 value: '2',
                  //                 child: GestureDetector(
                  //                   onTap: () {
                  //                     Navigator.pop(context);
                  //                     productController.deleteProduct(
                  //                         id: widget.args.productId,
                  //                         onSuccess: () {
                  //                           Navigator.pop(context);
                  //                           widget.args.onSuccess.call();
                  //                         });
                  //                   },
                  //                   child: SizedBox(
                  //                     height: 25,
                  //                     child: Center(
                  //                         child:
                  //                             Text(AppLocaleKey.delete.tr())),
                  //                   ),
                  //                 ),
                  //               ),
                  //             ]);
                  //       },
                  //       icon: const CustomImage(
                  //         path: AppImages.dotsMenuIcon,
                  //         type: ImageType.svg,
                  //       )),
                  // )
                ],
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text(_mainCategoryId.toString()),
                        // Text(_clearPriceEC.text.toString()),
                        // Text(_clearPriceEC.text.toString()),
                        // Text(_subCategoryId.toString()),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              switchValue == true ? AppLocaleKey.available.tr() : AppLocaleKey.notAvailable.tr(),
                              style: AppTextStyle.text14MS(context),
                            ),
                            const SizedBox(width: 20),
                            Switch.adaptive(
                              value: switchValue ?? true,
                              onChanged: (v) {
                                setState(() {
                                  productController.changeProductStatus(
                                    id: widget.args.productId,
                                    status: v.toString() == 'true' ? 'show' : 'hide',
                                    onSuccess: () {
                                      Provider.of<ProductController>(context, listen: false).getProducts();
                                    },
                                  );
                                  switchValue = v;
                                });
                              },
                            ),
                          ],
                        ),

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
                        productController.subCategory.isNotEmpty ||
                                productController.vendorSingleProduct?.subCategoryName != null
                            ? CustomSingleSelect(
                                apiResponse: productController.subCategoryResponse,
                                onReload: () => productController.getSubCategories(
                                  parentId:
                                      _selectedCategoryId ?? productController.vendorSingleProduct?.categoryId ?? 0,
                                ),
                                title: AppLocaleKey.subCategory.tr(),
                                validator: validateEmptyDropDown,
                                value: _subCategoryId,
                                onChanged: (value) {
                                  setState(() {
                                    _subCategoryId = value;
                                    productController.getProductClasses(
                                      categoryId:
                                          _selectedCategoryId ?? productController.vendorSingleProduct?.categoryId ?? 0,
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
                            categoryId: _selectedCategoryId ?? productController.vendorSingleProduct?.categoryId ?? 0,
                            subcategoryId:
                                _selectedSubCategoryId ?? productController.vendorSingleProduct?.subCategoryId ?? 0,
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
                              productController.getSingleProduct(
                                productId: selectedProductId ?? productController.vendorSingleProduct?.id ?? 0,
                              );
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
                                  if (productController.vendorSingleProduct?.features?.any(
                                        (element) => element.name == 'half',
                                      ) ==
                                      true)
                                    Expanded(
                                      child: CustomButton(
                                        borderColor: AppColor.textFormBorderColor(context),
                                        color: AppColor.whiteColor(context),
                                        text: AppLocaleKey.halfKiloPrice.tr().replaceAll(
                                          '{}',
                                          '${(totalPrice ?? 0) / 2}',
                                        ),
                                        style: AppTextStyle.text16RS(context),
                                      ),
                                    ),
                                  const SizedBox(width: 20),
                                  if (productController.vendorSingleProduct?.features?.any(
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
                        Column(
                          children: [
                            productController.vendorSingleProduct?.hasClean == 1
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
                                if (productController.vendorSingleProduct?.features?.any(
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
                                if (productController.vendorSingleProduct?.features?.any(
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
                                if (productController.vendorSingleProduct?.features?.any(
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

                        const SizedBox(height: 20),
                        Text(AppLocaleKey.addProductImage.tr(), style: AppTextStyle.formTitleStyle(context)),
                        const SizedBox(height: 20),
                        CustomImageContainer(
                          bgImage: productController.vendorSingleProduct?.productImage ?? '',
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
                          text: AppLocaleKey.saveChanges.tr(),
                          onPressed: () {
                            // if (_productImage == null) {
                            //   CommonMethods.showError(
                            //       message: AppLocaleKey.selectImage.tr());
                            // } else
                            if (_formKey.currentState!.validate()) {
                              productController.updateItem(
                                id: widget.args.productId,
                                productId: productController.vendorSingleProduct?.productId ?? 0,
                                productName: _productNameEC.text,
                                productDescription: _productDescriptionEC.text,
                                productImage: _productImage,
                                productPrice: int.tryParse(_totalPriceEC.text) ?? 0,
                                extraClearPrice: int.tryParse(_clearPriceEC.text) ?? 0,
                                extraCleanPrice: int.tryParse(_cleanPriceEC.text) ?? 0,
                                extraComboPrice: int.tryParse(_compoPriceEC.text) ?? 0,
                                extraMediumPrice: int.tryParse(_mediumPriceEC.text) ?? 0,
                                extraLargePrice: int.tryParse(_largePriceEC.text) ?? 0,
                                resturantId: context.read<AuthController>().profile?.resturantId ?? 0,
                                categoryId:
                                    _selectedCategoryId ?? productController.vendorSingleProduct?.categoryId ?? 0,
                                onSuccess: () {
                                  Provider.of<ProductController>(context, listen: false).getProducts();
                                  // _clearPriceEC.clear();
                                  // _clearPriceEC.clear();
                                  // _compoPriceEC.clear();
                                  // _largePriceEC.clear();
                                  // _mediumPriceEC.clear();
                                  //  Navigator.pop(context);
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
            ),
          ),
        );
      },
    );
  }
}
