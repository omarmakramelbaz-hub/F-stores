import '../../custom_widgets/custom_image/custom_image.dart';
import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({super.key, required this.onPressed, required this.imagePath, this.size});
  final VoidCallback onPressed;
  final String imagePath;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        elevation: 5,
        shape: const OvalBorder(),
        child: SizedBox(
          height: size ?? 34,
          width: size ?? 34,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomImage(path: imagePath, type: ImageType.svg),
          ),
        ),
      ),
    );
  }
}
