import 'package:easy_localization/easy_localization.dart';
import '../../../../../helpers/routes/app_routers_import.dart';
import 'package:flutter/material.dart';

import '../../../../../helpers/locale/app_locale_key.dart';
import '../../../../../helpers/theme/app_text_style.dart';
import '../../../../custom_widgets/buttons/custom_button.dart';
import '../../../../custom_widgets/custom_app_bar/custom_auth_app_bar.dart';
import '../../../../custom_widgets/custom_form_field/custom_form_field.dart';
import 'verification_code_screen.dart';

class ForgetPasswordScreen extends StatefulWidget {
  static const String routeName = 'ForgetPasswordScreen';
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAuthAppBar(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 21),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              Text(AppLocaleKey.didForgotPassword.tr(), style: AppTextStyle.text20BS(context)),
              const SizedBox(height: 15),
              Text(
                AppLocaleKey.donotWorryYouCanVerifyThePasswordThroughThePhoneRegisteredWithUs.tr(),
                style: AppTextStyle.text18RS(context),
              ),
              const SizedBox(height: 28),
              CustomFormField(title: AppLocaleKey.mobileNumber.tr(), keyboardType: TextInputType.phone),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomButton(
          text: AppLocaleKey.next.tr(),
          onPressed: () {
            NamedNavigatorImpl.pushNamed(context, VerificationCodeScreen.routeName);
          },
        ),
      ),
    );
  }
}
