import 'dart:async';
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../../../../helpers/hive/hive_methods.dart';
import '../../../../../helpers/images/app_images.dart';
import '../../../../../helpers/locale/app_locale_key.dart';
import '../../../../../helpers/routes/app_routers_import.dart';
import '../../../../../helpers/theme/app_colors.dart';
import '../../../../../helpers/theme/app_text_style.dart';
import '../../../../../helpers/utils/common_methods.dart';
import '../../../../custom_widgets/buttons/custom_button.dart';
import '../../../../custom_widgets/custom_app_bar/custom_app_bar.dart';
import '../../../../custom_widgets/custom_image/custom_image.dart';
import '../../auth/controller/auth_controller.dart';
import '../../bottom_navigation/screen/bottom_navigation_bar_screen.dart';

class VendorLocationScreen extends StatefulWidget {
  static const String routeName = 'VendorLocationScreen';

  const VendorLocationScreen({super.key});

  @override
  State<VendorLocationScreen> createState() => _VendorLocationScreenState();
}

class _VendorLocationScreenState extends State<VendorLocationScreen> {
  StreamSubscription<Position>? positionStream;
  List<Placemark>? placemarks;
  LatLng? latLng;
  GoogleMapController? gmc;
  Set<Marker> markers = {};
  Timer? _debounce;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _determinePosition();
    });
  }

  @override
  void dispose() {
    positionStream?.cancel();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _determinePosition() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        CommonMethods.showError(message: 'Location services are disabled.');
        setState(() => _isLoading = false);
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          CommonMethods.showError(message: 'Location permissions are denied');
          setState(() => _isLoading = false);
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        CommonMethods.showError(message: 'Location permissions are permanently denied, we cannot request permissions.');
        setState(() => _isLoading = false);
        return;
      }

      Position position = await Geolocator.getCurrentPosition();

      final storedLat = HiveMethods.getLat();
      final storedLng = HiveMethods.getLan();

      final lat = (storedLat is double) ? storedLat : position.latitude;
      final lng = (storedLng is double) ? storedLng : position.longitude;

      await _updateLocation(lat, lng);
    } catch (e, s) {
      log('Failed to get location: $e\n$s');
      CommonMethods.showError(message: 'Failed to get location');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updateLocation(double lat, double lng) async {
    if (!mounted) return;

    setState(() {
      latLng = LatLng(lat, lng);
      markers.clear();
      markers.add(Marker(
        markerId: const MarkerId('currentLocation'),
        position: latLng!,
      ));
    });

    try {
      placemarks = await placemarkFromCoordinates(lat, lng);
    } catch (e) {
      log('Reverse geocoding failed: $e');
      placemarks = [];
    }

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (gmc != null && latLng != null) {
      await gmc!.animateCamera(CameraUpdate.newLatLng(latLng!));
    }
  }

  void _onMapTap(LatLng tappedPoint) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      _updateLocation(tappedPoint.latitude, tappedPoint.longitude);
    });
  }

  void _onConfirmLocation(BuildContext context) {
    final authController = Provider.of<AuthController>(context, listen: false);

    if (latLng == null || placemarks == null || placemarks!.isEmpty) {
      CommonMethods.showError(message: 'Please select a valid location.');
      return;
    }

    final place = placemarks!.first;

    authController.updateVendorLocation(
      resturantId: authController.profile?.resturantId ?? 0,
      lat: latLng!.latitude,
      lng: latLng!.longitude,
      countryName: place.country ?? '',
      cityName: place.locality ?? '',
      address: place.street ?? '',
      onSuccess: () {
        HiveMethods.updateLat(latLng!.latitude);
        HiveMethods.updateLan(latLng!.longitude);
        authController.getProfile();

        log('Location confirmed: ${place.country}, ${place.locality}, ${place.street}');
        NamedNavigatorImpl.pushNamedAndRemoveUntil(context, VendorBottomNavigationBarScreen.routeName);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        extendBody: true,
        appBar: CustomAppBar(
          context,
          height: 80,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: AppColor.blackColor(context)),
            onPressed: () => Navigator.pop(context),
          ),
          appBarColor: AppColor.whiteColor(context),
          title: Text(AppLocaleKey.location.tr(), style: AppTextStyle.text18BS(context)),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.6,
                          child: GoogleMap(
                            onTap: _onMapTap,
                            markers: markers,
                            mapType: MapType.normal,
                            onMapCreated: (controller) {
                              gmc = controller;
                              if (latLng != null) {
                                gmc!.animateCamera(CameraUpdate.newLatLng(latLng!));
                              }
                            },
                            initialCameraPosition: CameraPosition(
                              target: latLng ?? const LatLng(30.033333, 31.233334),
                              zoom: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (placemarks != null && placemarks!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.11,
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
                                  const CustomImage(
                                    path: AppImages.currentLocation,
                                    type: ImageType.svg,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(AppLocaleKey.area.tr(), style: AppTextStyle.text14MG(context)),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                '${placemarks!.first.locality ?? ''}, ${placemarks!.first.street ?? ''}',
                                style: AppTextStyle.text14MG(context).copyWith(overflow: TextOverflow.ellipsis),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
        bottomNavigationBar: _isLoading
            ? const SizedBox.shrink()
            : Padding(
                padding: const EdgeInsets.all(32),
                child: CustomButton(text: AppLocaleKey.confirm.tr(), onPressed: () => _onConfirmLocation(context)),
              ),
      ),
    );
  }
}
