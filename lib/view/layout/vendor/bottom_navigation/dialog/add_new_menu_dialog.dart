import 'package:easy_localization/easy_localization.dart';
import '../../../../../helpers/routes/app_routers_import.dart';
import 'package:flutter/material.dart';

import '../../../../../helpers/hive/hive_methods.dart';
import '../../../../../helpers/locale/app_locale_key.dart';
import '../../../../../helpers/theme/app_colors.dart';
import '../../../../../helpers/theme/app_text_style.dart';
import '../../../../custom_widgets/buttons/custom_button.dart';
import '../../products/screen/add_new_menu_screen.dart';
import '../../products/screen/add_product_screen.dart';

class AddNewMenuDialog extends StatelessWidget {
  const AddNewMenuDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      child: Builder(
        builder: (context) {
          return Container(
            decoration: BoxDecoration(color: AppColor.whiteColor(context), borderRadius: BorderRadius.circular(25)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 30),
                Text(AppLocaleKey.doYouWantTheMainRestaurantMenu.tr(), style: AppTextStyle.text16BS(context)),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: CustomButton(
                    text: AppLocaleKey.yes.tr(),
                    onPressed: () {
                      HiveMethods.updateFirstTimeInProducts();
                      Navigator.pop(context);
                      NamedNavigatorImpl.pushNamed(context, AddNewMenuScreen.routeName);
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: CustomButton(
                    color: AppColor.whiteColor(context),
                    text: AppLocaleKey.noAddNewMenu.tr(),
                    style: AppTextStyle.text16BS(context),
                    onPressed: () {
                      HiveMethods.updateFirstTimeInProducts();
                      Navigator.pop(context);
                      NamedNavigatorImpl.pushNamed(context, AddProductScreen.routeName);
                    },
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }
}
