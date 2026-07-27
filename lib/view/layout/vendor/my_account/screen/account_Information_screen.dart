import 'package:easy_localization/easy_localization.dart';
import '../../../../../helpers/routes/app_routers_import.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../../../helpers/images/app_images.dart';
import '../../../../../helpers/locale/app_locale_key.dart';
import '../../../../../helpers/theme/app_colors.dart';
import '../../../../../helpers/theme/app_text_style.dart';
import '../../../../custom_widgets/custom_app_bar/custom_app_bar.dart';
import '../../../../custom_widgets/custom_image/custom_image.dart';
import '../../auth/controller/auth_controller.dart';
import '../bottom_sheet/delivery_time_bottom_sheet.dart';
import '../widget/setting_button_widget.dart';
import 'change_password_screen.dart';
import 'personal_information_screen.dart';

class AccountInformationScreen extends StatelessWidget {
  static const String routeName = 'AccountInformationScreen';
  const AccountInformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context,
        height: 80,
        centerTitle: false,
        leadingPadding: 40,
        appBarColor: AppColor.whiteColor(context),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColor.blackColor(context)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Padding(
          padding: const EdgeInsets.only(bottom: 40),
          child: Text(AppLocaleKey.accountInformation.tr(), style: AppTextStyle.text20BW(context)),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
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
                            path: Provider.of<AuthController>(context).profile?.resturantLogo ?? '',
                            type: ImageType.network,
                            fit: BoxFit.fill,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Provider.of<AuthController>(context).profile?.resturantName ?? '',
                              style: AppTextStyle.textD18M(context),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                SvgPicture.asset(AppImages.flagIcon),
                                const SizedBox(width: 10),
                                Text(
                                  Provider.of<AuthController>(context).profile?.resturantCityname ?? '',
                                  style: AppTextStyle.textL18R(context),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Spacer(),
                        InkWell(onTap: () {}, child: SvgPicture.asset(AppImages.settingIcon)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 29),
                  Divider(color: AppColor.greyColor(context).withOpacity(0.2), height: 2),
                  const SizedBox(height: 24),
                  SettingButton(
                    title: AppLocaleKey.personalInformation.tr(),
                    onTap: () {
                      NamedNavigatorImpl.pushNamed(context, PersonalInformationScreen.routeName);
                    },
                  ),
                  const SizedBox(height: 32),
                  SettingButton(
                    title: AppLocaleKey.changePassword.tr(),
                    onTap: () {
                      NamedNavigatorImpl.pushNamed(context, ChangePasswordScreen.routeName);
                    },
                  ),
                  // const SizedBox(
                  //   height: 32,
                  // ),
                  // SettingButton(
                  //   title: AppLocaleKey.changeLanguage.tr(),
                  //   onTap: () {
                  //     NavigatorMethods.showAppBottomSheet(
                  //         context, const ChangeLangBottomSheet());
                  //   },
                  // ),
                  const SizedBox(height: 32),
                  SettingButton(
                    title: AppLocaleKey.deliveryTime.tr(),
                    onTap: () {
                      NamedNavigatorImpl.showAppBottomSheet(
                        enableDrag: true,
                        isScrollControlled: true,
                        context,
                        const DeliveryTimeBottomSheet(),
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
    );
  }
}
