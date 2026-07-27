import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helpers/locale/app_locale_key.dart';
import '../../../helpers/routes/app_routers_import.dart';
import '../../../helpers/theme/app_colors.dart';
import '../../../helpers/theme/app_text_style.dart';
import '../../custom_widgets/buttons/custom_button.dart';
import '../../layout/vendor/order/controller/order_controller.dart';
import '../../layout/vendor/order/model/vendor_orders_model.dart';
import 'app_bottom_sheet.dart';

class DeliverOrderBottomSheet extends StatelessWidget {
  const DeliverOrderBottomSheet({super.key, required this.order, this.onsuccess});
  final VendorOrdersModel order;
  final VoidCallback? onsuccess;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => OrderController(),
      child: Consumer<OrderController>(
        builder: (context, orderController, _) {
          return AppBottomSheet(
            title: AppLocaleKey.deliverOrderVia.tr(),
            children: [
              CustomButton(
                text: AppLocaleKey.restaurant.tr(),
                onPressed: () {
                  orderController.delverOrderFromOrOut(
                    type: 'in_resturant',
                    orderId: order.id!,
                    restaurantId: order.resturantId!,
                    onSuccess: () {
                      NamedNavigatorImpl.pop(context);
                      onsuccess?.call();
                    },
                  );
                },
              ),
              const SizedBox(height: 18),
              if (order.resturantKmPrice != 0 && order.resturantKmPrice != null)
                CustomButton(
                  text: AppLocaleKey.externalRepresentative.tr(),
                  style: AppTextStyle.text16BS(context),
                  color: Colors.transparent,
                  borderColor: AppColor.mainAppColor(context),
                  onPressed: () {
                    orderController.delverOrderFromOrOut(
                      type: ' out_resturant',
                      orderId: order.id!,
                      restaurantId: order.resturantId!,
                      onSuccess: () {
                        NamedNavigatorImpl.pop(context);
                        onsuccess?.call();
                      },
                    );
                  },
                ),
              const SizedBox(height: 28),
            ],
          );
        },
      ),
    );
  }
}
