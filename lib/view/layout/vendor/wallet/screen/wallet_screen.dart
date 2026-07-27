import 'dart:convert';
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import '../../../../../helpers/routes/app_routers_import.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

import '../../../../../helpers/locale/app_locale_key.dart';
import '../../../../../helpers/notification_helper/sound_notification.dart';
import '../../../../../helpers/pusher_service/pusher_controller.dart';
import '../../../../../helpers/theme/app_colors.dart';
import '../../../../../helpers/theme/app_text_style.dart';
import '../../../../custom_widgets/api_response_widget/api_response_widget.dart';
import '../../../../custom_widgets/buttons/custom_button.dart';
import '../../../../custom_widgets/custom_app_bar/custom_app_bar.dart';
import '../../../../custom_widgets/page_container/page_container.dart';
import '../../my_account/controller/my_account_controller.dart';
import '../bottom_sheet/charge_wallet_bottom_sheet.dart';
import '../bottom_sheet/mony_transfer_bottom_sheet.dart';
import '../controller/wallet_controller.dart';
import '../widget/my_current_balance_in_wallet_screen.dart';
import '../widget/recent_transactions_widget.dart';

class WalletScreen extends StatefulWidget {
  static const String routeName = 'WalletScreen';
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  late PusherController _pusherController;
  String? pusherWalletAmount;
  @override
  void initState() {
    SoundNotification.stopSound();
    super.initState();

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
          context.read<WalletController>().getWallet();
        });
      }
    } catch (e, stackTrace) {
      log('Error handling Pusher event: $e');
      log('Stack trace: $stackTrace');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<WalletController, MyAccountController>(
      builder: (context, walletController, myAccountController, _) {
        return Scaffold(
          extendBody: true,
          appBar: CustomAppBar(
            context,
            height: 100,
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
              child: Text(AppLocaleKey.wallet.tr(), style: AppTextStyle.text18BS(context)),
            ),
          ),
          body: PageContainer(
            bottom: false,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 22),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(color: AppColor.whiteColor(context)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 15),
                        MyCurrentBalanceInWalletScreenWidget(
                          wallet: walletController.wallet,
                          pusherWalletAmount: pusherWalletAmount,
                        ),
                        Column(
                          children: [
                            const SizedBox(height: 20),
                            CustomButton(
                              onPressed: () {
                                NamedNavigatorImpl.showAppBottomSheet(
                                  enableDrag: true,
                                  isScrollControlled: true,
                                  context,
                                  ChangeNotifierProvider.value(
                                    value: walletController,
                                    child: MoneyTransferBottomSheet(walletController: walletController),
                                  ),
                                );
                              },
                              text: AppLocaleKey.moneyTransfer.tr(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        Text(AppLocaleKey.recentTransactions.tr(), style: AppTextStyle.text18BS(context)),
                        const SizedBox(height: 15),
                        ApiResponseWidget(
                          apiResponse: walletController.walletResponse,
                          onReload: walletController.getWallet,
                          isEmpty: walletController.wallet == null,
                          child: RecentTransactionsWidget(wallet: walletController.wallet),
                        ),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: (myAccountController.setting?.walletCardActivate == 'false' &&
                    myAccountController.setting?.paymentCardActivate == 'false')
                ? const SizedBox()
                : CustomButton(
                    text: AppLocaleKey.walletCharging.tr(),
                    onPressed: () {
                      NamedNavigatorImpl.showAppBottomSheet(
                        enableDrag: true,
                        isScrollControlled: true,
                        context,
                        ChangeNotifierProvider.value(
                          value: walletController,
                          child: ChargeWalletBottomSheet(
                            walletController: walletController,
                            myAccountController: myAccountController,
                          ),
                        ),
                      );
                    },
                  ),
          ),
        );
      },
    );
  }
}
