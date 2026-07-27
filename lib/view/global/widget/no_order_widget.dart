import 'package:easy_localization/easy_localization.dart';
import '../../../helpers/images/app_images.dart';
import '../../../helpers/locale/app_locale_key.dart';
import '../../../helpers/theme/app_text_style.dart';
import '../../custom_widgets/custom_image/custom_image.dart';
import 'package:flutter/material.dart';

class NoOrdersWidget extends StatelessWidget {
  const NoOrdersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 25),
        const CustomImage(path: AppImages.noOrderIcon, type: ImageType.svg, height: 120),
        const SizedBox(height: 20),
        Text(AppLocaleKey.noOrders.tr(), style: AppTextStyle.text20BS(context)),
        const SizedBox(height: 20),
      ],
    );
  }
}
