import 'package:flutter/material.dart';

import '../extension/context_extension.dart';
import 'app_colors.dart';

class AppTextStyle {
  AppTextStyle(TextStyle textD14R);

  static TextStyle appBarStyle(BuildContext context, {bool listen = true}) {
    return TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w700,
      color: AppColor.appBarTextColor(context, listen: listen),
      fontFamily: context.fontFamily(),
    );
  }

  static TextStyle appBarAuthStyle(BuildContext context, {bool listen = true}) {
    return TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w400,
      color: AppColor.appBarTextColor(context, listen: listen),
      fontFamily: context.fontFamily(),
    );
  }

  static TextStyle buttonStyle(BuildContext context, {bool listen = true}) {
    return TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w700,
      color: AppColor.buttonTextColor(context, listen: listen),
      fontFamily: context.fontFamily(),
    );
  }

  static TextStyle hintStyle(BuildContext context, {bool listen = true}) {
    return TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: AppColor.hintColor(context, listen: listen),
      fontFamily: context.fontFamily(),
    );
  }

  static TextStyle textFormStyle(BuildContext context, {bool listen = true}) {
    return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: AppColor.textFormColor(context, listen: listen),
      fontFamily: context.fontFamily(),
    );
  }

  static TextStyle formTitleStyle(BuildContext context, {bool listen = true}) {
    return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: AppColor.darkTextColor(context, listen: listen),
      fontFamily: context.fontFamily(),
    );
  }

  static TextStyle textD34B(BuildContext context, {bool listen = true}) {
    return TextStyle(
      color: AppColor.darkTextColor(context),
      fontSize: 34,
      fontWeight: FontWeight.w700,
      fontFamily: context.fontFamily(),
    );
  }

  static TextStyle textD20B(BuildContext context, {bool listen = true}) {
    return TextStyle(
      color: AppColor.darkTextColor(context),
      fontSize: 20,
      fontWeight: FontWeight.w700,
      fontFamily: context.fontFamily(),
    );
  }

  static TextStyle textM14B(BuildContext context, {bool listen = true}) {
    return TextStyle(
      color: AppColor.mainAppColor(context),
      fontSize: 14,
      fontWeight: FontWeight.w500,
      fontFamily: context.fontFamily(),
    );
  }

  static TextStyle textD18R(BuildContext context, {bool listen = true}) {
    return TextStyle(
      color: AppColor.darkTextColor(context),
      fontSize: 18,
      fontWeight: FontWeight.w400,
      fontFamily: context.fontFamily(),
    );
  }

  static TextStyle textL18R(BuildContext context, {bool listen = true}) {
    return TextStyle(
      color: AppColor.lightTextColor(context),
      fontSize: 18,
      fontWeight: FontWeight.w400,
      fontFamily: context.fontFamily(),
    );
  }

  static TextStyle textW16R(BuildContext context, {bool listen = true}) {
    return TextStyle(
      color: AppColor.whiteColor(context),
      fontSize: 16,
      fontWeight: FontWeight.w400,
      fontFamily: context.fontFamily(),
    );
  }

  static TextStyle textW16M(BuildContext context, {bool listen = true}) {
    return TextStyle(
      color: AppColor.whiteColor(context),
      fontSize: 16,
      fontWeight: FontWeight.w500,
      fontFamily: context.fontFamily(),
    );
  }

  static TextStyle textW16B(BuildContext context, {bool listen = true}) {
    return TextStyle(
      color: AppColor.whiteColor(context),
      fontSize: 16,
      fontWeight: FontWeight.w700,
      fontFamily: context.fontFamily(),
    );
  }

  static TextStyle textD14R(BuildContext context, {bool listen = true}) {
    return TextStyle(
      color: AppColor.darkTextColor(context),
      fontSize: 14,
      fontWeight: FontWeight.w400,
      fontFamily: context.fontFamily(),
    );
  }

  static TextStyle textD16M(BuildContext context, {bool listen = true}) {
    return TextStyle(
      color: AppColor.darkTextColor(context),
      fontSize: 16,
      fontWeight: FontWeight.w500,
      fontFamily: context.fontFamily(),
    );
  }

  static TextStyle textM14R(BuildContext context, {bool listen = true}) {
    return TextStyle(
      color: AppColor.mainAppColor(context),
      fontSize: 14,
      fontWeight: FontWeight.w400,
      fontFamily: context.fontFamily(),
    );
  }

  static TextStyle textM16R(BuildContext context, {bool listen = true}) {
    return TextStyle(
      color: AppColor.mainAppColor(context),
      fontSize: 16,
      fontWeight: FontWeight.w400,
      fontFamily: context.fontFamily(),
    );
  }

  static TextStyle textW14R(BuildContext context, {bool listen = true}) {
    return TextStyle(
      color: AppColor.whiteColor(context),
      fontSize: 14,
      fontWeight: FontWeight.w400,
      fontFamily: context.fontFamily(),
    );
  }

  ///otp
  // static TextStyle text20B(BuildContext context,
  //     {bool listen = true, Color? color}) {
  //   return TextStyle(
  //     fontSize: 20,
  //     fontWeight: FontWeight.w700,
  //     color: color ?? AppColor.darkTextColor(context, listen: listen),
  //   );
  // }

  static TextStyle text28RM(BuildContext context, {bool listen = true, Color? color}) {
    return TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w400,
      color: color ?? AppColor.mainAppColor(context, listen: listen),
      fontFamily: context.fontFamily(),
    );
  }

  static TextStyle text16MS(BuildContext context, {bool listen = true, Color? color}) {
    return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: color ?? AppColor.secondAppColor(context, listen: listen),
      fontFamily: context.fontFamily(),
    );
  }

  static TextStyle text20MS(BuildContext context, {bool listen = true, Color? color}) {
    return TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w500,
      color: color ?? AppColor.secondAppColor(context, listen: listen),
      fontFamily: context.fontFamily(),
    );
  }

  static TextStyle text20BS(BuildContext context, {bool listen = true, Color? color}) {
    return TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      color: color ?? AppColor.secondAppColor(context, listen: listen),
      fontFamily: context.fontFamily(),
    );
  }

  static TextStyle text18RDG(BuildContext context, {bool listen = true, Color? color}) {
    return TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w400,
      color: color ?? AppColor.darkGreyColor(context, listen: listen),
      fontFamily: context.fontFamily(),
    );
  }

  static TextStyle text14RS(BuildContext context, {bool listen = true, Color? color}) {
    return TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: color ?? AppColor.secondAppColor(context, listen: listen),
      fontFamily: context.fontFamily(),
    );
  }

  static TextStyle text16EM(BuildContext context, {bool listen = true, Color? color}) {
    return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w800,
      color: color ?? AppColor.mainAppColor(context, listen: listen),
      fontFamily: context.fontFamily(),
    );
  }

  static TextStyle text16BS(BuildContext context, {bool listen = true, Color? color}) {
    return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: color ?? AppColor.secondAppColor(context, listen: listen),
      fontFamily: context.fontFamily(),
    );
  }

  static TextStyle text18MS(BuildContext context, {bool listen = true, Color? color}) {
    return TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: color ?? AppColor.secondAppColor(context, listen: listen),
      fontFamily: context.fontFamily(),
    );
  }

  static TextStyle text18BS(BuildContext context, {bool listen = true, Color? color}) {
    return TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w700,
      color: color ?? AppColor.secondAppColor(context, listen: listen),
      fontFamily: context.fontFamily(),
    );
  }

  static TextStyle text16RS(BuildContext context, {bool listen = true, Color? color}) {
    return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: color ?? AppColor.secondAppColor(context, listen: listen),
      fontFamily: context.fontFamily(),
    );
  }

  static TextStyle text14MM(BuildContext context, {bool listen = true, Color? color}) {
    return TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: color ?? AppColor.mainAppColor(context, listen: listen),
      fontFamily: context.fontFamily(),
    );
  }

  static TextStyle text16BM(BuildContext context, {bool listen = true, Color? color}) {
    return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: color ?? AppColor.mainAppColor(context, listen: listen),
      fontFamily: context.fontFamily(),
    );
  }

  static TextStyle text16MM(BuildContext context, {bool listen = true, Color? color}) {
    return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: color ?? AppColor.mainAppColor(context, listen: listen),
      fontFamily: context.fontFamily(),
    );
  }

  static TextStyle text14MS(BuildContext context, {bool listen = true, Color? color}) {
    return TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: color ?? AppColor.secondAppColor(context, listen: listen),
      fontFamily: context.fontFamily(),
    );
  }

  static TextStyle text14BS(BuildContext context, {bool listen = true, Color? color}) {
    return TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      color: color ?? AppColor.secondAppColor(context, listen: listen),
      fontFamily: context.fontFamily(),
    );
  }

  static TextStyle text14RG(BuildContext context, {bool listen = true, Color? color}) {
    return TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: color ?? AppColor.greyColor(context, listen: listen),
      fontFamily: context.fontFamily(),
    );
  }

  static TextStyle text16MG(BuildContext context, {bool listen = true, Color? color}) {
    return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: color ?? AppColor.greyColor(context, listen: listen),
      fontFamily: context.fontFamily(),
    );
  }

  static TextStyle text16RG(BuildContext context, {bool listen = true, Color? color}) {
    return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: color ?? AppColor.greyColor(context, listen: listen),
      fontFamily: context.fontFamily(),
    );
  }

  static TextStyle text14MG(BuildContext context, {bool listen = true, Color? color}) {
    return TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: color ?? AppColor.greyColor(context, listen: listen),
      fontFamily: context.fontFamily(),
    );
  }

  static TextStyle text16BG(BuildContext context, {bool listen = true, Color? color}) {
    return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: color ?? AppColor.greyColor(context, listen: listen),
      fontFamily: context.fontFamily(),
    );
  }

  static TextStyle text16ML(BuildContext context, {bool listen = true, Color? color}) {
    return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: color ?? AppColor.lightTextColor(context, listen: listen),
      fontFamily: context.fontFamily(),
    );
  }

  static TextStyle text14RL(BuildContext context, {bool listen = true, Color? color}) {
    return TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: color ?? AppColor.lightTextColor(context, listen: listen),
      fontFamily: context.fontFamily(),
    );
  }

  static TextStyle text14RM(BuildContext context, {bool listen = true, Color? color}) {
    return TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: color ?? AppColor.mainAppColor(context, listen: listen),
      fontFamily: context.fontFamily(),
    );
  }

  static TextStyle text18BW(BuildContext context, {bool listen = true, Color? color}) {
    return TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w700,
      color: color ?? AppColor.whiteColor(context, listen: listen),
      fontFamily: context.fontFamily(),
    );
  }

  static TextStyle text18RS(BuildContext context, {bool listen = true, Color? color}) {
    return TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w400,
      color: color ?? AppColor.secondAppColor(context, listen: listen),
      fontFamily: context.fontFamily(),
    );
  }

  static TextStyle text20MW(BuildContext context, {bool listen = true, Color? color}) {
    return TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w500,
      color: color ?? AppColor.whiteColor(context, listen: listen),
      fontFamily: context.fontFamily(),
    );
  }

  static TextStyle text20BW(BuildContext context, {bool listen = true, Color? color}) {
    return TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      color: color ?? AppColor.whiteColor(context, listen: listen),
      fontFamily: context.fontFamily(),
    );
  }

  static TextStyle text18BR(BuildContext context, {bool listen = true, Color? color}) {
    return TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w700,
      color: color ?? AppColor.redColor(context, listen: listen),
      fontFamily: context.fontFamily(),
    );
  }

  static TextStyle text16RM(BuildContext context, {bool listen = true, Color? color}) {
    return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: color ?? AppColor.mainAppColor(context, listen: listen),
      fontFamily: context.fontFamily(),
    );
  }

  static TextStyle text16BW(BuildContext context, {bool listen = true, Color? color}) {
    return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: color ?? AppColor.whiteColor(context, listen: listen),
      fontFamily: context.fontFamily(),
    );
  }

  static TextStyle text14MW(BuildContext context, {bool listen = true, Color? color}) {
    return TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: color ?? AppColor.whiteColor(context, listen: listen),
      fontFamily: context.fontFamily(),
    );
  }

  static TextStyle text18MW(BuildContext context, {bool listen = true, Color? color}) {
    return TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: color ?? AppColor.whiteColor(context, listen: listen),
      fontFamily: context.fontFamily(),
    );
  }

  static TextStyle text18MG(BuildContext context, {bool listen = true, Color? color}) {
    return TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: color ?? AppColor.greyColor(context, listen: listen),
      fontFamily: context.fontFamily(),
    );
  }

  static TextStyle textD18M(BuildContext context, {bool listen = true}) {
    return TextStyle(
      color: AppColor.darkTextColor(context),
      fontSize: 18,
      fontWeight: FontWeight.w700,
      fontFamily: context.fontFamily(),
    );
  }

  static TextStyle textW18B(BuildContext context, {bool listen = true}) {
    return TextStyle(
      color: AppColor.whiteColor(context),
      fontSize: 18,
      fontWeight: FontWeight.w700,
      fontFamily: context.fontFamily(),
    );
  }
}
