import 'package:easy_localization/easy_localization.dart';
import '../../../../../helpers/routes/app_routers_import.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../helpers/images/app_images.dart';
import '../../../../../helpers/locale/app_locale_key.dart';
import '../../../../../helpers/theme/app_colors.dart';
import '../../../../../helpers/theme/app_text_style.dart';
import '../../../../../helpers/utils/common_methods.dart';
import '../../../../custom_widgets/custom_form_field/custom_form_field.dart';
import '../../../../custom_widgets/custom_image/custom_image.dart';
import '../bottom_sheet/submit_your_fee_bottom_sheet.dart';
import '../controller/request_delegate_controller.dart';
import '../screen/search_place_screen.dart';

class CustomMapAnimatedContainer extends StatelessWidget {
  const CustomMapAnimatedContainer({
    super.key,
    required this.containerHeight,
    //  required this.requestDelegateController,
  });

  final double? containerHeight;
  // final RequestDelegateController requestDelegateController;
  @override
  Widget build(BuildContext context) {
    return Consumer<RequestDelegateController>(
      builder: (context, requestDelegateController, _) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: containerHeight ?? MediaQuery.of(context).size.height * 0.35,
          decoration: BoxDecoration(
            color: AppColor.blackColor(context),
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(18.0),
                        child: CustomImage(path: AppImages.darkMotorCycle, type: ImageType.svg),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        AppLocaleKey.usingMotorcycle.tr(),
                        style: AppTextStyle.text16RM(context).copyWith(color: AppColor.whiteColor(context)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  InkWell(
                    onTap: () {
                      NamedNavigatorImpl.pushNamed(context, SearchPlaceScreen.routeName);
                      requestDelegateController.fromAddress != ''
                          ? requestDelegateController.setFromController(requestDelegateController.fromAddress)
                          : null;
                      requestDelegateController.fromLat != ''
                          ? requestDelegateController.setFromLat(requestDelegateController.fromLat!)
                          : null;
                      requestDelegateController.fromLan != ''
                          ? requestDelegateController.setFromLan(requestDelegateController.fromLan!)
                          : null;
                    },
                    child: Row(
                      children: [
                        const CustomImage(path: AppImages.radioFromIcon, type: ImageType.svg),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            requestDelegateController.fromAddress != ''
                                ? requestDelegateController.fromAddress
                                : AppLocaleKey.deliverFromCurrentLocation.tr(),
                            style: AppTextStyle.text16RS(context).copyWith(color: AppColor.whiteColor(context)),
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  requestDelegateController.toAddress != ''
                      ? InkWell(
                          onTap: () {
                            NamedNavigatorImpl.pushNamed(context, SearchPlaceScreen.routeName);
                            requestDelegateController.fromAddress != ''
                                ? requestDelegateController.setFromController(requestDelegateController.fromAddress)
                                : null;
                            requestDelegateController.fromLat != ''
                                ? requestDelegateController.setFromLat(requestDelegateController.fromLat!)
                                : null;
                            requestDelegateController.fromLan != ''
                                ? requestDelegateController.setFromLan(requestDelegateController.fromLan!)
                                : null;
                          },
                          child: Row(
                            children: [
                              const CustomImage(path: AppImages.radioToIcon, type: ImageType.svg),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  requestDelegateController.toAddress != ''
                                      ? requestDelegateController.toAddress
                                      : AppLocaleKey.deliverFromCurrentLocation.tr(),
                                  style: AppTextStyle.text16RS(context).copyWith(color: AppColor.whiteColor(context)),
                                  maxLines: 2,
                                ),
                              ),
                            ],
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            NamedNavigatorImpl.pushNamed(context, SearchPlaceScreen.routeName);
                            requestDelegateController.fromAddress != ''
                                ? requestDelegateController.setFromController(requestDelegateController.fromAddress)
                                : null;
                            requestDelegateController.fromLat != ''
                                ? requestDelegateController.setFromLat(requestDelegateController.fromLat!)
                                : null;
                            requestDelegateController.fromLan != ''
                                ? requestDelegateController.setFromLan(requestDelegateController.fromLan!)
                                : null;
                          },
                          child: Card(
                            elevation: 2,
                            color: AppColor.lightDarkColor(context),
                            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                            child: SizedBox(
                              width: double.infinity,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                                child: Row(
                                  children: [
                                    const CustomImage(path: AppImages.searchLocationIcon, type: ImageType.svg),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        AppLocaleKey.deliverTo.tr(),
                                        style: AppTextStyle.text16MS(
                                          context,
                                        ).copyWith(color: AppColor.whiteColor(context)),
                                        maxLines: 2,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                  const SizedBox(height: 15),
                  CustomFormField(
                    controller: requestDelegateController.priceEC,
                    onTap: () {
                      if (requestDelegateController.toLat != null &&
                          requestDelegateController.toLan != null &&
                          requestDelegateController.fromLat != null &&
                          requestDelegateController.fromLan != null) {
                        NamedNavigatorImpl.showAppBottomSheet(
                          context,
                          ChangeNotifierProvider.value(
                            value: requestDelegateController,
                            child: SubmitYourFeeBottomSheet(
                              requestDelegateController: requestDelegateController,
                              kmPrice: int.parse('${requestDelegateController.delegatesOnMap?.shippingKmPrice}'),
                              shippingPercentage: int.parse(
                                '${requestDelegateController.delegatesOnMap?.shippingMinPricePrecentage}',
                              ),
                              distance: num.parse('${requestDelegateController.distance}'),
                            ),
                          ),
                        );
                      } else {
                        CommonMethods.showError(message: AppLocaleKey.chooseDeliveryLocationsFirst.tr());
                      }
                    },
                    readOnly: true,
                    suffixIcon: const Padding(
                      padding: EdgeInsets.all(14.0),
                      child: CustomImage(path: AppImages.editPriceIcon, type: ImageType.svg),
                    ),
                    hintText: AppLocaleKey.providePrice.tr(),
                    radius: 10,
                    fillColor: AppColor.lightDarkColor(context),
                    unFocusColor: AppColor.lightDarkColor(context),
                    textStyle: AppTextStyle.text14MW(context),
                  ),

                  // Container(
                  //   padding:
                  //       const EdgeInsets.symmetric(horizontal: 10, vertical: 13),
                  //   decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(8),
                  //       color: AppColor.lightMainAppColor(context)),
                  //   child: Row(
                  //     children: [
                  //       const CustomImage(
                  //         path: AppImages.infoIcon,
                  //         type: ImageType.svg,
                  //       ),
                  //       const SizedBox(width: 10),
                  //       Text(AppLocaleKey.deliveryDuration.tr(),
                  //           style: AppTextStyle.text16RS(context)),
                  //     ],
                  //   ),
                  // )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
