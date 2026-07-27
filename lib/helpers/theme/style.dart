import 'package:flutter/material.dart';

import '../extension/context_extension.dart';
import 'app_colors.dart';
import 'app_text_style.dart';
import 'app_theme.dart';

ThemeData appThemeData(BuildContext context) {
  return ThemeData(
    primaryColor: AppColor.mainAppColor(context),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    useMaterial3: false,
    hintColor: AppColor.hintColor(context),
    dividerTheme: DividerThemeData(color: AppColor.greyColor(context), thickness: 1, space: 0),
    brightness: AppTheme.getByTheme(context, light: Brightness.light, dark: Brightness.dark),
    buttonTheme: ButtonThemeData(buttonColor: AppColor.mainAppColor(context), alignedDropdown: true),
    bottomSheetTheme: const BottomSheetThemeData(backgroundColor: Colors.white),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      primary: AppColor.mainAppColor(context),
      secondary: AppColor.secondAppColor(context),
      surface: AppColor.whiteColor(context),
      brightness: AppTheme.getByTheme(context, light: Brightness.light, dark: Brightness.dark),
    ),
    tabBarTheme: TabBarThemeData(dividerColor: AppColor.greyColor(context)),
    appBarTheme: AppBarTheme(
      color: AppColor.secondAppColor(context),
      elevation: 0,
      centerTitle: true,
      titleTextStyle: AppTextStyle.appBarStyle(context),
      foregroundColor: AppColor.appBarTextColor(context),
    ),
    scaffoldBackgroundColor: AppColor.scaffoldColor(context),
    fontFamily: context.fontFamily(),
    textSelectionTheme: TextSelectionThemeData(cursorColor: AppColor.mainAppColor(context)),
    platform: TargetPlatform.iOS,
  );
}

List<BoxShadow> appShadow = [
  BoxShadow(color: const Color(0xff000000).withOpacity(0.05), offset: const Offset(0, 0), blurRadius: 30),
];
