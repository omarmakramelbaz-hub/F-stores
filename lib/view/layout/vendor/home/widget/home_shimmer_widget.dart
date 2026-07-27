import '../../../../../helpers/theme/app_colors.dart';
import '../../../../custom_widgets/custom_loading/custom_shimmer.dart';
import 'package:flutter/material.dart';

class HomeShimmerWidget extends StatelessWidget {
  const HomeShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            CustomShimmer(
              radius: 10,
              height: 50,
              width: MediaQuery.of(context).size.width / 2.7,
              shimmerColor: AppColor.mainAppColor(context),
              fillColor: AppColor.lightGreyColor(context),
            ),
            const SizedBox(width: 10),
            CustomShimmer(
              radius: 30,
              height: 40,
              width: 40,
              shimmerColor: AppColor.mainAppColor(context),
              fillColor: AppColor.lightGreyColor(context),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: CustomShimmer(
                radius: 10,
                height: 30,
                width: MediaQuery.of(context).size.width / 3,
                shimmerColor: AppColor.mainAppColor(context),
                fillColor: AppColor.lightGreyColor(context),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        CustomShimmer(
          radius: 12,
          height: 100,
          width: double.infinity,
          shimmerColor: AppColor.mainAppColor(context),
          fillColor: AppColor.lightGreyColor(context),
        ),
      ],
    );
  }
}
