import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../../helpers/images/app_images.dart';
import '../../../../../helpers/locale/app_locale_key.dart';
import '../../../../../helpers/theme/app_colors.dart';
import '../../../../../helpers/theme/app_text_style.dart';
import '../../../../custom_widgets/custom_app_bar/custom_app_bar.dart';
import '../../../../custom_widgets/custom_image/custom_image.dart';

class DeliveryLocationArgs {
  final double lat;
  final double lng;
  const DeliveryLocationArgs({required this.lat, required this.lng});
}

class DeliveryLocationScreen extends StatefulWidget {
  static const String routeName = 'DeliveryLocationScreen';
  final DeliveryLocationArgs? args;
  const DeliveryLocationScreen({super.key, this.args});

  @override
  State<DeliveryLocationScreen> createState() => _DeliveryLocationScreenState();
}

class _DeliveryLocationScreenState extends State<DeliveryLocationScreen> {
  List<Placemark>? placemarks;
  double? currentLat;
  double? currentLng;
  GoogleMapController? gmc;
  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _determinePosition() async {
    placemarks = await placemarkFromCoordinates(widget.args!.lat, widget.args!.lng);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: CustomAppBar(
        context,
        height: 80,
        appBarColor: AppColor.whiteColor(context),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColor.blackColor(context)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Text(AppLocaleKey.location.tr(), style: AppTextStyle.text18BS(context)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: GoogleMap(
                    markers: markers,
                    mapType: MapType.normal,
                    onMapCreated: (GoogleMapController controller) {
                      gmc = controller;
                      if (currentLat != null && currentLng != null) {
                        gmc!.animateCamera(CameraUpdate.newLatLng(LatLng(widget.args!.lat, widget.args!.lng)));
                      }
                      markers.add(
                        Marker(
                          markerId: const MarkerId('location'),
                          position: LatLng(widget.args!.lat, widget.args!.lng),
                        ),
                      );
                      setState(() {});
                    },
                    initialCameraPosition: CameraPosition(target: LatLng(widget.args!.lat, widget.args!.lng), zoom: 16),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (placemarks != null) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.1,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColor.whiteColor(context),
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.greyColor(context).withOpacity(0.2),
                        offset: const Offset(0, -3),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const CustomImage(path: AppImages.currentLocation, type: ImageType.svg),
                          const SizedBox(width: 10),
                          Text(AppLocaleKey.area.tr(), style: AppTextStyle.text14MG(context)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '${placemarks![0].locality}, ${placemarks![0].street}',
                        style: AppTextStyle.text14MG(context).copyWith(overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
