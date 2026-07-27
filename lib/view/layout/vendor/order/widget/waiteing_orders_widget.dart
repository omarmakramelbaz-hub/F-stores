import 'package:easy_localization/easy_localization.dart';
import '../../../../../helpers/locale/app_locale_key.dart';
import '../../../../custom_widgets/api_response_widget/api_response_widget.dart';
import '../../../../custom_widgets/custom_form_field/custom_form_field.dart';
import '../../../../custom_widgets/custom_loading/custom_loading.dart';
import '../../../../global/widget/no_current_order_widget.dart';
import '../controller/order_controller.dart';
import 'single_on_going_order_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WaitingOrdersWidget extends StatelessWidget {
  WaitingOrdersWidget({super.key, required this.orderController});
  final OrderController orderController;
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        if (notification.metrics.pixels == notification.metrics.maxScrollExtent &&
            orderController.waitingOrdersHasPagination &&
            !orderController.waitingIsPaginating) {
          Provider.of<OrderController>(context, listen: false).getVendorWaitingOrders(
            // orderNo:
            //     _searchController.text, // Keep search term when paginating
            // status: 'pending', // Ensure the status remains consistent
          );
        }
        return true;
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 20),
              CustomFormField(
                controller: _searchController,
                keyboardType: TextInputType.number,
                onFieldSubmitted: (value) {
                  orderController.waitingOrderPage = 1;
                  orderController.getVendorWaitingOrders(orderNo: int.parse(_searchController.text));
                },
                onChanged: (value) {
                  if (value.isEmpty) {
                    orderController.waitingOrderPage = 1;
                    orderController.getVendorWaitingOrders();
                  }
                },
                hintText: AppLocaleKey.searchForARequest.tr(),
                suffixIcon: InkWell(
                  onTap: () {
                    orderController.waitingOrderPage = 1;
                    orderController.getVendorWaitingOrders(orderNo: int.parse(_searchController.text));
                  },
                  child: const Icon(Icons.search),
                ),
              ),
              const SizedBox(height: 20),
              ApiResponseWidget(
                emptyWidget: const NoCurrentOrderWidget(),
                apiResponse: orderController.vendorWaitingOrdersResponse,
                onReload: () => orderController.getVendorWaitingOrders(
                  pageNumber: orderController.waitingOrderPage,
                  // orderNo: _searchController.text, // Reload with current search term
                  // status: 'pending',
                ),
                isEmpty: orderController.vendorWaitingOrders.isEmpty,
                child: Column(
                  children: [
                    ...List.generate(orderController.vendorWaitingOrders.length + 1, (index) {
                      if (index == orderController.vendorWaitingOrders.length) {
                        return orderController.waitingIsPaginating
                            ? const Center(child: CustomLoading())
                            : const SizedBox.shrink();
                      }
                      return SingleOnGoingOrderItem(
                        orderController: orderController,
                        items: orderController.vendorWaitingOrders[index].items,
                        order: orderController.vendorWaitingOrders[index],
                        onSuccess: () {},
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }
}
