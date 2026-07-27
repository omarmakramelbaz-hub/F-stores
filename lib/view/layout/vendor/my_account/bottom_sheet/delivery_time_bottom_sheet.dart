import 'package:easy_localization/easy_localization.dart';
import '../../../../../helpers/images/app_images.dart';
import '../../../../../helpers/locale/app_locale_key.dart';
import '../../../../../helpers/theme/app_colors.dart';
import '../../../../../helpers/theme/app_text_style.dart';
import '../../../../custom_widgets/buttons/custom_button.dart';
import '../../../../custom_widgets/custom_form_field/custom_form_field.dart';
import '../../../../custom_widgets/validation/validation_mixin.dart';
import '../../auth/controller/auth_controller.dart';
import '../controller/my_account_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class DeliveryTimeBottomSheet extends StatefulWidget {
  const DeliveryTimeBottomSheet({super.key});

  @override
  State<DeliveryTimeBottomSheet> createState() => _MenuBottomSheetWidgetState();
}

class _MenuBottomSheetWidgetState extends State<DeliveryTimeBottomSheet> with ValidationMixin {
  final _formKey = GlobalKey<FormState>();
  final _deliveryTimeController = TextEditingController();

  // @override
  // void initState() {
  //   _deliveryTimeController.text = Provider.of<AuthController>(context,listen: false).profile.;
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: MediaQuery.of(context).size.height * .320,
      decoration: BoxDecoration(
        color: AppColor.whiteColor(context),
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(36), topRight: Radius.circular(36)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 33, vertical: 20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(AppLocaleKey.deliveryTime.tr(), style: AppTextStyle.text16MS(context)),
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: AppColor.whiteColor(context),
                        child: SvgPicture.asset(AppImages.closeIcon),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Divider(thickness: 1, color: AppColor.lightGreyColor(context)),
              const SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                child: CustomFormField(controller: _deliveryTimeController, validator: validateEmptyField),
              ),
              // CustomSingleSelect(
              //   value: _deliveryTime,
              //   onChanged: (value) {
              //     setState(
              //       () {
              //         _deliveryTime = value;
              //       },
              //     );
              //   },
              //   title: AppLocaleKey.deliveryTime.tr(),
              //   items: const [],
              // ),
              const SizedBox(height: 20),
              ChangeNotifierProvider(
                create: (context) => MyAccountController(),
                child: Consumer<MyAccountController>(
                  builder: (context, myAccountController, _) {
                    return CustomButton(
                      gradient: LinearGradient(
                        colors: [AppColor.gridOneButtonColor(context), AppColor.gridTwoButtonColor(context)],
                      ),
                      text: AppLocaleKey.save.tr(),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          myAccountController.updateDeliveryTime(
                            deliveryTime: _deliveryTimeController.text,
                            restaurantId: context.read<AuthController>().profile?.resturantId ?? 0,
                            onSuccess: () {
                              Navigator.pop(context);
                            },
                          );
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
