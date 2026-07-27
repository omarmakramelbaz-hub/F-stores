import '../../../helpers/theme/app_colors.dart';
import '../../../helpers/theme/app_text_style.dart';
import '../../layout/vendor/order/model/vendor_orders_model.dart';
import 'package:flutter/material.dart';

class OrderItemWidget extends StatelessWidget {
  final Items? orderItem;
  const OrderItemWidget({super.key, this.orderItem});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
      child: Row(
        children: [
          Expanded(child: Text(orderItem?.resturantProduct?.productName ?? '', style: AppTextStyle.text16RS(context))),
          Container(
            height: 26,
            width: 45,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: AppColor.lightGreyColor(context)),
            child: Center(
              child: Text(orderItem?.qty.toString() ?? '', style: AppTextStyle.text18BS(context).copyWith(height: 1.6)),
            ),
          ),
        ],
      ),
    );
  }
}
