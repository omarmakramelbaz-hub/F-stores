import 'package:easy_localization/easy_localization.dart';
import '../../../../../helpers/images/app_images.dart';
import '../../../../../helpers/locale/app_locale_key.dart';
import '../../../../../helpers/theme/app_colors.dart';
import '../../../../../helpers/theme/app_text_style.dart';
import '../../auth/controller/auth_controller.dart';
import '../model/wallet_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class MyCurrentBalanceWidget extends StatelessWidget {
  final WalletModel? wallet;
  const MyCurrentBalanceWidget({super.key, required this.wallet});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppColor.whiteColor(context),
          boxShadow: [
            BoxShadow(color: AppColor.greyColor(context).withOpacity(0.2), offset: const Offset(2, 4), blurRadius: 10),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: FittedBox(
                          child: Text(AppLocaleKey.myCurrentBalance.tr(), style: AppTextStyle.text16MS(context)),
                        ),
                      ),
                      const SizedBox(width: 5),
                      SvgPicture.asset(AppImages.downIcon),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Text(
                    context.read<AuthController>().profile?.balance.toString() ?? '',
                    style: AppTextStyle.text16BS(context),
                  ),
                ],
              ),
            ),
            SvgPicture.asset(AppImages.walletIcon),
          ],
        ),
      ),
    );
  }
}
