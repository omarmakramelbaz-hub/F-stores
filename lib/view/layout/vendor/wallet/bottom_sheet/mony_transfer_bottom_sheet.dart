import 'package:country_picker/country_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../helpers/locale/app_locale_key.dart';
import '../../../../../helpers/theme/app_colors.dart';
import '../../../../../helpers/utils/common_methods.dart';
import '../../../../../helpers/utils/country_code_methods.dart';
import '../../../../custom_widgets/buttons/custom_button.dart';
import '../../../../custom_widgets/custom_form_field/custom_form_field.dart';
import '../../../../custom_widgets/validation/validation_mixin.dart';
import '../../../../global/bottom_sheet/app_bottom_sheet.dart';
import '../../auth/controller/auth_controller.dart';
import '../controller/wallet_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MoneyTransferBottomSheet extends StatefulWidget {
  const MoneyTransferBottomSheet({super.key, required this.walletController});
  final WalletController walletController;

  @override
  State<MoneyTransferBottomSheet> createState() => _MoneyTransferBottomSheetState();
}

class _MoneyTransferBottomSheetState extends State<MoneyTransferBottomSheet> with ValidationMixin {
  Country? _country;

  final chargeWalletFormKey = GlobalKey<FormState>();
  final chargeAmountEc = TextEditingController();
  final mobileEc = TextEditingController();
  final chargeAmountFocusNode = FocusNode();
  String _selectedAccountType = 'user';

  @override
  void initState() {
    _country = CountryCodeMethods.getByCode('20');
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
  }

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
                title: AppLocaleKey.moneyTransfer.tr(),
                children: [
                  const SizedBox(height: 21),
                  CustomFormField(
                    controller: mobileEc,
                    title: AppLocaleKey.mobileNumber.tr(),
                    keyboardType: TextInputType.phone,
                    hintText: AppLocaleKey.mobileNumber.tr(),
                    validator: (v) => validatePhone(v, country: _country),
                    country: _country,
                  ),
                  const SizedBox(height: 21),
                  CustomFormField(
                    title: AppLocaleKey.amountToBeTransferred.tr(),
                    hintText: AppLocaleKey.enterAmount.tr(),
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
                      } else if (double.tryParse(p0)! < 1 || double.parse(p0) > 5000 || p0.startsWith('0')) {
                        return AppLocaleKey.theMaximumTransferIs5000EGP.tr();
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 21),
                  ListTile(
                    title: Text(AppLocaleKey.user.tr()),
                    leading: Radio<String>(
                      activeColor: AppColor.mainAppColor(context),
                      value: 'user',
                      groupValue: _selectedAccountType,
                      onChanged: (value) {
                        setState(() {
                          _selectedAccountType = value!;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: Text(AppLocaleKey.delegate.tr()),
                    leading: Radio<String>(
                      activeColor: AppColor.mainAppColor(context),
                      value: 'delegate',
                      groupValue: _selectedAccountType,
                      onChanged: (value) {
                        setState(() {
                          _selectedAccountType = value!;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: Text(AppLocaleKey.vendor.tr()),
                    leading: Radio<String>(
                      activeColor: AppColor.mainAppColor(context),
                      value: 'vendor',
                      groupValue: _selectedAccountType,
                      onChanged: (value) {
                        setState(() {
                          _selectedAccountType = value!;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 21),
                  Builder(
                    builder: (context) {
                      return CustomButton(
                        text: AppLocaleKey.transfer.tr(),
                        onPressed: () {
                          if (chargeWalletFormKey.currentState!.validate()) {
                            CommonMethods.showChooseDialog(
                              context,
                              title: tr(AppLocaleKey.areYouSureYouWantToTransferTheAmount),
                              message: '',
                              onPressed: () {
                                Navigator.pop(context);
                                context.read<WalletController>().checkMonyTransfer(
                                  accountType: _selectedAccountType,
                                  mobile: mobileEc.text,
                                  amount: double.parse(chargeAmountEc.text),
                                  onSuccess: () {
                                    context.read<WalletController>().chargingMonyTransfer(
                                      accountType: _selectedAccountType,
                                      mobile: mobileEc.text,
                                      amount: double.parse(chargeAmountEc.text),
                                      onSuccess: () {
                                        Navigator.pop(context);
                                        context.read<WalletController>().getWallet();
                                        context.read<AuthController>().getProfile();
                                      },
                                    );
                                  },
                                );
                              },
                            );
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
