import 'package:easy_localization/easy_localization.dart';
import '../../../../../helpers/images/app_images.dart';
import '../../../../../helpers/locale/app_locale_key.dart';
import '../../../../../helpers/theme/app_colors.dart';
import '../../../../../helpers/theme/app_text_style.dart';
import '../../../../custom_widgets/custom_image/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PaymentWayOrderWidget extends StatelessWidget {
  const PaymentWayOrderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppLocaleKey.paymentMethod.tr(), style: AppTextStyle.text18BS(context)),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                height: 24,
                width: 5,
                decoration: BoxDecoration(
                  color: AppColor.mainAppColor(context),
                  borderRadius: BorderRadius.horizontal(
                    left: context.locale.languageCode == 'ar' ? const Radius.circular(5) : const Radius.circular(0),
                    right: context.locale.languageCode == 'ar' ? const Radius.circular(0) : const Radius.circular(5),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              CustomImage(
                height: 18,
                path: buildPaymentTypeIcon(paymentType: 'cash'),
                type: ImageType.svg,
                color: AppColor.mainAppColor(context),
              ),
              const SizedBox(width: 10),
              Text(buildPaymentTitle(paymentType: 'cash'), style: AppTextStyle.text16BM(context)),
            ],
          ),
        ],
      ),
    );
  }

  String buildPaymentTitle({required String paymentType}) {
    switch (paymentType) {
      case 'cash':
        return AppLocaleKey.cash.tr();
      case 'online':
        return AppLocaleKey.visa.tr();
      case 'v_cash':
        return AppLocaleKey.vfCash.tr();
      case 'wallet':
        return AppLocaleKey.appWallet.tr();
      default:
        return AppLocaleKey.cash.tr();
    }
  }

  String buildPaymentTypeIcon({required String paymentType}) {
    switch (paymentType) {
      case 'cash':
        return AppImages.cashIcon;
      case 'online':
        return AppImages.visaIcon;
      case 'v_cash':
        return AppImages.vfCash;
      case 'wallet':
        return AppImages.payWalletIcon.tr();
      default:
        return AppImages.cashIcon;
    }
  }
}
