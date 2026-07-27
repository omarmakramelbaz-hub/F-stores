import 'package:easy_localization/easy_localization.dart';
import '../../../../../helpers/routes/app_routers_import.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../../../helpers/locale/app_locale_key.dart';
import '../../../../../helpers/theme/app_colors.dart';
import '../../../../../helpers/theme/app_text_style.dart';
import '../../../../custom_widgets/buttons/custom_button.dart';
import '../../../../custom_widgets/custom_form_field/custom_form_field.dart';
import '../../../../custom_widgets/validation/validation_mixin.dart';
import '../../../../global/bottom_sheet/dark_app_bottom_sheet.dart';
import '../controller/request_delegate_controller.dart';

class RiseYourFeeBottomSheet extends StatefulWidget {
  const RiseYourFeeBottomSheet({
    super.key,
    required this.requestDelegateController,
    required this.kmPrice,
    required this.shippingPercentage,
    required this.distance,
  });
  final RequestDelegateController requestDelegateController;
  final num kmPrice;
  final num shippingPercentage;
  final num distance;

  @override
  State<RiseYourFeeBottomSheet> createState() => _RiseYourFeeBottomSheetState();
}

class _RiseYourFeeBottomSheetState extends State<RiseYourFeeBottomSheet> with ValidationMixin {
  final TextEditingController _feeEC = TextEditingController();
  final FocusNode focusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _feeEC.text = widget.requestDelegateController.priceEC.text;

    //  Provider.of<RequestDelegateController>(context, listen: false);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<RequestDelegateController>();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // final requestDelegateController = widget.requestDelegateController;

    return Form(
      key: _formKey,
      child: DarkAppBottomSheet(
        isDark: true,
        title: AppLocaleKey.searchingAboutDelegate.tr(),
        showBorder: true,
        children: [
          Center(child: Text(AppLocaleKey.providePrice.tr(), style: AppTextStyle.text14MW(context))),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    int currentValue = int.parse(_feeEC.text);
                    currentValue += 1;
                    _feeEC.text = currentValue.toString();
                  });
                },
                child: Card(
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                  color: AppColor.mainAppColor(context),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: Text('1+', style: AppTextStyle.text14MW(context).copyWith(fontSize: 25)),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                      child: CustomFormField(
                        controller: _feeEC,
                        hintText: AppLocaleKey.egyptianPound.tr(),
                        formFieldBorder: FormFieldBorder.underLine,
                        textStyle: AppTextStyle.text14MW(context),
                        keyboardType: TextInputType.number,
                        unFocusColor: Colors.transparent,
                        focusNode: focusNode,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        // onFieldSubmitted: (p0) {
                        //   focusNode.unfocus();

                        //   WidgetsBinding.instance.addPostFrameCallback((_) {
                        //     if (mounted) {
                        //       widget.requestDelegateController.setPriceEC(p0);
                        //       widget.requestDelegateController.setActualPrice(p0);
                        //       log(widget.requestDelegateController.priceEC.text);
                        //       log(p0);
                        //     }
                        //   });
                        // },
                        validator: (v) => validateFee(
                          value: _feeEC.text,
                          distance: widget.distance,
                          // num.parse(requestDelegateController.distance.toString()),
                          percentage: widget.shippingPercentage,
                          kmPrice: widget.kmPrice,
                        ),
                        suffixIcon: Text(
                          AppLocaleKey.egyptianPound.tr(),
                          style: AppTextStyle.text14MW(context).copyWith(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    int currentValue = int.parse(_feeEC.text);
                    currentValue -= 1;
                    _feeEC.text = currentValue.toString();
                  });
                },
                child: Card(
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                  color: AppColor.mainAppColor(context),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: Text('1-', style: AppTextStyle.text14MW(context).copyWith(fontSize: 25)),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: const SizedBox(height: 15),
          ),
          CustomButton(
            text: AppLocaleKey.riseUpFee.tr(),
            onPressed: () {
              // if (widget.requestDelegateController.priceEC.text.isNotEmpty &&
              //     widget.requestDelegateController.priceEC.text.trim() != '') {
              //   // requestDelegateController.dispose();
              //   NavigatorMethods.pop(context);
              // }

              if (_formKey.currentState!.validate()) {
                widget.requestDelegateController.setPriceEC(_feeEC.text);
                widget.requestDelegateController.setActualPrice(_feeEC.text);
                NamedNavigatorImpl.pop(context);
              }
            },
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }
}
