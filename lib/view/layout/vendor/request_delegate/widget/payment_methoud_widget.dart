import 'package:easy_localization/easy_localization.dart';
import '../../../../../helpers/images/app_images.dart';
import '../../../../../helpers/locale/app_locale_key.dart';
import '../../../../../helpers/theme/app_colors.dart';
import '../../../../../helpers/theme/app_text_style.dart';
import '../../../../custom_widgets/custom_image/custom_image.dart';
import '../../my_account/controller/my_account_controller.dart';
import '../controller/request_delegate_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChoosePaymentMethodWidget extends StatelessWidget {
  const ChoosePaymentMethodWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MyAccountController()
        ..initialSetting()
        ..getSetting(),
      child: Consumer<MyAccountController>(
        builder: (context, myAccountController, _) {
          return Column(
            children: [
              PaymentMethodWidget(
                label: AppLocaleKey.cash.tr(),
                selectedPayment: 'cash',
                leading: CustomImage(
                  path: AppImages.cashIcon,
                  type: ImageType.svg,
                  color: AppColor.whiteColor(context),
                ),
              ),
              const SizedBox(height: 16),
              PaymentMethodWidget(
                label: AppLocaleKey.appWalletBalance.tr(),
                selectedPayment: 'wallet',
                leading: CustomImage(
                  path: AppImages.payWalletIcon,
                  type: ImageType.svg,
                  color: AppColor.whiteColor(context),
                  height: 20,
                ),
              ),
              const SizedBox(height: 16),
              myAccountController.setting?.paymentCardActivate == 'true'
                  ? PaymentMethodWidget(
                      label: AppLocaleKey.creditCard.tr(),
                      selectedPayment: 'online',
                      leading: const CustomImage(path: AppImages.visaIcon, type: ImageType.svg),
                    )
                  : const SizedBox(),
              const SizedBox(height: 16),
              myAccountController.setting?.walletCardActivate == 'true'
                  ? PaymentMethodWidget(
                      label: AppLocaleKey.digitalWalletAndInstaPay.tr(),
                      selectedPayment: 'v_cash',
                      leading: CustomImage(
                        path: AppImages.digitalWallet,
                        type: ImageType.asset,
                        height: 25,
                        color: AppColor.whiteColor(context),
                      ),
                    )
                  : const SizedBox(),
            ],
          );
        },
      ),
    );
  }
}

class PaymentMethodWidget extends StatelessWidget {
  final String label;

  final String selectedPayment;
  final String? iconColor;
  final Widget leading;

  const PaymentMethodWidget({
    super.key,
    required this.label,
    required this.selectedPayment,
    this.iconColor,
    required this.leading,
  });

  @override
  Widget build(BuildContext context) {
    final requestDelegateController = context.watch<RequestDelegateController>();
    final isSelected = requestDelegateController.selectedPayment == selectedPayment;
    return InkWell(
      onTap: () => requestDelegateController.setSelectedPayment(selectedPayment),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppColor.blackColor(context),
          border: Border.all(
            color: isSelected ? AppColor.mainAppColor(context) : AppColor.borderColor(context),
            width: 1,
          ),
        ),
        child: Center(
          child: Row(
            children: [
              leading,
              const SizedBox(width: 10),
              Text(label, style: AppTextStyle.text16MS(context).copyWith(color: AppColor.whiteColor(context))),
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
