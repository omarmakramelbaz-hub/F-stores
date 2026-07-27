import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import '../../../../../helpers/routes/app_routers_import.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

import '../../../../../helpers/images/app_images.dart';
import '../../../../../helpers/locale/app_locale_key.dart';
import '../../../../../helpers/notification_helper/sound_notification.dart';
import '../../../../../helpers/pusher_service/pusher_controller.dart';
import '../../../../../helpers/theme/app_colors.dart';
import '../../../../../helpers/theme/app_text_style.dart';
import '../../../../../helpers/utils/common_methods.dart';
import '../../../../../helpers/utils/date_methods.dart';
import '../../../../../helpers/utils/url_launcher_methods.dart';
import '../../../../custom_widgets/api_response_widget/api_response_widget.dart';
import '../../../../custom_widgets/buttons/custom_button.dart';
import '../../../../custom_widgets/custom_app_bar/custom_app_bar.dart';
import '../../../../custom_widgets/custom_image/custom_image.dart';
import '../../../../custom_widgets/dotted_decoration/dotted_decoration.dart';
import '../../../../global/bottom_sheet/deliver_order_bottom_sheet.dart';
import '../../../../global/button/custom_elivated_botton.dart';
import '../../../../global/chat/screen/admin_chat_screen.dart';
import '../../../../global/widget/order_details_item_widget.dart';
import '../bottom_sheet/another_representative_bottom_sheet.dart';
import '../controller/order_controller.dart';
import 'delivery_location_screen.dart';

class OrderDetailsScreenArgs {
  final int orderId;
  final bool? fromHome;
  const OrderDetailsScreenArgs({required this.orderId, required this.fromHome});
}

class OrderDetailsScreen extends StatefulWidget {
  static const String routeName = 'OrderDetailsScreen';
  final OrderDetailsScreenArgs args;
  const OrderDetailsScreen({super.key, required this.args});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  BuildContext? currentContext;
  String? pusherStatus;
  String status = 'pending';
  int? pusherDelegateId;
  late PusherController _pusherController;

  Timer? _timer; // Timer instance
  int _remainingTime = 0; // Countdown timer in seconds
  bool _isResearchButtonDisabled = false; // To disable Button 2

