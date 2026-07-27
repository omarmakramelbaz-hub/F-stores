import 'package:easy_localization/easy_localization.dart';
import '../../../helpers/images/app_images.dart';
import '../../../helpers/locale/app_locale_key.dart';
import '../../../helpers/theme/app_text_style.dart';
import '../../custom_widgets/custom_image/custom_image.dart';
import 'package:flutter/material.dart';

class NoNotificationWidget extends StatelessWidget {
  const NoNotificationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.15),
        Center(
          child: Padding(
            padding: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.18),
            child: const CustomImage(path: AppImages.noNotificationIcon, type: ImageType.svg),
          ),
        ),
        const SizedBox(height: 30),
        Center(child: Text(AppLocaleKey.noNotification.tr(), style: AppTextStyle.text16BM(context))),
      ],
    );
  }
}
