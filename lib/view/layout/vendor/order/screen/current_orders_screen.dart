import 'package:easy_localization/easy_localization.dart';
import '../../../../../helpers/locale/app_locale_key.dart';
import '../../../../../helpers/theme/app_colors.dart';
import '../../../../../helpers/theme/app_text_style.dart';
import '../../../../custom_widgets/api_response_widget/api_response_widget.dart';
import '../../../../custom_widgets/custom_app_bar/custom_app_bar.dart';
import '../../../../custom_widgets/custom_loading/custom_loading.dart';
import '../../../../global/widget/order_widget.dart';
import '../controller/order_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CurrentOrdersArgs {
  final VoidCallback onPop;

  CurrentOrdersArgs({required this.onPop});
}

class CurrentOrdersScreen extends StatefulWidget {
  static const String routeName = 'CurrentOrdersScreen';
  final CurrentOrdersArgs args;
  const CurrentOrdersScreen({super.key, required this.args});

  @override
  State<CurrentOrdersScreen> createState() => _CurrentOrdersScreenState();
}

class _CurrentOrdersScreenState extends State<CurrentOrdersScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<OrderController>(context, listen: false).initialCurrentVendorOrders();

      Provider.of<OrderController>(context, listen: false).getCurrentVendorOrders();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderController>(
      builder: (context, vendorOrderController, _) {
        return PopScope(
          onPopInvoked: (didPop) {
            if (didPop) {
              widget.args.onPop.call();
            }
          },
          child: Scaffold(
            appBar: CustomAppBar(
              context,
              height: 80,
              centerTitle: false,
              leadingPadding: 40,
              title: Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Text(AppLocaleKey.currentOrders.tr(), style: AppTextStyle.text20BW(context)),
              ),
            ),
            body: NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (notification.metrics.pixels == notification.metrics.maxScrollExtent &&
                    vendorOrderController.currentOrdersHasPagination &&
                    !vendorOrderController.currentIsPaginating) {
                  vendorOrderController.getCurrentVendorOrders();
                }
                return true;
              },
              child: ApiResponseWidget(
                apiResponse: vendorOrderController.vendorOrdersResponse,
                onReload: () => vendorOrderController.getCurrentVendorOrders(),
                isEmpty: vendorOrderController.currentVendorOrders.isEmpty,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 21),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Text(AppLocaleKey.currentOrders.tr(), style: AppTextStyle.text20BS(context)),
                            const SizedBox(width: 20),
                            CircleAvatar(
                              radius: 14,
                              backgroundColor: AppColor.mainAppColor(context),
                              child: Center(
                                child: Text(
                                  vendorOrderController.currentOrders?.meta?.total.toString() ?? '0',
                                  style: AppTextStyle.text18BW(
                                    context,
                                  ).copyWith(height: context.locale.languageCode == 'ar' ? 1.7 : 1),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        ...List.generate(vendorOrderController.currentVendorOrders.length + 1, (index) {
                          if (index == vendorOrderController.currentVendorOrders.length) {
                            return vendorOrderController.currentIsPaginating
                                ? const Center(child: CustomLoading())
                                : const SizedBox.shrink();
                          }
                          return OrderWidget(
                            orderController: vendorOrderController,
                            isDelivered: false,
                            orderId: vendorOrderController.currentVendorOrders[index].id!,
                            order: vendorOrderController.currentVendorOrders[index],
                            orderItem: vendorOrderController.currentVendorOrders[index].items,
                            onsuccess: () {
                              vendorOrderController.getCurrentVendorOrders(pageNumber: 1);
                            },
                          );
                        }),
                        const SizedBox(height: 60),
                      ],
                    ),
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
