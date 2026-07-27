import 'package:flutter/material.dart';

import '../../../helpers/theme/app_colors.dart';

class CustomAppBar extends PreferredSize {
  final double height;
  final double radius;
  final double elevation;
  final Widget? leading;
  final List<Widget>? actions;
  final Widget? title;
  final Color? appBarColor;
  final Color? shadowColor;
  final bool? centerTitle;
  final PreferredSizeWidget? bottom;
  final double? leadingWidth;
  final bool automaticallyImplyLeading;
  final BuildContext context;
  final BorderRadiusGeometry? borderRadius;
  final double? leadingPadding;
  CustomAppBar(
    this.context, {
    super.key,
    this.height = 70,
    this.radius = 50,
    this.elevation = 0,
    this.leading,
    this.actions,
    this.title,
    this.appBarColor,
    this.centerTitle,
    this.bottom,
    this.leadingWidth,
    this.shadowColor,
    this.automaticallyImplyLeading = true,
    this.borderRadius,
    this.leadingPadding,
  }) : super(
          preferredSize: Size.fromHeight(height),
          child: AppBar(
            elevation: elevation,
            backgroundColor: appBarColor ?? AppColor.appBarColor(context),
            toolbarHeight: height,
            automaticallyImplyLeading: automaticallyImplyLeading,
            shadowColor: shadowColor,
            centerTitle: centerTitle,
            title: Padding(
              padding: const EdgeInsets.only(top: 22),
              child: title ??
                  SizedBox(
                    height: height,
                    child: const Column(mainAxisAlignment: MainAxisAlignment.end, children: []),
                  ),
            ),
            leading: Padding(
              padding: EdgeInsets.only(bottom: leadingPadding ?? 0, top: 10),
              child: automaticallyImplyLeading && Navigator.canPop(context) && leading == null
                  ? Center(
                      child: IconButton(
                        onPressed: Navigator.canPop(context)
                            ? () {
                                Navigator.pop(context);
                              }
                            : null,
                        icon: Icon(Icons.arrow_back_ios_rounded, color: AppColor.whiteColor(context)),
                      ),
                    )
                  : leading,
            ),
            actions: actions,
            leadingWidth: leadingWidth,
            // flexibleSpace: ClipRRect(
            //   borderRadius: borderRadius ??
            //       BorderRadius.vertical(
            //         bottom: Radius.circular(radius),
            //       ),
            //   child: Container(
            //     decoration: BoxDecoration(
            //       borderRadius: borderRadius ??
            //           BorderRadius.vertical(
            //             bottom: Radius.circular(radius),
            //           ),
            //       gradient: LinearGradient(
            //         begin: Alignment.topCenter,
            //         end: Alignment.bottomCenter,
            //         colors: <Color>[
            //           AppColor.mainAppColor(context),
            //           AppColor.mainAppColor(context)
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
            shape: RoundedRectangleBorder(
              borderRadius: borderRadius ?? BorderRadius.vertical(bottom: Radius.circular(radius)),
            ),
            bottom: bottom,
          ),
        );
}
