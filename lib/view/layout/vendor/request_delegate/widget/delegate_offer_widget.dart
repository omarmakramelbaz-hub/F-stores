import 'package:easy_localization/easy_localization.dart';
import '../../../../../helpers/routes/app_routers_import.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../helpers/images/app_images.dart';
import '../../../../../helpers/locale/app_locale_key.dart';
import '../../../../../helpers/theme/app_colors.dart';
import '../../../../../helpers/theme/app_text_style.dart';
import '../../../../custom_widgets/buttons/custom_button.dart';
import '../../../../custom_widgets/custom_image/custom_image.dart';
import '../../bottom_navigation/screen/bottom_navigation_bar_screen.dart';
import '../controller/request_delegate_controller.dart';
import '../model/accepted_delegate_model.dart';

class DelegateOfferWidget extends StatefulWidget {
  const DelegateOfferWidget({
    super.key,
    required this.acceptedDelegateModel,
    this.cancelReCall,
    this.order,
    this.onReject,
  });
  final Delegates? acceptedDelegateModel;
  final VoidCallback? cancelReCall;
  final VoidCallback? onReject;
  final Order? order;
  @override
  State<DelegateOfferWidget> createState() => _DelegateOfferWidgetState();
}

class _DelegateOfferWidgetState extends State<DelegateOfferWidget> {
  RequestDelegateController? requestDelegateController;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        requestDelegateController = Provider.of<RequestDelegateController>(context, listen: false);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RequestDelegateController>(
      builder: (context, requestDelegateController, _) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Card(
            color: AppColor.lightDarkColor(context),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomImage(
                        path: widget.acceptedDelegateModel?.photoProfile != null
                            ? widget.acceptedDelegateModel?.photoProfile ?? ''
                            : AppImages.delegateRDIcon,
                        type: widget.acceptedDelegateModel?.photoProfile != null ? ImageType.network : ImageType.svg,
                        height: 45,
                        width: 45,
                        radius: 25,
                        fit: BoxFit.cover,
                      ),
                      // const SizedBox(
                      //   width: 5,
                      // ),
                      Text(
                        widget.acceptedDelegateModel?.name ?? '',
                        style: AppTextStyle.text18RS(context).copyWith(color: AppColor.whiteColor(context)),
                      ),

                      // const SizedBox(
                      //   width: 5,
                      // ),
                      // Row(
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      //   children: [
                      //     const CustomImage(
                      //         path: AppImages.starIcon, type: ImageType.svg),
                      //     const SizedBox(
                      //       width: 5,
                      //     ),
                      //     Text(
                      //       '4.5',
                      //       style: AppTextStyle.text14RS(context).copyWith(
                      //           color: AppColor.whiteColor(context), height: 1.4),
                      //     ),
                      //   ],
                      // ),
                      Text(
                        AppLocaleKey.deliveryCount.tr().replaceAll(
                              '{}',
                              '${widget.acceptedDelegateModel?.completedOrdersCount ?? ""}',
                            ),
                        style: AppTextStyle.text14RS(context).copyWith(color: AppColor.whiteColor(context)),
                      ),
                      Column(
                        children: [
                          Text(
                            requestDelegateController
                                .calculateExpectedDeliveryTime(
                                  averageSpeedKmPerHour: 30,
                                  toDLat: widget.acceptedDelegateModel?.lat ?? '0.0',
                                  toDLng: widget.acceptedDelegateModel?.lng ?? '0.0',
                                )
                                .toStringAsFixed(2),
                            style: AppTextStyle.text14RS(context).copyWith(color: AppColor.whiteColor(context)),
                          ),
                          Text(
                            "${requestDelegateController.calculateDistanceInMeters(toDLat: widget.acceptedDelegateModel?.lat ?? "0.0", toDLng: widget.acceptedDelegateModel?.lng ?? "0.0").toStringAsFixed(2)} m",
                            style: AppTextStyle.text14RS(context).copyWith(color: AppColor.whiteColor(context)),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: MediaQuery.of(context).size.width * 0.2),
                      Text(
                        AppLocaleKey.egyp.tr().replaceAll(
                              '{}',
                              '${widget.acceptedDelegateModel?.amount ?? widget.order?.actualPrice ?? requestDelegateController.actualPrice}',
                            ),
                        style: AppTextStyle.text18RS(context).copyWith(color: AppColor.whiteColor(context)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          height: 40,
                          text: AppLocaleKey.accept.tr(),
                          onPressed: () {
                            requestDelegateController.acceptedOrDeclinedDelegate(
                              orderId: requestDelegateController.orderId!,
                              delegateId: widget.acceptedDelegateModel!.id!,
                              status: 'accepted',
                              onSuccess: () {
                                widget.cancelReCall?.call();
                                NamedNavigatorImpl.pushNamedAndRemoveUntil(
                                  context,
                                  VendorBottomNavigationBarScreen.routeName,
                                );
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: CustomButton(
                          height: 40,
                          text: AppLocaleKey.reject.tr(),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              AppColor.blackColor(context).withOpacity(0.5),
                              AppColor.blackColor(context).withOpacity(0.5),
                            ],
                          ),
                          onPressed: () {
                            requestDelegateController.acceptedOrDeclinedDelegate(
                              orderId: requestDelegateController.orderId!,
                              delegateId: widget.acceptedDelegateModel!.id!,
                              status: 'declined',
                              onSuccess: () {
                                // widget.cancelReCall?.call();
                                widget.onReject?.call();
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
