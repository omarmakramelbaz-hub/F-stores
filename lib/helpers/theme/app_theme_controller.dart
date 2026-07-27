import 'package:flutter/material.dart';

import '../hive/hive_methods.dart';
import 'theme_enum.dart';

class AppThemeController extends ChangeNotifier {
  void initial() {
    _theme = HiveMethods.getTheme();
    notifyListeners();
  }

  ThemeEnum _theme = ThemeEnum.light;
  set theme(ThemeEnum value) {
    _theme = value;
    HiveMethods.updateThem(_theme);
    notifyListeners();
  }

  ThemeEnum get theme => _theme;
}
