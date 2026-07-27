import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../helpers/locale/app_locale_key.dart';
import '../../../helpers/routes/app_routers_import.dart';
import '../../../helpers/theme/app_colors.dart';
import '../../../helpers/theme/app_text_style.dart';
import '../../custom_widgets/custom_image/custom_image.dart';
import '../../layout/vendor/order/bottom_sheet/update_order_bottom_sheet.dart';
import '../../layout/vendor/order/controller/order_controller.dart';
import '../../layout/vendor/order/model/vendor_orders_model.dart';

class OrderDetailsItemWidget extends StatelessWidget {
  const OrderDetailsItemWidget({
    super.key,
    required this.items,
    required this.orderController,
    required this.order,
    this.onSuccess,
  });

  final Items? items;
  final OrderController orderController;
  final VendorOrdersModel? order;
  final VoidCallback? onSuccess;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomImage(
            height: 83,
            width: 120,
            radius: 12,
            path: items?.resturantProduct?.productImage ?? '',
            type: ImageType.network,
            fit: BoxFit.cover,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  const TextSpan(text: '\n'),
                  TextSpan(text: items?.resturantProduct?.productName, style: AppTextStyle.text16RS(context)),
                  const TextSpan(text: '\n\n'),
                  items?.updatedTotal == null || items?.updatedTotal == 0
                      ? TextSpan(
                          text: AppLocaleKey.pound.tr().replaceAll('{}', '${items?.price}'),
                          style: AppTextStyle.text16RG(context),
                        )
                      : TextSpan(
                          text: AppLocaleKey.pound.tr().replaceAll('{}', '${items?.updatedTotal}'),
                          style: AppTextStyle.text16RG(context),
                        ),
                  const TextSpan(text: '\n'),
                  TextSpan(text: getProductClean(items?.productClean), style: AppTextStyle.text16RG(context)),
                  const TextSpan(text: '\n'),
                  TextSpan(
                    text: getProductFeatureName(items?.productFeatureName),
                    style: AppTextStyle.text16RG(context),
                  ),
                ],
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: 26,
                width: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: AppColor.lightGreyColor(context),
                ),
                child: Center(
                  child: Text(
                    '${items?.qty}',
                    style: AppTextStyle.text18BS(
                      context,
                    ).copyWith(height: context.locale.languageCode == 'ar' ? 1.7 : 1),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              (items?.productFeatureName == 'kilo' ||
                          items?.productFeatureName == 'half' ||
                          items?.productFeatureName == 'quarter') &&
                      (order?.status != 'shipped' && order?.status != 'completed' && order?.status != 'declined')
                  ? InkWell(
                      onTap: () {
                        NamedNavigatorImpl.showAppBottomSheet(
                          isScrollControlled: true,
                          context,
                          UpdateOrderBottomSheet(
                            itemId: items?.id ?? 0,
                            order: order,
                            orderController: orderController,
                            onSuccess: () {
                              onSuccess?.call();
                            },
                          ),
                        );
                      },
                      child: Container(
                        height: 26,
                        width: 45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: AppColor.lightGreyColor(context),
                        ),
                        child: Center(
                          child: Text(
                            AppLocaleKey.edit.tr(),
                            style: AppTextStyle.text14BS(context).copyWith(
                              height: context.locale.languageCode == 'ar' ? 1.7 : 1,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ],
      ),
    );
  }
}

String? getProductClean(String? productClean) {
  switch (productClean) {
    case 'extra_clean':
      return AppLocaleKey.clean.tr();
    case 'extra_clear':
      return AppLocaleKey.clear.tr();
    case 'extra_large':
      return AppLocaleKey.large.tr();
    case 'extra_medium':
      return AppLocaleKey.medium.tr();
    case 'extra_vacuim':
      return AppLocaleKey.vacuum.tr();
    case 'extra_combo':
      return AppLocaleKey.combo.tr();
    default:
      return '';
  }
}

String? getProductFeatureName(String? productFeatureName) {
  switch (productFeatureName) {
    case 'kilo':
      return AppLocaleKey.kilo.tr();
    case 'half':
      return AppLocaleKey.half.tr();
    case 'quarter':
      return AppLocaleKey.quarter.tr();
    default:
      return '';
  }
}
