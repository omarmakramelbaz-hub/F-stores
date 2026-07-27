import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../custom_widgets/api_response_widget/api_response_widget.dart';
import '../../../../custom_widgets/custom_loading/custom_loading.dart';
import '../../../../global/widget/no_current_order_widget.dart';
import '../../order/controller/order_controller.dart';
import 'current_home_order.dart';
import 'home_shimmer_widget.dart';

class VendorPendingTapList extends StatelessWidget {
  const VendorPendingTapList({super.key, required this.controller});
  final OrderController controller;
  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        if (notification.metrics.pixels == notification.metrics.maxScrollExtent &&
            controller.pendingOrdersHasPagination &&
            !controller.pendingIsPaginating) {
          Provider.of<OrderController>(
            context,
            listen: false,
          ).getPendingVendorHomeOrders(pageNumber: controller.pendingOrderPage);
        }
        return true;
      },
      child: SingleChildScrollView(
        child: ApiResponseWidget(
          emptyWidget: const NoCurrentOrderWidget(),
          apiResponse: controller.pendingVendorOrdersResponse,
          onReload: () => controller.getPendingVendorHomeOrders(),
          isEmpty: controller.pendingVendorOrders.isEmpty,
          loadingWidget: const HomeShimmerWidget(),
          child: RefreshIndicator(
            onRefresh: () async {
              controller.getPendingVendorHomeOrders(pageNumber: 1);
            },
            child: Column(
              children: [
                ...List.generate(controller.pendingVendorOrders.length + 1, (index) {
                  if (index == controller.pendingVendorOrders.length) {
                    return controller.pendingIsPaginating ? const Center(child: CustomLoading()) : Container();
                  }
                  return VendorCurrentOrderHomeWidget(
                    orderController: controller,
                    isDelivered: false,
                    orderId: controller.pendingVendorOrders[index].id ?? 0,
                    order: controller.pendingVendorOrders[index],
                    orderItem: controller.pendingVendorOrders[index].items,
                  );
                }),
                // SizedBox(height: MediaQuery.of(context).size.height * 0.25),
              ],
            ),
          ),
        ),
      ),
    );
    // });
  }
}
