import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../helpers/images/app_images.dart';

enum ToastType { success, error, offline, warning, help }

class CustomToast extends StatelessWidget {
  final ToastType type;
  final String? title;
  final String? icon;
  final String message;
  final Color? backgroundColor;
  final Color? textColor;

  const CustomToast({
    super.key,
    required this.type,
    this.title,
    required this.message,
    this.backgroundColor,
    this.textColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 100,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: backgroundColor ?? _backgroundColor(),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        children: [
          Center(
            child: CircleAvatar(
              radius: 37.5,
              backgroundColor: Colors.white60,
              child: SvgPicture.asset(
                icon ?? _icons(),
                height: 50,
                width: 50,
                colorFilter: ColorFilter.mode(backgroundColor ?? _backgroundColor(), BlendMode.srcIn),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (title != null) ...{
                  Text(
                    title!,
                    style: TextStyle(color: textColor ?? Colors.white, fontSize: 15, fontWeight: FontWeight.w700),
                    maxLines: 1,
                  ),
                  const SizedBox(height: 8),
                },
                Text(
                  message,
                  style: TextStyle(color: textColor ?? Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _backgroundColor() {
    switch (type) {
      case ToastType.success:
        return const Color(0xff1FC170);
      case ToastType.error:
        return const Color(0xffff3333);
      case ToastType.offline:
        return const Color(0xFF616161);
      case ToastType.warning:
        return const Color(0xffFFCC00);
      case ToastType.help:
        return const Color(0xff0091EA);
    }
  }

  String _icons() {
    switch (type) {
      case ToastType.success:
        return AppImages.success;
      case ToastType.error:
        return AppImages.error;
      case ToastType.offline:
        return AppImages.offlineIcon;
      case ToastType.warning:
        return AppImages.warning;
      case ToastType.help:
        return AppImages.help;
    }
  }
}
