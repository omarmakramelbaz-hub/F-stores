import 'dart:convert';
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import '../../../../../helpers/routes/app_routers_import.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

import '../../../../../helpers/images/app_images.dart';
import '../../../../../helpers/locale/app_locale_key.dart';
import '../../../../../helpers/pusher_service/pusher_controller.dart';
import '../../../../../helpers/theme/app_colors.dart';
import '../../../../../helpers/theme/app_text_style.dart';
import '../../../../custom_widgets/custom_image/custom_image.dart';
import '../../../../custom_widgets/custom_loading/custom_shimmer.dart';
import '../../auth/controller/auth_controller.dart';
import '../../wallet/screen/wallet_screen.dart';

class MyCurrentBalanceWidget extends StatefulWidget {
  const MyCurrentBalanceWidget({super.key});

  @override
  State<MyCurrentBalanceWidget> createState() => _MyCurrentBalanceWidgetState();
}

class _MyCurrentBalanceWidgetState extends State<MyCurrentBalanceWidget> {
  num? balance;
  num? minWallet;
  num? minWalletDisabled;
  late PusherController _pusherController;
  String? pusherWalletAmount;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authController = Provider.of<AuthController>(context, listen: false);
      authController.getProfile().then((_) {
        setState(() {
          balance = authController.profile?.balance;
          minWallet = authController.profile?.minWallet;
          minWalletDisabled = authController.profile?.minWalletDisabled;
        });
      });
    });
    _pusherController = context.read<PusherController>();
    _pusherController.addEventListener('balance.updated', _handleWalletUpdate);
  }

  void _handleWalletUpdate(PusherEvent event) {
    try {
      var jsonData = jsonDecode(event.data) as Map<String, dynamic>;
      log('Wallet updated: $jsonData');

      String amount = jsonData['user_balance']?.toString() ?? '0';
      pusherWalletAmount = num.parse(amount).toStringAsFixed(2);

      if (mounted) {
        setState(() {
          Provider.of<AuthController>(context, listen: false).getProfile();
        });
      }
    } catch (e, stackTrace) {
      log('Error handling Pusher event: $e');
      log('Stack trace: $stackTrace');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            NamedNavigatorImpl.pushNamed(context, WalletScreen.routeName);
          },
          child: Center(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: AppColor.whiteColor(context),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.greyColor(context).withOpacity(0.2),
                    offset: const Offset(0, 4),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 15),
                        Expanded(
                          child: Row(
                            children: [
                              Text(AppLocaleKey.myCurrentBalance.tr(), style: AppTextStyle.text16MS(context)),
                              const SizedBox(width: 5),
                              SvgPicture.asset(AppImages.downIcon),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),
                        balance == null
                            ? CustomShimmer(
                                height: 20,
                                width: 100,
                                radius: 4,
                                shimmerColor: AppColor.mainAppColor(context),
                              )
                            : Text(
                                AppLocaleKey.pound.tr().replaceAll(
                                      '{}',
                                      '${pusherWalletAmount ?? balance?.toStringAsFixed(0).toString()}',
                                    ),
                                style: AppTextStyle.text16BS(context),
                              ),
                      ],
                    ),
                  ),
                  Expanded(child: SvgPicture.asset(AppImages.walletIcon)),
                ],
              ),
            ),
          ),
        ),
        if (balance != null && minWallet != null && minWalletDisabled != null) ...[
          if (balance! >= minWalletDisabled! && balance! <= minWallet!) ...[
            const SizedBox(height: 12),
            _buildAlertContainer(context, AppLocaleKey.pleaseChargeYourBalance.tr(args: [minWallet!.toString()])),
          ],
          if (balance! < minWalletDisabled!) ...[
            const SizedBox(height: 12),
            _buildAlertContainer(
              context,
              AppLocaleKey.yourAccountIsCurrentlySuspended.tr(args: [minWallet!.toString()]),
            ),
          ],
        ],
      ],
    );
  }

  Widget _buildAlertContainer(BuildContext context, String message) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            Navigator.pushNamed(context, WalletScreen.routeName);
          },
          child: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: AppColor.ffebbcColor(context)),
            child: Row(
              children: [
                const Card(
                  elevation: 5,
                  shape: OvalBorder(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: CustomImage(path: AppImages.infoIcon, type: ImageType.svg),
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(child: Text(message, style: AppTextStyle.text14RS(context).copyWith(fontSize: 12))),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
