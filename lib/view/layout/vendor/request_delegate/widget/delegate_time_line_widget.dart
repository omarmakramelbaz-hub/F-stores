// import '../../../../../helpers/theme/app_colors.dart';
// import 'package:flutter/material.dart';
// import 'package:timeline_tile/timeline_tile.dart';
//
// class DelegateTimeLineWidget extends StatelessWidget {
//   final bool isFirst;
//   final bool isLast;
//   final Widget endChild;
//   final bool isDone;
//   final Widget icon;
//   const DelegateTimeLineWidget({
//     super.key,
//     required this.isFirst,
//     required this.isLast,
//     required this.endChild,
//     required this.isDone,
//     required this.icon,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 80,
//       child: TimelineTile(
//         isFirst: isFirst,
//         isLast: isLast,
//         endChild: endChild,
//         beforeLineStyle: LineStyle(color: AppColor.greyColor(context).withOpacity(.2)),
//         indicatorStyle: IndicatorStyle(
//           width: MediaQuery.of(context).size.width * 0.1,
//           height: MediaQuery.of(context).size.width * 0.3,
//           indicator: Container(
//             padding: const EdgeInsets.all(10),
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: AppColor.whiteColor(context),
//               boxShadow: [BoxShadow(color: AppColor.greyColor(context), blurRadius: 8, offset: const Offset(0, 5))],
//             ),
//             child: icon,
//           ),
//         ),
//       ),
//     );
//   }
// }
