import 'package:easy_localization/easy_localization.dart';
import '../../../../../helpers/images/app_images.dart';
import '../../../../../helpers/theme/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SettingButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  const SettingButton({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Text(title, style: AppTextStyle.text16MS(context)),
            const Spacer(),
            SvgPicture.asset(context.locale.languageCode == 'ar' ? AppImages.backLeftIcon : AppImages.backIosIcon),
            const SizedBox(width: 10),
          ],
        ),
      ),
    );
  }
}
