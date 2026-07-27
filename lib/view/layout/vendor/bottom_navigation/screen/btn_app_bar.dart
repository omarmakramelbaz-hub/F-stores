import 'package:audioplayers/audioplayers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../helpers/images/app_images.dart';
import '../../../../../helpers/locale/app_locale_key.dart';
import '../../../../../helpers/notification_helper/sound_notification.dart';
import '../../../../../helpers/routes/app_routers_import.dart';
import '../../../../../helpers/theme/app_colors.dart';
import '../../../../../helpers/theme/app_text_style.dart';
import '../../../../custom_widgets/buttons/custom_button.dart';
import '../../../../custom_widgets/custom_app_bar/custom_app_bar.dart';
import '../../../../custom_widgets/custom_image/custom_image.dart';
import '../../auth/controller/auth_controller.dart';
import '../../map/screen/map_screen.dart';
import '../../products/screen/add_product_screen.dart';
import '../controller/bottom_navigation_controller.dart';

class BtnAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BtnAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    return Consumer<VendorBottomNavigationController>(
      builder: (context, controller, _) {
        return CustomAppBar(
          context,
          height: 80,
          appBarColor: AppColor.whiteColor(context),
          leadingWidth: MediaQuery.of(context).size.width / 1.5,
          leading: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: controller.screenIndex == 2
                ? Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(AppLocaleKey.products.tr(), style: AppTextStyle.text16BS(context)),
                  )
                : InkWell(
                    onTap: () {
                      NamedNavigatorImpl.pushNamed(context, VendorLocationScreen.routeName);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(AppLocaleKey.address.tr(), style: AppTextStyle.textD18M(context)),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: Text(
                                  Provider.of<AuthController>(context).profile?.areaTitle ??
                                      Provider.of<AuthController>(context).profile?.resturantCityname ??
                                      '',
                                  style: AppTextStyle.textD16M(context),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
          title: const SizedBox(),
          actions: (() {
            if (controller.screenIndex == 2) {
              [
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
                  child: CustomButton(
                    borderColor: AppColor.mainAppColor(context),
                    prefixIcon: const CustomImage(path: AppImages.addIcon, type: ImageType.svg),
                    text: AppLocaleKey.addProduct.tr(),
                    style: AppTextStyle.text16MM(context),
                    width: MediaQuery.of(context).size.width / 2.5,
                    height: 38,
                    color: AppColor.whiteColor(context),
                    gap: 15,
                    onPressed: () {
                      NamedNavigatorImpl.pushNamed(context, AddProductScreen.routeName);
                    },
                  ),
                ),
              ];
            }

            return [
              StreamBuilder<PlayerState>(
                stream: SoundNotification.audioPlayer.onPlayerStateChanged,
                builder: (context, snapshot) {
                  if (snapshot.data == PlayerState.playing) {
                    return IconButton(
                      onPressed: () {
                        SoundNotification.stopSound();
                      },
                      icon: const Icon(Icons.stop_circle_outlined, color: Colors.red, size: 30),
                    );
                  }
                  return const SizedBox.shrink();
                },
              )
            ];
          })(),
        );
      },
    );
  }
}
