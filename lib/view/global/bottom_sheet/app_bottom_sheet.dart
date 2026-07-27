import '../../../helpers/images/app_images.dart';
import '../../../helpers/theme/app_colors.dart';
import '../../../helpers/theme/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppBottomSheet extends StatelessWidget {
  const AppBottomSheet({super.key, required this.title, required this.children});
  final String title;
  final List<Widget> children;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        color: AppColor.whiteColor(context),
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(36), topRight: Radius.circular(36)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(child: Text(title, style: AppTextStyle.text16MS(context))),
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: AppColor.whiteColor(context),
                        child: SvgPicture.asset(AppImages.closeIcon),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Divider(thickness: 0.7, color: AppColor.greyColor(context)),
              const SizedBox(height: 15),
              ...children,
            ],
          ),
        ),
      ),
    );
  }
}
