import 'dart:developer';
import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../helpers/images/app_images.dart';
import '../../../../../helpers/locale/app_locale_key.dart';
import '../../../../../helpers/theme/app_colors.dart';
import '../../../../../helpers/theme/app_text_style.dart';
import '../../../../../helpers/utils/country_code_methods.dart';
import '../../../../../helpers/utils/date_methods.dart';
import '../../../../custom_widgets/api_response_widget/api_response_widget.dart';
import '../../../../custom_widgets/buttons/custom_button.dart';
import '../../../../custom_widgets/custom_app_bar/custom_app_bar.dart';
import '../../../../custom_widgets/custom_form_field/custom_form_field.dart';
import '../../../../custom_widgets/custom_image/custom_image.dart';
import '../../../../custom_widgets/validation/validation_mixin.dart';
import '../../../../global/widget/custom_image_container.dart';
import '../../auth/controller/auth_controller.dart';
import '../controller/my_account_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class PersonalInformationScreen extends StatefulWidget {
  static const String routeName = 'PersonalInformationScreen';
  const PersonalInformationScreen({super.key});

  @override
  State<PersonalInformationScreen> createState() => _PersonalInformationScreenState();
}

class _PersonalInformationScreenState extends State<PersonalInformationScreen> with ValidationMixin {
  int? _branch;
  final _formKey = GlobalKey<FormState>();
  final _restNameEc = TextEditingController();
  final _ownerNameEc = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();

  final _startDate = TextEditingController();
  final _endDate = TextEditingController();
  final _minOrderPrice = TextEditingController();
  //===========================================
  final _kmPrice = TextEditingController();
  final _subscriptionFee = TextEditingController();

  DateTime? _startDateValue;
  DateTime? _endDateValue;

  Country? _country;

