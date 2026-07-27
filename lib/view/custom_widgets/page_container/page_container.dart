import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../helpers/theme/app_colors.dart';
import '../../../helpers/theme/app_theme.dart';

enum StatusBarTheme { light, dark }

class PageContainer extends StatelessWidget {
  final Widget child;
  final Color? statusBarColor;
  final Color statusBarForegroundColor;
  final StatusBarTheme? statusBarTheme;
  final bool top;
  final bool bottom;
  final bool right;
  final bool left;

  const PageContainer({
    super.key,
    required this.child,
    this.statusBarColor,
    this.statusBarForegroundColor = Colors.transparent,
    this.statusBarTheme,
    this.top = true,
    this.bottom = true,
    this.right = true,
    this.left = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: statusBarColor ?? AppColor.scaffoldColor(context),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: statusBarForegroundColor,
          statusBarIconBrightness: _android(
            statusBarTheme ?? AppTheme.getByTheme(context, light: StatusBarTheme.dark, dark: StatusBarTheme.light),
          ),
          statusBarBrightness: _ios(
            statusBarTheme ?? AppTheme.getByTheme(context, light: StatusBarTheme.dark, dark: StatusBarTheme.light),
          ),
        ),
        child: SafeArea(top: top, bottom: bottom, right: right, left: left, child: child),
      ),
    );
  }

  Brightness _android(StatusBarTheme statusBarTheme) {
    switch (statusBarTheme) {
      case StatusBarTheme.dark:
        return Brightness.dark;
      case StatusBarTheme.light:
        return Brightness.light;
    }
  }

  Brightness _ios(StatusBarTheme statusBarTheme) {
    switch (statusBarTheme) {
      case StatusBarTheme.dark:
        return Brightness.light;
      case StatusBarTheme.light:
        return Brightness.dark;
    }
  }
}
