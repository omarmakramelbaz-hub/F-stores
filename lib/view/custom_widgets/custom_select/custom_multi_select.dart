import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../helpers/extension/context_extension.dart';
import '../../../helpers/locale/app_locale_key.dart';
import '../../../helpers/networking/api_helper.dart';
import '../../../helpers/routes/app_routers_import.dart';
import '../../../helpers/theme/app_colors.dart';
import '../../../helpers/theme/app_text_style.dart';
import '../../../helpers/utils/common_methods.dart';
import '../api_response_widget/api_response_widget.dart';
import '../buttons/custom_button.dart';
import '../custom_form_field/custom_form_field.dart';
import 'custom_select_item.dart';

class CustomMultiSelect extends StatefulWidget {
  final List<dynamic> value;
  final List<CustomSelectItem>? items;
  final void Function(List<dynamic>)? onChanged;
  final String? Function(List<dynamic>)? validator;
  final TextInputType? keyboardType;
  final String? hintText;
  final int? maxLines;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final double radius;
  final Color? fillColor;
  final Color? focusColor;
  final Color? unFocusColor;
  final String? title;
  final String? otherSideTitle;
  final ApiResponse? apiResponse;
  final void Function()? onReload;
  final Widget? icon;

  final FormFieldBorder formFieldBorder;
  const CustomMultiSelect({
    super.key,
    this.value = const [],
    this.items,
    this.onChanged,
    this.validator,
    this.keyboardType,
    this.hintText,
    this.maxLines = 1,
    this.prefixIcon,
    this.suffixIcon,
    this.radius = 50,
    this.fillColor,
    this.focusColor,
    this.unFocusColor,
    this.title,
    this.otherSideTitle,
    this.apiResponse,
    this.onReload,
    this.icon,
    this.formFieldBorder = FormFieldBorder.outLine,
  });

  @override
  State<CustomMultiSelect> createState() => _CustomMultiSelectState();
}

class _CustomMultiSelectState extends State<CustomMultiSelect> {
  final _selectedEC = TextEditingController();

  void _showValue() {
    Future.delayed(Duration.zero, () {
      _selectedEC.text =
          widget.items
              ?.where(
                (element) => List.generate(widget.value.length, (index) => widget.value[index]).contains(element.value),
              )
              .map((e) => e.name)
              .join(' , ') ??
          '';
    });
  }

  @override
  Widget build(BuildContext context) {
    _showValue();
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (widget.title != null) ...{
                Expanded(child: Text(widget.title!, style: AppTextStyle.formTitleStyle(context))),
              },
              if (widget.otherSideTitle != null) ...{
                Text(widget.otherSideTitle!, style: AppTextStyle.formTitleStyle(context)),
              },
            ],
          ),
          if (widget.title != null || widget.otherSideTitle != null) ...{const SizedBox(height: 10)},
          TextFormField(
            controller: _selectedEC,
            validator: (v) => widget.validator?.call(widget.value),
            onTap: widget.apiResponse?.state == ResponseState.loading
                ? null
                : widget.items != null && widget.items?.isNotEmpty == true
                ? () {
                    NamedNavigatorImpl.showAppBottomSheet(
                      context,
                      CustomMultiSelectBottomSheet(
                        value: widget.value,
                        items: widget.items,
                        onChanged: (v) {
                          widget.onChanged?.call(v);
                        },
                      ),
                      isScrollControlled: true,
                    );
                  }
                : () {
                    CommonMethods.showAlertDialog(
                      message: context.apiTr(ar: 'لا توجد بيانات', en: 'There is no data'),
                    );
                  },
            readOnly: true,
            keyboardType: widget.keyboardType,
            style: AppTextStyle.textFormStyle(context),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            maxLines: widget.maxLines,
            cursorColor: widget.focusColor,
            decoration: InputDecoration(
              hintMaxLines: 2,
              hintText: widget.hintText,
              hintStyle: AppTextStyle.hintStyle(context),
              fillColor:
                  widget.fillColor ??
                  (widget.formFieldBorder == FormFieldBorder.underLine
                      ? Colors.transparent
                      : AppColor.textFormFillColor(context)),
              filled: true,
              border: _border(color: widget.unFocusColor ?? AppColor.textFormBorderColor(context)),
              disabledBorder: _border(color: widget.unFocusColor ?? AppColor.textFormBorderColor(context)),
              focusedBorder: _border(color: widget.unFocusColor ?? AppColor.mainAppColor(context)),
              enabledBorder: _border(color: widget.unFocusColor ?? AppColor.textFormBorderColor(context)),
              contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              suffixIconConstraints: BoxConstraints(maxWidth: widget.suffixIcon != null ? 110 : 40),
              prefixIcon: widget.prefixIcon,
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 35,
                    child: widget.apiResponse != null
                        ? ApiResponseWidget(
                            apiResponse: widget.apiResponse!,
                            onReload: widget.onReload,
                            isEmpty: false,
                            errorWidget: IconButton(
                              onPressed: widget.onReload,
                              icon: Icon(Icons.wifi_protected_setup_rounded, color: AppColor.hintColor(context)),
                            ),
                            offlineWidget: GestureDetector(
                              onTap: widget.onReload,
                              child: Icon(Icons.wifi_protected_setup_rounded, color: AppColor.hintColor(context)),
                            ),
                            loadingWidget: const CupertinoActivityIndicator(),
                            child:
                                widget.icon ??
                                Icon(
                                  widget.items == null || widget.items!.isEmpty
                                      ? Icons.error_rounded
                                      : Icons.keyboard_arrow_down_rounded,
                                  color: AppColor.hintColor(context),
                                  size: 25,
                                ),
                          )
                        : widget.icon ??
                              Icon(
                                widget.items == null || widget.items!.isEmpty
                                    ? Icons.error_rounded
                                    : Icons.keyboard_arrow_down_rounded,
                                color: AppColor.hintColor(context),
                                size: 25,
                              ),
                  ),
                  if (widget.suffixIcon != null) ...{widget.suffixIcon ?? const SizedBox(), const SizedBox(width: 10)},
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputBorder _border({required Color color}) {
    switch (widget.formFieldBorder) {
      case FormFieldBorder.outLine:
        return OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.radius),
          borderSide: BorderSide(color: color),
        );
      case FormFieldBorder.underLine:
        return UnderlineInputBorder(
          borderRadius: BorderRadius.circular(0),
          borderSide: BorderSide(color: color),
        );
      case FormFieldBorder.none:
        return InputBorder.none;
    }
  }
}

