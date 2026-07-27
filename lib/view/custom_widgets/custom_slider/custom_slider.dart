// import 'package:carousel_slider/carousel_slider.dart' as carousel_slider;
// import 'package:flutter/material.dart';
// import 'package:smooth_page_indicator/smooth_page_indicator.dart';
//
// import '../../../helpers/theme/app_colors.dart';
// import '../custom_image/custom_image.dart';
//
// class SliderArguments {
//   String? url;
//   Widget? child;
//   void Function()? onTap;
//   SliderArguments({this.url, this.child, this.onTap});
// }
//
// class CustomSlider extends StatefulWidget {
//   final List<SliderArguments> sliderArguments;
//   final bool autoPlay;
//   final bool hasDots;
//   final bool isDotsOnContent;
//   final bool hasZoom;
//   final double aspectRatio;
//   final double radius;
//   final BoxFit fit;
//
//   const CustomSlider({
//     super.key,
//     required this.sliderArguments,
//     this.autoPlay = true,
//     this.hasDots = true,
//     this.isDotsOnContent = true,
//     this.hasZoom = false,
//     this.aspectRatio = 333 / 158,
//     this.radius = 50,
//     this.fit = BoxFit.cover,
//   });
//
//   @override
//   State<CustomSlider> createState() => _CustomSliderState();
// }
//
// class _CustomSliderState extends State<CustomSlider> {
//   int _index = 0;
//   late carousel_slider.CarouselController _carouselController;
//   @override
//   void initState() {
//     _carouselController = carousel_slider.CarouselController();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         carousel_slider.CarouselSlider(
//           carouselController: _carouselController,
//           items: widget.sliderArguments.map((item) {
//             return GestureDetector(
//               onTap: item.onTap,
//               child: Padding(
//                 padding: const EdgeInsets.all(2.0),
//                 child: Container(
//                   width: double.infinity,
//                   margin: EdgeInsets.only(bottom: widget.isDotsOnContent ? 0.0 : 20.0),
//                   clipBehavior: Clip.antiAlias,
//                   decoration: BoxDecoration(
//                     color: AppColor.whiteColor(context),
//                     borderRadius: BorderRadius.circular(widget.radius),
//                   ),
//                   child:
//                       item.child ??
//                       CustomImage(
//                         hasZoom: widget.hasZoom,
//                         radius: 25,
//                         path: item.url!,
//                         width: double.infinity,
//                         height: 190,
//                         fit: widget.fit,
//                         type: ImageType.network,
//                       ),
//                 ),
//               ),
//             );
//           }).toList(),
//           options: carousel_slider.CarouselOptions(
//             aspectRatio: widget.aspectRatio,
//             autoPlayAnimationDuration: const Duration(seconds: 2),
//             autoPlay: widget.autoPlay,
//             viewportFraction: 0.9,
//             onPageChanged: (i, _) {
//               setState(() {
//                 _index = i;
//               });
//             },
//           ),
//         ),
//         if (widget.hasDots) ...{
//           Positioned(
//             bottom: 7,
//             right: 0,
//             left: 0,
//             child: Center(
//               child: SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: AnimatedSmoothIndicator(
//                   activeIndex: _index,
//                   count: widget.sliderArguments.length,
//                   effect: ExpandingDotsEffect(
//                     dotColor: AppColor.greyColor(context),
//                     activeDotColor: AppColor.mainAppColor(context),
//                     dotHeight: 7,
//                     dotWidth: 7,
//                   ),
//                   onDotClicked: (i) {
//                     _carouselController.animateToPage(i);
//                   },
//                 ),
//               ),
//             ),
//           ),
//         },
//       ],
//     );
//   }
// }
