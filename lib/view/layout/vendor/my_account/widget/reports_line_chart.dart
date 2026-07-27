// import 'package:easy_localization/easy_localization.dart';
// import '../../../../../helpers/locale/app_locale_key.dart';
// import '../../../../../helpers/theme/app_colors.dart';
// import '../../../../../helpers/theme/app_text_style.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
//
// enum ChartViewType { week, month, year }
//
// class ReportsLineChart extends StatelessWidget {
//   final ChartViewType chartViewType;
//
//   const ReportsLineChart({super.key, required this.chartViewType});
//
//   List<FlSpot> getSpots() {
//     switch (chartViewType) {
//       case ChartViewType.week:
//         return const [
//           FlSpot(1, 10),
//           FlSpot(2, 0),
//           FlSpot(3, 0),
//           FlSpot(4, 0),
//           FlSpot(5, 0),
//           FlSpot(6, 0),
//           FlSpot(7, 0),
//         ];
//       case ChartViewType.month:
//         return const [
//           FlSpot(1, 15),
//           FlSpot(5, 35),
//           FlSpot(10, 40),
//           FlSpot(15, 25),
//           FlSpot(20, 30),
//           FlSpot(25, 45),
//           FlSpot(30, 20),
//         ];
//       case ChartViewType.year:
//         return const [
//           FlSpot(1, 100),
//           FlSpot(2, 200),
//           FlSpot(3, 150),
//           FlSpot(4, 180),
//           FlSpot(5, 220),
//           FlSpot(6, 190),
//           FlSpot(7, 250),
//           FlSpot(8, 230),
//           FlSpot(9, 280),
//           FlSpot(10, 300),
//           FlSpot(11, 260),
//           FlSpot(12, 320),
//         ];
//     }
//   }
//
//   Widget getTitlesWidget(double value, BuildContext context) {
//     switch (chartViewType) {
//       case ChartViewType.week:
//         switch (value.toInt()) {
//           case 1:
//             return Text(AppLocaleKey.sat.tr(), style: AppTextStyle.text14MG(context));
//           case 2:
//             return Text(AppLocaleKey.sun.tr(), style: AppTextStyle.text14MG(context));
//           case 3:
//             return Text(AppLocaleKey.mon.tr(), style: AppTextStyle.text14MG(context));
//           case 4:
//             return Text(AppLocaleKey.tue.tr(), style: AppTextStyle.text14MG(context));
//           case 5:
//             return Text(AppLocaleKey.wed.tr(), style: AppTextStyle.text14MG(context));
//           case 6:
//             return Text(AppLocaleKey.th.tr(), style: AppTextStyle.text14MG(context));
//           case 7:
//             return Text(AppLocaleKey.fr.tr(), style: AppTextStyle.text14MG(context));
//         }
//         break;
//       case ChartViewType.month:
//         return Text(value.toInt().toString(), style: AppTextStyle.text14MG(context));
//       case ChartViewType.year:
//         switch (value.toInt()) {
//           case 1:
//             return Text(AppLocaleKey.jan.tr(), style: AppTextStyle.text14MG(context));
//           case 2:
//             return Text(AppLocaleKey.feb.tr(), style: AppTextStyle.text14MG(context));
//           case 3:
//             return Text(AppLocaleKey.mar.tr(), style: AppTextStyle.text14MG(context));
//           case 4:
//             return Text(AppLocaleKey.apr.tr(), style: AppTextStyle.text14MG(context));
//           case 5:
//             return Text(AppLocaleKey.may.tr(), style: AppTextStyle.text14MG(context));
//           case 6:
//             return Text(AppLocaleKey.jun.tr(), style: AppTextStyle.text14MG(context));
//           case 7:
//             return Text(AppLocaleKey.jul.tr(), style: AppTextStyle.text14MG(context));
//           case 8:
//             return Text(AppLocaleKey.aug.tr(), style: AppTextStyle.text14MG(context));
//           case 9:
//             return Text(AppLocaleKey.sep.tr(), style: AppTextStyle.text14MG(context));
//           case 10:
//             return Text(AppLocaleKey.oct.tr(), style: AppTextStyle.text14MG(context));
//           case 11:
//             return Text(AppLocaleKey.nov.tr(), style: AppTextStyle.text14MG(context));
//           case 12:
//             return Text(AppLocaleKey.dec.tr(), style: AppTextStyle.text14MG(context));
//         }
//         break;
//     }
//     return const Text('');
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     double maxX, maxY;
//     switch (chartViewType) {
//       case ChartViewType.week:
//         maxX = 7;
//         maxY = 100;
//         break;
//       case ChartViewType.month:
//         maxX = 30;
//         maxY = 500;
//         break;
//       case ChartViewType.year:
//         maxX = 12;
//         maxY = 3000;
//         break;
//     }
//
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 5),
//       child: SizedBox(
//         height: 300,
//         child: SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           child: SizedBox(
//             width: maxX * 70,
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: LineChart(
//                 LineChartData(
//                   gridData: const FlGridData(show: true),
//                   titlesData: FlTitlesData(
//                     bottomTitles: AxisTitles(
//                       sideTitles: SideTitles(
//                         showTitles: true,
//                         reservedSize: 22,
//                         interval: 1,
//                         getTitlesWidget: (value, meta) => getTitlesWidget(value, context),
//                       ),
//                     ),
//                     leftTitles: AxisTitles(
//                       sideTitles: SideTitles(
//                         showTitles: true,
//                         reservedSize: 40,
//                         getTitlesWidget: (value, meta) {
//                           return Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Text(
//                               value.toInt().toString(),
//                               style: AppTextStyle.text14MG(context).copyWith(fontSize: 10),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                     topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
//                     rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
//                   ),
//                   borderData: FlBorderData(
//                     show: false,
//                     border: Border.all(color: AppColor.greyColor(context), width: 1),
//                   ),
//                   minX: 1,
//                   maxX: maxX,
//                   minY: 0,
//                   maxY: maxY,
//                   lineBarsData: [
//                     LineChartBarData(
//                       spots: getSpots(),
//                       isCurved: true,
//                       color: AppColor.greenColor(context),
//                       barWidth: 3,
//                       belowBarData: BarAreaData(show: true, color: AppColor.greenColor(context).withOpacity(0.5)),
//                       dotData: const FlDotData(show: false),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
