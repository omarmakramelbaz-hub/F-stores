import 'package:easy_localization/easy_localization.dart';
import '../../../../../helpers/routes/app_routers_import.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../helpers/locale/app_locale_key.dart';
import '../../../../../helpers/theme/app_colors.dart';
import '../../../../custom_widgets/api_response_widget/api_response_widget.dart';
import '../../../../custom_widgets/custom_form_field/custom_form_field.dart';
import '../../../../custom_widgets/custom_loading/custom_loading.dart';
import '../../../../global/widget/no_current_order_widget.dart';
import '../controller/order_controller.dart';
import 'filter_search_bottom_sheet.dart';
import 'single_on_going_order_item.dart';

class OnGoingOrdersWidget extends StatelessWidget {
  OnGoingOrdersWidget({super.key, required this.orderController});

  final OrderController orderController;

  // @override
  final searchNumberEc = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        if (notification.metrics.pixels == notification.metrics.maxScrollExtent &&
            orderController.onGoingOrdersHasPagination &&
            !orderController.onGoingIsPaginating) {
          Provider.of<OrderController>(
            context,
            listen: false,
          ).getVendorOngoingOrders(pageNumber: orderController.ongoingOrderPage);
        }
        return true;
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: CustomFormField(
                      controller: searchNumberEc,
                      keyboardType: TextInputType.number,
                      hintText: AppLocaleKey.searchForARequest.tr(),
                      suffixIcon: InkWell(
                        onTap: () {
                          orderController.ongoingOrderPage = 1;
                          orderController.getVendorOngoingOrders(orderNo: int.parse(searchNumberEc.text));
                        },
                        child: const Icon(Icons.search),
                      ),
                      onFieldSubmitted: (value) {
                        orderController.ongoingOrderPage = 1;
                        orderController.getVendorOngoingOrders(orderNo: int.parse(value));
                      },
                      onChanged: (value) {
                        if (value.isEmpty) {
                          orderController.ongoingOrderPage = 1;
                          orderController.getVendorOngoingOrders();
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 11),
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: AppColor.mainAppColor(context),
                    child: Center(
                      child: IconButton(
                        icon: Icon(Icons.tune_rounded, color: AppColor.whiteColor(context)),
                        onPressed: () {
                          NamedNavigatorImpl.showAppBottomSheet(
                            enableDrag: true,
                            isScrollControlled: true,
                            context,
                            ChangeNotifierProvider.value(
                              value: orderController,
                              builder: (context, child) => const FilterSearchBottomSheet(),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ApiResponseWidget(
                emptyWidget: const NoCurrentOrderWidget(),
                apiResponse: orderController.vendorOngoingOrdersResponse,
                onReload: () => orderController.getVendorOngoingOrders(pageNumber: orderController.ongoingOrderPage),
                isEmpty: orderController.vendorOngoingOrders.isEmpty,
                child: Column(
                  children: [
                    ...List.generate(orderController.vendorOngoingOrders.length + 1, (index) {
                      if (index == orderController.vendorOngoingOrders.length) {
                        return orderController.onGoingIsPaginating
                            ? const Center(child: CustomLoading())
                            : const SizedBox.shrink();
                      }
                      return SingleOnGoingOrderItem(
                        orderController: orderController,
                        items: orderController.vendorOngoingOrders[index].items,
                        order: orderController.vendorOngoingOrders[index],
                        onSuccess: () {
                          // setState(() {
                          //   orderController.getVendorOngoingOrders(
                          //       pageNumber: orderController.ongoingOrderPage);
                          // });
                        },
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
