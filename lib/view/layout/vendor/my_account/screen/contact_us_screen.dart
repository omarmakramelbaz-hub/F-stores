import 'package:easy_localization/easy_localization.dart';
import '../../../../../helpers/locale/app_locale_key.dart';
import '../../../../../helpers/theme/app_colors.dart';
import '../../../../../helpers/theme/app_text_style.dart';
import '../../../../custom_widgets/api_response_widget/api_response_widget.dart';
import '../../../../custom_widgets/buttons/custom_button.dart';
import '../../../../custom_widgets/custom_app_bar/custom_app_bar.dart';
import '../../../../custom_widgets/custom_form_field/custom_form_field.dart';
import '../../../../custom_widgets/validation/validation_mixin.dart';
import '../controller/my_account_controller.dart';
import '../widget/mobile_and_email_contact_us_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContactUsScreen extends StatefulWidget {
  static const String routeName = 'ContactUsScreen';
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> with ValidationMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameEc = TextEditingController();
  final _emailEc = TextEditingController();
  final _messages = TextEditingController();
  @override
  dispose() {
    _nameEc.dispose();
    _emailEc.dispose();
    _messages.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) {
        return MyAccountController()
          ..initialSetting()
          ..getSetting();
      },
      child: Consumer<MyAccountController>(
        builder: (context, myAccountController, _) => Form(
          key: _formKey,
          child: Scaffold(
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
              appBarColor: AppColor.whiteColor(context),
              leadingPadding: 40,
              title: Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Text(AppLocaleKey.connectWithUs.tr(), style: AppTextStyle.text20BS(context)),
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  ApiResponseWidget(
                    apiResponse: myAccountController.settingResponse,
                    onReload: myAccountController.getSetting,
                    isEmpty: myAccountController.setting == null,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: AppColor.whiteColor(context),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(34),
                          topRight: Radius.circular(34),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColor.greyColor(context).withOpacity(0.2),
                            offset: const Offset(0, -3),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                            child: Text(
                              myAccountController.setting?.contactText ?? '',
                              textAlign: TextAlign.justify,
                              style: AppTextStyle.text16RS(context),
                            ),
                          ),
                          const SizedBox(height: 6),
                          MobileAndEmailContactUsWidget(
                            mobile: myAccountController.setting?.mobile ?? '',
                            email: myAccountController.setting?.email ?? '',
                          ),
                          const SizedBox(height: 30),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              children: [
                                CustomFormField(
                                  controller: _nameEc,
                                  validator: validateEmptyField,
                                  title: AppLocaleKey.name.tr(),
                                ),
                                const SizedBox(height: 24),
                                CustomFormField(
                                  controller: _emailEc,
                                  validator: validateEmptyField,
                                  title: AppLocaleKey.email.tr(),
                                ),
                                const SizedBox(height: 24),
                                CustomFormField(
                                  contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                                  controller: _messages,
                                  validator: validateEmptyField,
                                  maxLines: 5,
                                  title: AppLocaleKey.theMessage.tr(),
                                ),
                                const SizedBox(height: 24),
                                CustomButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      context.read<MyAccountController>().storeContact(
                                        name: _nameEc.text,
                                        email: _emailEc.text,
                                        message: _messages.text,
                                        onSuccess: () {
                                          Navigator.pop(context);
                                        },
                                      );
                                    }
                                  },
                                  text: AppLocaleKey.send.tr(),
                                ),
                                const SizedBox(height: 24),
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
        ),
      ),
    );
  }
}
