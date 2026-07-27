import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../helpers/routes/app_routers_import.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../helpers/locale/app_locale_key.dart';
import '../../../../../helpers/theme/app_text_style.dart';
import '../../../../../helpers/utils/common_methods.dart';
import '../../../../../helpers/utils/country_code_methods.dart';
import '../../../../custom_widgets/api_response_widget/api_response_widget.dart';
import '../../../../custom_widgets/buttons/custom_button.dart';
import '../../../../custom_widgets/custom_app_bar/custom_auth_app_bar.dart';
import '../../../../custom_widgets/custom_form_field/custom_form_field.dart';
import '../../../../custom_widgets/validation/validation_mixin.dart';
import '../../../../global/widget/custom_image_container.dart';
import '../../my_account/controller/my_account_controller.dart';
import '../controller/vendor_controller.dart';
import 'contract_vendor_screen.dart';
import 'login_screen.dart';

class RegisterAsVendorScreenArgs {
  final VoidCallback onSuccess;

  RegisterAsVendorScreenArgs({required this.onSuccess});
}

class RegisterAsVendorScreen extends StatefulWidget {
  static const String routeName = 'RegisterAsVendorScreen';
  final RegisterAsVendorScreenArgs args;

  const RegisterAsVendorScreen({super.key, required this.args});

  @override
  State<RegisterAsVendorScreen> createState() => _RegisterAsVendorScreenState();
}

class _RegisterAsVendorScreenState extends State<RegisterAsVendorScreen> with ValidationMixin {
  final _formKey = GlobalKey<FormState>();

  // Text Editing Controllers
  final _merchantNameEc = TextEditingController();
  final _ownerNameEc = TextEditingController();
  final _branchesCountEc = TextEditingController();
  final _nationalIdEc = TextEditingController();
  final _taxIdEc = TextEditingController();
  final _commercialRegistrationEc = TextEditingController();
  final _phoneNumberOneEc = TextEditingController();
  final _phoneNumberTwoEc = TextEditingController();
  final _vodafoneCashNumber = TextEditingController();
  final _emailEc = TextEditingController();

  // FocusNodes
  final _merchantNameFocus = FocusNode();
  final _ownerNameFocus = FocusNode();
  final _branchesCountFocus = FocusNode();
  final _nationalIdFocus = FocusNode();
  final _taxIdFocus = FocusNode();
  final _commercialRegistrationFocus = FocusNode();
  final _phoneNumberOneFocus = FocusNode();
  final _phoneNumberTwoFocus = FocusNode();
  final _vodafoneCashFocus = FocusNode();
  final _emailFocus = FocusNode();

  File? _idImage;
  File? _taxImage;
  File? _commercialRegistrationImage;
  Country? _country;

