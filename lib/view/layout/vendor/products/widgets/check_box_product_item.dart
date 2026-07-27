import 'package:easy_localization/easy_localization.dart';
import '../../../../../helpers/locale/app_locale_key.dart';
import '../../../../../helpers/theme/app_colors.dart';
import '../../../../../helpers/theme/app_text_style.dart';
import '../../../../custom_widgets/custom_image/custom_image.dart';
import '../model/product_model.dart';
import 'package:flutter/material.dart';

class CheckBoxProductItem extends StatefulWidget {
  const CheckBoxProductItem({super.key, required this.productModel});
  final ProductModel productModel;
  @override
  State<CheckBoxProductItem> createState() => _CheckBoxProductItemState();
}

class _CheckBoxProductItemState extends State<CheckBoxProductItem> {
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      overlayColor: WidgetStateColor.resolveWith((states) => Colors.transparent),
      onTap: () {
        setState(() {
          isChecked = !isChecked;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Checkbox.adaptive(
              fillColor: WidgetStateColor.resolveWith((states) => AppColor.whiteColor(context)),
              checkColor: AppColor.mainAppColor(context),
              side: BorderSide(color: isChecked ? AppColor.mainAppColor(context) : AppColor.greyColor(context)),
              activeColor: AppColor.whiteColor(context),
              value: isChecked,
              onChanged: (value) {
                setState(() {
                  isChecked = value!;
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
                path: widget.productModel.productImage ?? '',
                type: ImageType.network,
                height: 70,
                width: 120,
                radius: 12,
                fit: BoxFit.fill,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(child: Text(widget.productModel.productName ?? '', style: AppTextStyle.text16RS(context))),
            const SizedBox(width: 5),
            Text(
              AppLocaleKey.pound.tr().replaceAll('{}', '${widget.productModel.productPrice}'),
              style: AppTextStyle.text16RG(context),
            ),
          ],
        ),
      ),
    );
  }
}
