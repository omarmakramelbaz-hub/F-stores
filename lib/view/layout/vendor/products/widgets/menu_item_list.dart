import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import '../../../../../helpers/locale/app_locale_key.dart';
import '../../../../../helpers/theme/app_colors.dart';
import '../../../../../helpers/theme/app_text_style.dart';
import '../../../../custom_widgets/custom_image/custom_image.dart';
import '../controller/product_controller.dart';
import '../model/product_model.dart';
import 'package:flutter/material.dart';

class MenuItemCheckBoxList extends StatefulWidget {
  const MenuItemCheckBoxList({
    super.key,
    required this.productModel,
    required this.length,
    required this.productController,
  });
  final List<ProductModel> productModel;
  final int length;
  final ProductController productController;

  @override
  State<MenuItemCheckBoxList> createState() => _MenuItemCheckBoxListState();
}

class _MenuItemCheckBoxListState extends State<MenuItemCheckBoxList> {
  List<int> selectedIndices = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        widget.productModel.length,
        (index) => InkWell(
          overlayColor: WidgetStateColor.resolveWith((states) => Colors.transparent),
          onTap: () {
            setState(() {
              // Toggle selection state
              if (selectedIndices.contains(index)) {
                selectedIndices.remove(index); // Unselect if already selected
                widget.productController.removeItemFromMenu(index: index);
              } else {
                selectedIndices.add(index); // Select the new item
                widget.productController.addItemToMenu(index: index);
              }
            });

            log(widget.productController.selectedProductIds.toString());
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                Checkbox.adaptive(
                  fillColor: WidgetStateColor.resolveWith((states) => AppColor.whiteColor(context)),
                  checkColor: AppColor.mainAppColor(context),
                  side: BorderSide(
                    color: selectedIndices.contains(index)
                        ? AppColor.mainAppColor(context)
                        : AppColor.greyColor(context),
                  ),
                  activeColor: AppColor.whiteColor(context),
                  value: selectedIndices.contains(index), // Check if this item is selected
                  onChanged: (value) {
                    setState(() {
                      // Toggle the checkbox based on user interaction
                      if (value == true) {
                        selectedIndices.add(index);
                        widget.productController.addItemToMenu(index: index);
                      } else {
                        selectedIndices.remove(index);
                        widget.productController.removeItemFromMenu(index: index);
                      }
                    });
                  },
                ),
                Container(
                  height: 70,
                  width: 120,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.greyColor(context).withOpacity(0.2),
                        offset: const Offset(0, 4),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: CustomImage(
                    path: widget.productModel[index].productImage ?? '',
                    type: ImageType.network,
                    height: 70,
                    width: 120,
                    radius: 12,
                    fit: BoxFit.fill,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Text(widget.productModel[index].productName ?? '', style: AppTextStyle.text16RS(context)),
                ),
                const SizedBox(width: 5),
                Text(
                  AppLocaleKey.pound.tr().replaceAll('{}', '${widget.productModel[index].productPrice}'),
                  style: AppTextStyle.text16RG(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
