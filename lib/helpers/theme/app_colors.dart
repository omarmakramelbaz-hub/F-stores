import 'package:flutter/material.dart';

import 'app_theme.dart';

class AppColor {
  static Color mainAppColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(context, light: const Color(0xffFD7201), dark: const Color(0xffFD7201), listen: listen);
  }

  static Color splashMainAppColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(context, light: const Color(0xffF47221), dark: const Color(0xffF47221), listen: listen);
  }

  static Color lightMainAppColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(context, light: const Color(0xffFFC18E), dark: const Color(0xffFFC18E), listen: listen);
  }

  static Color lightDarkColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(context, light: const Color(0xff323943), dark: const Color(0xff323943), listen: listen);
  }

  static Color secondAppColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(context, light: const Color(0xff000000), dark: const Color(0xff000000), listen: listen);
  }

  static Color scaffoldColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(context, light: const Color(0xffFFFFFF), dark: const Color(0xffFFFFFF), listen: listen);
  }

  static Color hintColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(context, light: const Color(0xffAEAEAE), dark: const Color(0xffAEAEAE), listen: listen);
  }

  static Color darkTextColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(context, light: const Color(0xff000000), dark: const Color(0xff000000), listen: listen);
  }

  static Color lightTextColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(context, light: const Color(0xff727272), dark: const Color(0xff727272), listen: listen);
  }

  static Color greyColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(context, light: const Color(0xff818181), dark: const Color(0xff818181), listen: listen);
  }

  static Color darkGreyColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(context, light: const Color(0xff727272), dark: const Color(0xff727272), listen: listen);
  }

  static Color whiteColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(context, light: const Color(0xffffffff), dark: const Color(0xffffffff), listen: listen);
  }

  static Color offWhiteColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(context, light: const Color(0xffF4F5F7), dark: const Color(0xffF4F5F7), listen: listen);
  }

  static Color textFormFillColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(context, light: const Color(0xFFFFFFFF), dark: const Color(0xFFFFFFFF), listen: listen);
  }

  static Color otpFillColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(context, light: const Color(0xFFffffff), dark: const Color(0xFFffffff), listen: listen);
  }

  static Color textFormBorderColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(context, light: const Color(0xffDBDBDB), dark: const Color(0xffDBDBDB), listen: listen);
  }

  static Color appBarColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(context, light: const Color(0xffFD7201), dark: const Color(0xffFD7201), listen: listen);
  }

  static Color appBarColor2(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(context, light: const Color(0xffFF9D4D), dark: const Color(0xffFF9D4D), listen: listen);
  }

  static Color buttonTextColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(context, light: const Color(0xffFFFFFF), dark: const Color(0xffFFFFFF), listen: listen);
  }

  static Color blackColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(context, light: const Color(0xff000000), dark: const Color(0xff000000), listen: listen);
  }

  static Color textFormColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(context, light: const Color(0xff000000), dark: const Color(0xff000000), listen: listen);
  }

  static Color popupColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(context, light: const Color(0xffffffff), dark: const Color(0xffffffff), listen: listen);
  }

  static Color appBarTextColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(context, light: const Color(0xffFFFFFF), dark: const Color(0xffFFFFFF), listen: listen);
  }

  static Color borderColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(context, light: const Color(0xffDBDBDB), dark: const Color(0xffDBDBDB), listen: listen);
  }

  static Color lightGreyColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(context, light: const Color(0xffE8E8E8), dark: const Color(0xffE8E8E8), listen: listen);
  }

  static Color yellowColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(context, light: const Color(0xffF5B520), dark: const Color(0xffF5B520), listen: listen);
  }

  static Color lightYellowColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(context, light: const Color(0xffFF8A2C), dark: const Color(0xffFF8A2C), listen: listen);
  }

  static Color redColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(context, light: const Color(0xffFF0000), dark: const Color(0xffFF0000), listen: listen);
  }

  static Color greenColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(context, light: const Color(0xff14E591), dark: const Color(0xff14E591), listen: listen);
  }

  // static Color blueColor(BuildContext context, {bool listen = true}) {
  //   return AppTheme.getByTheme(
  //     context,
  //     light: const Color(0xff5449F8),
  //     dark: const Color(0xff5449F8),
  //     listen: listen,
  //   );
  // }

  static Color inActiveColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(context, light: const Color(0xFFC4C5CE), dark: const Color(0xFFC4C5CE), listen: listen);
  }

  static Color searchField(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(context, light: const Color(0xffF3F6F8), dark: const Color(0xffF3F6F8));
  }

  static Color borderColorContainer(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(context, light: const Color(0xffE4E4E4), dark: const Color(0xffE4E4E4));
  }

  static Color gridOneButtonColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(context, light: const Color(0xffFD7201), dark: const Color(0xffFD7201));
  }

  static Color gridTwoButtonColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(context, light: const Color(0xffFF9D4D), dark: const Color(0xffFF9D4D));
  }

  static Color ecececColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(context, light: const Color(0xffECECEC), dark: const Color(0xffECECEC));
  }

  static Color ffebbcColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(context, light: const Color(0xffFFEBBC), dark: const Color(0xffFFEBBC));
  }
}
