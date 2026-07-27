import '../../../../../helpers/theme/app_text_style.dart';
import '../../../../custom_widgets/api_response_widget/api_response_widget.dart';
import '../controller/product_controller.dart';
import '../widgets/product_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// class ProductsScreenArgs {
//   final VoidCallback onSuccess;

//   ProductsScreenArgs({required this.onSuccess});
// }

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductController>(context, listen: false)
        ..initialCategories()
        ..getCategories()
        ..initialProducts()
        ..getProducts(
          // parentId:
          //     context.read<AuthController>().profile?.resturantParentId
        );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductController>(
      builder: (context, productController, _) {
        return Scaffold(
          body: RefreshIndicator(
            onRefresh: () async {
              productController.getProducts(
                // parentId:
                //     context.read<AuthController>().profile?.resturantParentId ??
                //         0
              );
            },
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 5),
                child: Column(
                  children: [
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.end,
                    //   children: [
                    //     CustomButton(
                    //       onPressed: () {
                    //         productController.getProducts(
                    //             // parentId: context
                    //             //         .read<AuthController>()
                    //             //         .profile
                    //             //         ?.resturantParentId ??
                    //             //     0
                    //             );
                    //       },
                    //       height: 35,
                    //       width: 90,
                    //       prefixIcon: Icon(
                    //         Icons.refresh,
                    //         color: AppColor.whiteColor(context),
                    //       ),
                    //       text: AppLocaleKey.refresh.tr(),
                    //       style: AppTextStyle.text16BW(context),
                    //       color: AppColor.mainAppColor(context),
                    //     ),
                    //   ],
                    // ),
                    Center(
                      child: ApiResponseWidget(
                        apiResponse: productController.productsResponse,
                        onReload: () => productController.getProducts(
                          // parentId: context
                          //         .read<AuthController>()
                          //         .profile
                          //         ?.resturantParentId ??
                          //     0
                        ),
                        isEmpty: productController.products.isEmpty,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                                  const SizedBox(height: 30),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 5),
                                    child: Text(
                                      productController.category[index].name ?? '',
                                      style: AppTextStyle.text18BS(context),
                                    ),
                                  ),
                                  ...List.generate(categoryProducts.length, (itemIndex) {
                                    return ProductItemWidget(
                                      productModel: categoryProducts[itemIndex],
                                      onDeleted: () {
                                        productController.getProducts(
                                          // parentId: context
                                          //         .read<AuthController>()
                                          //         .profile
                                          //         ?.resturantParentId ??
                                          //     0
                                        );
                                      },
                                    );
                                  }),
                                ],
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 120),
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
