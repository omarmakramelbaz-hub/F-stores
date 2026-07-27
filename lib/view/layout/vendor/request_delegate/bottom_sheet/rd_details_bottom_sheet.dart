import 'package:easy_localization/easy_localization.dart';
import '../../../../../helpers/locale/app_locale_key.dart';
import '../../../../../helpers/theme/app_colors.dart';
import '../../../../../helpers/theme/app_text_style.dart';
import '../../../../custom_widgets/buttons/custom_button.dart';
import '../../../../custom_widgets/custom_form_field/custom_form_field.dart';
import '../../../../global/bottom_sheet/dark_app_bottom_sheet.dart';
import '../controller/request_delegate_controller.dart';
import 'package:flutter/material.dart';

class RDDetailsBottomSheet extends StatefulWidget {
  const RDDetailsBottomSheet({super.key, required this.requestDelegateController});
  final RequestDelegateController requestDelegateController;

  @override
  State<RDDetailsBottomSheet> createState() => _RDDetailsBottomSheetState();
}

class _RDDetailsBottomSheetState extends State<RDDetailsBottomSheet> {
  final FocusNode focusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: DarkAppBottomSheet(
        title: AppLocaleKey.packageDescription.tr(),
        isDark: true,
        showBorder: true,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: CustomFormField(
              controller: widget.requestDelegateController.descriptionEC,
              hintText: AppLocaleKey.packageDescription.tr(),
              maxLines: 7,
              radius: 15,
              fillColor: AppColor.lightDarkColor(context),
              unFocusColor: AppColor.lightDarkColor(context),
              textStyle: AppTextStyle.text14MW(context),
              validator: (p0) {
                if (p0 == null || p0.isEmpty) {
                  return AppLocaleKey.validateEmpty.tr();
                } else if (p0.length < 3) {
                  return AppLocaleKey.validateDisc.tr();
                }
                return null;
              },
              onFieldSubmitted: (p0) {
                focusNode.unfocus();
              },
            ),
          ),
          const SizedBox(height: 15),
          CustomButton(
            text: AppLocaleKey.save.tr(),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                widget.requestDelegateController.setDescriptionEC(widget.requestDelegateController.descriptionEC.text);
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }
}