class CustomMultiSelectBottomSheet extends StatefulWidget {
  final List<dynamic> value;
  final List<CustomSelectItem>? items;
  final void Function(List<dynamic>)? onChanged;
  const CustomMultiSelectBottomSheet({super.key, this.value = const [], this.items, this.onChanged});

  @override
  State<CustomMultiSelectBottomSheet> createState() => _CustomMultiSelectBottomSheetState();
}

class _CustomMultiSelectBottomSheetState extends State<CustomMultiSelectBottomSheet> {
  List<dynamic> _initialValue = [];
  List<CustomSelectItem>? _items;
  @override
  void initState() {
    _initialValue = List.generate(widget.value.length, (index) => widget.value[index]);
    _items = widget.items;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color: AppColor.whiteColor(context),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
      ),
      constraints: BoxConstraints(maxHeight: context.height() * 0.75),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                CustomButton(
                  text: context.apiTr(ar: 'تطبيق', en: 'Done'),
                  height: 47,
                  width: 90,
                  onPressed: () {
                    widget.onChanged?.call(_initialValue);
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CustomFormField(
                    fillColor: AppColor.offWhiteColor(context),
                    unFocusColor: AppColor.offWhiteColor(context),
                    hintText: tr(AppLocaleKey.search),
                    onChanged: (v) {
                      _items = widget.items?.where((element) => element.name.toLowerCase().contains(v)).toList();
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Column(
                children: [
                  ...List.generate(
                    _items?.length ?? 0,
                    (index) => Column(
                      children: [
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              if (_initialValue.contains(_items?[index].value)) {
                                setState(() {
                                  _initialValue.remove(_items?[index].value);
                                });
                              } else {
                                setState(() {
                                  _initialValue.add(_items?[index].value);
                                });
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      _items?[index].name ?? '',
                                      style: TextStyle(
                                        color: AppColor.darkTextColor(context),
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Container(
                                    width: 22,
                                    height: 22,
                                    decoration: BoxDecoration(
                                      color: _initialValue.contains(_items?[index].value)
                                          ? AppColor.mainAppColor(context)
                                          : AppColor.whiteColor(context),
                                      border: Border.all(
                                        color: _initialValue.contains(_items?[index].value)
                                            ? AppColor.mainAppColor(context)
                                            : AppColor.greyColor(context),
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Center(
                                      child: _initialValue.contains(_items?[index].value)
                                          ? Icon(Icons.check_rounded, color: AppColor.whiteColor(context), size: 18)
                                          : null,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                      ],
                    ),
                  ),
                  SizedBox(height: MediaQuery.viewInsetsOf(context).bottom),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
