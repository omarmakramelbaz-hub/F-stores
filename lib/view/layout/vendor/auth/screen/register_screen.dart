// import 'dart:io';
//
// import 'package:flutter/material.dart';
//
// import '../../../../../helpers/locale/all_translation.dart';
// import '../../../../../helpers/locale/app_locale_key.dart';
// import '../../../../../helpers/theme/app_text_style.dart';
// import 'package:faskhaninja_vendor/helpers/routes/app_routers_import.dart';
// import '../../../../custom_widgets/buttons/custom_button.dart';
// import '../../../../custom_widgets/custom_app_bar/custom_auth_app_bar.dart';
// import '../../../../custom_widgets/custom_form_field/custom_form_field.dart';
// import '../../../../custom_widgets/validation/validation_mixin.dart';
// import '../../../../global/widget/custom_image_container.dart';
// import '../bottom_sheet.dart/terms_and_conditions_bottom_sheet.dart';
//
// class RegisterScreen extends StatefulWidget {
//   static const String routeName = 'register_screen';
//   const RegisterScreen({super.key});
//
//   @override
//   State<RegisterScreen> createState() => _RegisterScreenState();
// }
//
// class _RegisterScreenState extends State<RegisterScreen> with ValidationMixin {
//   // final _formKey = GlobalKey<FormState>();
//   // final _merchantNameEc = TextEditingController();
//   // final _ownerNameEc = TextEditingController();
//   // final _branchesCountEc = TextEditingController();
//   // final _nationalIdEc = TextEditingController();
//   // final _taxIdEc = TextEditingController();
//   // final _commercialRegistrationEc = TextEditingController();
//   // final _phoneNumberOneEc = TextEditingController();
//   // final _phoneNumberTwoEc = TextEditingController();
//   // final _emailEc = TextEditingController();
//   File? _idImage;
//   File? _taximage;
//   File? _commercialRegistrationImage;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAuthAppBar(context),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 21),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 25),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 10),
//                 child: Text(AppLocaleKey.startAsMerchant.tr(), style: AppTextStyle.text20BS(context)),
//               ),
//               const SizedBox(height: 23),
//               CustomFormField(title: AppLocaleKey.merchantName.tr(), validator: validateName),
//               const SizedBox(height: 23),
//               CustomFormField(title: AppLocaleKey.ownerName.tr(), validator: validateName),
//               const SizedBox(height: 23),
//               CustomFormField(
//                 title: AppLocaleKey.branchesCount.tr(),
//                 validator: validateEmptyField,
//                 keyboardType: TextInputType.number,
//               ),
//               const SizedBox(height: 23),
//               CustomFormField(
//                 title: AppLocaleKey.nationalId.tr(),
//                 validator: validateEmptyField,
//                 keyboardType: TextInputType.number,
//               ),
//               const SizedBox(height: 23),
//               CustomFormField(
//                 title: AppLocaleKey.taxNumber.tr(),
//                 validator: validateEmptyField,
//                 keyboardType: TextInputType.number,
//               ),
//               const SizedBox(height: 23),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(AppLocaleKey.nationalIdImage.tr(), style: AppTextStyle.text16RS(context)),
//                   const SizedBox(width: 1),
//                   Text(AppLocaleKey.taxNumberImage.tr(), style: AppTextStyle.text16RS(context)),
//                   const SizedBox(width: 1),
//                 ],
//               ),
//               const SizedBox(height: 15),
//               //========================== images (nationalIdImage, taxNumberImage ) ===========================
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   CustomImageContainer(
//                     image: _idImage,
//                     onSuccess: (v) {
//                       setState(() {
//                         _idImage = v;
//                       });
//                     },
//                   ),
//                   CustomImageContainer(
//                     image: _taximage,
//                     onSuccess: (v) {
//                       setState(() {
//                         _taximage = v;
//                       });
//                     },
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 23),
//               CustomFormField(title: AppLocaleKey.commercialRegistrationNumber.tr(), validator: validateEmail),
//               const SizedBox(height: 23),
//               Text(AppLocaleKey.commercialRegistrationImage.tr(), style: AppTextStyle.text16RS(context)),
//               const SizedBox(height: 15),
//               CustomImageContainer(
//                 image: _commercialRegistrationImage,
//                 onSuccess: (v) {
//                   setState(() {
//                     _commercialRegistrationImage = v;
//                   });
//                 },
//               ),
//               const SizedBox(height: 23),
//               CustomFormField(title: AppLocaleKey.firstPhoneNumber.tr(), keyboardType: TextInputType.phone),
//               const SizedBox(height: 23),
//               CustomFormField(title: AppLocaleKey.secondPhoneNumber.tr(), keyboardType: TextInputType.phone),
//               const SizedBox(height: 23),
//               CustomFormField(title: AppLocaleKey.vodafonCashNumber.tr(), keyboardType: TextInputType.number),
//               const SizedBox(height: 23),
//               CustomFormField(title: AppLocaleKey.bankAccountNumber.tr(), keyboardType: TextInputType.number),
//               const SizedBox(height: 23),
//               CustomButton(
//                 text: AppLocaleKey.next.tr(),
//                 onPressed: () {
//                   NavigatorMethods.showAppBottomSheet(
//                     context,
//                     enableDrag: true,
//                     isScrollControlled: true,
//                     const TermsAndConditionsBottomSheet(),
//                   );
//                 },
//               ),
//               const SizedBox(height: 30),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
