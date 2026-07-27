import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

import '../../../helpers/extension/context_extension.dart';
import '../../../helpers/theme/app_colors.dart';

class CustomOtpField extends StatefulWidget {
  final int length;
  final TextEditingController? controller;
  final void Function(String)? onCompleted;
  final double radius;
  const CustomOtpField({super.key, this.length = 4, this.controller, this.onCompleted, this.radius = 50});

  @override
  State<CustomOtpField> createState() => _CustomOtpFieldState();
}

class _CustomOtpFieldState extends State<CustomOtpField> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Directionality(
        textDirection: ui.TextDirection.ltr,
        child: Pinput(
          controller: widget.controller,
          defaultPinTheme: PinTheme(
            width: 70,
            height: 70,
            textStyle: TextStyle(fontSize: 20, color: AppColor.whiteColor(context), fontWeight: FontWeight.w600),
            decoration: BoxDecoration(
              color: AppColor.otpFillColor(context),
              border: Border.all(color: AppColor.textFormBorderColor(context)),
              borderRadius: BorderRadius.circular(widget.radius),
            ),
          ),
          focusedPinTheme: PinTheme(
            width: 70,
            height: 70,
            textStyle: TextStyle(fontSize: 20, color: AppColor.mainAppColor(context), fontWeight: FontWeight.w600),
            decoration: BoxDecoration(
              color: AppColor.otpFillColor(context),
              border: Border.all(color: AppColor.textFormBorderColor(context)),
              borderRadius: BorderRadius.circular(widget.radius),
            ),
          ),
          submittedPinTheme: PinTheme(
            width: 70,
            height: 70,
            textStyle: TextStyle(fontSize: 20, color: AppColor.mainAppColor(context), fontWeight: FontWeight.w600),
            decoration: BoxDecoration(
              color: AppColor.otpFillColor(context),
              border: Border.all(color: AppColor.mainAppColor(context)),
              borderRadius: BorderRadius.circular(widget.radius),
            ),
          ),
          errorPinTheme: PinTheme(
            width: 70,
            height: 70,
            textStyle: TextStyle(fontSize: 20, color: AppColor.mainAppColor(context), fontWeight: FontWeight.w600),
            decoration: BoxDecoration(
              color: AppColor.otpFillColor(context),
              border: Border.all(color: Colors.red.shade700),
              borderRadius: BorderRadius.circular(widget.radius),
            ),
          ),
          errorBuilder: (errorText, pin) {
            return Align(
              alignment: context.getByLang(ar: AlignmentDirectional.centerEnd, en: AlignmentDirectional.centerStart),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Text(
                  errorText!,
                  style: TextStyle(fontSize: 12, color: Colors.red.shade700, fontWeight: FontWeight.w400),
                ),
              ),
            );
          },
          validator: (s) {
            return s!.trim().length == widget.length
                ? null
                : context.apiTr(
                    ar: 'الكود مكون من ${widget.length} ارقام',
                    en: 'The code consists of ${widget.length} digits',
                  );
          },
          pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
          onTapOutside: (event) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          onCompleted: widget.onCompleted,
        ),
      ),
    );
  }
}
