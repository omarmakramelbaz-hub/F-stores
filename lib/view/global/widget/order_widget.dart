import 'package:easy_localization/easy_localization.dart';
import '../../../helpers/routes/app_routers_import.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helpers/images/app_images.dart';
import '../../../helpers/locale/app_locale_key.dart';
import '../../../helpers/theme/app_colors.dart';
import '../../../helpers/theme/app_text_style.dart';
import '../../../helpers/utils/date_methods.dart';
import '../../custom_widgets/buttons/custom_button.dart';
import '../../custom_widgets/custom_image/custom_image.dart';
import '../../custom_widgets/dotted_decoration/dotted_decoration.dart';
import '../../layout/vendor/order/bottom_sheet/another_representative_bottom_sheet.dart';
import '../../layout/vendor/order/controller/order_controller.dart';
import '../../layout/vendor/order/model/vendor_orders_model.dart';
import '../../layout/vendor/order/screen/order_details_screen.dart';
import '../bottom_sheet/deliver_order_bottom_sheet.dart';
import 'order_item_widget.dart';

class OrderWidget extends StatefulWidget {
  final List<Items>? orderItem;
  final VendorOrdersModel? order;
  final int orderId;
  const OrderWidget({
    super.key,
    this.isDelivered,
    required this.orderItem,
    required this.order,
    required this.orderId,
    this.onsuccess,
    required this.orderController,
  });
  final bool? isDelivered;

  final VoidCallback? onsuccess;
  final OrderController orderController;

