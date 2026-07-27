import 'package:easy_localization/easy_localization.dart';
import '../../../../../helpers/images/app_images.dart';
import '../../../../../helpers/locale/app_locale_key.dart';
import '../../../../../helpers/theme/app_colors.dart';
import '../../../../../helpers/theme/app_text_style.dart';
import '../../my_account/controller/my_account_controller.dart';
import '../controller/wallet_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class ChooseVCashOrVisaWidget extends StatelessWidget {
  const ChooseVCashOrVisaWidget({super.key, required this.myAccountController});
  final MyAccountController myAccountController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        myAccountController.setting?.paymentCardActivate == 'true'
            ? PaymentMethodWidget(
                icon: AppImages.visaIcon,
                label: AppLocaleKey.creditCard.tr(),
                selectedPayment: 'online',
              )
            : const SizedBox(),
        const SizedBox(height: 16),
        myAccountController.setting?.walletCardActivate == 'true'
            ? PaymentMethodWidget(
                icon: AppImages.digitalWallet,
                label: AppLocaleKey.digitalWalletAndInstaPay.tr(),
                selectedPayment: 'v_cash',
                isSvg: false,
              )
            : const SizedBox(),
      ],
    );
  }
}

class PaymentMethodWidget extends StatelessWidget {
  final String icon;
  final String label;
  final bool isSvg;
  final String selectedPayment;

  const PaymentMethodWidget({
    super.key,
    required this.icon,
    required this.label,
    this.isSvg = true,
    required this.selectedPayment,
  });

  @override
  Widget build(BuildContext context) {
    final walletController = context.watch<WalletController>();
    final isSelected = walletController.selectedPayment == selectedPayment;
    return InkWell(
      onTap: () => walletController.setSelectedPayment(selectedPayment),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppColor.whiteColor(context),
          border: Border.all(
            color: isSelected ? AppColor.mainAppColor(context) : AppColor.borderColor(context),
            width: 1,
          ),
        ),
        child: Center(
          child: Row(
            children: [
              isSvg ? SvgPicture.asset(icon) : Image.asset(icon, height: 25),
              const SizedBox(width: 10),
              Text(label, style: AppTextStyle.text16MS(context)),
              const Spacer(),
              isSelected
                  ? Container(
                      height: 16,
                      width: 16,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(width: 1.3, color: AppColor.mainAppColor(context)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: CircleAvatar(backgroundColor: AppColor.mainAppColor(context)),
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
