import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../custom_widgets/api_response_widget/api_response_widget.dart';
import '../../../../custom_widgets/custom_loading/custom_loading.dart';
import '../../../../global/widget/no_current_order_widget.dart';
import '../../order/controller/order_controller.dart';
import 'current_home_order.dart';
import 'home_shimmer_widget.dart';

class VendorCurrentTapList extends StatelessWidget {
  const VendorCurrentTapList({super.key, required this.controller});
  final OrderController controller;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        if (notification.metrics.pixels == notification.metrics.maxScrollExtent &&
            controller.currentHomeOrdersHasPagination &&
            !controller.currentHomeIsPaginating) {
          Provider.of<OrderController>(
            context,
            listen: false,
          ).getCurrentVendorHomeOrders(pageNumber: controller.currentOrderHomePage);
        }
        return true;
      },
      child: SingleChildScrollView(
        child: ApiResponseWidget(
          emptyWidget: const NoCurrentOrderWidget(),
          apiResponse: controller.currentVendorHomeOrdersResponse,
          onReload: () => controller.getCurrentVendorHomeOrders(),
          isEmpty: controller.currentVendorHomeOrders.isEmpty,
          loadingWidget: const HomeShimmerWidget(),
          child: Column(
            children: [
              ...List.generate(controller.currentVendorHomeOrders.length + 1, (index) {
                if (index == controller.currentVendorHomeOrders.length) {
                  return controller.currentHomeIsPaginating ? const Center(child: CustomLoading()) : Container();
                }
                return VendorCurrentOrderHomeWidget(
                  orderController: controller,
                  isDelivered: false,
                  orderId: controller.currentVendorHomeOrders[index].id ?? 0,
                  order: controller.currentVendorHomeOrders[index],
                  orderItem: controller.currentVendorHomeOrders[index].items,
                );
              }),
              // SizedBox(height: MediaQuery.of(context).size.height * 0.25),
            ],
          ),
        ),
      ),
    );
  }
}
