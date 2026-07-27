import 'package:easy_localization/easy_localization.dart';
import '../../../../../helpers/routes/app_routers_import.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../helpers/images/app_images.dart';
import '../../../../../helpers/locale/app_locale_key.dart';
import '../../../../../helpers/theme/app_colors.dart';
import '../../../../../helpers/theme/app_text_style.dart';
import '../../../../custom_widgets/api_response_widget/api_response_widget.dart';
import '../../../../custom_widgets/buttons/custom_button.dart';
import '../../../../custom_widgets/custom_app_bar/custom_app_bar.dart';
import '../../../../custom_widgets/custom_image/custom_image.dart';
import '../../auth/controller/auth_controller.dart';
import '../controller/product_controller.dart';
import '../widgets/menu_item_list.dart';
import 'add_product_screen.dart';

class AddNewMenuScreen extends StatefulWidget {
  static const String routeName = 'AddNewMenuScreen';
  const AddNewMenuScreen({super.key});

  @override
  State<AddNewMenuScreen> createState() => _AddNewMenuScreenState();
}

class _AddNewMenuScreenState extends State<AddNewMenuScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProductController()
        ..initialCategories()
        ..getCategories()
        ..initialProducts()
        ..getProducts(
            // parentId:
            //     context.read<AuthController>().profile?.resturantParentId ?? 0,
            ),
      child: Consumer<ProductController>(
        builder: (context, productController, _) {
          return Scaffold(
            extendBody: true,
            appBar: CustomAppBar(
              context,
              centerTitle: false,
              title: Text(AppLocaleKey.newMenu.tr(), style: AppTextStyle.text18BW(context)),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(top: 35, bottom: 35, left: 20, right: 20),
                  child: CustomButton(
                    prefixIcon: const CustomImage(path: AppImages.addIcon, type: ImageType.svg),
                    text: AppLocaleKey.addProduct.tr(),
                    style: AppTextStyle.text16MM(context),
                    width: MediaQuery.of(context).size.width / 2.5,
                    color: AppColor.whiteColor(context),
                    gap: 15,
                    onPressed: () {
                      NamedNavigatorImpl.pushNamed(context, AddProductScreen.routeName);
                    },
                  ),
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 5),
                child: ApiResponseWidget(
                  apiResponse: productController.productsResponse,
                  onReload: () => productController.getProducts(
                    parentId: context.read<AuthController>().profile?.resturantParentId ?? 0,
                  ),
                  isEmpty: productController.products.isEmpty,
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Text(
                                AppLocaleKey.chooseItemsThatYouWantToAddToList.tr(),
                                style: AppTextStyle.text16MS(context),
                              ),
                              Checkbox.adaptive(
                                fillColor: WidgetStateColor.resolveWith((states) => AppColor.whiteColor(context)),
                                checkColor: AppColor.mainAppColor(context),
                                side: BorderSide(color: AppColor.mainAppColor(context)),
                                activeColor: AppColor.whiteColor(context),
                                value: true, // Check if this item is selected
                                onChanged: (value) {},
                              ),
                            ],
                          ),
                          ...List.generate(productController.category.length, (index) {
                            // Filter products for the current category
                            var categoryProducts = productController.products
                                .where((product) => product.categoryId == productController.category[index].id)
                                .toList();

                            // If there are no products in this category, skip rendering
                            if (categoryProducts.isEmpty) {
                              return const SizedBox();
                            }

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 5),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 5),
                                  child: Text(
                                    productController.category[index].name ?? '',
                                    style: AppTextStyle.text18BS(context),
                                  ),
                                ),
                                MenuItemCheckBoxList(
                                  length: categoryProducts.length,
                                  productModel: categoryProducts,
                                  productController: productController,
                                ),
                                // ...List.generate(
                                //   categoryProducts.length,
                                //   (itemIndex) {
                                //     return CheckBoxProductItem(
                                //       productModel: categoryProducts[itemIndex],
                                //     );
                                //   },
                                // ),
                              ],
                            );
                          }),
                        ],
                      ),
                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              ),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(21.0),
              child: CustomButton(
                text: AppLocaleKey.addMenu.tr(),
                onPressed: () {
                  productController.copyMainMenu(
                    onSuccess: () {
                      NamedNavigatorImpl.pop(context);
                    },
                    resturantId: context.read<AuthController>().profile?.resturantId ?? 0,
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
