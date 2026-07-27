import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

import '../../../../../helpers/locale/app_locale_key.dart';
import '../../../../../helpers/networking/api_helper.dart';
import '../../../../../helpers/notification_helper/notification_helper.dart';
import '../../../../../helpers/pusher_service/pusher_controller.dart';
import '../../../../../helpers/routes/app_routers_import.dart';
import '../../../../../helpers/theme/app_colors.dart';
import '../../../../../helpers/theme/app_text_style.dart';
import '../../auth/controller/auth_controller.dart';
import '../../order/controller/order_controller.dart';
import '../../wallet/screen/wallet_screen.dart';
import '../widget/current_tap_list.dart';
import '../widget/lable_and_more_widget.dart';
import '../widget/my_current_balance_card.dart';
import '../widget/pending_tap_list.dart';
import '../widget/resturant_status_widget.dart';

class HomeVendorScreen extends StatefulWidget {
  static const String routeName = 'home_screen';
  const HomeVendorScreen({super.key});

  @override
  State<HomeVendorScreen> createState() => _HomeVendorScreenState();
}

class _HomeVendorScreenState extends State<HomeVendorScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late PusherController _pusherController;
  int? totalPending;
  void _refreshData() {
    var orderController = Provider.of<OrderController>(context, listen: false);
    orderController.initialPendingVendorHomeOrders();
    orderController.getPendingVendorHomeOrders();
    orderController.initialCurrentVendorHomeOrders();
    orderController.getCurrentVendorHomeOrders();
  }

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshData();
    });
    _pusherController = context.read<PusherController>();
    _pusherController.addEventListener('vendor.updated', (PusherEvent event) => _refreshData());
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pusherController.removeEventListener('vendor.updated', (PusherEvent event) => _refreshData());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<OrderController>(
        builder: (context, controller, _) {
          return NestedScrollView(
            headerSliverBuilder: (context, _) {
              return [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 21),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // const SizedBox(height: 30),
                        if (context.read<AuthController>().profile?.walletBlock == 0) ...[
                          const ResturantStatusWidget(),
                        ],
                        const SizedBox(height: 18),
                        InkWell(
                          onTap: () => NamedNavigatorImpl.pushNamed(context, WalletScreen.routeName),
                          child: LabelAndMoreWidget(title: AppLocaleKey.myWallet.tr()),
                        ),
                        const MyCurrentBalanceWidget(),
                        const SizedBox(height: 28),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [Text(AppLocaleKey.todayRequests.tr(), style: AppTextStyle.text16BS(context))],
                        ),
                        const SizedBox(height: 13),
                      ],
                    ),
                  ),
                ),
              ];
            },
            body: Column(
              children: [
                if (kDebugMode)
                  ElevatedButton(
                    onPressed: () {
                      ApiHelper.instance.sendNotification(
                        deviceToken: FirebaseNotifications.fcmToken!,
                        titleName: 'title',
                        body: 'body',
                        data: {
                          'notification_sound': 'long',
                          'notification_type': '1',
                          'notificationType': '1',
                        },
                      );
                    },
                    child: const Text('child'),
                  ),

                ///
                TabBar(
                  controller: _tabController,
                  labelColor: AppColor.mainAppColor(context),
                  indicatorColor: AppColor.mainAppColor(context),
                  unselectedLabelColor: AppColor.greyColor(context),
                  indicatorPadding: EdgeInsets.zero,
                  labelPadding: EdgeInsets.zero,
                  labelStyle: AppTextStyle.text14BS(context).copyWith(color: AppColor.mainAppColor(context)),
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorWeight: 2.5,
                  onTap: (value) => setState(() => _tabController.index = value),
                  tabs: [
                    Tab(child: _tabItem(AppLocaleKey.pending.tr(), controller.totalPendingHome, 0)),
                    Tab(child: _tabItem(AppLocaleKey.ongoing.tr(), controller.currentHomeOrders?.meta?.total ?? 0, 1)),
                  ],
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      VendorPendingTapList(controller: controller),
                      VendorCurrentTapList(controller: controller),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _tabItem(String label, int count, int tabIndex) {
    final bool isSelected = _tabController.index == tabIndex;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label),
        const SizedBox(width: 13),
        CircleAvatar(
          radius: 14,
          backgroundColor: isSelected ? AppColor.mainAppColor(context) : AppColor.lightGreyColor(context),
          child: Center(
            child: Text(
              count.toString(),
              style: AppTextStyle.text16BW(context).copyWith(height: context.locale.languageCode == 'ar' ? 1.7 : 1),
            ),
          ),
        ),
      ],
    );
  }
}
