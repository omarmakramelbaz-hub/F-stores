import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../helpers/hive/hive_methods.dart';
import '../../../../../../helpers/images/app_images.dart';
import '../../../../../../helpers/routes/app_routers_import.dart';
import '../../../../../../helpers/theme/app_colors.dart';
import '../../../../../custom_widgets/api_response_widget/api_response_widget.dart';
import '../../../../../custom_widgets/custom_image/custom_image.dart';
import '../../../bottom_navigation/screen/bottom_navigation_bar_screen.dart';
import '../../controller/auth_controller.dart';
import '../../screen/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const String routeName = 'SplashScreen';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    _initial();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: AppColor.splashMainAppColor(context),
      body: const CustomImage(
        path: AppImages.vendorSplashImage,
        type: ImageType.asset,
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
      ),
      bottomNavigationBar: SizedBox(
        height: 80,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Consumer<AuthController>(
            builder: (context, authController, _) {
              return ApiResponseWidget(
                apiResponse: authController.profileResponse,
                onReload: _getData,
                isEmpty: false,
                unauthorizedWidget: const SizedBox(),
                axis: Axis.horizontal,
                child: const SizedBox(),
              );
            },
          ),
        ),
      ),
    );
  }

  void _initial() {
    if (HiveMethods.getToken() != null) {
      context.read<AuthController>().initialProfile();
      _getData();
    } else {
      Future.delayed(const Duration(milliseconds: 2700), () {
        NamedNavigatorImpl.pushNamedAndRemoveUntil(context, LoginScreen.routeName);
      });
    }
  }

  Future<void> _getData() async {
    context.read<AuthController>().getProfile(
      // onHaveIdANDToken: (id, token) {
      //   context.read<PusherController>().initPusher(channelName: 'private-user.$id', userId: id, token: token);
      // },
      onSuccess: () {
        Future.delayed(const Duration(milliseconds: 2700), () {
          NamedNavigatorImpl.pushNamedAndRemoveUntil(context, VendorBottomNavigationBarScreen.routeName);
          HiveMethods.setIsFreeDelivery(context.read<AuthController>().profile?.kmPrice == 0);
        });
      },
      onUnauthenticated: () {
        Future.delayed(const Duration(milliseconds: 2700), () {
          NamedNavigatorImpl.pushNamedAndRemoveUntil(context, LoginScreen.routeName);
        });
      },
    );
  }
}
