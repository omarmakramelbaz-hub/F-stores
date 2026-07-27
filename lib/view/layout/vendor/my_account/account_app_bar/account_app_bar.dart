import 'package:easy_localization/easy_localization.dart';
import '../../../../../helpers/images/app_images.dart';
import '../../../../../helpers/theme/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomAccountAppBar extends StatelessWidget {
  final String title;
  const CustomAccountAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: SvgPicture.asset(
              context.locale.languageCode == 'ar' ? AppImages.backIosIcon : AppImages.backLeftIcon,
            ),
          ),
          Text(title, style: AppTextStyle.text18BS(context)),
        ],
      ),
    );
  }
}
