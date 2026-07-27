import 'package:easy_localization/easy_localization.dart';
import '../../../../../helpers/locale/app_locale_key.dart';
import '../../../../../helpers/theme/app_colors.dart';
import '../../../../../helpers/theme/app_text_style.dart';
import '../../../../custom_widgets/api_response_widget/api_response_widget.dart';
import '../../../../custom_widgets/custom_app_bar/custom_app_bar.dart';
import '../controller/my_account_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  static const String routeName = 'TermsAndConditionsScreen';
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context,
        height: 80,
        centerTitle: false,
        leadingPadding: 40,
        appBarColor: AppColor.whiteColor(context),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColor.blackColor(context)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Padding(
          padding: const EdgeInsets.only(bottom: 40),
          child: Text(AppLocaleKey.termsAndConditions.tr(), style: AppTextStyle.text20BS(context)),
        ),
      ),
      body: ChangeNotifierProvider(
        create: (BuildContext context) {
          return MyAccountController()
            ..initialSetting()
            ..getSetting();
        },
        child: SingleChildScrollView(
          child: Consumer<MyAccountController>(
            builder: (context, myAccountController, _) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                ApiResponseWidget(
                  apiResponse: myAccountController.settingResponse,
                  onReload: myAccountController.getSetting,
                  isEmpty: myAccountController.setting == null,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: AppColor.whiteColor(context),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(34),
                        topRight: Radius.circular(34),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.greyColor(context).withOpacity(0.2),
                          offset: const Offset(0, -3),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 24),
                          Text(tr(AppLocaleKey.termsAndConditions), style: AppTextStyle.text16BS(context)),
                          const SizedBox(height: 10),
                          HtmlWidget(
                            myAccountController.setting?.terms ?? '',
                            textStyle: AppTextStyle.text18RS(context),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
