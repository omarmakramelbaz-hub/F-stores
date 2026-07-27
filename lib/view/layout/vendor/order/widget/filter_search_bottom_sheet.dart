import 'package:easy_localization/easy_localization.dart';
import '../../../../../helpers/images/app_images.dart';
import '../../../../../helpers/locale/app_locale_key.dart';
import '../../../../../helpers/theme/app_colors.dart';
import '../../../../../helpers/theme/app_text_style.dart';
import '../../../../../helpers/utils/date_methods.dart';
import '../../../../custom_widgets/buttons/custom_button.dart';
import '../../../../custom_widgets/custom_form_field/custom_form_field.dart';
import '../controller/order_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class FilterSearchBottomSheet extends StatefulWidget {
  const FilterSearchBottomSheet({super.key});

  @override
  State<FilterSearchBottomSheet> createState() => _FilterSearchBottomSheetState();
}

class _FilterSearchBottomSheetState extends State<FilterSearchBottomSheet> {
  int? indexDelivery;
  int? indexOrderStatus;
  final dateEc = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.whiteColor(context),
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(36), topRight: Radius.circular(36)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 33, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppLocaleKey.theFilter.tr(), style: AppTextStyle.text16BS(context)),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: AppColor.whiteColor(context),
                      child: SvgPicture.asset(AppImages.closeIcon),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Divider(thickness: 1, color: AppColor.lightGreyColor(context)),
            const SizedBox(height: 20),
            Text(AppLocaleKey.deliveryType.tr(), style: AppTextStyle.text16MS(context)),
            const SizedBox(height: 17),
            Row(
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      indexDelivery = 0;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      color: indexDelivery == 0 ? AppColor.mainAppColor(context) : AppColor.whiteColor(context),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppColor.borderColor(context)),
                    ),
                    child: Center(
                      child: Text(
                        AppLocaleKey.delegateInResturant.tr(),
                        style: indexDelivery == 0 ? AppTextStyle.text14MW(context) : AppTextStyle.text14MS(context),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 29),
                InkWell(
                  onTap: () {
                    setState(() {
                      indexDelivery = 1;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: indexDelivery == 1 ? AppColor.mainAppColor(context) : AppColor.whiteColor(context),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppColor.borderColor(context)),
                    ),
                    child: Center(
                      child: Text(
                        AppLocaleKey.delegateOutResturant.tr(),
                        style: indexDelivery == 1 ? AppTextStyle.text14MW(context) : AppTextStyle.text14MS(context),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 27),
            Text(AppLocaleKey.orderStatus.tr(), style: AppTextStyle.text16MS(context)),
            const SizedBox(height: 17),
            Row(
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      indexOrderStatus = 0;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      color: indexOrderStatus == 0 ? AppColor.mainAppColor(context) : AppColor.whiteColor(context),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppColor.borderColor(context)),
                    ),
                    child: Center(
                      child: Text(
                        AppLocaleKey.inPreparation.tr(),
                        style: indexOrderStatus == 0 ? AppTextStyle.text14MW(context) : AppTextStyle.text14MS(context),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 29),
                InkWell(
                  onTap: () {
                    setState(() {
                      indexOrderStatus = 1;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: indexOrderStatus == 1 ? AppColor.mainAppColor(context) : AppColor.whiteColor(context),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppColor.borderColor(context)),
                    ),
                    child: Center(
                      child: Text(
                        AppLocaleKey.shipped.tr(),
                        style: indexOrderStatus == 1 ? AppTextStyle.text14MW(context) : AppTextStyle.text14MS(context),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 27),
            Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: CustomFormField(
                controller: dateEc,
                readOnly: true,
                onTap: () {
                  DateMethods.pickDate(
                    context,
                    initialDate: DateTime.now(),
                    onSuccess: (date) {
                      dateEc.text = DateMethods.formatToDate(date.toString());
                    },
                  );
                },
                title: AppLocaleKey.date.tr(),
              ),
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: AppLocaleKey.filter.tr(),
              onPressed: () {
                context.read<OrderController>().ongoingOrderPage = 1;
                context.read<OrderController>().getVendorOngoingOrders(
                  date: dateEc.text,
                  type: indexOrderStatus == 0
                      ? 'accepted'
                      : indexOrderStatus == 1
                      ? 'shipped '
                      : null,
                  delegateFromOut: indexDelivery == 0
                      ? 'in_resturant'
                      : indexDelivery == 1
                      ? 'out_resturant'
                      : null,
                );
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
