import 'package:easy_localization/easy_localization.dart';
import '../../../../../helpers/routes/app_routers_import.dart';
import 'package:flutter/material.dart';

import '../../../../../helpers/locale/app_locale_key.dart';
import '../../../../../helpers/theme/app_colors.dart';
import '../../../../../helpers/theme/app_text_style.dart';
import '../../../../custom_widgets/custom_image/custom_image.dart';
import '../model/product_model.dart';
import '../screen/product_details_screen.dart';

class ProductItemWidget extends StatelessWidget {
  const ProductItemWidget({super.key, required this.productModel, required this.onDeleted});
  final ProductModel productModel;
  final VoidCallback onDeleted;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        NamedNavigatorImpl.pushNamed(
          context,
          ProductDetailsScreen.routeName,
          arguments: ProductDetailsScreenArgs(productId: productModel.id ?? 0, onSuccess: onDeleted),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
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
                path: productModel.productImage ?? '',
                type: ImageType.network,
                height: 70,
                width: 120,
                radius: 12,
                fit: BoxFit.fill,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(child: Text(productModel.productName ?? '', style: AppTextStyle.text16RS(context))),
            const SizedBox(width: 5),
            productModel.status == 'show'
                ? Text(
                    AppLocaleKey.pound.tr().replaceAll('{}', '${productModel.productPrice}'),
                    style: AppTextStyle.text16RG(context),
                  )
                : Text(AppLocaleKey.notAvailable.tr(), style: AppTextStyle.text16RG(context)),
          ],
        ),
      ),
    );
  }
}
