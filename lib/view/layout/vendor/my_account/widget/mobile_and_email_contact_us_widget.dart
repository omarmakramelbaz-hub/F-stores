import 'package:easy_localization/easy_localization.dart';
import '../../../../../helpers/images/app_images.dart';
import '../../../../../helpers/locale/app_locale_key.dart';
import '../../../../../helpers/theme/app_colors.dart';
import '../../../../../helpers/theme/app_text_style.dart';
import '../../../../../helpers/utils/url_launcher_methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MobileAndEmailContactUsWidget extends StatelessWidget {
  final String mobile;
  final String email;
  const MobileAndEmailContactUsWidget({super.key, required this.mobile, required this.email});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      //  height: 169,
      decoration: const BoxDecoration(
        image: DecorationImage(fit: BoxFit.cover, image: AssetImage(AppImages.shapeContactUs)),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              UrlLauncherMethods.makePhoneCall(mobile);
            },
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColor.whiteColor(context),
                  radius: 25,
                  child: Center(
                    child: SvgPicture.asset(
                      AppImages.callIcon,
                      colorFilter: ColorFilter.mode(AppColor.blackColor(context), BlendMode.srcIn),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppLocaleKey.mobileNumber.tr(), style: AppTextStyle.text18BW(context)),
                    const SizedBox(height: 5),
                    Text(mobile, style: AppTextStyle.text18BW(context)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          GestureDetector(
            onTap: () {
              UrlLauncherMethods.makeMailMessage(email);
            },
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColor.whiteColor(context),
                  radius: 25,
                  child: Center(child: SvgPicture.asset(AppImages.emailIcon, height: 15)),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppLocaleKey.email.tr(), style: AppTextStyle.text18BW(context)),
                    const SizedBox(height: 5),
                    Text(email, style: AppTextStyle.text18BW(context)),
                    const SizedBox(height: 5),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
