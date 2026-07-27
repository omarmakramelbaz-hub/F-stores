import 'dart:convert';
import 'dart:developer';

import '../../../../../helpers/pusher_service/pusher_controller.dart';
import '../../../../../helpers/theme/app_colors.dart';
import '../../../../custom_widgets/api_response_widget/api_response_widget.dart';
import '../../../../global/widget/no_notification_widget.dart';
import '../controller/notifications_controller.dart';
import '../model/notifications_model.dart';
import '../widget/notification_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late PusherController _pusherController;
  @override
  void initState() {
    super.initState();
    _pusherController = context.read<PusherController>();

    _pusherController.addEventListener('notification.updated', _handleVendorNotificationUpdated);
  }

  void _handleVendorNotificationUpdated(PusherEvent event) {
    try {
      var jsonData = jsonDecode(event.data) as Map<String, dynamic>;
      log('Notification updated: $jsonData');
      if (mounted) {
        var notification = NotificationsModel.fromJson(jsonData);
        context.read<NotificationsController>().addNotificationToTop(notification);
      }
    } catch (e, stackTrace) {
      log('Error handling Pusher event: $e');
      log('Stack trace: $stackTrace');
    }
  }

  @override
  dispose() {
    _pusherController.removeEventListener('notification.updated', _handleVendorNotificationUpdated);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<NotificationsController>(
        builder: (context, notificationsController, _) => RefreshIndicator(
          onRefresh: () async {
            await notificationsController.getNotifications();
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // Text(
              //   tr(AppLocaleKey.today),
              //   style: AppTextStyle.text18BS(context),
              // ),
              const SizedBox(height: 30),

              ApiResponseWidget(
                apiResponse: notificationsController.notificationsResponse,
                onReload: () => notificationsController.getNotifications(),
                isEmpty: notificationsController.notifications.isEmpty,
                emptyWidget: const NoNotificationWidget(),
                child: Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColor.whiteColor(context),
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(36),
                        topLeft: Radius.circular(36),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.greyColor(context).withOpacity(.2),
                          blurRadius: 10,
                          offset: const Offset(0, -3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // const SizedBox(height: 20),
                          // Text(
                          //   "اليوم ",
                          //   style: AppTextStyle.text16MS(context),
                          // ),
                          const SizedBox(height: 25),
                          Expanded(
                            child: ListView.separated(
                              itemCount: notificationsController.notifications.length,
                              itemBuilder: (context, index) {
                                return NotificationWidget(notification: notificationsController.notifications[index]);
                              },
                              separatorBuilder: (BuildContext context, int index) => Column(
                                children: [
                                  const Padding(padding: EdgeInsets.only(bottom: 15)),
                                  Divider(color: AppColor.greyColor(context).withOpacity(0.3)),
                                  const Padding(padding: EdgeInsets.only(bottom: 15)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
