import 'package:custom_timer/custom_timer.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../helpers/routes/app_routers_import.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../helpers/extension/context_extension.dart';
import '../../../../../helpers/images/app_images.dart';
import '../../../../../helpers/locale/app_locale_key.dart';
import '../../../../../helpers/theme/app_colors.dart';
import '../../../../../helpers/theme/app_text_style.dart';
import '../../../../../helpers/utils/common_methods.dart';
import '../../../../custom_widgets/buttons/custom_button.dart';
import '../../../../custom_widgets/custom_app_bar/custom_auth_app_bar.dart';
import '../../../../custom_widgets/custom_form_field/custom_otp_field.dart';
import '../../../../custom_widgets/custom_toast/custom_toast.dart';
import 'create_new_password_screen.dart';

class VerificationCodeScreen extends StatefulWidget {
  static const routeName = 'VerificationCodeScreen';

  const VerificationCodeScreen({super.key});

  @override
  State<VerificationCodeScreen> createState() => _VerificationCodeScreenState();
}

class _VerificationCodeScreenState extends State<VerificationCodeScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _codeEC = TextEditingController();
  late final CustomTimerController _timerController = CustomTimerController(
    vsync: this,
    begin: const Duration(minutes: 2),
    end: const Duration(),
    initialState: CustomTimerState.reset,
    interval: CustomTimerInterval.milliseconds,
  );

  @override
  void initState() {
    _timerController.reset();
    _timerController.start();
    super.initState();
  }

  @override
  void dispose() {
    _timerController.dispose();
    _codeEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: CustomAuthAppBar(context),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 25),
              Text(tr(AppLocaleKey.verificationCode), style: AppTextStyle.text20BS(context)),
              const SizedBox(height: 18),
              Text(
                tr(AppLocaleKey.pleaseEnterTheVerificationCodeSentToTheNumber),
                style: AppTextStyle.text18RDG(context),
              ),
              const SizedBox(height: 25),
              CustomOtpField(controller: _codeEC, onCompleted: (v) {}),
              const SizedBox(height: 25),
              Center(
                child: CustomTimer(
                  controller: _timerController,
                  builder: (state, time) {
                    return Text('${time.minutes}:${time.seconds}', style: AppTextStyle.text18MS(context));
                  },
                ),
              ),
              const SizedBox(height: 15),
              Center(
                child: TextButton(
                  onPressed: () {
                    if (_timerController.state.value == CustomTimerState.finished) {
                      _timerController.reset();
                      _timerController.start();
                    } else {
                      CommonMethods.showToast(
                        message: context.apiTr(ar: 'انتظر لنهاية الوقت', en: 'Wait for the end of time'),
                        type: ToastType.warning,
                        backgroundColor: Colors.orange.shade900,
                      );
                    }
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        AppImages.refreshIcon,
                        colorFilter: ColorFilter.mode(AppColor.whiteColor(context), BlendMode.srcIn),
                        width: 22,
                        height: 22,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 150),
                      Text(
                        context.apiTr(ar: 'ارسال مرة أخرى', en: 'Resend Code'),
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: 16,
                          color: AppColor.blackColor(context),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0),
          child: CustomButton(
            style: AppTextStyle.text18BW(context),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // context.read<AuthController>().codeActivate(
                //       mobileCode: _codeEC.text,
                //       onSuccess: () {
                //         NavigatorMethods.pushNamed(
                //             context, CreateNewAccountScreen.routeName);
                //       },
                //     );

                NamedNavigatorImpl.pushNamed(context, CreateNewPasswordScreen.routeName);
              }
            },
            text: tr(AppLocaleKey.next),
          ),
        ),
      ),
    );
  }
}
