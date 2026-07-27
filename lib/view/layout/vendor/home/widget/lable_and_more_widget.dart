import 'package:easy_localization/easy_localization.dart';
import '../../../../../helpers/images/app_images.dart';
import '../../../../../helpers/locale/app_locale_key.dart';
import '../../../../../helpers/theme/app_colors.dart';
import '../../../../../helpers/theme/app_text_style.dart';
import '../../../../custom_widgets/custom_image/custom_image.dart';
import 'package:flutter/material.dart';

class LabelAndMoreWidget extends StatelessWidget {
  const LabelAndMoreWidget({super.key, required this.title, this.trilling, this.ordersCount, this.onPressed});
  final String title;
  final String? trilling;
  final int? ordersCount;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Text(title, style: AppTextStyle.text20BS(context)),
              const SizedBox(width: 20),
              ordersCount != null
                  ? CircleAvatar(
                      radius: 14,
                      backgroundColor: AppColor.mainAppColor(context),
                      child: Center(
                        child: Text(
                          ordersCount.toString(),
                          style: AppTextStyle.text18BW(
                            context,
                          ).copyWith(height: context.locale.languageCode == 'ar' ? 1.7 : 1),
                        ),
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
        GestureDetector(
          onTap: onPressed,
          child: Text(
            trilling ?? AppLocaleKey.more.tr(),
            style: AppTextStyle.textM16R(context).copyWith(color: AppColor.mainAppColor(context)),
          ),
        ),
        const SizedBox(width: 5),
        CustomImage(
          path: context.locale.languageCode == 'ar' ? AppImages.arMoreArrowIcon : AppImages.enMoreArrowIcon,
          type: ImageType.svg,
          color: AppColor.mainAppColor(context),
        ),
      ],
    );
  }
}
