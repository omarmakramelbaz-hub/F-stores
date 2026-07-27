import 'package:easy_localization/easy_localization.dart';
import '../../../../../helpers/routes/app_routers_import.dart';
import 'package:flutter/material.dart';

import '../../../../../helpers/locale/app_locale_key.dart';
import '../../../../custom_widgets/buttons/custom_button.dart';
import '../../../../global/bottom_sheet/app_bottom_sheet.dart';
import '../controller/order_controller.dart';
import '../model/vendor_orders_model.dart';

class AnotherRepresentativeBottomSheet extends StatelessWidget {
  const AnotherRepresentativeBottomSheet({
    super.key,
    required this.order,
    required this.orderController,
    required this.onSuccess,
  });
  final VendorOrdersModel? order;
  final OrderController orderController;
  final VoidCallback onSuccess;
  @override
  Widget build(BuildContext context) {
    return AppBottomSheet(
      title: AppLocaleKey.doYouWantToResetSearchAboutAnotherRepresentative.tr(),
      children: [
        CustomButton(
          text: AppLocaleKey.yes.tr(),
          onPressed: () {
            orderController.delverOrderFromOrOut(
              type: ' out_resturant',
              orderId: order?.id ?? 0,
              restaurantId: order?.resturantId ?? 0,
              onSuccess: () {
                NamedNavigatorImpl.pop(context);
                onSuccess.call();
              },
            );
            Navigator.pop(context);
          },
        ),
        const SizedBox(height: 20),
        // CustomButton(
        //   text: AppLocaleKey.innerDelegate.tr(),
        //   color: AppColor.whiteColor(context),
        //   borderColor: AppColor.mainAppColor(context),
        //   style: AppTextStyle.text16BS(context),
        //   onPressed: () {
        //     orderController.delverOrderFromOrOut(
        //         type: "in_resturant",
        //         orderId: order?.id ?? 0,
        //         restaurantId: order?.resturantId ?? 0,
        //         onSuccess: () {
        //           NavigatorMethods.pop(context);
        //           onSuccess.call();
        //         });
        //     Navigator.pop(context);
        //   },
        // ),
        // const SizedBox(height: 20),
      ],
    );
  }
}
