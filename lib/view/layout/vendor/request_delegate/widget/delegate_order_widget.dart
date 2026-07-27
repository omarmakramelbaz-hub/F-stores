import 'package:easy_localization/easy_localization.dart';
import '../../../../../helpers/routes/app_routers_import.dart';
import 'package:flutter/material.dart';

import '../../../../../helpers/locale/app_locale_key.dart';
import '../../../../../helpers/theme/app_colors.dart';
import '../../../../../helpers/theme/app_text_style.dart';
import '../../../../../helpers/utils/date_methods.dart';
import '../model/request_delegate_order_model.dart';
import '../screen/tracking_delegate_order_screen.dart';

class DelegateOrderWidget extends StatelessWidget {
  const DelegateOrderWidget({super.key, required this.requestDelegateOrderModel});
  final RequestDelegateOrderModel requestDelegateOrderModel;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        NamedNavigatorImpl.pushNamed(
          context,
          TrackingDelegateOrderScreen.routeName,
          arguments: TrackingDelegateOrderArgs(id: requestDelegateOrderModel.id!),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: AppColor.whiteColor(context),
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: AppColor.greyColor(context).withOpacity(0.2),
                offset: const Offset(0, -3),
                blurRadius: 10,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(requestDelegateOrderModel.orderNo.toString(), style: AppTextStyle.text16ML(context)),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Text(
                      DateMethods.formatOrderDate(requestDelegateOrderModel.createdAt.toString()),
                      style: AppTextStyle.text16ML(context),
                    ),
                  ),
                  buildOrderStatusContainer(context: context, orderStatus: requestDelegateOrderModel.status ?? ''),
                ],
              ),
              const SizedBox(height: 10),
              Text(requestDelegateOrderModel.description.toString(), style: AppTextStyle.text16MS(context)),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocaleKey.pound.tr().replaceAll('{}', '${requestDelegateOrderModel.actualPrice}'),
                    style: AppTextStyle.text16RS(context),
                  ),
                  Text(
                    tr(AppLocaleKey.trackingYourOrder),
                    style: TextStyle(
                      color: AppColor.mainAppColor(context),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildOrderStatusContainer({required String orderStatus, required BuildContext context}) {
    switch (orderStatus) {
      case 'accepted':
        return Container(
          decoration: BoxDecoration(
            color: AppColor.yellowColor(context),
            borderRadius: const BorderRadius.all(Radius.circular(12)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Text(AppLocaleKey.orderAccepted.tr(), style: AppTextStyle.text14MW(context)),
          ),
        );
      case 'pending':
        return Container(
          decoration: BoxDecoration(
            color: AppColor.mainAppColor(context),
            borderRadius: const BorderRadius.all(Radius.circular(12)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Text(AppLocaleKey.pending.tr(), style: AppTextStyle.text14MW(context)),
          ),
        );
      case 'shipped':
        return Container(
          decoration: BoxDecoration(
            color: AppColor.greenColor(context),
            borderRadius: const BorderRadius.all(Radius.circular(12)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Text(AppLocaleKey.orderReceived.tr(), style: AppTextStyle.text14MW(context)),
          ),
        );

      case 'completed':
        return Container(
          decoration: BoxDecoration(
            color: AppColor.greyColor(context),
            borderRadius: const BorderRadius.all(Radius.circular(12)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Text(AppLocaleKey.orderDelivered.tr(), style: AppTextStyle.text14MW(context)),
          ),
        );
      case 'cancelled':
        return Container(
          decoration: BoxDecoration(
            color: AppColor.lightGreyColor(context),
            borderRadius: const BorderRadius.all(Radius.circular(12)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Text(AppLocaleKey.canceled.tr(), style: AppTextStyle.text14MS(context)),
          ),
        );
      case 'declined':
        return Container(
          decoration: BoxDecoration(
            color: AppColor.lightGreyColor(context),
            borderRadius: const BorderRadius.all(Radius.circular(12)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Text(AppLocaleKey.canceled.tr(), style: AppTextStyle.text14MS(context)),
          ),
        );
    }
    return Container();
  }
}
