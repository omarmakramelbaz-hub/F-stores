import 'dart:convert';
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

import '../../../../../helpers/locale/app_locale_key.dart';
import '../../../../../helpers/notification_helper/sound_notification.dart';
import '../../../../../helpers/pusher_service/pusher_controller.dart';
import '../../../../../helpers/utils/common_methods.dart';
import '../../../../../helpers/utils/permission_handler.dart';
import '../controller/bottom_navigation_controller.dart';
import 'btn_app_bar.dart';
import 'custom_nav_bar_widget.dart';

class VendorBottomNavigationBarScreen extends StatefulWidget {
  static const String routeName = 'BottomNavigationBarScreen';
  const VendorBottomNavigationBarScreen({super.key});

  @override
  State<VendorBottomNavigationBarScreen> createState() => _VendorBottomNavigationBarScreenState();
}

class _VendorBottomNavigationBarScreenState extends State<VendorBottomNavigationBarScreen> {
  late PusherController _pusherController;
  @override
  void initState() {
    Future.delayed(Duration.zero, () async => await PermissionService.requestLocation());
    _pusherController = context.read<PusherController>();
    _pusherController.addEventListener('vendor.updated', _handleVendorUpdated);
    super.initState();
  }

  void _handleVendorUpdated(PusherEvent event) {
    try {
      var jsonData = jsonDecode(event.data) as Map<String, dynamic>;

      if (mounted) {
        var status = jsonData['order_id']['status']?.toString();

        var orderNo = jsonData['order_id']['order_no']?.toString();
        log('*************************************************************');
        log(jsonData.toString());

        if (status != null && status == 'pending') {
          SoundNotification.playLongSound();
          CommonMethods.showToast(message: '${AppLocaleKey.thereIsANewOrder.tr()} $orderNo');
        } else {
          CommonMethods.showToast(message: '${AppLocaleKey.thereIsANewOrderWithStatus.tr()} $orderNo');
        }
      }
    } catch (e, stackTrace) {
      log('Error handling Pusher event: $e');
      log('Stack trace: $stackTrace');
    }
  }

  @override
  void dispose() {
    _pusherController.removeEventListener('vendor.updated', _handleVendorUpdated);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => VendorBottomNavigationController(),
      child: Consumer<VendorBottomNavigationController>(
        builder: (context, controller, _) {
          return PopScope(
            canPop: controller.screenIndex == 0,
            onPopInvoked: controller.onWillPop,
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: const BtnAppBar(),
              body: controller.screensList[controller.screenIndex],
              bottomNavigationBar: const CustomNavBarWidget(),
            ),
          );
        },
      ),
    );
  }
}