  File? _imageCover;
  File? _imageLogo;
  @override
  void initState() {
    _country = CountryCodeMethods.getByCode('20');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AuthController>(context, listen: false).initialAreas();
      Provider.of<AuthController>(context, listen: false).getAreas();

      Provider.of<AuthController>(context, listen: false).initialProfile();
      Provider.of<AuthController>(context, listen: false).getProfile().then((value) {
        final profile = Provider.of<AuthController>(context, listen: false).profile;
        _restNameEc.text = profile?.resturantName ?? '';
        _ownerNameEc.text = profile?.name ?? '';
        _branch = profile?.resturantCityId;
        _email.text = profile?.email ?? '';
        _phone.text = profile?.mobile ?? '';
        _startDate.text = profile?.resturantOpenAt ?? '';
        _endDate.text = profile?.resturantCloseAt ?? '';
        _minOrderPrice.text = profile?.minOrderPrice.toString() ?? '';
        _kmPrice.text = AppLocaleKey.pointsForKilo.tr().replaceAll('{}', profile?.kmPrice.toString() ?? '');
        _subscriptionFee.text = " ${profile?.serviceFees.toString() ?? ""} %";

        // Parsing dates using custom format
        DateFormat format = DateFormat('HH:mm:ss'); // Update the format as needed

        // Parsing open date
        _startDateValue = profile?.resturantOpenAt != null ? format.parse(profile!.resturantOpenAt!, true) : null;

        // Parsing close date
        _endDateValue = profile?.resturantCloseAt != null ? format.parse(profile!.resturantCloseAt!, true) : null;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthController>(
      builder: (context, authController, _) {
        return Form(
          key: _formKey,
          child: Container(
            color: AppColor.whiteColor(context),
            child: ApiResponseWidget(
              apiResponse: authController.profileResponse,
              onReload: () => authController.getProfile(),
              isEmpty: authController.profile == null,
              child: Scaffold(
                appBar: CustomAppBar(
                  context,
                  height: 80,
                  centerTitle: false,
                  leadingPadding: 40,
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back_ios, color: AppColor.blackColor(context)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  appBarColor: AppColor.whiteColor(context),
                  title: Padding(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: Text(AppLocaleKey.personalInformation.tr(), style: AppTextStyle.text20BS(context)),
                  ),
                ),
                body: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 35),
                      Container(
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
                          children: [
                            const SizedBox(height: 26),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                children: [
                                  Center(
                                    child: CustomImage(
                                      height: 50,
                                      width: 50,
                                      radius: 30,
                                      path: authController.profile?.resturantLogo ?? '',
                                      type: ImageType.network,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        authController.profile?.resturantName ?? '',
                                        style: AppTextStyle.textD18M(context),
                                      ),
                                      const SizedBox(width: 10),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          SvgPicture.asset(AppImages.flagIcon),
                                          const SizedBox(width: 10),
                                          Text(
                                            authController.profile?.areaTitle ??
                                                authController.profile?.resturantCityname ??
                                                '',
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
                            const SizedBox(height: 14),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //======================================= owner info =======================
                                  Row(
                                    children: [
                                      Text(AppLocaleKey.branchOwnerInfo.tr(), style: AppTextStyle.textD18R(context)),
                                    ],
                                  ),
                                  const SizedBox(height: 30),
                                  CustomFormField(
                                    validator: validateName,
                                    controller: _ownerNameEc,
                                    title: AppLocaleKey.merchantName.tr(),
                                  ),
                                  const SizedBox(height: 30),
                                  CustomFormField(
                                    validator: validateEmail,
                                    controller: _email,
                                    title: AppLocaleKey.email.tr(),
                                    keyboardType: TextInputType.emailAddress,
                                  ),
                                  const SizedBox(height: 30),
                                  Divider(color: AppColor.lightGreyColor(context), thickness: 2),
                                  const SizedBox(height: 21),
                                  //========================================== restaurant infor ========================
                                  Row(
                                    children: [
                                      Text(AppLocaleKey.resturantInfo.tr(), style: AppTextStyle.textD18R(context)),
                                    ],
                                  ),
                                  const SizedBox(height: 30),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Text(
                                              AppLocaleKey.coverImage.tr(),
                                              style: AppTextStyle.formTitleStyle(context),
                                            ),
                                            const SizedBox(width: 20),
                                            CustomImageContainer(
                                              bgImage: authController.profile?.resturantBgImage,
                                              image: _imageCover,
                                              onSuccess: (v) {
                                                setState(() {
                                                  _imageCover = v;
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 20),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Text(
                                              AppLocaleKey.logoImage.tr(),
                                              style: AppTextStyle.formTitleStyle(context),
                                            ),
                                            const SizedBox(width: 20),
                                            CustomImageContainer(
                                              bgImage: authController.profile?.resturantLogo ?? AppImages.imageCover,
                                              image: _imageLogo,
                                              onSuccess: (v) {
                                                setState(() {
                                                  _imageLogo = v;
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 21),
                                  CustomFormField(
                                    validator: validateName,
                                    controller: _restNameEc,
                                    title: AppLocaleKey.restaurantName.tr(),
                                  ),
                                  const SizedBox(height: 25),
                                  CustomFormField(
                                    validator: (v) => validatePhone(v, country: _country),
                                    controller: _phone,
                                    title: AppLocaleKey.resturantNumber.tr(),
                                    keyboardType: TextInputType.number,
                                    country: _country,
                                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                  ),
                                  const SizedBox(height: 25),
                                  CustomFormField(
                                    controller: _startDate,
                                    onTap: () {
                                      DateMethods.pickTime(
                                        context,
                                        initialDate: DateTime.now(),
                                        onSuccess: (v) {
                                          setState(() {
                                            _startDateValue = v;
                                            _startDate.text = DateMethods.formatToTime(v.toString());
                                          });
                                        },
                                      );
                                    },
                                    readOnly: true,
                                    title: AppLocaleKey.startingTimeOfResturantWork.tr(),
                                    suffixIcon: const Icon(Icons.access_time_rounded),
                                  ),
                                  const SizedBox(height: 25),
                                  CustomFormField(
                                    controller: _endDate,
                                    onTap: () {
                                      DateMethods.pickTime(
                                        context,
                                        initialDate: DateTime.now(),
                                        onSuccess: (v) {
                                          setState(() {
                                            _endDateValue = v;
                                            _endDate.text = DateMethods.formatToTime(v.toString());
                                          });
                                        },
                                      );
                                    },
                                    readOnly: true,
                                    title: AppLocaleKey.endingTimeResturantWork.tr(),
                                    suffixIcon: const Icon(Icons.access_time_rounded),
                                  ),
                                  const SizedBox(height: 25),
                                  CustomFormField(
                                    controller: _minOrderPrice,
                                    title: AppLocaleKey.lowestPriceToExecuteTheOrder.tr(),
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                  ),
                                  const SizedBox(height: 25),
                                  CustomFormField(
                                    fillColor: AppColor.lightGreyColor(context),
                                    controller: _kmPrice,
                                    title: AppLocaleKey.deliveryKiloPrice.tr(),
                                    readOnly: true,
                                  ),
                                  const SizedBox(height: 25),
                                  CustomFormField(
                                    fillColor: AppColor.lightGreyColor(context),
                                    controller: _subscriptionFee,
                                    title: AppLocaleKey.ownerSubscriptionFee.tr(),
                                    readOnly: true,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 50),
                            ChangeNotifierProvider(
                              create: (context) => MyAccountController(),
                              child: Consumer<MyAccountController>(
                                builder: (context, myAccountController, _) {
                                  return Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: CustomButton(
                                      text: AppLocaleKey.saveChanges.tr(),
                                      onPressed: () {
                                        log(_startDateValue.toString());
                                        log(_endDateValue.toString());
                                        if (_formKey.currentState!.validate()) {
                                          myAccountController.updateVendorProfileInfo(
                                            email: _email.text,
                                            restaurantPhone: _phone.text,
                                            name: _ownerNameEc.text,
                                            restaurantLogo: _imageLogo,
                                            restaurantCover: _imageCover,
                                            restaurantName: _restNameEc.text,
                                            restaurantAreaId: _branch!,
                                            openAt: _startDateValue,
                                            closeAt: _endDateValue,
                                            minOrderPrice: num.parse(_minOrderPrice.text),
                                            onSuccess: () {
                                              log(DateFormat('HH:mm:ss').format(_startDateValue ?? DateTime.now()));
                                              log(DateFormat('HH:mm:ss').format(_endDateValue ?? DateTime.now()));
                                              Navigator.pop(context);
                                            },
                                          );
                                        }
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
