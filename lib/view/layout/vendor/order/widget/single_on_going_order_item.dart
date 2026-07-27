import 'package:easy_localization/easy_localization.dart';
import '../../../../../helpers/routes/app_routers_import.dart';
import 'package:flutter/material.dart';

import '../../../../../helpers/images/app_images.dart';
import '../../../../../helpers/locale/app_locale_key.dart';
import '../../../../../helpers/notification_helper/sound_notification.dart';
import '../../../../../helpers/theme/app_colors.dart';
import '../../../../../helpers/theme/app_text_style.dart';
import '../../../../../helpers/utils/date_methods.dart';
import '../../../../custom_widgets/custom_image/custom_image.dart';
import '../../../../custom_widgets/dotted_decoration/dotted_decoration.dart';
import '../../../../global/widget/order_item_widget.dart';
import '../controller/order_controller.dart';
import '../model/vendor_orders_model.dart';
import '../screen/order_details_screen.dart';

class SingleOnGoingOrderItem extends StatefulWidget {
  const SingleOnGoingOrderItem({super.key, this.items, this.order, this.onSuccess, required this.orderController});
  final List<Items>? items;
  final VendorOrdersModel? order;
  final VoidCallback? onSuccess;
  final OrderController orderController;

  @override
  State<SingleOnGoingOrderItem> createState() => _SingleOnGoingOrderItemState();
}