  @override
  void initState() {
    super.initState();
    // _startTimer();
    // SoundNotification.instance.stopSound();
    _pusherController = context.read<PusherController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderController>().initialSingleOrder();
      context.read<OrderController>().getSingleOrder(id: widget.args.orderId).then(
            (value) => setState(() {
              status = context.read<OrderController>().singleOrder?.status ?? '';
            }),
          );
    });
    _pusherController.addEventListener('vendor.updated', _handleVendorUpdated);
  }

  void _handleVendorUpdated(PusherEvent event) {
    try {
      var jsonData = jsonDecode(event.data) as Map<String, dynamic>;
      if (mounted) {
        context.read<OrderController>().getSingleOrder(id: widget.args.orderId);
        setState(() {
          status = jsonData['order']['status']?.toString() ?? '';
          pusherDelegateId = int.parse(jsonData['order']['delegate_id']);
          var orderNo = jsonData['order']['order_no']?.toString();
          log('================> $pusherDelegateId');
          log('================> $pusherStatus');
          CommonMethods.showToast(message: '${AppLocaleKey.thereIsANewOrderWithStatus.tr()} $orderNo');
        });
      }
    } catch (e, stackTrace) {
      log('Error handling Pusher event: $e');
      log('Stack trace: $stackTrace');
    }
  }

  void updateStatus(String newStatus) {
    setState(() {
      status = newStatus;
      log('Status updated to =============================> $newStatus <=======================');
    });
  }

  // Function to start a 3-minute (180 seconds) timer
  void _startTimer() {
    setState(() {
      _remainingTime = 180;
      _isResearchButtonDisabled = true;
    });

    _timer?.cancel(); // Cancel any existing timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          _isResearchButtonDisabled = false; // Re-enable Button 2 when time is up
          _timer?.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _pusherController.removeEventListener('vendor.updated', _handleVendorUpdated);
    _timer?.cancel(); // Cancel timer when widget is disposed
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    currentContext = context;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderController>(
      builder: (context, orderController, _) {
        //final status = orderController.singleOrder?.status;
        return Container(
          color: AppColor.scaffoldColor(context),
          child: ApiResponseWidget(
            apiResponse: orderController.singleOrderResponse,
            onReload: () => orderController.getSingleOrder(id: widget.args.orderId),
            isEmpty: orderController.singleOrder == null,
            child: Scaffold(
              extendBody: false,
              appBar: CustomAppBar(
                context,
                height: 90,
                centerTitle: false,
                leadingPadding: 20,
                appBarColor: AppColor.whiteColor(context),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: AppColor.blackColor(context)),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                title: Padding(
                  padding: const EdgeInsets.only(bottom: 25),
                  child: Text(AppLocaleKey.orderDetailes.tr(), style: AppTextStyle.text20BS(context)),
                ),
                //   actions: [
                //     Padding(
                //       padding:
                //           const EdgeInsets.only(right: 16, top: 35, left: 16),
                //       child: Text(
                //         "${AppLocaleKey.orderNumber.tr()}: ${orderController.singleOrder?.orderNo ?? 0}#",
                //         style: AppTextStyle.textW14R(context),
                //       ),
                //     ),
                //   ],
              ),
              body: RefreshIndicator(
                onRefresh: () async {
                  orderController.getSingleOrder(id: widget.args.orderId);
                },
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 21),
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColor.textFormBorderColor(context)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomImage(
                                      path: orderController.singleOrder?.userLogo == null ||
                                              orderController.singleOrder?.userLogo == ''
                                          ? AppImages.userIcon
                                          : orderController.singleOrder?.userLogo ?? '',
                                      type: orderController.singleOrder?.userLogo == null ||
                                              orderController.singleOrder?.userLogo == ''
                                          ? ImageType.svg
                                          : ImageType.network,
                                      height: 50,
                                      width: 50,
                                      radius: 25,
                                      fit: BoxFit.fill,
                                    ),
                                    const SizedBox(width: 5),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    orderController.singleOrder?.userName ?? '',
                                                    style: AppTextStyle.textD16M(context),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    textWidthBasis: TextWidthBasis.longestLine,
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Row(
                                                    children: [
                                                      orderController.singleOrder?.delegateId == null
                                                          ? CustomElevatedButton(
                                                              onPressed: () {
                                                                UrlLauncherMethods.makePhoneCall(
                                                                  orderController.singleOrder?.userAddress?.mobile ??
                                                                      '',
                                                                );
                                                              },
                                                              imagePath: AppImages.callIcon,
                                                            )
                                                          : const SizedBox(),
                                                      // orderController
                                                      //             .singleOrder
                                                      //             ?.delegateId ==
                                                      //         null
                                                      //     ? CustomElevatedButton(
                                                      //         onPressed: () {
                                                      //           NavigatorMethods.pushNamed(
                                                      //               context,
                                                      //               ChatScreen
                                                      //                   .routeName,
                                                      //               arguments:
                                                      //                   ChatScreenArgs(
                                                      //                 senderDeviceToken:
                                                      //                     orderController.singleOrder?.resturantVendorFcmId ??
                                                      //                         "",
                                                      //                 accountType:
                                                      //                     'vendor',
                                                      //                 isVendor:
                                                      //                     false,
                                                      //                 vendorDeviceToken:
                                                      //                     '',
                                                      //                 receiverDeviceToken:
                                                      //                     orderController.singleOrder?.userFcmId ??
                                                      //                         "",
                                                      //                 senderName:
                                                      //                     orderController.singleOrder?.resturantName ??
                                                      //                         "",
                                                      //                 orderId:
                                                      //                     "VC${widget.args.orderId}",
                                                      //               ));
                                                      //         },
                                                      //         imagePath:
                                                      //             AppImages
                                                      //                 .chatIcon,
                                                      //       )
                                                      //     : const SizedBox(),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  Text(
                                                    DateMethods.formatToDate(
                                                      orderController.singleOrder?.createdAt?.toString(),
                                                    ),
                                                    style: AppTextStyle.text14RG(context),
                                                  ),
                                                  const SizedBox(width: 5),
                                                  Text(
                                                    DateMethods.formatToTime(
                                                      orderController.singleOrder?.createdAt?.toString() ?? '',
                                                    ),
                                                    style: AppTextStyle.text14RG(context),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                AppLocaleKey.orderNumber.tr().replaceAll(
                                                      '{}',
                                                      '${orderController.singleOrder?.orderNo ?? 0}',
                                                    ),
                                                style: AppTextStyle.text14RG(context),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              //===============================================================================
                              Container(decoration: const DottedDecoration(strokeWidth: 0.7, dash: [7, 5])),
                              const SizedBox(height: 15),
                              // Padding(
                              //   padding:
                              //       const EdgeInsets.symmetric(horizontal: 17),
                              //   child: Text(
                              //     AppLocaleKey.orderLocation.tr(),
                              //     style: AppTextStyle.text16MS(context),
                              //   ),
                              // ),
                              // const SizedBox(
                              //   height: 10,
                              // ),
                              //Location
                              // Padding(
                              //   padding:
                              //       const EdgeInsets.symmetric(horizontal: 12),
                              //   child: Row(
                              //     children: [
                              //       const CustomImage(
                              //           path: AppImages.locationIcon,
                              //           type: ImageType.svg),
                              //       const SizedBox(
                              //         width: 5,
                              //       ),
                              //       Text(
                              //         "${orderController.singleOrder?.userAddress?.areaName ?? ""}\t- \t${orderController.singleOrder?.userAddress?.streetName ?? ""}\t- \t${orderController.singleOrder?.userAddress?.addressName ?? ""}",
                              //         style: AppTextStyle.text16RG(context),
                              //       )
                              //     ],
                              //   ),
                              // ),
                              // const SizedBox(
                              //   height: 10,
                              // ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 17),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(AppLocaleKey.deliveryLocation.tr(), style: AppTextStyle.text16MS(context)),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              //Location
                              InkWell(
                                onTap: () {
                                  log('${orderController.singleOrder?.userAddress?.lat}');
                                  log('${orderController.singleOrder?.userAddress?.lng}');
                                  NamedNavigatorImpl.pushNamed(
                                    context,
                                    DeliveryLocationScreen.routeName,
                                    arguments: DeliveryLocationArgs(
                                      lat: double.parse(orderController.singleOrder?.userAddress?.lat ?? ''),
                                      lng: double.parse(orderController.singleOrder?.userAddress?.lng ?? ''),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  child: Row(
                                    children: [
                                      const CustomImage(path: AppImages.locationIcon, type: ImageType.svg),
                                      const SizedBox(width: 5),
                                      Expanded(
                                        child: Text(
                                          "${orderController.singleOrder?.userAddress?.streetName ?? ""}\t - \t${orderController.singleOrder?.userAddress?.cityName ?? ""}",
                                          style: AppTextStyle.text16RG(context),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Divider(thickness: 0.2, color: AppColor.textFormColor(context)),
                              orderController.singleOrder?.delegateId != null &&
                                      orderController.singleOrder?.delegateFromOut == 'out_resturant'
                                  ? Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          CustomImage(
                                            path: orderController.singleOrder?.delegateLogo ?? '',
                                            type: ImageType.network,
                                            height: 50,
                                            width: 50,
                                            radius: 24,
                                            fit: BoxFit.fill,
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                              child: Text(
                                                orderController.singleOrder?.delegateName ?? '',
                                                style: AppTextStyle.textD16M(context),
                                              ),
                                            ),
                                          ),
                                          CustomElevatedButton(
                                            onPressed: () {
                                              final data = orderController.singleOrder;
                                              NamedNavigatorImpl.pushNamed(
                                                context,
                                                AdminChatScreen.routeName,
                                                arguments: AdminChatScreenArgs(
                                                  senderId: data?.resturantVendorId.toString() ?? '',
                                                  receiverId: data?.delegateId.toString() ?? '',
                                                  receiverDeviceToken: data?.delegateFcmId ?? '',
                                                  receiverName: data?.delegateName ?? '',
                                                  senderName: data?.resturantName ?? '',
                                                  senderDeviceToken: data?.resturantVendorFcmId ?? '',
                                                  accountType: 'vendor',
                                                  isToVendor: false,
                                                  vendorDeviceToken: data?.resturantVendorDeviceToken ?? '',
                                                ),
                                              );
                                              // NavigatorMethods.pushNamed(
                                              //     context, ChatScreen.routeName,
                                              //     arguments: ChatScreenArgs(
                                              //       senderDeviceToken:
                                              //           orderController
                                              //                   .singleOrder
                                              //                   ?.delegateFcmId ??
                                              //               "",
                                              //       accountType: 'vendor',
                                              //       isVendor: false,
                                              //       vendorDeviceToken: orderController
                                              //               .singleOrder
                                              //               ?.resturantVendorDeviceToken ??
                                              //           "",
                                              //       receiverDeviceToken:
                                              //           orderController
                                              //                   .singleOrder
                                              //                   ?.delegateFcmId ??
                                              //               "",
                                              //       senderName: orderController
                                              //               .singleOrder
                                              //               ?.resturantName ??
                                              //           "",
                                              //       receiverName: orderController
                                              //               .singleOrder
                                              //               ?.delegateName ??
                                              //           "",
                                              //       orderId:
                                              //           "VD${widget.args.orderId}",
                                              //     ));
                                            },
                                            imagePath: AppImages.chatIcon,
                                          ),
                                          CustomElevatedButton(
                                            onPressed: () {
                                              UrlLauncherMethods.makePhoneCall(
                                                orderController.singleOrder!.delegateMobile ?? '',
                                              );
                                            },
                                            imagePath: AppImages.callIcon,
                                          ),
                                        ],
                                      ),
                                    )
                                  : orderController.singleOrder?.delegateFromOut != null
                                      ? Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              CustomImage(
                                                path: orderController.singleOrder?.resturantLogo ?? '',
                                                type: ImageType.network,
                                                height: 50,
                                                width: 50,
                                                radius: 24,
                                                fit: BoxFit.fill,
                                              ),
                                              const SizedBox(width: 20),
                                              Text(
                                                orderController.singleOrder?.delegateFromOut == 'out_resturant'
                                                    ? AppLocaleKey.delegateOutResturant.tr()
                                                    : AppLocaleKey.delegateInResturant.tr(),
                                              ),
                                            ],
                                          ),
                                        )
                                      : const SizedBox(),
                              Divider(thickness: 0.2, color: AppColor.textFormColor(context)),

                              ...List.generate(
                                orderController.singleOrder?.items?.length ?? 0,
                                (orderIndex) => OrderDetailsItemWidget(
                                  order: orderController.singleOrder,
                                  orderController: orderController,
                                  items: orderController.singleOrder?.items?[orderIndex],
                                  onSuccess: () {
                                    orderController.getSingleOrder(id: widget.args.orderId);
                                  },
                                ),
                              ),

                              //===========================nots=========================
                              if (orderController.singleOrder?.notes != null) ...[
                                Divider(thickness: 0.2, color: AppColor.textFormColor(context)),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                  child: Text(AppLocaleKey.orderNote.tr(), style: AppTextStyle.text16BS(context)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                  child: Text(
                                    orderController.singleOrder?.notes ?? '',
                                    style: AppTextStyle.textD16M(context),
                                  ),
                                ),
                              ],

                              Divider(thickness: 0.2, color: AppColor.textFormColor(context)),
                              //============================ Priceng ================================
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                child: Column(
                                  children: [
                                    // Secondary Total (Item price - 10%)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(AppLocaleKey.netProfit.tr(), style: AppTextStyle.text18MG(context)),
                                          Text(
                                            AppLocaleKey.pound.tr().replaceAll(
                                                  '{}',
                                                  ((orderController.singleOrder?.vendorPercentage ??
                                                          orderController.singleOrder?.vendorPercentage ??
                                                          0))
                                                      .toStringAsFixed(2),
                                                ), // Subtract 10%, default to 0
                                            style: AppTextStyle.text16RG(context),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(AppLocaleKey.appPercentage.tr(), style: AppTextStyle.text18MG(context)),
                                          Text(
                                            AppLocaleKey.pound.tr().replaceAll(
                                                  '{}',
                                                  ((orderController.singleOrder?.appToVendorPercentage ?? 0))
                                                      .toStringAsFixed(2),
                                                ), // Subtract 10%, default to 0
                                            style: AppTextStyle.text16RG(context),
                                          ),
                                        ],
                                      ),
                                    ),

                                    Container(
                                      padding: const EdgeInsets.symmetric(vertical: 5),
                                      decoration: const DottedDecoration(strokeWidth: 0.7, dash: [7, 5]),
                                    ),
                                    const SizedBox(height: 5),
                                    // Delivery Cost
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(AppLocaleKey.deliveryCost.tr(), style: AppTextStyle.text18MG(context)),
                                          Text(
                                            AppLocaleKey.pound.tr().replaceAll(
                                                  '{}',
                                                  (orderController.singleOrder?.deliveryPrice ?? 0).toStringAsFixed(2),
                                                ), // Default to 0 if null
                                            style: AppTextStyle.text16RG(context),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(vertical: 5),
                                      decoration: const DottedDecoration(strokeWidth: 0.7, dash: [7, 5]),
                                    ),
                                    const SizedBox(height: 5), // Service Fee (5% of total item price)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(AppLocaleKey.serviceFee.tr(), style: AppTextStyle.text18MG(context)),
                                          Text(
                                            AppLocaleKey.pound.tr().replaceAll(
                                                  '{}',
                                                  ((orderController.singleOrder?.serviceFees ?? 0)).toStringAsFixed(2),
                                                ),
                                            style: AppTextStyle.text16RG(context),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(vertical: 5),
                                      decoration: const DottedDecoration(strokeWidth: 0.7, dash: [7, 5]),
                                    ),
                                    const SizedBox(height: 5),
                                    // Added Value (14% of total item price)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(AppLocaleKey.addedValue.tr(), style: AppTextStyle.text18MG(context)),
                                          Text(
                                            AppLocaleKey.pound.tr().replaceAll(
                                                  '{}',
                                                  ((orderController.singleOrder?.tax ?? 0)).toStringAsFixed(2),
                                                ),
                                            style: AppTextStyle.text16RG(context),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(vertical: 5),
                                      decoration: const DottedDecoration(strokeWidth: 0.7, dash: [7, 5]),
                                    ),
                                    const SizedBox(height: 5),
                                    // Total Price (Sum of item price + delivery + service fee + added value)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(AppLocaleKey.totalPrice.tr(), style: AppTextStyle.text18BS(context)),

                                          // Text(
                                          //   AppLocaleKey.pound.tr().replaceAll(
                                          //       "{}",
                                          //       ((orderController.singleOrder
                                          //                       ?.totalItemPrice ??
                                          //                   0) +
                                          //               (orderController
                                          //                       .singleOrder
                                          //                       ?.deliveryPrice ??
                                          //                   0) +
                                          //               ((orderController
                                          //                           .singleOrder
                                          //                           ?.totalItemPrice ??
                                          //                       0) *
                                          //                   0.05) +
                                          //               ((orderController
                                          //                           .singleOrder
                                          //                           ?.totalItemPrice ??
                                          //                       0) *
                                          //                   0.14))
                                          //           .toStringAsFixed(
                                          //               2)), // Default to 0 for any null value
                                          //   style:
                                          //       AppTextStyle.text18BS(context),
                                          // ),
                                          Text(
                                            AppLocaleKey.pound.tr().replaceAll(
                                                  '{}',
                                                  ((orderController.singleOrder?.grandTotal ?? 0)).toStringAsFixed(2),
                                                ), // Default to 0 for any null value
                                            style: AppTextStyle.text18BS(context),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Divider(thickness: 0.2, color: AppColor.textFormColor(context)),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                child: Text(AppLocaleKey.paymentMethod.tr(), style: AppTextStyle.text16BS(context)),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 24,
                                      width: 5,
                                      decoration: BoxDecoration(
                                        color: AppColor.mainAppColor(context),
                                        borderRadius: BorderRadius.horizontal(
                                          left: context.locale.languageCode == 'ar'
                                              ? const Radius.circular(5)
                                              : const Radius.circular(0),
                                          right: context.locale.languageCode == 'ar'
                                              ? const Radius.circular(0)
                                              : const Radius.circular(5),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    CustomImage(
                                      height: 18,
                                      path: orderController.singleOrder?.paymentType == 'cash'
                                          ? AppImages.cashIcon
                                          : orderController.singleOrder?.paymentType == 'online'
                                              ? AppImages.visaIcon
                                              : orderController.singleOrder?.paymentType == 'v_cash'
                                                  ? AppImages.vfCash
                                                  : orderController.singleOrder?.paymentType == 'wallet'
                                                      ? AppImages.payWalletIcon.tr()
                                                      : '',
                                      type: ImageType.svg,
                                      color: AppColor.mainAppColor(context),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      orderController.singleOrder?.paymentType == 'cash'
                                          ? AppLocaleKey.cash.tr()
                                          : orderController.singleOrder?.paymentType == 'online'
                                              ? AppLocaleKey.visa.tr()
                                              : orderController.singleOrder?.paymentType == 'v_cash'
                                                  ? AppLocaleKey.digitalWalletAndInstaPay.tr()
                                                  : orderController.singleOrder?.paymentType == 'wallet'
                                                      ? AppLocaleKey.appWalletBalance.tr()
                                                      : '',
                                      style: AppTextStyle.text16BM(context),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              //==========================  buttton  ================================
                            ],
                          ),
                        ),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ),
              bottomNavigationBar: buildBottomNavigationBar(
                orderController.singleOrder?.status ?? '',
                orderController,
                context,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildBottomNavigationBar(String status, OrderController orderController, BuildContext context) {
    if (status == 'cancelled') {
      return _buildOrderCancelledButton();
    } else if (status == 'new_order') {
      return _buildDeliverOrderToCustomerButton(orderController);
    }
    if (status == 'completed') {
      return _buildPaymentOrDeliveryButton(orderController);
    }
    if (status == 'pending' && orderController.singleOrder?.scheduleDate == null) {
      if (orderController.singleOrder?.delegateFromOut == 'out_resturant') {
        return _buildDelegateStatusBasedButton(status, orderController);
      }
      if (orderController.singleOrder?.delegateFromOut == 'in_resturant') {
        return _buildStatusBasedButton(status, orderController);
      }
      if (orderController.singleOrder?.delegateFromOut == null) {
        return _buildChooseDeliveryMethodButton(orderController);
      }
    }
    if (status == 'accepted' && orderController.singleOrder?.delegateFromOut == 'out_resturant') {
      return _buildDeliveredToRepresentativeButtonOut(status, orderController);
    }
    // if (status == "pending" &&
    //     orderController.singleOrder?.delegateFromOut == "out_resturant") {
    //   return _buildPendingDelegateButton(orderController);
    // }
    // if (status == "pending" &&
    //         orderController.singleOrder?.delegateFromOut == null ||
    //     orderController.singleOrder?.delegateFromOut == "in_resturant") {
    //   return _buildStatusBasedButton(status, orderController);
    // }
    if (status == 'pending' && orderController.singleOrder?.scheduleDate != null) {
      String apiDateString = orderController.singleOrder?.scheduleDate ?? '';

      DateTime? apiDate = DateTime.parse(apiDateString);

      DateTime currentDate = DateTime.now();

      DateTime apiDateOnly = DateTime(apiDate.year, apiDate.month, apiDate.day);
      DateTime currentDateOnly = DateTime(currentDate.year, currentDate.month, currentDate.day);

      if (apiDateOnly == currentDateOnly) {
        if (status == 'pending') {
          if (orderController.singleOrder?.delegateFromOut != 'out_resturant') {
            return _buildDelegateStatusBasedButton(status, orderController);
          }
          if (orderController.singleOrder?.delegateFromOut != 'in_resturant') {
            return _buildStatusBasedButton(status, orderController);
          }
        }
        if (orderController.singleOrder?.delegateFromOut == null) {
          return _buildChooseDeliveryMethodButton(orderController);
        }
      }

      if (orderController.singleOrder?.acceptedNotify == 'no' &&
          orderController.singleOrder?.orderType == 'schedule' &&
          status == 'pending') {
        return _buildChooseDeliveryMethodForScheduledOrderButton(orderController);
      }

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 23),
        child: CustomButton(
          text: AppLocaleKey.thisOrderIsScheduled.tr().replaceAll(
                '{}',
                DateMethods.formatDateToArabic(orderController.singleOrder?.scheduleDate ?? ''),
              ),
          color: AppColor.lightGreyColor(context),
          style: AppTextStyle.text16MS(context),
        ),
      );
    }
    if (orderController.singleOrder?.delegateFromOut == 'in_resturant') {
      return _buildStatusBasedButton(status, orderController);
    }
    if (status == 'shipped' && orderController.singleOrder?.delegateFromOut == 'out_resturant') {
      return _buildDelegateInRouteButton(orderController);
    }
    return _buildDelegateStatusBasedButton(status, orderController);
  }

  Widget _buildChooseDeliveryMethodButton(OrderController orderController) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 23),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: CustomButton(
              text: AppLocaleKey.chooseDeliveryMethod.tr(),
              onPressed: () {
                SoundNotification.stopSound();
                NamedNavigatorImpl.showAppBottomSheet(
                  context,
                  DeliverOrderBottomSheet(
                    order: orderController.singleOrder!,
                    onsuccess: () {
                      _startTimer();
                      orderController.getSingleOrder(id: widget.args.orderId);
                      callBackground();
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 1,
            child: CustomButton(
              text: AppLocaleKey.declineOrder.tr(),
              color: AppColor.redColor(context),
              style: AppTextStyle.text14MW(context),
              onPressed: () {
                SoundNotification.stopSound();
                orderController.updateOrderStatus(
                  status: 'declined',
                  orderId: widget.args.orderId,
                  onSuccess: () {
                    orderController.getSingleOrder(id: widget.args.orderId);
                    callBackground();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChooseDeliveryMethodForScheduledOrderButton(OrderController orderController) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 23),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: CustomButton(
              text: AppLocaleKey.accept.tr(),
              onPressed: () {
                SoundNotification.stopSound();
                orderController.acceptScheduleOrder(
                  orderId: widget.args.orderId,
                  onSuccess: () {
                    orderController.getSingleOrder(id: widget.args.orderId);
                    callBackground();
                  },
                );
                // NavigatorMethods.showAppBottomSheet(
                //   context,
                //   DeliverOrderBottomSheet(
                //     order: orderController.singleOrder!,
                //     onsuccess: () {
                //       _startTimer();
                //       orderController.getSingleOrder(id: widget.args.orderId);
                //       callBackground();
                //     },
                //   ),
                // );
              },
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 1,
            child: CustomButton(
              text: AppLocaleKey.declineOrder.tr(),
              color: AppColor.redColor(context),
              style: AppTextStyle.text14MW(context),
              onPressed: () {
                SoundNotification.stopSound();
                orderController.updateOrderStatus(
                  status: 'declined',
                  orderId: widget.args.orderId,
                  onSuccess: () {
                    orderController.getSingleOrder(id: widget.args.orderId);
                    callBackground();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBasedButton(String status, OrderController orderController) {
    switch (status) {
      case 'accepted':
        return _buildDeliveredToRepresentativeButton(status, orderController);
      case 'shipped':
        return _inResturantDelegateOnRoute(orderController);
      case 'completed':
        return _buildPaymentOrDeliveryButton(orderController);
      case 'cancelled':
        return _buildOrderCancelledButton();
      case 'declined':
        return _buildOrderCancelledButton();

      default:
        return Container();
    }
  }

  Widget _buildDeliveredToRepresentativeButton(String status, OrderController orderController) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 23),
      child: CustomButton(
        color: AppColor.greenColor(context),
        text: AppLocaleKey.deliveredToTheRepresentative.tr(),
        onPressed: () {
          orderController.updateOrderStatus(
            status: 'shipped',
            orderId: widget.args.orderId,
            onSuccess: () {
              orderController.getSingleOrder(id: widget.args.orderId);
            },
          );
        },
      ),
    );
  }

  Widget _buildDeliveredToRepresentativeButtonOut(String status, OrderController orderController) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 23),
      child: CustomButton(
        color: AppColor.lightGreyColor(context),
        text: AppLocaleKey.delegateSelected.tr(),
        style: AppTextStyle.text18BS(context),
        onPressed: () {
          // orderController.updateOrderStatus(
          //   status: 'shipped',
          //   orderId: widget.args.orderId,
          //   onSuccess: () {
          //     orderController.getSingleOrder(id: widget.args.orderId);
          //   },
          // );
        },
      ),
    );
  }

  Widget _buildDeliverOrderToCustomerButton(OrderController orderController) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 23),
      child: CustomButton(
        color: AppColor.greenColor(context),
        text: AppLocaleKey.deliverOrderToCustomer.tr(),
        onPressed: () {
          orderController.updateOrderStatus(
            orderId: widget.args.orderId,
            status: 'completed',
            onSuccess: () {
              orderController.getSingleOrder(id: widget.args.orderId);
              callBackground();
            },
          );
        },
      ),
    );
  }

  Widget _inResturantDelegateOnRoute(OrderController orderController) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 23),
      child: CustomButton(
        color: AppColor.greenColor(context),
        text: AppLocaleKey.delegateInRoute.tr(),
        onPressed: () {
          CommonMethods.showChooseDialog(
            context,
            message: AppLocaleKey.deliverOrderToCustomer.tr(),
            onPressed: () {
              Navigator.pop(context);
              orderController.updateOrderStatus(
                orderId: widget.args.orderId,
                status: 'completed',
                onSuccess: () {
                  orderController.getSingleOrder(id: widget.args.orderId);
                  callBackground();
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildPaymentOrDeliveryButton(OrderController orderController) {
    if (orderController.singleOrder?.paymentType == 'cash' &&
        orderController.singleOrder?.hasTransferedBefore != 1 &&
        orderController.singleOrder?.delegateFromOut == 'in_resturant') {
      return _buildPaymentButtons(orderController);
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 23),
      child: CustomButton(
        color: AppColor.lightGreyColor(context),
        text: AppLocaleKey.deliveredOrderToCustomer.tr(),
        style: AppTextStyle.text18BS(context),
      ),
    );
  }

  Widget _buildPaymentButtons(OrderController orderController) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 23),
      child: CustomButton(
        color: AppColor.lightGreyColor(context),
        text: AppLocaleKey.deliveredOrderToCustomer.tr(),
        style: AppTextStyle.text18BS(context),
      ),
      // Row(
      //   children: [
      //     Expanded(
      //       flex: 2,
      //       child: CustomButton(
      //         color: AppColor.lightGreyColor(context),
      //         text: AppLocaleKey.deliveredOrderToCustomer.tr(),
      //         style: AppTextStyle.text18BS(context),
      //       ),
      //     ),
      //   //  const SizedBox(width: 10),
      //     // Expanded(
      //     //   flex: 1,
      //     //   child: CustomButton(
      //     //     color: AppColor.greenColor(context),
      //     //     text: AppLocaleKey.payToDelegate.tr(),
      //     //     onPressed: () {
      //     //       orderController.vendorTransferOrderPrice(
      //     //         orderId: widget.args.orderId,
      //     //         onSuccess: () {
      //     //           orderController.getSingleOrder(id: widget.args.orderId);
      //     //         },
      //     //       );
      //     //     },
      //     //   ),
      //     // ),
      //   ],
      // ),
    );
  }

  Widget _buildOrderCancelledButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 23),
      child: CustomButton(
        color: AppColor.lightGreyColor(context),
        text: AppLocaleKey.orderCanceled.tr(),
        style: AppTextStyle.text18MS(context),
      ),
    );
  }

  Widget _buildDelegateStatusBasedButton(String status, OrderController orderController) {
    switch (status) {
      case 'pending':
        return _buildPendingDelegateButton(orderController);
      case 'accepted':
        return _buildDeliveredToRepresentativeButtonOut(status, orderController);
      case 'shipped':
        return _buildDelegateInRouteButton(orderController);
      case 'completed':
        return _buildOrderCompletedButton();
      case 'cancelled':
        return _buildOrderCancelledButton();
      case 'declined':
        return _buildOrderCancelledButton();
      case 'another_delegate':
        return _buildPendingDelegateButton(orderController);
      default:
        return _buildDefaultContainer();
    }
    // return status == "cancelled" ? _buildOrderCancelledButton() : Container();
  }

  Widget _buildPendingDelegateButton(OrderController orderController) {
    if (orderController.singleOrder?.delegateFromOut == null) {
      return _buildChooseDeliveryMethodButton(orderController);
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 23),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: CustomButton(
              color: AppColor.mainAppColor(context),
              text: AppLocaleKey.inResturantDelegate.tr(),
              style: AppTextStyle.text16BW(context),
              onPressed: () {
                SoundNotification.stopSound();
                orderController.delverOrderFromOrOut(
                  type: 'in_resturant',
                  orderId: widget.args.orderId,
                  restaurantId: orderController.singleOrder?.resturantId ?? 0,
                  onSuccess: () {
                    orderController.getSingleOrder(id: widget.args.orderId);
                    callBackground();
                  },
                );
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: CustomButton(
              onPressed: _isResearchButtonDisabled
                  ? () {
                      SoundNotification.stopSound();
                      CommonMethods.showError(message: AppLocaleKey.cantSearchAgainAfter3Minutes.tr());
                    }
                  : () {
                      SoundNotification.stopSound();
                      NamedNavigatorImpl.showAppBottomSheet(
                        context,
                        ChangeNotifierProvider.value(
                          builder: (context, child) => AnotherRepresentativeBottomSheet(
                            orderController: orderController,
                            order: orderController.singleOrder,
                            onSuccess: () {
                              orderController.getSingleOrder(id: widget.args.orderId);
                              callBackground();
                            },
                          ),
                          value: orderController,
                        ),
                      );
                    },
              color: Colors.transparent,
              text: AppLocaleKey.reSearch.tr(),
              style: AppTextStyle.text16MS(context),
              prefixIcon: const CustomImage(path: AppImages.refreshIcon, type: ImageType.svg, height: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDelegateInRouteButton(OrderController orderController) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 23),
      child: CustomButton(
        color: AppColor.lightGreyColor(context),
        text: AppLocaleKey.delegateInRoute.tr(),
        style: AppTextStyle.text18BS(context),
        onPressed: () {
          // orderController.getSingleOrder(id: widget.args.orderId);
        },
      ),
    );
  }

  Widget _buildOrderCompletedButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 23),
      child: CustomButton(
        color: AppColor.lightGreyColor(context),
        text: AppLocaleKey.deliveredOrderToCustomer.tr(),
        style: AppTextStyle.text18BS(context),
      ),
    );
  }

  Widget _buildDefaultContainer() {
    return Container(color: Colors.green, height: 100, width: 200);
  }

  Future<void> callBackground() async {
    if (!mounted) return;

    if (widget.args.fromHome == true) {
      log('Home Order');
      final homeController = Provider.of<OrderController>(context, listen: false);

      try {
        await Future.wait([homeController.getCurrentVendorHomeOrders(), homeController.getPendingVendorHomeOrders()]);
      } catch (e) {
        log('Error loading home orders: $e');
      }
    } else {
      log('not in Home Order');
      final orderController = Provider.of<OrderController>(context, listen: false);
      try {
        // Initialize states first
        orderController.initialVendorWaitingOrders();
        orderController.initialVendorOngoingOrders();
        orderController.initialVendorCompletedOrders();

        await Future.wait([
          orderController.getVendorWaitingOrders(),
          orderController.getVendorOngoingOrders(),
          orderController.getVendorCompletedOrders(),
        ]);
      } catch (e) {
        log('Error loading orders: $e');
      }
    }
  }
}
