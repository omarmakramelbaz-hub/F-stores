import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import '../../../../../helpers/routes/app_routers_import.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../helpers/locale/app_locale_key.dart';
import '../../../../../helpers/utils/common_methods.dart';
import '../../../../custom_widgets/buttons/custom_button.dart';
import '../../../../custom_widgets/custom_form_field/custom_form_field.dart';
import '../../../../custom_widgets/custom_payment_web_view/custom_payment_web_view.dart';
import '../../../../global/bottom_sheet/app_bottom_sheet.dart';
import '../../auth/controller/auth_controller.dart';
import '../../my_account/controller/my_account_controller.dart';
import '../controller/wallet_controller.dart';
import '../widget/chooseVCashOrVisaWidget.dart';

class ChargeWalletBottomSheet extends StatefulWidget {
  const ChargeWalletBottomSheet({super.key, required this.walletController, required this.myAccountController});
  final WalletController walletController;
  final MyAccountController myAccountController;

  @override
  State<ChargeWalletBottomSheet> createState() => _ChargeWalletBottomSheetState();
}

class _ChargeWalletBottomSheetState extends State<ChargeWalletBottomSheet> {
  final chargeWalletFormKey = GlobalKey<FormState>();
  final chargeAmountEc = TextEditingController();
  final chargeAmountFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Form(
              key: chargeWalletFormKey,
              child: AppBottomSheet(
                title: AppLocaleKey.walletCharging.tr(),
                children: [
                  CustomFormField(
                    title: AppLocaleKey.chargeAmount.tr(),
                    controller: chargeAmountEc,
                    keyboardType: TextInputType.number,
                    focusNode: chargeAmountFocusNode,
                    onFieldSubmitted: (p0) {
                      chargeAmountFocusNode.unfocus();
                    },
                    validator: (p0) {
                      if (p0 == null || p0.isEmpty) {
                        return AppLocaleKey.enterAmount.tr();
                      } else if (p0.contains('.') ||
                          p0.contains(',') ||
                          p0.contains('-') ||
                          p0.contains('+') ||
                          p0.contains(' ') ||
                          p0.contains('*') ||
                          p0.contains('/')) {
                        return AppLocaleKey.enterAmount.tr();
                      } else if (double.tryParse(p0)! < 50) {
                        return AppLocaleKey.minimumChargeAmount.tr().replaceAll('{}', '50');
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 21),
                  ChooseVCashOrVisaWidget(myAccountController: widget.myAccountController),
                  const SizedBox(height: 21),
                  Builder(
                    builder: (context) {
                      return CustomButton(
                        text: AppLocaleKey.payNow.tr(),
                        onPressed: () {
                          if (chargeWalletFormKey.currentState!.validate() &&
                              widget.walletController.selectedPayment != null) {
                            context.read<WalletController>().chargingWallet(
                                  amount: chargeAmountEc.text,
                                  onSuccess: (link) {
                                    log(link);
                                    // UrlLauncherMethods.launchInBrowser(link);
                                    NamedNavigatorImpl.pushNamed(
                                      context,
                                      CustomPaymentWebViewScreen.routeName,
                                      arguments: PaymentArgs(
                                        url: link,
                                        onFailed: () {},
                                        onSuccess: () {
                                          Navigator.pop(context);
                                          widget.walletController.getWallet();
                                          context.read<AuthController>().getProfile();
                                        },
                                      ),
                                    );
                                    //
                                  },
                                );
                          }
                          if (widget.walletController.selectedPayment == null) {
                            CommonMethods.showError(message: AppLocaleKey.youMustChoosePaymentMethod.tr());
                          }
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