  @override
  void initState() {
    _country = CountryCodeMethods.getByCode('20');
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MyAccountController>().initialSetting();
      context.read<MyAccountController>().getSetting();
    });
  }

  @override
  void dispose() {
    // Dispose Controllers and FocusNodes
    _merchantNameEc.dispose();
    _ownerNameEc.dispose();
    _branchesCountEc.dispose();
    _nationalIdEc.dispose();
    _taxIdEc.dispose();
    _commercialRegistrationEc.dispose();
    _phoneNumberOneEc.dispose();
    _phoneNumberTwoEc.dispose();
    _vodafoneCashNumber.dispose();
    _emailEc.dispose();

    _merchantNameFocus.dispose();
    _ownerNameFocus.dispose();
    _branchesCountFocus.dispose();
    _nationalIdFocus.dispose();
    _taxIdFocus.dispose();
    _commercialRegistrationFocus.dispose();
    _phoneNumberOneFocus.dispose();
    _phoneNumberTwoFocus.dispose();
    _vodafoneCashFocus.dispose();
    _emailFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // bool isChecked = false;
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        widget.args.onSuccess.call();
      },
      child: Consumer<MyAccountController>(
        builder: (context, myAccountController, _) {
          bool hideInputs = myAccountController.setting?.delegateVendorSmallInfo == '1';
          return Scaffold(
            appBar: CustomAuthAppBar(context),
            body: ApiResponseWidget(
              apiResponse: myAccountController.settingResponse,
              onReload: () => myAccountController.getSetting(),
              isEmpty: myAccountController.setting == null,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 21),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 25),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(AppLocaleKey.startAsMerchant.tr(), style: AppTextStyle.text20BS(context)),
                        ),
                        const SizedBox(height: 23),
                        CustomFormField(
                          controller: _merchantNameEc,
                          focusNode: _merchantNameFocus,
                          title: AppLocaleKey.merchantName.tr(),
                          validator: validateName,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(_ownerNameFocus);
                          },
                        ),
                        const SizedBox(height: 23),
                        CustomFormField(
                          controller: _ownerNameEc,
                          focusNode: _ownerNameFocus,
                          title: AppLocaleKey.ownerName.tr(),
                          validator: validateName,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(_branchesCountFocus);
                          },
                        ),
                        const SizedBox(height: 23),
                        CustomFormField(
                          controller: _branchesCountEc,
                          focusNode: _branchesCountFocus,
                          title: AppLocaleKey.branchesCount.tr(),
                          validator: validateEmptyField,
                          keyboardType: TextInputType.number,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(_nationalIdFocus);
                          },
                        ),
                        hideInputs ? Container() : const SizedBox(height: 23),
                        hideInputs
                            ? Container()
                            : CustomFormField(
                                controller: _nationalIdEc,
                                focusNode: _nationalIdFocus,
                                title: AppLocaleKey.nationalId.tr(),
                                validator: validateNationalId,
                                keyboardType: TextInputType.number,
                                onFieldSubmitted: (_) {
                                  FocusScope.of(context).requestFocus(_taxIdFocus);
                                },
                              ),
                        hideInputs ? Container() : const SizedBox(height: 23),
                        hideInputs
                            ? Container()
                            : CustomFormField(
                                controller: _taxIdEc,
                                focusNode: _taxIdFocus,
                                title: AppLocaleKey.taxNumber.tr(),
                                validator: validateEmptyField,
                                keyboardType: TextInputType.number,
                                onFieldSubmitted: (_) {
                                  FocusScope.of(context).requestFocus(_commercialRegistrationFocus);
                                },
                              ),
                        hideInputs ? Container() : const SizedBox(height: 23),
                        hideInputs
                            ? Container()
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(AppLocaleKey.nationalIdImage.tr(), style: AppTextStyle.text16RS(context)),
                                  const SizedBox(width: 1),
                                  Text(AppLocaleKey.taxNumberImage.tr(), style: AppTextStyle.text16RS(context)),
                                  const SizedBox(width: 1),
                                ],
                              ),
                        hideInputs ? Container() : const SizedBox(height: 15),
                        //========================== images (nationalIdImage, taxNumberImage ) ===========================
                        hideInputs
                            ? Container()
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomImageContainer(
                                    image: _idImage,
                                    onSuccess: (v) {
                                      setState(() {
                                        _idImage = v;
                                      });
                                    },
                                  ),
                                  CustomImageContainer(
                                    image: _taxImage,
                                    onSuccess: (v) {
                                      setState(() {
                                        _taxImage = v;
                                      });
                                    },
                                  ),
                                ],
                              ),
                        hideInputs ? Container() : const SizedBox(height: 23),
                        hideInputs
                            ? Container()
                            : CustomFormField(
                                controller: _commercialRegistrationEc,
                                focusNode: _commercialRegistrationFocus,
                                title: AppLocaleKey.commercialRegistrationNumber.tr(),
                                validator: validateEmptyField,
                                keyboardType: TextInputType.number,
                                onFieldSubmitted: (_) {
                                  FocusScope.of(context).requestFocus(_phoneNumberOneFocus);
                                },
                              ),
                        hideInputs ? Container() : const SizedBox(height: 23),
                        hideInputs
                            ? Container()
                            : Text(
                                AppLocaleKey.commercialRegistrationImage.tr(),
                                style: AppTextStyle.text16RS(context),
                              ),
                        hideInputs ? Container() : const SizedBox(height: 15),
                        hideInputs
                            ? Container()
                            : CustomImageContainer(
                                image: _commercialRegistrationImage,
                                onSuccess: (v) {
                                  setState(() {
                                    _commercialRegistrationImage = v;
                                  });
                                },
                              ),
                        const SizedBox(height: 23),
                        CustomFormField(
                          validator: (v) => validatePhone(v, country: _country),
                          controller: _phoneNumberOneEc,
                          focusNode: _phoneNumberOneFocus,
                          title: AppLocaleKey.firstPhoneNumber.tr(),
                          keyboardType: TextInputType.phone,
                          country: _country,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(_phoneNumberTwoFocus);
                          },
                        ),
                        hideInputs ? Container() : const SizedBox(height: 23),
                        hideInputs
                            ? Container()
                            : CustomFormField(
                                // //  validator: (v) => validatePhone(v, country: _country),
                                controller: _phoneNumberTwoEc,
                                focusNode: _phoneNumberTwoFocus,
                                title: AppLocaleKey.secondPhoneNumber.tr(),
                                keyboardType: TextInputType.phone,
                                country: _country,
                                onFieldSubmitted: (_) {
                                  FocusScope.of(context).requestFocus(_vodafoneCashFocus);
                                },
                              ),
                        hideInputs ? Container() : const SizedBox(height: 23),
                        hideInputs
                            ? Container()
                            : CustomFormField(
                                validator: (v) => validateVCash(v, country: _country),
                                controller: _vodafoneCashNumber,
                                focusNode: _vodafoneCashFocus,
                                title: AppLocaleKey.vodafonCashNumber.tr(),
                                keyboardType: TextInputType.number,
                                country: _country,
                                onFieldSubmitted: (_) {
                                  FocusScope.of(context).requestFocus(_emailFocus);
                                },
                              ),
                        const SizedBox(height: 23),
                        CustomFormField(
                          validator: validateEmail,
                          controller: _emailEc,
                          focusNode: _emailFocus,
                          title: AppLocaleKey.email.tr(),
                          keyboardType: TextInputType.emailAddress,
                          onFieldSubmitted: (_) {
                            // Unfocus the field or submit the form
                            FocusScope.of(context).unfocus();
                          },
                        ),
                        const SizedBox(height: 23),
                        ChangeNotifierProvider(
                          create: (context) => VendorAndDeliveryController(),
                          child: Builder(
                            builder: (context) {
                              return CustomButton(
                                text: AppLocaleKey.next.tr(),
                                onPressed: () {
                                  if (!hideInputs) {
                                    if (_idImage == null || _taxImage == null || _commercialRegistrationImage == null) {
                                      CommonMethods.showError(message: AppLocaleKey.youMustAddAllImages.tr());
                                    }
                                  }
                                  if (hideInputs) {
                                    if (_formKey.currentState!.validate()) {
                                      NamedNavigatorImpl.pushNamed(
                                        context,
                                        ContractVendorScreen.routeName,
                                        arguments: ContractVendorArgs(
                                          vendorName: _merchantNameEc.text,
                                          vendorOwnerName: _ownerNameEc.text,
                                          vendorNational: _nationalIdEc.text,
                                          vendorCommercialRegistrationNo: _commercialRegistrationEc.text,
                                          vendorTaxNo: _taxIdEc.text,
                                          vendorMobile: _phoneNumberOneEc.text,
                                          vendorEmail: _emailEc.text,
                                          vendorVodafoneCash: _vodafoneCashNumber.text,
                                          onConfirm: () {
                                            context.read<VendorAndDeliveryController>().vendorRegister(
                                                  fullName: _merchantNameEc.text,
                                                  ownerName: _ownerNameEc.text,
                                                  branchesNo: int.tryParse(_branchesCountEc.text.toString())!,
                                                  nationalId: int.tryParse(_nationalIdEc.text.toString()),
                                                  commercialRegistrationNo: _commercialRegistrationEc.text,
                                                  nationalIdImage: _idImage,
                                                  commercialRegistrationNoImage: _commercialRegistrationImage,
                                                  taxNo: _taxIdEc.text,
                                                  taxNoImage: _taxImage,
                                                  estMobile: _phoneNumberOneEc.text,
                                                  sndMobile: _phoneNumberTwoEc.text,
                                                  vodafoneCashMobile: _vodafoneCashNumber.text,
                                                  email: _emailEc.text,
                                                  onSuccess: () {
                                                    NamedNavigatorImpl.pushNamedAndRemoveUntil(
                                                      context,
                                                      LoginScreen.routeName,
                                                    );
                                                  },
                                                );
                                          },
                                        ),
                                      );
                                    }
                                  }

                                  // log(isChecked.toString());
                                  if (_formKey.currentState!.validate() &&
                                      _idImage != null &&
                                      _taxImage != null &&
                                      _commercialRegistrationImage != null) {
                                    NamedNavigatorImpl.pushNamed(
                                      context,
                                      ContractVendorScreen.routeName,
                                      arguments: ContractVendorArgs(
                                        vendorName: _merchantNameEc.text,
                                        vendorOwnerName: _ownerNameEc.text,
                                        vendorNational: _nationalIdEc.text,
                                        vendorCommercialRegistrationNo: _commercialRegistrationEc.text,
                                        vendorTaxNo: _taxIdEc.text,
                                        vendorMobile: _phoneNumberOneEc.text,
                                        vendorEmail: _emailEc.text,
                                        vendorVodafoneCash: _vodafoneCashNumber.text,
                                        onConfirm: () {
                                          context.read<VendorAndDeliveryController>().vendorRegister(
                                                fullName: _merchantNameEc.text,
                                                ownerName: _ownerNameEc.text,
                                                branchesNo: int.tryParse(_branchesCountEc.text.toString())!,
                                                nationalId: int.tryParse(_nationalIdEc.text.toString()),
                                                commercialRegistrationNo: _commercialRegistrationEc.text,
                                                nationalIdImage: _idImage,
                                                commercialRegistrationNoImage: _commercialRegistrationImage,
                                                taxNo: _taxIdEc.text,
                                                taxNoImage: _taxImage,
                                                estMobile: _phoneNumberOneEc.text,
                                                sndMobile: _phoneNumberTwoEc.text,
                                                vodafoneCashMobile: _vodafoneCashNumber.text,
                                                email: _emailEc.text,
                                                onSuccess: () {
                                                  NamedNavigatorImpl.pushNamedAndRemoveUntil(
                                                      context, LoginScreen.routeName);
                                                },
                                              );
                                        },
                                      ),
                                    );
                                  }
                                },
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