  @override
  State<OrderWidget> createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  @override
  Widget build(BuildContext context) {
    bool isStatusChanged = false;
    final status = widget.order?.status;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.textFormBorderColor(context)),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              NamedNavigatorImpl.pushNamed(
                context,
                OrderDetailsScreen.routeName,
                arguments: OrderDetailsScreenArgs(orderId: widget.orderId, fromHome: false),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      CustomImage(
                        path: widget.order?.userLogo ?? '',
                        type: ImageType.network,
                        height: 50,
                        width: 50,
                        radius: 25,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(width: 10),
                      Text(widget.order?.userName ?? '', style: AppTextStyle.textD16M(context)),
                      const SizedBox(width: 10),
                      const Card(
                        elevation: 5,
                        shape: OvalBorder(),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                          child: CustomImage(path: AppImages.infoIcon, type: ImageType.svg),
                        ),
                      ),
                      Expanded(child: Container()),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("${widget.order?.orderNo ?? ""}\t#", style: AppTextStyle.text16RG(context)),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5),
                                child: Icon(Icons.access_time, size: 17, color: AppColor.greyColor(context)),
                              ),
                              Text(
                                DateMethods.formatToTime(widget.order?.createdAt?.toString() ?? ''),
                                style: AppTextStyle.text16RG(context),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                //===============================================================================
                Container(decoration: const DottedDecoration(strokeWidth: 0.7, dash: [7, 5])),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 17),
                  child: Text(AppLocaleKey.deliveryLocation.tr(), style: AppTextStyle.text16MS(context)),
                ),
                const SizedBox(height: 10),
                //Location
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      const CustomImage(path: AppImages.locationIcon, type: ImageType.svg),
                      const SizedBox(width: 5),
                      Text(
                        "${widget.order?.userAddress?.areaName ?? ""}\t- \t${widget.order?.userAddress?.streetName ?? ""}\t- \t${widget.order?.userAddress?.addressName ?? ""}",
                        style: AppTextStyle.text16MG(context),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Divider(thickness: 0.2, color: AppColor.textFormColor(context)),

                ...List.generate(
                  widget.orderItem?.length ?? 0,
                  (orderIndex) => OrderItemWidget(orderItem: widget.orderItem?[orderIndex]),
                ),
                widget.order?.delegateId != null
                    ? Divider(thickness: 0.2, color: AppColor.textFormColor(context))
                    : const SizedBox(),
              ],
            ),
          ),
          widget.order?.scheduleDate != null
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 23),
                  child: CustomButton(
                    color: AppColor.lightGreyColor(context),
                    text: AppLocaleKey.scheduledOrder.tr(),
                    style: AppTextStyle.text18MS(context),
                  ),
                )
              : const SizedBox(),
          if (widget.order?.delegateId == null &&
              widget.order?.status == 'pending' &&
              widget.isDelivered == false &&
              widget.order?.scheduleDate == null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 23),
              child: CustomButton(
                text: AppLocaleKey.chooseDeliveryMethod.tr(),
                color: isStatusChanged == true ? AppColor.greenColor(context) : AppColor.mainAppColor(context),
                onPressed: () {
                  NamedNavigatorImpl.showAppBottomSheet(
                    context,
                    DeliverOrderBottomSheet(
                      order: widget.order!,
                      onsuccess: () {
                        widget.onsuccess?.call();
                        setState(() {
                          isStatusChanged = true;
                        });
                      },
                    ),
                  );
                },
              ),
            ),
          widget.isDelivered == true && status == 'pending' && widget.order?.scheduleDate == null
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 23),
                  child: CustomButton(
                    text: AppLocaleKey.chooseDeliveryMethod.tr(),
                    onPressed: () {
                      NamedNavigatorImpl.showAppBottomSheet(context, DeliverOrderBottomSheet(order: widget.order!));
                    },
                  ),
                )
              : status == 'another_delegate'
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 23),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: ChangeNotifierProvider<OrderController>(
                              create: (context) => OrderController(),
                              child: Builder(
                                builder: (context) {
                                  return CustomButton(
                                    onPressed: () {
                                      Provider.of<OrderController>(context, listen: false).updateOrderStatus(
                                        status: 'shipped',
                                        orderId: widget.order?.id ?? 0,
                                        onSuccess: () {
                                          widget.onsuccess?.call();
                                        },
                                      );
                                    },
                                    color: AppColor.greenColor(context),
                                    text: AppLocaleKey.deliveredToTheRepresentative.tr(),
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 2,
                            child: CustomButton(
                              onPressed: () {
                                NamedNavigatorImpl.showAppBottomSheet(
                                  context,
                                  ChangeNotifierProvider.value(
                                    builder: (context, child) => AnotherRepresentativeBottomSheet(
                                      onSuccess: () {
                                        widget.onsuccess?.call();
                                      },
                                      orderController: widget.orderController,
                                      order: widget.order,
                                    ),
                                    value: widget.orderController,
                                  ),
                                );
                              },
                              color: Colors.transparent,
                              text: AppLocaleKey.anotherRepresentative.tr(),
                              style: AppTextStyle.text18MS(context),
                              prefixIcon:
                                  const CustomImage(path: AppImages.refreshIcon, type: ImageType.svg, height: 18),
                            ),
                          ),
                        ],
                      ),
                    )
                  : status == 'shipped' && widget.order?.delegateFromOut != 'in_resturant'
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 23),
                          child: CustomButton(
                            color: AppColor.greenColor(context),
                            text: AppLocaleKey.delegateInRoute.tr(),
                            onPressed: () {
                              widget.onsuccess?.call();
                            },
                          ),
                        )
                      : status == 'delivered'
                          ? Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 23),
                              child: CustomButton(
                                color: AppColor.greenColor(context),
                                text: AppLocaleKey.deliveredToTheRepresentative.tr(),
                                onPressed: () {
                                  widget.orderController.updateOrderStatus(
                                    status: 'shipped',
                                    orderId: widget.order?.id ?? 0,
                                    onSuccess: () {
                                      widget.onsuccess?.call();
                                    },
                                  );
                                },
                              ),
                            )
                          : status == 'cancelled'
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 23),
                                  child: CustomButton(
                                    color: AppColor.lightGreyColor(context),
                                    text: AppLocaleKey.orderCanceled.tr(),
                                    style: AppTextStyle.text18MS(context),
                                  ),
                                )
                              : status == 'completed'
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 23),
                                      child: CustomButton(
                                        color: AppColor.lightGreyColor(context),
                                        text: AppLocaleKey.deliveredOrderToCustomer.tr(),
                                        style: AppTextStyle.text18BS(context),
                                      ),
                                    )
                                  : widget.orderController.singleOrder?.delegateFromOut == 'out_resturant'
                                      ? Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 23),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: CustomButton(
                                                  color: AppColor.lightGreyColor(context),
                                                  text: AppLocaleKey.waitingApprovalFromDelegates.tr(),
                                                  style: AppTextStyle.text16BS(context),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: CustomButton(
                                                  onPressed: () {
                                                    NamedNavigatorImpl.showAppBottomSheet(
                                                      context,
                                                      ChangeNotifierProvider.value(
                                                        builder: (context, child) => AnotherRepresentativeBottomSheet(
                                                          onSuccess: () {
                                                            widget.onsuccess?.call();
                                                          },
                                                          orderController: widget.orderController,
                                                          order: widget.orderController.singleOrder,
                                                        ),
                                                        value: widget.orderController,
                                                      ),
                                                    );
                                                  },
                                                  color: Colors.transparent,
                                                  text: AppLocaleKey.reSearch.tr(),
                                                  style: AppTextStyle.text16MS(context),
                                                  prefixIcon: const CustomImage(
                                                      path: AppImages.refreshIcon, type: ImageType.svg, height: 14),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : const SizedBox(),
        ],
      ),
    );
  }
}
