import 'package:easy_localization/easy_localization.dart';
import '../../../../../helpers/locale/app_locale_key.dart';
import '../../../../../helpers/theme/app_colors.dart';
import '../../../../../helpers/theme/app_text_style.dart';
import '../../../../custom_widgets/api_response_widget/api_response_widget.dart';
import '../../../../custom_widgets/custom_app_bar/custom_app_bar.dart';
import '../controller/my_account_controller.dart';
import '../widget/help_box_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HelpScreen extends StatefulWidget {
  static const String routeName = 'HelpScreen';
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context,
        height: 80,
        centerTitle: false,
        leadingPadding: 40,
        title: Padding(
          padding: const EdgeInsets.only(bottom: 40),
          child: Text(AppLocaleKey.help.tr(), style: AppTextStyle.text20BW(context)),
        ),
      ),
      body: ChangeNotifierProvider(
        create: (BuildContext context) {
          return MyAccountController()
            ..initialHelp()
            ..getHelp();
        },
        child: Consumer<MyAccountController>(
          builder: (context, myAccountController, _) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 35),
              ApiResponseWidget(
                apiResponse: myAccountController.helpResponse,
                onReload: myAccountController.getHelp,
                isEmpty: myAccountController.help.isEmpty,
                child: Expanded(
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
                    child: ListView.builder(
                      itemCount: myAccountController.help.length,
                      itemBuilder: (context, index) {
                        return HelpBoxWidget(
                          question: myAccountController.help[index].question ?? '',
                          answer: myAccountController.help[index].answer ?? '',
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
