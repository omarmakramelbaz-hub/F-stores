import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../helpers/hive/hive_methods.dart';
import '../../../../../helpers/images/app_images.dart';
import '../../../../../helpers/locale/app_locale_key.dart';
import '../../../../../helpers/theme/app_colors.dart';
import '../../../../../helpers/theme/app_text_style.dart';
import '../../../../custom_widgets/buttons/custom_button.dart';

class ChangeLangBottomSheet extends StatefulWidget {
  const ChangeLangBottomSheet({super.key});

  @override
  State<ChangeLangBottomSheet> createState() => _MenuBottomSheetWidgetState();
}

class _MenuBottomSheetWidgetState extends State<ChangeLangBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.whiteColor(context),
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(36), topRight: Radius.circular(36)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 33, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppLocaleKey.changeLanguage.tr(), style: AppTextStyle.text16MS(context)),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: AppColor.whiteColor(context),
                      child: SvgPicture.asset(AppImages.closeIcon),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Divider(thickness: 0.7, color: AppColor.greyColor(context)),
            const SizedBox(height: 15),
            CustomButton(
              gradient: LinearGradient(
                colors: [AppColor.gridOneButtonColor(context), AppColor.gridTwoButtonColor(context)],
              ),
              onPressed: () {
                context.setLocale(const Locale('ar'));
                HiveMethods.updateLang(const Locale('ar'));
                Navigator.pop(context);
              },
              style: context.locale == const Locale('ar')
                  ? AppTextStyle.text18BW(context)
                  : AppTextStyle.text18BS(context),
              color:
                  context.locale == const Locale('ar') ? AppColor.mainAppColor(context) : AppColor.whiteColor(context),
              borderColor: context.locale == const Locale('ar') ? null : AppColor.mainAppColor(context),
              text: 'العربية',
            ),
            const SizedBox(height: 15),
            CustomButton(
              gradient: LinearGradient(
                colors: [
                  AppColor.gridOneButtonColor(context),
                  AppColor.gridTwoButtonColor(context),
                ],
              ),
              onPressed: () {
                context.setLocale(const Locale('en'));
                HiveMethods.updateLang(const Locale('en'));
                Navigator.pop(context);
              },
              style: context.locale == const Locale('en')
                  ? AppTextStyle.text18BW(context)
                  : AppTextStyle.text18BS(context),
              color:
                  context.locale == const Locale('en') ? AppColor.mainAppColor(context) : AppColor.whiteColor(context),
              borderColor: context.locale == const Locale('en') ? null : AppColor.mainAppColor(context),
              text: 'English',
            ),
          ],
        ),
      ),
    );
  }
}