class _SingleOnGoingOrderItemState extends State<SingleOnGoingOrderItem> {
  bool isShipped = false;
  @override
  Widget build(BuildContext context) {
    // final status = widget.order?.status;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.textFormBorderColor(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              SoundNotification.stopSound();
              NamedNavigatorImpl.pushNamed(
                context,
                OrderDetailsScreen.routeName,
                arguments: OrderDetailsScreenArgs(orderId: widget.order?.id ?? 0, fromHome: false),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  CustomImage(
                    path: widget.order?.userLogo == null || widget.order?.userLogo == ''
                        ? AppImages.userIcon
                        : widget.order?.userLogo ?? '',
                    type: widget.order?.userLogo == null || widget.order?.userLogo == ''
                        ? ImageType.svg
                        : ImageType.network,
                    height: 50,
                    width: 50,
                    radius: 25,
                    fit: BoxFit.fill,
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
                  const Expanded(child: SizedBox()),
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
          widget.order?.delegateId != null
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomImage(
                        path: widget.order?.delegateLogo ?? '',
                        type: ImageType.network,
                        height: 50,
                        width: 50,
                        radius: 24,
                        fit: BoxFit.fill,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(widget.order?.delegateName ?? '', style: AppTextStyle.textD16M(context)),
                        ),
                      ),
                      // CustomElevatedButton(
                      //   onPressed: () {
                      //     UrlLauncherMethods.makePhoneCall(
                      //         widget.order?.delegateMobile ?? "");
                      //   },
                      //   imagePath: AppImages.callIcon,
                      // ),
                      // CustomElevatedButton(
                      //   onPressed: () {},
                      //   imagePath: AppImages.chatIcon,
                      // ),
                    ],
                  ),
                )
              : const SizedBox(),

          widget.order?.delegateId != null
              ? Divider(thickness: 0.2, color: AppColor.textFormColor(context))
              : const SizedBox(),

          ...List.generate(
            widget.items?.length ?? 0,
            (orderIndex) => OrderItemWidget(orderItem: widget.items?[orderIndex]),
          ),
          // Divider(
          //   thickness: 0.2,
          //   color: AppColor.textFormColor(context),
          // ),

          // status == "pending" && widget.order?.delegateFromOut == null
          //     ? Padding(
          //         padding:
          //             const EdgeInsets.symmetric(horizontal: 16, vertical: 23),
          //         child: CustomButton(
          //           text: AppLocaleKey.chooseDeliveryMethod.tr(),
          //           onPressed: () {
          //             NavigatorMethods.showAppBottomSheet(
          //                 context,
          //                 DeliverOrderBottomSheet(
          //                   order: widget.order!,
          //                 ));
          //           },
          //         ),
          //       )
          //     : status == "another_delegate"
          //         ? Padding(
          //             padding: const EdgeInsets.symmetric(
          //                 horizontal: 16, vertical: 23),
          //             child: Row(
          //               children: [
          //                 Expanded(
          //                   flex: 3,
          //                   child: ChangeNotifierProvider<OrderController>(
          //                     create: (context) => OrderController(),
          //                     child: Builder(builder: (context) {
          //                       return CustomButton(
          //                         onPressed: () {
          //                           if (widget.order?.delegateId != null) {
          //                             Provider.of<OrderController>(context,
          //                                     listen: false)
          //                                 .updateOrderStatus(
          //                                     status: 'shipped',
          //                                     orderId: widget.order?.id ?? 0,
          //                                     onSuccess: () {
          //                                       widget.onSuccess?.call();
          //                                     });
          //                           }
          //                         },
          //                         color: widget.order?.delegateId == null
          //                             ? AppColor.lightGreyColor(context)
          //                             : AppColor.greenColor(context),
          //                         text: AppLocaleKey
          //                             .deliveredToTheRepresentative
          //                             .tr(),
          //                         style: widget.order?.delegateId == null
          //                             ? AppTextStyle.text18BS(context)
          //                             : AppTextStyle.buttonStyle(context),
          //                       );
          //                     }),
          //                   ),
          //                 ),
          //                 const SizedBox(
          //                   width: 10,
          //                 ),
          //                 Expanded(
          //                     flex: 2,
          //                     child: CustomButton(
          //                       onPressed: () {
          //                         NavigatorMethods.showAppBottomSheet(
          //                             context,
          //                             ChangeNotifierProvider.value(
          //                               builder: (context, child) =>
          //                                   AnotherRepresentativeBottomSheet(
          //                                 orderController:
          //                                     widget.orderController,
          //                                 order: widget.order,
          //                               ),
          //                               value: widget.orderController,
          //                             ));
          //                       },
          //                       color: Colors.transparent,
          //                       text: AppLocaleKey.anotherRepresentative.tr(),
          //                       style: AppTextStyle.text18MS(context),
          //                       prefixIcon: const CustomImage(
          //                         path: AppImages.refreshIcon,
          //                         type: ImageType.svg,
          //                         height: 18,
          //                       ),
          //                     ))
          //               ],
          //             ),
          //           )
          //         : status == "shipped"
          //             ? widget.order?.delegateFromOut != "in_resturant"
          //                 ? Padding(
          //                     padding: const EdgeInsets.symmetric(
          //                         horizontal: 16, vertical: 23),
          //                     child: CustomButton(
          //                       color: AppColor.greenColor(context),
          //                       text: AppLocaleKey.deliverOrderToCustomer.tr(),
          //                       onPressed: () {
          //                         widget.orderController.updateOrderStatus(
          //                             orderId: widget.order?.id ?? 0,
          //                             status: "completed",
          //                             onSuccess: () {
          //                               widget.orderController.getSingleOrder(
          //                                 id: widget.order?.id ?? 0,
          //                               );
          //                             });
          //                       },
          //                     ),
          //                   )
          //                 : widget.order?.delegateFromOut != "in_resturant"
          //                     ? Padding(
          //                         padding: const EdgeInsets.symmetric(
          //                             horizontal: 16, vertical: 23),
          //                         child: CustomButton(
          //                           color: AppColor.greenColor(context),
          //                           text: AppLocaleKey.delegateInRoute.tr(),
          //                           onPressed: () {
          //                             widget.onSuccess?.call();
          //                           },
          //                         ),
          //                       )
          //                     : Padding(
          //                         padding: const EdgeInsets.symmetric(
          //                             horizontal: 16, vertical: 23),
          //                         child: CustomButton(
          //                           color: AppColor.lightGreyColor(context),
          //                           text: AppLocaleKey.deliveredOrderToCustomer
          //                               .tr(),
          //                           style: AppTextStyle.text18BS(context),
          //                         ))
          //             : status == "delivered"
          //                 ? Padding(
          //                     padding: const EdgeInsets.symmetric(
          //                         horizontal: 16, vertical: 23),
          //                     child: CustomButton(
          //                       color: AppColor.greenColor(context),
          //                       text: AppLocaleKey.deliveredToTheRepresentative
          //                           .tr(),
          //                       onPressed: () {
          //                         widget.orderController.updateOrderStatus(
          //                             status: 'shipped',
          //                             orderId: widget.order?.id ?? 0,
          //                             onSuccess: () {
          //                               widget.onSuccess?.call();
          //                             });
          //                       },
          //                     ),
          //                   )
          //                 : status == "cancelled"
          //                     ? Padding(
          //                         padding: const EdgeInsets.symmetric(
          //                             horizontal: 16, vertical: 23),
          //                         child: CustomButton(
          //                           color: AppColor.lightGreyColor(context),
          //                           text: AppLocaleKey.orderCanceled.tr(),
          //                           style: AppTextStyle.text18MS(context),
          //                         ),
          //                       )
          //                     : status == "accepted"
          //                         ? Padding(
          //                             padding: const EdgeInsets.symmetric(
          //                                 horizontal: 16, vertical: 23),
          //                             child: CustomButton(
          //                               color: AppColor.greenColor(context),
          //                               text: AppLocaleKey
          //                                   .deliveredToTheRepresentative
          //                                   .tr(),
          //                               onPressed: () {
          //                                 widget.orderController
          //                                     .updateOrderStatus(
          //                                         status: 'shipped',
          //                                         orderId:
          //                                             widget.order?.id ?? 0,
          //                                         onSuccess: () {
          //                                           widget.orderController
          //                                               .getSingleOrder(
          //                                             id: widget.order?.id ?? 0,
          //                                           );
          //                                         });
          //                               },
          //                             ),
          //                           )
          //                         : status == "completed"
          //                             ? widget.order?.paymentType == "cash" &&
          //                                     widget.order?.delegateFromOut ==
          //                                         "in_resturant"
          //                                 ? Padding(
          //                                     padding:
          //                                         const EdgeInsets.symmetric(
          //                                             horizontal: 16,
          //                                             vertical: 23),
          //                                     child: Row(
          //                                       children: [
          //                                         Expanded(
          //                                           flex: 2,
          //                                           child: CustomButton(
          //                                             color: AppColor
          //                                                 .lightGreyColor(
          //                                                     context),
          //                                             text: AppLocaleKey
          //                                                 .deliveredOrderToCustomer
          //                                                 .tr(),
          //                                             style:
          //                                                 AppTextStyle.text18BS(
          //                                                     context),
          //                                           ),
          //                                         ),
          //                                         Expanded(
          //                                           flex: 1,
          //                                           child: CustomButton(
          //                                             color:
          //                                                 AppColor.greenColor(
          //                                                     context),
          //                                             text: AppLocaleKey
          //                                                 .payToDelegate
          //                                                 .tr(),
          //                                             onPressed: () {
          //                                               widget.orderController
          //                                                   .vendorTransferOrderPrice(
          //                                                       orderId: widget
          //                                                               .order
          //                                                               ?.id ??
          //                                                           0,
          //                                                       onSuccess: () {
          //                                                         widget
          //                                                             .orderController
          //                                                             .getSingleOrder(
          //                                                                 id: widget.order?.id ??
          //                                                                     0);
          //                                                       });
          //                                             },
          //                                           ),
          //                                         )
          //                                       ],
          //                                     ))
          //                                 : Padding(
          //                                     padding:
          //                                         const EdgeInsets.symmetric(
          //                                             horizontal: 16,
          //                                             vertical: 23),
          //                                     child: CustomButton(
          //                                       color: AppColor.lightGreyColor(
          //                                           context),
          //                                       text: AppLocaleKey
          //                                           .deliveredOrderToCustomer
          //                                           .tr(),
          //                                       style: AppTextStyle.text18BS(
          //                                           context),
          //                                     ))
          //                             : widget.orderController.singleOrder
          //                                         ?.delegateFromOut ==
          //                                     "out_resturant"
          //                                 ? Padding(
          //                                     padding:
          //                                         const EdgeInsets.symmetric(
          //                                             horizontal: 16,
          //                                             vertical: 23),
          //                                     child: Row(
          //                                       children: [
          //                                         Expanded(
          //                                           flex: 2,
          //                                           child: CustomButton(
          //                                             color: AppColor
          //                                                 .lightGreyColor(
          //                                                     context),
          //                                             text: AppLocaleKey
          //                                                 .waitingApprovalFromDelegates
          //                                                 .tr(),
          //                                             style:
          //                                                 AppTextStyle.text16BS(
          //                                                     context),
          //                                           ),
          //                                         ),
          //                                         Expanded(
          //                                             flex: 1,
          //                                             child: CustomButton(
          //                                               onPressed: () {
          //                                                 NavigatorMethods
          //                                                     .showAppBottomSheet(
          //                                                         context,
          //                                                         ChangeNotifierProvider
          //                                                             .value(
          //                                                           builder: (context,
          //                                                                   child) =>
          //                                                               AnotherRepresentativeBottomSheet(
          //                                                             orderController:
          //                                                                 widget
          //                                                                     .orderController,
          //                                                             order: widget
          //                                                                 .order,
          //                                                           ),
          //                                                           value: widget
          //                                                               .orderController,
          //                                                         ));
          //                                               },
          //                                               color:
          //                                                   Colors.transparent,
          //                                               text: AppLocaleKey
          //                                                   .reSearch
          //                                                   .tr(),
          //                                               style: AppTextStyle
          //                                                   .text16MS(context),
          //                                               prefixIcon:
          //                                                   const CustomImage(
          //                                                 path: AppImages
          //                                                     .refreshIcon,
          //                                                 type: ImageType.svg,
          //                                                 height: 14,
          //                                               ),
          //                                             ))
          //                                       ],
          //                                     ),
          //                                   )
          //                                 : const SizedBox(),
        ],
      ),
    );
  }
}
