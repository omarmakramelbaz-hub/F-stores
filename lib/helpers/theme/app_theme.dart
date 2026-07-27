import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_theme_controller.dart';
import 'theme_enum.dart';

class AppTheme {
  static dynamic getByTheme(BuildContext context, {required dynamic light, required dynamic dark, bool listen = true}) {
    switch (Provider.of<AppThemeController>(context, listen: listen).theme) {
      case ThemeEnum.light:
        return light;
      case ThemeEnum.dark:
        return dark;
    }
  }
}
