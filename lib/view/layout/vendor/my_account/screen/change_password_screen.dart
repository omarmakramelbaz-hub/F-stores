import 'package:easy_localization/easy_localization.dart';
import '../../../../../helpers/locale/app_locale_key.dart';
import '../../../../../helpers/theme/app_colors.dart';
import '../../../../../helpers/theme/app_text_style.dart';
import '../../../../custom_widgets/buttons/custom_button.dart';
import '../../../../custom_widgets/custom_app_bar/custom_app_bar.dart';
import '../../../../custom_widgets/custom_form_field/custom_form_field.dart';
import '../../../../custom_widgets/custom_image/custom_image.dart';
import '../../../../custom_widgets/validation/validation_mixin.dart';
import '../../auth/controller/auth_controller.dart';
import '../controller/my_account_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChangePasswordScreen extends StatefulWidget {
  static const String routeName = 'ChangePasswordScreen';
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> with ValidationMixin {
  final _currentPasswordEc = TextEditingController();
  final _newPasswordEc = TextEditingController();
  final _confirmPasswordEc = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    _currentPasswordEc.dispose();
    _newPasswordEc.dispose();
    _confirmPasswordEc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context,
        height: 80,
        centerTitle: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColor.blackColor(context)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        leadingPadding: 40,
        appBarColor: AppColor.whiteColor(context),
        title: Padding(
          padding: const EdgeInsets.only(bottom: 40),
          child: Text(AppLocaleKey.changePassword.tr(), style: AppTextStyle.text20BS(context)),
        ),
      ),
      body: SingleChildScrollView(
        child: ChangeNotifierProvider(
          create: (BuildContext context) => MyAccountController(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 35),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: AppColor.whiteColor(context),
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(34), topRight: Radius.circular(34)),
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.greyColor(context).withOpacity(0.2),
                      offset: const Offset(0, -3),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 26),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Container(
                              height: 56,
                              width: 56,
                              decoration: const BoxDecoration(shape: BoxShape.circle),
                              child: Center(
                                child: CustomImage(
                                  radius: 50,
                                  path: Provider.of<AuthController>(context).profile?.photoProfile ?? '',
                                  type: ImageType.network,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  Provider.of<AuthController>(context).profile?.name ?? '',
                                  style: AppTextStyle.textD18M(context),
                                ),
                                const SizedBox(width: 10),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    //   SvgPicture.asset(AppImages.flagIcon),
                                    const SizedBox(width: 10),
                                    Text(
                                      Provider.of<AuthController>(context).profile?.areaTitle ?? '',
                                      style: AppTextStyle.textL18R(context),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const Spacer(),
                          ],
                        ),
                      ),
                      const SizedBox(height: 29),
                      Divider(color: AppColor.greyColor(context).withOpacity(0.2), height: 2),
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Column(
                          children: [
                            CustomFormField(controller: _currentPasswordEc, title: AppLocaleKey.currentPassword.tr()),
                            const SizedBox(height: 30),
                            CustomFormField(
                              validator: validateNewPassword,
                              controller: _newPasswordEc,
                              title: AppLocaleKey.newPassword.tr(),
                            ),
                            const SizedBox(height: 30),
                            CustomFormField(
                              validator: validateConfirmPassword,
                              controller: _confirmPasswordEc,
                              title: AppLocaleKey.retypePassword.tr(),
                            ),
                            const SizedBox(height: 50),
                            Builder(
                              builder: (context) {
                                return CustomButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      context.read<MyAccountController>().changePassword(
                                        currentPassword: _currentPasswordEc.text,
                                        newPassword: _newPasswordEc.text,
                                        passwordConfirmation: _confirmPasswordEc.text,
                                        onSuccess: () {},
                                      );
                                    }
                                  },
                                  text: AppLocaleKey.saveChanges.tr(),
                                );
                              },
                            ),
                            const SizedBox(height: 50),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
