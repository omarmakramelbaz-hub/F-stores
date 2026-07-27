import 'package:easy_localization/easy_localization.dart';
import '../../../../../helpers/locale/app_locale_key.dart';
import '../../../../../helpers/theme/app_text_style.dart';
import 'package:flutter/material.dart';

class TrackingOrderTitleWidget extends StatelessWidget {
  const TrackingOrderTitleWidget({super.key, required this.orderStatus});
  final String orderStatus;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 10),
      child: Text(buildOrderTitle(orderStatus: orderStatus), style: AppTextStyle.text18BS(context)),
    );
  }

  String buildOrderTitle({required String orderStatus}) {
    switch (orderStatus) {
      case 'pending':
        return AppLocaleKey.orderAcceptedFromDelegate.tr();
      case 'shipped':
        return AppLocaleKey.delegateAcceptedAndInRoute.tr();
      case 'Completed':
        return AppLocaleKey.orderDeliveredFromDelegate.tr();
      case 'cancelled':
        return AppLocaleKey.orderCancelled.tr();
      default:
        return AppLocaleKey.pending.tr();
    }
  }
}
