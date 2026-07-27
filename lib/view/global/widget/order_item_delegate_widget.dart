import '../../../helpers/theme/app_colors.dart';
import '../../../helpers/theme/app_text_style.dart';
import 'package:flutter/material.dart';

class OrderItemDelegateWidget extends StatelessWidget {
  const OrderItemDelegateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
      child: Row(
        children: [
          Expanded(child: Text('فسيخ نبروة كيلو 4 قطع', style: AppTextStyle.text16RS(context))),
          Container(
            height: 26,
            width: 45,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: AppColor.lightGreyColor(context)),
            child: Center(child: Text('1', style: AppTextStyle.text18BS(context))),
          ),
        ],
      ),
    );
  }
}
