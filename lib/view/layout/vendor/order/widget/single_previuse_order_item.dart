import 'package:easy_localization/easy_localization.dart';
import '../../../../../helpers/routes/app_routers_import.dart';
import 'package:flutter/material.dart';

import '../../../../../helpers/images/app_images.dart';
import '../../../../../helpers/locale/app_locale_key.dart';
import '../../../../../helpers/notification_helper/sound_notification.dart';
import '../../../../../helpers/theme/app_colors.dart';
import '../../../../../helpers/theme/app_text_style.dart';
import '../../../../../helpers/utils/date_methods.dart';
import '../../../../custom_widgets/buttons/custom_button.dart';
import '../../../../custom_widgets/custom_image/custom_image.dart';
import '../../../../custom_widgets/dotted_decoration/dotted_decoration.dart';
import '../../../../global/widget/order_item_widget.dart';
import '../model/vendor_orders_model.dart';
import '../screen/order_details_screen.dart';

class SinglePreviousOrderItem extends StatelessWidget {
  const SinglePreviousOrderItem({super.key, this.items, this.order});
  final List<Items>? items;
  final VendorOrdersModel? order;
  @override
  Widget build(BuildContext context) {
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
                arguments: OrderDetailsScreenArgs(orderId: order?.id ?? 0, fromHome: false),
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
                        path: order?.userLogo == null || order?.userLogo == ''
                            ? AppImages.userIcon
                            : order?.userLogo ?? '',
                        type: order?.userLogo == null || order?.userLogo == '' ? ImageType.svg : ImageType.network,
                        height: 50,
                        width: 50,
                        radius: 25,
                        fit: BoxFit.fill,
                      ),
                      const SizedBox(width: 10),
                      Text(order?.userName ?? '', style: AppTextStyle.textD16M(context)),
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
                          Text("${order?.orderNo ?? ""}\t#", style: AppTextStyle.text16RG(context)),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5),
                                child: Icon(Icons.access_time, size: 17, color: AppColor.greyColor(context)),
                              ),
                              Text(
                                DateMethods.formatToTime(order?.createdAt?.toString() ?? ''),
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
                      Flexible(
                        child: Text(
                          "${order?.userAddress?.streetName ?? ""}\t-\t${order?.userAddress?.cityName ?? ""}",
                          style: AppTextStyle.text16MG(context),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                Divider(thickness: 0.2, color: AppColor.textFormColor(context)),

                ...List.generate(items?.length ?? 0, (orderIndex) => OrderItemWidget(orderItem: items?[orderIndex])),
              ],
            ),
          ),
          Divider(thickness: 0.2, color: AppColor.textFormColor(context)),
          order?.status == 'cancelled'
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 23),
                  child: CustomButton(
                    color: AppColor.lightGreyColor(context),
                    text: AppLocaleKey.orderCanceled.tr(),
                    style: AppTextStyle.text18MS(context),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 23),
                  child: CustomButton(
                    color: AppColor.lightGreyColor(context),
                    text: AppLocaleKey.deliveredOrderToCustomer.tr(),
                    style: AppTextStyle.text18BS(context),
                  ),
                ),
        ],
      ),
    );
  }
}
