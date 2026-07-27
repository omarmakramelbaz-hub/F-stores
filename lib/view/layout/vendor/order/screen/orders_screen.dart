import 'package:easy_localization/easy_localization.dart';
import '../../../../../helpers/locale/app_locale_key.dart';
import '../../../../../helpers/pusher_service/pusher_controller.dart';
import '../../../../../helpers/theme/app_colors.dart';
import '../../../../../helpers/theme/app_text_style.dart';
import '../controller/order_controller.dart';
import '../widget/on_going_orders_widget.dart';
import '../widget/previuse_orders_widget.dart';
import '../widget/waiteing_orders_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late PusherController _pusherController;
  @override
  void initState() {
    super.initState();
    _pusherController = context.read<PusherController>();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
    _pusherController.addEventListener('vendor.updated', (_) {
      _loadData();
    });
  }

  // void _handelVendorUpdated(PusherEvent event) {
  //   try {
  //     final decodedData = json.decode(event.data) as Map<String, dynamic>;
  //     final orderData = decodedData['order_id'];
  //     if (mounted) {
  //       var orderModel =
  //           VendorOrdersModel.fromJson(orderData as Map<String, dynamic>);
  //       context.read<OrderController>().addWaitingOrderToTop(orderModel);
  //       //_loadData();
  //     }
  //   } catch (e, stackTrace) {
  //     log("Error handling Pusher event: $e");
  //     log("Stack trace: $stackTrace");
  //   }
  // }

  void _loadData() {
    final orderController = Provider.of<OrderController>(context, listen: false);
    orderController.initialVendorWaitingOrders();

    orderController.initialVendorOngoingOrders();

    orderController.initialVendorCompletedOrders();
    Future.wait([
      orderController.getVendorWaitingOrders(),
      orderController.getVendorOngoingOrders(),
      orderController.getVendorCompletedOrders(pageNumber: 1),
    ]);
  }

  Color _getCircleAvatarBgColor(int index) {
    return _tabController.index == index
        ? AppColor.mainAppColor(context)
        : AppColor.greyColor(context).withOpacity(0.3);
  }

  @override
  void dispose() {
    _pusherController.removeEventListener('vendor.updated', (_) {
      _loadData();
    }); // Use saved reference
    _tabController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Consumer<OrderController>(
        builder: (context, orderController, _) {
          return Scaffold(
            body: Column(
              children: [
                //============title===============
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(AppLocaleKey.orders.tr(), style: AppTextStyle.text20BS(context)),
                      const Spacer(),
                      // CustomButton(
                      //   onPressed: _loadData,
                      //   height: 35,
                      //   width: 90,
                      //   prefixIcon: Icon(
                      //     Icons.refresh,
                      //     color: AppColor.whiteColor(context),
                      //   ),
                      //   text: AppLocaleKey.refresh.tr(),
                      //   style: AppTextStyle.text16BW(context),
                      //   color: AppColor.mainAppColor(context),
                      // ),
                    ],
                  ),
                ),
                const SizedBox(width: 30),

                TabBar(
                  controller: _tabController, // Attach TabController
                  labelStyle: AppTextStyle.text16BM(context),
                  unselectedLabelStyle: AppTextStyle.text16RG(context),
                  indicatorColor: AppColor.mainAppColor(context),
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorWeight: 3,
                  isScrollable: true,

                  onTap: (value) {
                    setState(() {
                      _tabController.index = value;
                    });
                  },
                  tabs: [
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(AppLocaleKey.pending.tr()),
                          const SizedBox(width: 13),
                          CircleAvatar(
                            radius: 14,
                            backgroundColor: _getCircleAvatarBgColor(0), // Change background color dynamically
                            child: Center(
                              child: Text(
                                orderController.totalPending.toString(),
                                style: AppTextStyle.text18BW(
                                  context,
                                ).copyWith(height: context.locale.languageCode == 'ar' ? 1.7 : 1),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(AppLocaleKey.ongoing.tr()),
                          const SizedBox(width: 13),
                          CircleAvatar(
                            radius: 14,
                            backgroundColor: _getCircleAvatarBgColor(1), // Change background color dynamically
                            child: Center(
                              child: Text(
                                orderController.ongoingOrders?.meta?.total?.toString() ?? '0',
                                style: AppTextStyle.text18BW(
                                  context,
                                ).copyWith(height: context.locale.languageCode == 'ar' ? 1.7 : 1),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(AppLocaleKey.finishedOrders.tr()),
                          const SizedBox(width: 13),
                          CircleAvatar(
                            radius: 14,
                            backgroundColor: _getCircleAvatarBgColor(2), // Change background color dynamically
                            child: Center(
                              child: Text(
                                orderController.completedOrders?.meta?.total?.toString() ?? '0',
                                style: AppTextStyle.text18BW(
                                  context,
                                ).copyWith(height: context.locale.languageCode == 'ar' ? 1.7 : 1),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Divider(color: AppColor.greyColor(context).withOpacity(0.2)),
                Expanded(
                  child: TabBarView(
                    controller: _tabController, // Attach TabController
                    children: [
                      WaitingOrdersWidget(orderController: orderController),
                      OnGoingOrdersWidget(orderController: orderController),
                      PreviousOrdersWidget(ordersController: orderController),
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
}
