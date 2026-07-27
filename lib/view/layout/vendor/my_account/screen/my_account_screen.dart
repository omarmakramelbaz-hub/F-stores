import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../../../helpers/hive/hive_methods.dart';
import '../../../../../helpers/images/app_images.dart';
import '../../../../../helpers/locale/app_locale_key.dart';
import '../../../../../helpers/routes/app_routers_import.dart';
import '../../../../../helpers/theme/app_colors.dart';
import '../../../../../helpers/theme/app_text_style.dart';
import '../../../../../helpers/utils/common_methods.dart';
import '../../../../custom_widgets/buttons/custom_button.dart';
import '../../../../custom_widgets/custom_form_field/custom_form_field.dart';
import '../../../../custom_widgets/custom_image/custom_image.dart';
import '../../../../global/chat/screen/admin_chat_screen.dart';
import '../../auth/bottom_sheet.dart/change_lang_bottom_sheet.dart';
import '../../auth/controller/auth_controller.dart';
import '../../auth/screen/login_screen.dart';
import '../../request_delegate/screen/delegats_orders_screen.dart';
import '../../request_delegate/screen/request_delegate_screen.dart';
import '../../wallet/screen/wallet_screen.dart';
import '../bottom_sheet/delivery_time_bottom_sheet.dart';
import '../controller/my_account_controller.dart';
import '../widget/change_phone_number.dart';
import '../widget/setting_button_widget.dart';
import 'change_password_screen.dart';
import 'contact_us_screen.dart';
import 'my_reports_screen.dart';
import 'personal_information_screen.dart';
import 'privacy_policy_screen.dart';
import 'terms_and_conditions_screen.dart';

class MyAccountScreen extends StatefulWidget {
  const MyAccountScreen({super.key});

  @override
  State<MyAccountScreen> createState() => _MyAccountScreenState();
}

