import 'package:easy_localization/easy_localization.dart';
import '../../../../../helpers/images/app_images.dart';
import '../../../../../helpers/locale/app_locale_key.dart';
import '../../../../../helpers/theme/app_colors.dart';
import '../../../../../helpers/theme/app_text_style.dart';
import '../../../../custom_widgets/api_response_widget/api_response_widget.dart';
import '../../../../custom_widgets/custom_app_bar/custom_app_bar.dart';
import '../../../../custom_widgets/custom_image/custom_image.dart';
import '../../../../custom_widgets/custom_table/custome_table.dart';
import '../controller/my_account_controller.dart';
import '../model/reports_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyReportsScreen extends StatefulWidget {
  static const routeName = 'MyReportsScreen';
  const MyReportsScreen({super.key});

  @override
  State<MyReportsScreen> createState() => _MyReportsScreenState();
}

class _MyReportsScreenState extends State<MyReportsScreen> {
  final Key chartRendererKey = GlobalKey();
  String selectedTimeFrame = 'week'; // Default value
  final List<String> timeFrames = ['day', 'week', 'month', 'year'];
  double calculateTotalOrderPrice(List<Orders> orders) {
    double total = 0;
    for (var order in orders) {
      total += order.totalItemPrice ?? 0;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MyAccountController()
        ..initialReports()
        ..getReports(reportType: 'week'),
      child: Consumer<MyAccountController>(
        builder: (context, myAccountController, _) {
          double totalOrderPrice = calculateTotalOrderPrice(myAccountController.reports?.orders ?? []);
          return Scaffold(
            appBar: CustomAppBar(
              context,
              height: 80,
              centerTitle: false,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: AppColor.blackColor(context)),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              leadingPadding: 40,
              appBarColor: AppColor.whiteColor(context),
              title: Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Text(AppLocaleKey.myReports.tr(), style: AppTextStyle.text18BS(context)),
              ),
            ),
            body: ApiResponseWidget(
              apiResponse: myAccountController.reportsResponse,
              onReload: () => myAccountController.getReports(reportType: selectedTimeFrame),
              isEmpty: myAccountController.reports == null,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: AppColor.whiteColor(context),
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColor.greyColor(context).withOpacity(0.4),
                                  offset: const Offset(6, 6),
                                  blurRadius: 5,
                                ),
                              ],
                            ),
                            child: DropdownButton<String>(
                              value: selectedTimeFrame,
                              underline: const SizedBox(),
                              icon: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.0),
                                child: CustomImage(path: AppImages.arrowDownIconMain, type: ImageType.svg),
                              ),
                              items: timeFrames.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value.tr(), style: AppTextStyle.text14RM(context)),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  selectedTimeFrame = newValue!;
                                  myAccountController.getReports(reportType: selectedTimeFrame);
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: LinearGradient(
                                  colors: [
                                    AppColor.mainAppColor(context),
                                    AppColor.mainAppColor(context).withOpacity(0.6),
                                  ],
                                ),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(AppLocaleKey.receivedOrdersCount.tr(), style: AppTextStyle.text14MW(context)),
                                    Text(
                                      AppLocaleKey.order.tr().replaceAll(
                                        '{}',
                                        '${myAccountController.reports?.ordersCount.toString()}',
                                      ),
                                      style: AppTextStyle.text16BW(context),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Container(
                              height: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: LinearGradient(
                                  colors: [
                                    AppColor.greenColor(context).withOpacity(0.7),
                                    AppColor.greenColor(context).withOpacity(0.8),
                                    AppColor.greenColor(context).withOpacity(0.9),
                                  ],
                                ),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(AppLocaleKey.receivedAmount.tr(), style: AppTextStyle.text14MW(context)),
                                    Text(
                                      AppLocaleKey.pound.tr().replaceAll(
                                        '{}',
                                        double.tryParse(
                                              myAccountController.reports?.totalGainFromApp.toString() ?? '0.0',
                                            )?.toStringAsFixed(2) ??
                                            '',
                                      ),
                                      style: AppTextStyle.text16BW(context),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: LinearGradient(
                                  colors: [
                                    AppColor.greyColor(context).withOpacity(0.8),
                                    AppColor.greyColor(context).withOpacity(0.6),
                                    AppColor.greyColor(context).withOpacity(0.8),
                                  ],
                                ),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(AppLocaleKey.paidAmount.tr(), style: AppTextStyle.text14MW(context)),
                                    Text(
                                      AppLocaleKey.pound.tr().replaceAll(
                                        '{}',
                                        double.tryParse(
                                              myAccountController.reports?.transferCashOrders.toString() ?? '0.0',
                                            )?.toStringAsFixed(2) ??
                                            '',
                                      ),
                                      style: AppTextStyle.text16BW(context),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Container(
                              height: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: LinearGradient(
                                  colors: [
                                    AppColor.yellowColor(context).withOpacity(0.6),
                                    AppColor.yellowColor(context).withOpacity(0.7),
                                    AppColor.yellowColor(context),
                                  ],
                                ),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(AppLocaleKey.forwardReceivables.tr(), style: AppTextStyle.text14MW(context)),
                                    Text(
                                      AppLocaleKey.pound.tr().replaceAll(
                                        '{}',
                                        double.tryParse(
                                              myAccountController.reports?.notTransferCashOrders.toString() ?? '0',
                                            )?.toStringAsFixed(2) ??
                                            '',
                                      ),
                                      style: AppTextStyle.text16BW(context),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),
                      Text(AppLocaleKey.orders.tr(), style: AppTextStyle.text16BS(context)),
                      const SizedBox(height: 10),
                      CustomAppTable(
                        columns: [
                          '#',
                          AppLocaleKey.user.tr(),
                          AppLocaleKey.reportOrderNumber.tr(),
                          AppLocaleKey.totalPrice.tr(),
                          // AppLocaleKey.branchName.tr(),
                          AppLocaleKey.resturantPercentage.tr(),
                          AppLocaleKey.deliveryFee.tr(),
                        ],
                        rows: List.generate(
                          myAccountController.reports?.orders?.length ?? 0,
                          (index) => DataRow(
                            cells: [
                              DataCell(Center(child: Text(int.parse((index + 1).toString()).toString()))),
                              DataCell(Center(child: Text(myAccountController.reports?.orders?[index].userName ?? ''))),
                              DataCell(Center(child: Text(myAccountController.reports?.orders?[index].orderNo ?? ''))),
                              DataCell(
                                Center(
                                  child: Text(
                                    AppLocaleKey.pound.tr().replaceAll(
                                      '{}',
                                      double.parse(
                                        myAccountController.reports?.orders?[index].grandTotal.toString() ?? '',
                                      ).toStringAsFixed(2),
                                    ),
                                  ),
                                ),
                              ),
                              // DataCell(Center(
                              //     child: Text(myAccountController.reports
                              //             ?.orders?[index].resturantName ??
                              //         ""))),
                              DataCell(
                                Center(
                                  child: Text(
                                    AppLocaleKey.pound.tr().replaceAll(
                                      '{}',
                                      double.parse(
                                        myAccountController.reports?.orders?[index].vendorPercentage.toString() ?? '',
                                      ).toStringAsFixed(2),
                                    ),
                                  ),
                                ),
                              ),
                              DataCell(
                                Center(
                                  child: Text(
                                    myAccountController.reports?.orders?[index].delegateFromOut != 'out_resturant'
                                        ? AppLocaleKey.pound.tr().replaceAll(
                                            '{}',
                                            double.parse(
                                              myAccountController.reports?.orders?[index].deliveryPrice.toString() ??
                                                  '',
                                            ).toStringAsFixed(2),
                                          )
                                        : AppLocaleKey.deliverFromOutResturant.tr(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),
                      Row(
                        children: [
                          Text(AppLocaleKey.totalPrice.tr(), style: AppTextStyle.text16BS(context)),
                          const Spacer(),
                          Text(
                            AppLocaleKey.pound.tr().replaceAll('{}', totalOrderPrice.toStringAsFixed(2)),
                            style: AppTextStyle.text16BG(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
