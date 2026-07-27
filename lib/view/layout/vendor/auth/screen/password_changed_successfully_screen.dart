import 'package:easy_localization/easy_localization.dart';
import '../../../../../helpers/images/app_images.dart';
import '../../../../../helpers/locale/app_locale_key.dart';
import '../../../../../helpers/theme/app_text_style.dart';
import '../../../../custom_widgets/buttons/custom_button.dart';
import '../../../../custom_widgets/custom_app_bar/custom_auth_app_bar.dart';
import '../../../../custom_widgets/custom_image/custom_image.dart';
import 'package:flutter/material.dart';

class PasswordChangedSuccessfullyScreen extends StatelessWidget {
  static const String routeName = '/PasswordChangedSuccessfullyScreen';
  const PasswordChangedSuccessfullyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: CustomAuthAppBar(context, leading: const SizedBox()),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 55),
              Text(AppLocaleKey.passwordChangedSuccessfully.tr(), style: AppTextStyle.text20BS(context)),
              const SizedBox(height: 50),
              const Center(
                child: CustomImage(path: AppImages.passwordChangedSuccessfullyIcon, type: ImageType.svg),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0),
          child: CustomButton(text: AppLocaleKey.next.tr(), onPressed: () {}),
        ),
      ),
    );
  }
}
