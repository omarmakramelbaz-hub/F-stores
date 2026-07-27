import 'package:easy_localization/easy_localization.dart';
import '../../../../../helpers/images/app_images.dart';
import '../../../../../helpers/locale/app_locale_key.dart';
import '../../../../../helpers/theme/app_colors.dart';
import '../../../../../helpers/theme/app_text_style.dart';
import '../../../../../helpers/utils/date_methods.dart';
import '../../auth/controller/auth_controller.dart';
import '../model/wallet_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class RecentTransactionsWidget extends StatelessWidget {
  final WalletModel? wallet;

  const RecentTransactionsWidget({super.key, required this.wallet});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...List.generate(wallet?.wallet?.length ?? 0, (int index) {
          bool isFromMe = (context.read<AuthController>().profile?.id == wallet?.wallet?[index].fromUser);
          bool isToMe = (context.read<AuthController>().profile?.id == wallet?.wallet?[index].toUser);
          return Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: AppColor.greyColor(context).withOpacity(.10)),
              ),
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(5),
                    width: 47,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColor.whiteColor(context),
                      boxShadow: [
                        BoxShadow(color: AppColor.greyColor(context), blurRadius: 4, offset: const Offset(0, 2)),
                      ],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: wallet?.wallet?[index].payment == 'visa'
                        ? SvgPicture.asset(AppImages.visaIcon)
                        : Image.asset(AppImages.digitalWallet, height: 25),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              DateMethods.formatDateToArabic(wallet?.wallet?[index].createdAt ?? ''),
                              style: AppTextStyle.text14RG(context),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              DateMethods.formatToTime(wallet?.wallet?[index].createdAt ?? ''),
                              style: AppTextStyle.text14RG(context),
                            ),
                          ],
                        ),
                        Text(
                          "${AppLocaleKey.theAmountIs.tr().replaceAll("{}", buildTransaction(transaction: wallet?.wallet?[index].type ?? ""))} ${AppLocaleKey.pound.tr().replaceAll("{}", wallet?.wallet?[index].amount.toString() ?? "")} ${AppLocaleKey.paymentTypeIs.tr().replaceAll("{}", buildPaymentType(paymentType: wallet?.wallet?[index].payment ?? ""))} ${wallet?.wallet?[index].fromUserName != null && wallet?.wallet?[index].toUserName != null ? AppLocaleKey.fromUser.tr().replaceAll("{}", isFromMe ? AppLocaleKey.yourWallet.tr() : wallet?.wallet?[index].fromUserName ?? "") : ""}  ${wallet?.wallet?[index].toUserName != null ? AppLocaleKey.toUser.tr().replaceAll("{}", isToMe ? AppLocaleKey.yourWallet.tr() : wallet?.wallet?[index].toUserName ?? "") : ""}  ${wallet?.wallet?[index].orderNo != null ? AppLocaleKey.orderNumber.tr().replaceAll("{}", wallet?.wallet?[index].orderNo ?? "") : ""} ",
                          style: AppTextStyle.text16MS(context).copyWith(height: 2),
                          maxLines: 4,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 5),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  String buildTransaction({required String transaction}) {
    switch (transaction) {
      case 'transfer':
        return AppLocaleKey.transfer.tr();
      case 'charging':
        return AppLocaleKey.charging.tr();
      case 'withdraw':
        return AppLocaleKey.withdraw.tr();
      case 'shipping':
        return AppLocaleKey.shipping.tr();
      default:
        return '';
    }
  }

  String buildPaymentType({required String paymentType}) {
    switch (paymentType) {
      case 'wallet':
        return AppLocaleKey.appWalletBalance.tr();
      case 'online':
        return AppLocaleKey.visa.tr();
      case 'visa':
        return AppLocaleKey.visa.tr();
      case 'v_cash':
        return AppLocaleKey.digitalWalletAndInstaPay.tr();
      default:
        return '';
    }
  }
}
