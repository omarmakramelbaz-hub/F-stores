import 'package:easy_localization/easy_localization.dart';
import '../../../../../helpers/locale/app_locale_key.dart';
import '../../../../custom_widgets/buttons/custom_button.dart';
import '../../../../global/bottom_sheet/dark_app_bottom_sheet.dart';
import '../controller/request_delegate_controller.dart';
import '../widget/payment_methoud_widget.dart';
import 'package:flutter/material.dart';

class PaymentRDBottomSheet extends StatelessWidget {
  const PaymentRDBottomSheet({super.key, required this.requestDelegateController});

  final RequestDelegateController requestDelegateController;

  @override
  Widget build(BuildContext context) {
    return DarkAppBottomSheet(
      title: AppLocaleKey.paymentMethod.tr(),
      isDark: true,
      children: [
        const SizedBox(height: 15),
        const ChoosePaymentMethodWidget(),
        const SizedBox(height: 15),
        CustomButton(
          text: AppLocaleKey.save.tr(),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
