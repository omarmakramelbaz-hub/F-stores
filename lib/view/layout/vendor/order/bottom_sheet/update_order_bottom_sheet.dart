import 'package:easy_localization/easy_localization.dart';
import '../../../../../helpers/locale/app_locale_key.dart';
import '../../../../custom_widgets/buttons/custom_button.dart';
import '../../../../custom_widgets/custom_form_field/custom_form_field.dart';
import '../../../../custom_widgets/validation/validation_mixin.dart';
import '../../../../global/bottom_sheet/app_bottom_sheet.dart';
import '../controller/order_controller.dart';
import '../model/vendor_orders_model.dart';
import 'package:flutter/material.dart';

class UpdateOrderBottomSheet extends StatefulWidget {
  const UpdateOrderBottomSheet({
    super.key,
    required this.order,
    required this.orderController,
    this.onSuccess,
    required this.itemId,
  });
  final VendorOrdersModel? order;
  final OrderController orderController;
  final VoidCallback? onSuccess;
  final int itemId;

  @override
  State<UpdateOrderBottomSheet> createState() => _UpdateOrderBottomSheetState();
}

class _UpdateOrderBottomSheetState extends State<UpdateOrderBottomSheet> with ValidationMixin {
  final _formKey = GlobalKey<FormState>();

  final priceController = TextEditingController();

  final reasonController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: AppBottomSheet(
          title: AppLocaleKey.edit.tr(),
          children: [
            CustomFormField(
              title: AppLocaleKey.editPrice.tr(),
              controller: priceController,
              validator: validateEmptyField,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            CustomFormField(
              title: AppLocaleKey.editReason.tr(),
              controller: reasonController,
              validator: validateEmptyField,
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: AppLocaleKey.saveChanges.tr(),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  widget.orderController
                      .updateOrder(
                        itemId: widget.itemId,
                        orderId: widget.order?.id ?? 0,
                        reason: reasonController.text,
                        total: priceController.text,
                        onSuccess: () {
                          // Navigator.pop(context);
                        },
                      )
                      .then((value) {
                        widget.onSuccess?.call();
                        Navigator.pop(context);
                      });
                }
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
