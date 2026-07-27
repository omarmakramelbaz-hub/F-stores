import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

import '../../view/custom_widgets/bottom_sheet/choose_gallery_or_camera_bottom_sheet.dart';
import '../routes/app_routers_import.dart';

class ImageMethods {
  static Future<void> pickImage({required ImageSource source, required void Function(File) onSuccess}) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(source: source);
    if (pickedImage != null) {
      File result = File(pickedImage.path);
      onSuccess.call(result);
    }
  }

  static Future<void> pickMultiImage({required void Function(List<File>) onSuccess}) async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> pickedImage = await picker.pickMultiImage();
    final List<File> result = pickedImage.map((e) => File(e.path)).toList();
    onSuccess.call(result);
  }

  static void pickImageBottomSheet(BuildContext context, {required void Function(File) onSuccess}) {
    NamedNavigatorImpl.showAppBottomSheet(
      context,
      ChooseGalleryOrCameraBottomSheet(
        onCamera: () => ImageMethods.pickImage(source: ImageSource.camera, onSuccess: onSuccess),
        onGallery: () => ImageMethods.pickImage(source: ImageSource.gallery, onSuccess: onSuccess),
      ),
    );
  }
}
