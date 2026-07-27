import 'dart:io';

import '../../../helpers/images/app_images.dart';
import '../../../helpers/images/image_methods.dart';
import '../../../helpers/theme/app_colors.dart';
import '../../custom_widgets/custom_image/custom_image.dart';
import 'package:flutter/material.dart';

class CustomImageContainer extends StatelessWidget {
  const CustomImageContainer({super.key, required this.onSuccess, this.image, this.readOnly, this.bgImage});
  final void Function(File) onSuccess;
  final File? image;
  final bool? readOnly;
  final String? bgImage;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        readOnly == true
            ? null
            : ImageMethods.pickImageBottomSheet(
                context,
                onSuccess: (v) {
                  onSuccess.call(v);
                  Navigator.pop(context);
                },
              );
      },
      child: Container(
        height: 122,
        width: MediaQuery.of(context).size.width / 2.33,
        decoration: BoxDecoration(
          border: Border.all(color: AppColor.textFormBorderColor(context)),
          borderRadius: BorderRadius.circular(20),
        ),
        child: image != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image(
                  fit: BoxFit.cover,
                  image: FileImage(image!),
                  errorBuilder: (context, url, error) => const SizedBox(),
                ),
              )
            : Padding(
                padding: EdgeInsets.all(bgImage == null ? 30 : 0),
                child: CustomImage(
                  path: bgImage != null
                      ? bgImage != ''
                            ? bgImage!
                            : AppImages.imageCover
                      : AppImages.imageCover,
                  type: bgImage == null ? ImageType.svg : ImageType.network,
                  fit: BoxFit.contain,
                  height: 5,
                ),
              ),
      ),
    );
  }
}
