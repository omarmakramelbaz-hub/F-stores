import 'dart:developer';

import '../../../../../helpers/routes/app_routers_import.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../helpers/images/app_images.dart';
import '../../../../../helpers/theme/app_text_style.dart';
import '../../../../../helpers/utils/date_methods.dart';
import '../../../../custom_widgets/custom_image/custom_image.dart';
import '../../order/screen/order_details_screen.dart';
import '../../request_delegate/screen/request_delegate_screen.dart';
import '../../wallet/screen/wallet_screen.dart';
import '../model/notifications_model.dart';

class NotificationWidget extends StatelessWidget {
  final NotificationsModel notification;
  const NotificationWidget({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        log('tapped');
        notification.data?.notificationData?.notificationType == 1
            ? notification.data?.notificationData?.orderType == 'shipping'
                ? NamedNavigatorImpl.pushNamed(context, RequestDelegateScreen.routeName)
                : NamedNavigatorImpl.pushNamed(
                    context,
                    OrderDetailsScreen.routeName,
                    arguments: OrderDetailsScreenArgs(
                      orderId: notification.data?.notificationData?.orderId ?? 0,
                      fromHome: false,
                    ),
                  )
            : notification.data?.notificationData?.notificationType == 3
                ? NamedNavigatorImpl.pushNamed(context, WalletScreen.routeName)
                : null;
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomImage(
                path: notification.data?.logo ?? '',
                width: MediaQuery.of(context).size.width * 0.1,
                height: MediaQuery.of(context).size.width * 0.1,
                radius: 25,
                fit: BoxFit.cover,
                type: ImageType.network,
              ),
              const SizedBox(width: 10),
              Expanded(child: Text(notification.data?.title ?? '', style: AppTextStyle.text16MS(context))),
              SvgPicture.asset(AppImages.timeIcon),
              const SizedBox(width: 10),
              Text(DateMethods.timeAgo(notification.createdAt ?? '', context), style: AppTextStyle.text16RM(context)),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Padding(
              //   padding: const EdgeInsets.symmetric(
              //     horizontal: 5,
              //   ),
              //   child: CircleAvatar(
              //     backgroundColor: AppColor.mainAppColor(context),
              //     radius: 6,
              //   ),
              // ),
              const SizedBox(width: 10),
              Expanded(child: Text(notification.data?.text ?? '', style: AppTextStyle.text16MS(context))),
            ],
          ),
        ],
      ),
    );
  }
}