@override
class _MyAccountScreenState extends State<MyAccountScreen> {
  bool isSwitched = true;
  final formKey = GlobalKey<FormState>();
  final codeEC = TextEditingController();
  @override
  void dispose() {
    codeEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<AuthController>(context).profile;
    return Scaffold(
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Padding(padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
            const SizedBox(height: 32),
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
                        CustomImage(
                          path:
                              Provider.of<AuthController>(context).profile?.photoProfile == null ||
                                  Provider.of<AuthController>(context).profile?.photoProfile == ''
                              ? AppImages.userIcon
                              : Provider.of<AuthController>(context).profile?.photoProfile ?? '',
                          type:
                              Provider.of<AuthController>(context).profile?.photoProfile == null ||
                                  Provider.of<AuthController>(context).profile?.photoProfile == ''
                              ? ImageType.svg
                              : ImageType.network,
                          height: 56,
                          width: 56,
                          radius: 25,
                          fit: BoxFit.fill,
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  Provider.of<AuthController>(context).profile?.resturantName ?? '',
                                  style: AppTextStyle.textD18M(context),
                                ),
                                const SizedBox(width: 10),
                                if (profile?.resturantLogo == null ||
                                    profile?.resturantName == null ||
                                    profile?.name == null ||
                                    profile?.resturantAreaId == null)
                                  SvgPicture.asset(AppImages.onlineIcon),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                SvgPicture.asset(AppImages.flagIcon),
                                const SizedBox(width: 10),
                                Text(
                                  Provider.of<AuthController>(context).profile?.areaTitle ??
                                      Provider.of<AuthController>(context).profile?.resturantCityname ??
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
                  const SizedBox(height: 48),
                  SettingButton(
                    title: AppLocaleKey.personalInformation.tr(),
                    onTap: () {
                      NamedNavigatorImpl.pushNamed(context, PersonalInformationScreen.routeName);
                    },
                  ),
                  const SizedBox(height: 32),
                  SettingButton(
                    title: AppLocaleKey.requestDelegate.tr(),
                    onTap: () {
                      NamedNavigatorImpl.pushNamed(context, RequestDelegateScreen.routeName);
                    },
                  ),
                  const SizedBox(height: 32),
                  SettingButton(
                    title: AppLocaleKey.requestDelegates.tr(),
                    onTap: () {
                      NamedNavigatorImpl.pushNamed(context, DelegateOrdersScreen.routeName);
                    },
                  ),
                  const SizedBox(height: 32),
                  SettingButton(
                    title: AppLocaleKey.changePhoneNumber.tr(),
                    onTap: () {
                      NamedNavigatorImpl.showAppBottomSheet(
                        enableDrag: true,
                        isScrollControlled: true,
                        context,
                        const ChangePhoneNumberBottomSheet(),
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                  SettingButton(
                    title: AppLocaleKey.changePassword.tr(),
                    onTap: () {
                      NamedNavigatorImpl.pushNamed(context, ChangePasswordScreen.routeName);
                    },
                  ),
                  const SizedBox(height: 32),
                  SettingButton(
                    title: AppLocaleKey.wallet.tr(),
                    onTap: () {
                      NamedNavigatorImpl.pushNamed(context, WalletScreen.routeName);
                    },
                  ),
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
                  const SizedBox(height: 32),
                  SettingButton(
                    title: AppLocaleKey.changeLanguage.tr(),
                    onTap: () {
                      NamedNavigatorImpl.showAppBottomSheet(context, const ChangeLangBottomSheet());
                    },
                  ),
                  const SizedBox(height: 32),
                  SettingButton(
                    title: AppLocaleKey.myReports.tr(),
                    onTap: () {
                      NamedNavigatorImpl.pushNamed(context, MyReportsScreen.routeName);
                    },
                  ),
                  const SizedBox(height: 32),
                  SettingButton(
                    title: AppLocaleKey.termsAndConditions.tr(),
                    onTap: () {
                      NamedNavigatorImpl.pushNamed(context, TermsAndConditionsScreen.routeName);
                    },
                  ),
                  const SizedBox(height: 32),
                  SettingButton(
                    title: AppLocaleKey.privacyPolicy.tr(),
                    onTap: () {
                      NamedNavigatorImpl.pushNamed(context, PrivacyPolicyScreen.routeName);
                    },
                  ),
                  const SizedBox(height: 32),
                  SettingButton(
                    title: AppLocaleKey.connectWithUs.tr(),
                    onTap: () {
                      NamedNavigatorImpl.pushNamed(context, ContactUsScreen.routeName);
                    },
                  ),
                  const SizedBox(height: 32),
                  ChangeNotifierProvider(
                    create: (context) => MyAccountController()
                      ..initialSetting()
                      ..getSetting(),
                    child: Consumer<MyAccountController>(
                      builder: (context, myAccountController, _) {
                        return SettingButton(
                          title: AppLocaleKey.connectSupport.tr(),
                          onTap: () {
                            NamedNavigatorImpl.pushNamed(
                              context,
                              AdminChatScreen.routeName,
                              arguments: AdminChatScreenArgs(
                                senderId: context.read<AuthController>().profile!.id!.toString(),
                                receiverId: myAccountController.setting?.adminId.toString() ?? '1',
                                receiverDeviceToken: myAccountController.setting?.adminDeviceToken ?? '',
                                receiverName: 'admin',
                                senderName: context.read<AuthController>().profile?.name ?? '',
                                senderDeviceToken: '',
                                accountType: 'vendor',
                                isToVendor: false,
                                vendorDeviceToken: '',
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                  SettingButton(
                    title: AppLocaleKey.deleteAccount.tr(),
                    onTap: () {
                      CommonMethods.showChooseDialog(
                        context,
                        onPressed: () {
                          Navigator.pop(context);
                          NamedNavigatorImpl.showAppDialog(
                            context,
                            Dialog(
                              elevation: 5,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                              child: Builder(
                                builder: (context) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: AppColor.whiteColor(context),
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    height: 200,
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Column(
                                          children: [
                                            CustomFormField(
                                              title: AppLocaleKey.enterVerificationCode.tr(),
                                              controller: codeEC,
                                            ),
                                            const SizedBox(height: 10),
                                            CustomButton(
                                              text: AppLocaleKey.deleteAccount.tr(),
                                              onPressed: () {
                                                context.read<AuthController>().deleteAccount(
                                                  mobileCode: codeEC.text,
                                                  onSuccess: () {
                                                    NamedNavigatorImpl.pushNamed(context, LoginScreen.routeName);
                                                  },
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                        message: AppLocaleKey.didYouWantToDeleteThisAccount.tr(),
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 31),
                    child: CustomButton(
                      text: AppLocaleKey.logOut.tr(),
                      prefixIcon: CustomImage(
                        path: AppImages.logOutIcon,
                        type: ImageType.svg,
                        color: AppColor.whiteColor(context),
                      ),
                      gap: 15,
                      onPressed: () {
                        CommonMethods.showChooseDialog(
                          context,
                          title: tr(AppLocaleKey.doYouWantToLogOut),
                          message: '',
                          onPressed: () {
                            context.read<AuthController>().logout(
                              onSuccess: () {
                                HiveMethods.deleteLat();
                                HiveMethods.getLan();
                                NamedNavigatorImpl.pushNamedAndRemoveUntil(context, LoginScreen.routeName);
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 130),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
