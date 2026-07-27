import 'package:easy_localization/easy_localization.dart';
import '../../../../../helpers/locale/app_locale_key.dart';
import '../../../../custom_widgets/api_response_widget/api_response_widget.dart';
import '../../../../custom_widgets/custom_form_field/custom_form_field.dart';
import '../../../../custom_widgets/custom_loading/custom_loading.dart';
import '../../../../global/widget/no_current_order_widget.dart';
import '../controller/order_controller.dart';
import 'single_previuse_order_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PreviousOrdersWidget extends StatelessWidget {
  PreviousOrdersWidget({super.key, required this.ordersController});
  final OrderController ordersController;

  // @override
  final orderNumberPreviousEc = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        if (notification.metrics.pixels == notification.metrics.maxScrollExtent &&
            ordersController.completedOrdersHasPagination &&
            !ordersController.completedIsPaginating) {
          Provider.of<OrderController>(
            context,
            listen: false,
          ).getVendorCompletedOrders(pageNumber: ordersController.completedOrderPage);
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
                controller: orderNumberPreviousEc,
                hintText: AppLocaleKey.searchForARequest.tr(),
                suffixIcon: InkWell(
                  onTap: () {
                    ordersController.completedOrderPage = 1;
                    ordersController.getVendorCompletedOrders(orderNo: int.parse(orderNumberPreviousEc.text));
                  },
                  child: const Icon(Icons.search),
                ),
                onFieldSubmitted: (value) {
                  ordersController.completedOrderPage = 1;
                  ordersController.getVendorCompletedOrders(orderNo: int.parse(value));
                },
                onChanged: (value) {
                  if (value.isEmpty) {
                    ordersController.completedOrderPage = 1;
                    ordersController.getVendorCompletedOrders();
                  }
                },
              ),
              const SizedBox(height: 20),
              ApiResponseWidget(
                emptyWidget: const NoCurrentOrderWidget(),
                apiResponse: ordersController.vendorCompletedOrdersResponse,
                onReload: () =>
                    ordersController.getVendorCompletedOrders(pageNumber: ordersController.completedOrderPage),
                isEmpty: ordersController.vendorCompletedOrders.isEmpty,
                child: Column(
                  children: [
                    ...List.generate(ordersController.vendorCompletedOrders.length + 1, (index) {
                      if (index == ordersController.vendorCompletedOrders.length) {
                        return ordersController.completedIsPaginating
                            ? const Center(child: CustomLoading())
                            : const SizedBox.shrink();
                      }
                      return SinglePreviousOrderItem(
                        items: ordersController.vendorCompletedOrders[index].items,
                        order: ordersController.vendorCompletedOrders[index],
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
