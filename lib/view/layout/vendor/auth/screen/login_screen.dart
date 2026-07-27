import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../helpers/hive/hive_methods.dart';
import '../../../../../helpers/locale/app_locale_key.dart';
import '../../../../../helpers/routes/app_routers_import.dart';
import '../../../../../helpers/theme/app_colors.dart';
import '../../../../../helpers/theme/app_text_style.dart';
import '../../../../../helpers/utils/gap.dart';
import '../../../../custom_widgets/buttons/custom_button.dart';
import '../../../../custom_widgets/custom_app_bar/custom_auth_app_bar.dart';
import '../../../../custom_widgets/custom_form_field/custom_form_field.dart';
import '../../../../custom_widgets/validation/validation_mixin.dart';
import '../../bottom_navigation/screen/bottom_navigation_bar_screen.dart';
import '../controller/auth_controller.dart';
import 'register_as_vendor.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const String routeName = 'LoginScreen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with ValidationMixin {
  final _mobileEc = TextEditingController();
  final _passwordEc = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  dispose() {
    _mobileEc.dispose();
    _passwordEc.dispose();
    super.dispose();
  }

  int userType = -1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAuthAppBar(context),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(AppLocaleKey.welcomeBack.tr(), style: AppTextStyle.textD20B(context)),
                  const SizedBox(width: 10),
                ],
              ),
              const Gap(15),
              Text(AppLocaleKey.welcomePleaseEnterYourAccountDetails.tr(), style: AppTextStyle.textL18R(context)),
              const Gap(25),
              CustomFormField(
                controller: _mobileEc,
                // validator: (v) => validatePhone(v, country: _country),
                // country: _country,
                title: AppLocaleKey.loginWithMobileOrEmail.tr(),
              ),
              const Gap(25),
              CustomFormField(
                controller: _passwordEc,
                // validator: validatePassword,
                title: AppLocaleKey.password.tr(),
                isPassword: true,
              ),
              const Gap(25),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomButton(
              text: AppLocaleKey.login.tr(),
              onPressed: () {
                log(userType.toString());
                if (_formKey.currentState!.validate()) {
                  context.read<AuthController>().login(
                        // onHaveIdANDToken: (id, token) {
                        //   context
                        //       .read<PusherController>()
                        //       .initPusher(channelName: 'private-user.$id', userId: id, token: token);
                        // },
                        mobile: _mobileEc.text,
                        password: _passwordEc.text,
                        onSuccess: (accountType) {
                          if (accountType == 'vendor') {
                            NamedNavigatorImpl.pushNamedAndRemoveUntil(
                                context, VendorBottomNavigationBarScreen.routeName);
                            if (context.read<AuthController>().profile?.kmPrice == 0 ||
                                context.read<AuthController>().profile?.kmPrice == null) {
                              HiveMethods.setIsFreeDelivery(true);
                            }
                          }
                        },
                      );
                }
              },
            ),
            const Gap(15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(AppLocaleKey.doNotHaveAccount.tr(), style: AppTextStyle.textD16M(context)),
                TextButton(
                  onPressed: () {
                    NamedNavigatorImpl.pushNamed(
                      context,
                      RegisterAsVendorScreen.routeName,
                      arguments: RegisterAsVendorScreenArgs(
                        onSuccess: () {
                          setState(() {});
                        },
                      ),
                    );
                  },
                  child: Text(
                    AppLocaleKey.createAccount.tr(),
                    style: AppTextStyle.textD16M(
                      context,
                    ).copyWith(fontWeight: FontWeight.bold, color: AppColor.mainAppColor(context)),
                  ),
                ),
              ],
            ),
            const Gap(15),
            // Text(
            //   AppLocaleKey.enterAsGuest.tr(),
            //   style: AppTextStyle.textD16M(context)
            //       .copyWith(decoration: TextDecoration.underline),
            // ),
            // const Gap(15),
          ],
        ),
      ),
    );
  }
}
