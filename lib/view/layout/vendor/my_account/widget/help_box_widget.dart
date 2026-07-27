import '../../../../../helpers/theme/app_colors.dart';
import '../../../../../helpers/theme/app_text_style.dart';
import 'package:flutter/material.dart';

class HelpBoxWidget extends StatefulWidget {
  const HelpBoxWidget({super.key, required this.answer, required this.question});
  final String answer;
  final String question;
  @override
  State<HelpBoxWidget> createState() => _HelpBoxWidgetState();
}

class _HelpBoxWidgetState extends State<HelpBoxWidget> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          isExpanded = !isExpanded;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: isExpanded ? 14 : 0),
        margin: EdgeInsets.only(bottom: 12, top: isExpanded == true ? 24 : 12, right: 20, left: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isExpanded ? AppColor.mainAppColor(context) : Colors.transparent),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Text(widget.question, style: AppTextStyle.text18MS(context)),
                const Spacer(),
                Card(
                  color: isExpanded ? AppColor.whiteColor(context) : AppColor.greyColor(context).withOpacity(0.5),
                  elevation: isExpanded ? 6 : 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  child: Icon(
                    isExpanded ? Icons.remove : Icons.add,
                    color: isExpanded ? AppColor.yellowColor(context) : AppColor.whiteColor(context),
                    size: isExpanded ? 24 : 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            isExpanded
                ? Text(widget.answer, textAlign: TextAlign.justify, style: AppTextStyle.text14RS(context))
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
