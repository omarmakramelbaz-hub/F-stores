import 'package:easy_localization/easy_localization.dart';
import '../../../../../helpers/routes/app_routers_import.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../../../helpers/hive/hive_methods.dart';
import '../../../../../helpers/images/app_images.dart';
import '../../../../../helpers/locale/app_locale_key.dart';
import '../../../../../helpers/theme/app_colors.dart';
import '../../../../../helpers/theme/app_text_style.dart';
import '../../auth/controller/auth_controller.dart';
import '../controller/bottom_navigation_controller.dart';
import '../dialog/add_new_menu_dialog.dart';

class CustomNavBarWidget extends StatelessWidget {
  const CustomNavBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<VendorBottomNavigationController>(
      builder: (context, controller, _) {
        return BottomAppBar(
          color: AppColor.whiteColor(context),
          shape: const CircularNotchedRectangle(),
          notchMargin: 10,
          child: SizedBox(
            height: 80,
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          controller.updateIndex(0);
                        },
                        icon: SvgPicture.asset(
                          controller.screenIndex == 0 ? AppImages.homeFillIcon : AppImages.homeIcon,
                          colorFilter: ColorFilter.mode(
                            controller.screenIndex == 0 ? AppColor.mainAppColor(context) : AppColor.greyColor(context),
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      Text(
                        AppLocaleKey.home.tr(),
                        style: controller.screenIndex == 0
                            ? AppTextStyle.text14RM(context)
                            : AppTextStyle.text14RG(context),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          controller.updateIndex(1);
                        },
                        icon: SvgPicture.asset(
                          controller.screenIndex == 1 ? AppImages.orderFillIcon : AppImages.ordersIcon,
                          colorFilter: ColorFilter.mode(
                            controller.screenIndex == 1 ? AppColor.mainAppColor(context) : AppColor.greyColor(context),
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      Text(
                        AppLocaleKey.orders.tr(),
                        style: controller.screenIndex == 1
                            ? AppTextStyle.text14RM(context)
                            : AppTextStyle.text14RG(context),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          controller.updateIndex(2);
                          if (HiveMethods.getIsFirstTimeInProducts() == true &&
                              context.read<AuthController>().profile?.parentHasMenu == 'yes') {
                            NamedNavigatorImpl.showAppDialog(context, willPop: true, const AddNewMenuDialog());
                          }

                          controller.updateIndex(2);
                          HiveMethods.updateFirstTimeInProducts();
                        },
                        icon: SvgPicture.asset(
                          AppImages.menuIcon,
                          colorFilter: ColorFilter.mode(
                            controller.screenIndex == 2 ? AppColor.mainAppColor(context) : AppColor.greyColor(context),
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      Text(
                        AppLocaleKey.menu.tr(),
                        style: controller.screenIndex == 2
                            ? AppTextStyle.text14RM(context)
                            : AppTextStyle.text14RG(context),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          controller.updateIndex(3);
                        },
                        icon: SvgPicture.asset(
                          controller.screenIndex == 3 ? AppImages.notificationFillIcon : AppImages.notificationsIcon,
                          colorFilter: ColorFilter.mode(
                            controller.screenIndex == 3 ? AppColor.mainAppColor(context) : AppColor.greyColor(context),
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      Text(
                        AppLocaleKey.notifications.tr(),
                        style: controller.screenIndex == 3
                            ? AppTextStyle.text14RM(context)
                            : AppTextStyle.text14RG(context),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          controller.updateIndex(4);
                        },
                        icon: SvgPicture.asset(
                          controller.screenIndex == 4 ? AppImages.accountFillIcon : AppImages.myAccountIcon,
                          colorFilter: ColorFilter.mode(
                            controller.screenIndex == 4 ? AppColor.mainAppColor(context) : AppColor.greyColor(context),
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      Text(
                        AppLocaleKey.myAccount.tr(),
                        style: controller.screenIndex == 4
                            ? AppTextStyle.text14RM(context)
                            : AppTextStyle.text14RG(context),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
