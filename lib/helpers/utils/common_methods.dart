import 'package:bot_toast/bot_toast.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../app.dart';
import '../../view/custom_widgets/custom_select/custom_select_item.dart';
import '../../view/custom_widgets/custom_toast/custom_toast.dart';
import '../enum/gender_enum.dart';
import '../extension/context_extension.dart';
import '../hive/hive_methods.dart';
import '../locale/app_locale_key.dart';
import '../networking/api_helper.dart';
import '../routes/app_routers_import.dart';
import '../theme/app_colors.dart';

class CommonMethods {
  static void showAlertDialog({String? title, required String message}) {
    showCupertinoDialog(
      context: NamedNavigatorImpl.navigatorState.currentContext!,
      builder: (context) => CupertinoAlertDialog(
        title: title != null
            ? Text(
                title,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  fontFamily: context.fontFamily(),
                ),
              )
            : null,
        content: Text(
          message,
          style: TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.w500,
            fontFamily: context.fontFamily(),
          ),
        ),
        actions: <Widget>[
          CupertinoDialogAction(
            child: Text(
              tr(AppLocaleKey.ok),
              style: TextStyle(
                color: Colors.red,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                fontFamily: context.fontFamily(),
              ),
            ),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );
  }

  static void showChooseDialog(
    BuildContext context, {
    String? title,
    required String message,
    required VoidCallback onPressed,
  }) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: title != null
            ? Text(
                title,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  fontFamily: context.fontFamily(),
                ),
              )
            : null,
        content: Text(
          message,
          style: TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.w500,
            fontFamily: context.fontFamily(),
          ),
        ),
        actions: [
          CupertinoDialogAction(
            child: Text(
              tr(AppLocaleKey.no),
              style: TextStyle(
                color: AppColor.darkTextColor(context),
                fontSize: 16,
                fontWeight: FontWeight.w700,
                fontFamily: context.fontFamily(),
              ),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          CupertinoDialogAction(
            onPressed: onPressed,
            child: Text(
              tr(AppLocaleKey.yes),
              style: TextStyle(
                color: AppColor.darkTextColor(context),
                fontSize: 16,
                fontWeight: FontWeight.w700,
                fontFamily: context.fontFamily(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static void showToast({
    required String message,
    String? title,
    String? icon,
    ToastType type = ToastType.success,
    Color? backgroundColor,
    Color? textColor,
    int seconds = 3,
  }) {
    BotToast.showCustomText(
      duration: Duration(seconds: seconds),
      toastBuilder: (cancelFunc) => SizedBox(
        height: 85,
        child: CustomToast(
          type: type,
          title: title,
          message: message,
          backgroundColor: backgroundColor,
          icon: icon,
          textColor: textColor,
        ),
      ),
    );
  }

  static void showError({
    ApiResponse? apiResponse,
    required String message,
    String? title,
    String? icon,
    Color? backgroundColor,
    Color? textColor,
    int seconds = 3,
  }) {
    BotToast.showCustomText(
      duration: Duration(seconds: seconds),
      toastBuilder: (context) => SizedBox(
        height: 85,
        child: CustomToast(
          title: title,
          message: message,
          type: apiResponse?.state == ResponseState.offline ? ToastType.offline : ToastType.error,
          backgroundColor: backgroundColor,
          icon: icon,
          textColor: textColor,
        ),
      ),
    );
  }

  static GenderEnum setGenderValue(String gender) {
    if (gender == 'male') {
      return GenderEnum.male;
    } else {
      return GenderEnum.female;
    }
  }

  static Future<bool> hasConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.mobile)) {
      return true;
    } else if (connectivityResult.contains(ConnectivityResult.wifi)) {
      return true;
    } else {
      return false;
    }
  }

  static List<CustomSelectItem> dropdownMenuItems = [
    ...List.generate(
      20,
      (index) => {
        'id': index,
        'value': NamedNavigatorImpl.navigatorState.currentContext!.apiTr(
          ar: 'العنصر ${index + 1}',
          en: 'Item ${index + 1}',
        ),
      },
    ),
  ].map((e) => CustomSelectItem(value: int.tryParse(e['id'].toString()), name: e['value']?.toString() ?? '')).toList();

  static void changeLanguage(BuildContext context, {required VoidCallback onTap}) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text(
          tr(AppLocaleKey.language),
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w700,
            fontFamily: context.fontFamily(),
          ),
        ),
        actions: [
          CupertinoActionSheetAction(
            isDefaultAction: true,
            onPressed: () {
              HiveMethods.updateLang(const Locale('ar'));
              context.setLocale(const Locale('ar'));
              onTap.call();
              MyApp.setMyAppState(context);
              Navigator.pop(context);
            },
            child: Text(
              'العربية',
              style: TextStyle(
                fontFamily: context.fontFamilyAr(),
                color: context.locale == const Locale('ar')
                    ? AppColor.mainAppColor(context)
                    : AppColor.darkTextColor(context),
              ),
            ),
          ),
          CupertinoActionSheetAction(
            isDefaultAction: true,
            onPressed: () {
              HiveMethods.updateLang(const Locale('en'));
              context.setLocale(const Locale('en'));
              onTap.call();
              MyApp.setMyAppState(context);
              Navigator.pop(context);
            },
            child: Text(
              'English',
              style: TextStyle(
                fontFamily: context.fontFamilyEn(),
                color: context.locale == const Locale('en')
                    ? AppColor.mainAppColor(context)
                    : AppColor.darkTextColor(context),
              ),
            ),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text(
            tr(AppLocaleKey.cancel),
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              fontFamily: context.fontFamily(),
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  static bool endScroll(ScrollEndNotification t, VoidCallback onEnd) {
    if (t.metrics.pixels > 0 && t.metrics.atEdge) {
      onEnd.call();
    }
    return true;
  }
}
