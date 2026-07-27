import 'package:collection/collection.dart';
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

class CustomSingleSelect extends StatefulWidget {
  final dynamic value;
  final List<CustomSelectItem>? items;
  final void Function(dynamic)? onChanged;
  final String? Function(dynamic)? validator;
  final String? hintText;
  final int? maxLines;
  final bool readOnly;
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
  final void Function()? onReInitial;
  final Widget? icon;
  final TextStyle? hintStyle;
  final bool hasRemove;
  final FormFieldBorder formFieldBorder;
  const CustomSingleSelect({
    super.key,
    this.value,
    this.items,
    this.onChanged,
    this.validator,
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
    this.onReInitial,
    this.formFieldBorder = FormFieldBorder.outLine,
    this.hintStyle,
    this.hasRemove = true,
    this.readOnly = false,
  });

  @override
  State<CustomSingleSelect> createState() => _CustomSingleSelectState();
}

class _CustomSingleSelectState extends State<CustomSingleSelect> {
  final _selectedEC = TextEditingController();

  void _showValue() {
    Future.delayed(Duration.zero, () {
      _selectedEC.text = widget.items?.firstWhereOrNull((element) => element.value == widget.value)?.name ?? '';
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
            onTap: widget.apiResponse?.state == ResponseState.loading && widget.readOnly == true
                ? null
                : widget.items != null && widget.items?.isNotEmpty == true
                    ? widget.readOnly == true
                        ? null
                        : () {
                            NamedNavigatorImpl.showAppBottomSheet(
                              context,
                              CustomSingleSelectBottomSheet(
                                value: widget.value,
                                items: widget.items,
                                hasRemove: widget.hasRemove,
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
            style: AppTextStyle.textFormStyle(context),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            maxLines: widget.maxLines,
            cursorColor: widget.focusColor,
            decoration: InputDecoration(
              hintMaxLines: 2,
              hintText: widget.hintText,
              hintStyle: widget.hintStyle ?? AppTextStyle.hintStyle(context),
              fillColor: widget.fillColor ??
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
                            child: widget.icon ??
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

class CustomSingleSelectBottomSheet extends StatefulWidget {
  final dynamic value;
  final List<CustomSelectItem>? items;
  final void Function(dynamic)? onChanged;
  final bool hasRemove;
  const CustomSingleSelectBottomSheet({super.key, this.value, this.items, this.onChanged, this.hasRemove = true});

  @override
  State<CustomSingleSelectBottomSheet> createState() => _CustomSingleSelectBottomSheetState();
}

class _CustomSingleSelectBottomSheetState extends State<CustomSingleSelectBottomSheet> {
  dynamic _initialValue;
  List<CustomSelectItem>? _items;
  @override
  void initState() {
    _initialValue = widget.value;
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
                              switch (widget.hasRemove) {
                                case true:
                                  if (_initialValue == _items?[index].value) {
                                    setState(() {
                                      _initialValue = null;
                                    });
                                  } else {
                                    setState(() {
                                      _initialValue = _items?[index].value;
                                    });
                                  }
                                  break;
                                case false:
                                  setState(() {
                                    _initialValue = _items?[index].value;
                                  });
                                  break;
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
                                  CircleAvatar(
                                    backgroundColor: _initialValue == _items?[index].value
                                        ? AppColor.mainAppColor(context)
                                        : AppColor.greyColor(context),
                                    radius: 11,
                                    child: CircleAvatar(
                                      backgroundColor: AppColor.whiteColor(context),
                                      radius: 9,
                                      child: CircleAvatar(
                                        backgroundColor: _initialValue == _items?[index].value
                                            ? AppColor.mainAppColor(context)
                                            : AppColor.whiteColor(context),
                                        radius: 7,
                                      ),
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
