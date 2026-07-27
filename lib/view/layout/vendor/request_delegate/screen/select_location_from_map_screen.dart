import 'dart:async';
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import '../../../../../helpers/locale/app_locale_key.dart';
import '../../../../../helpers/theme/app_colors.dart';
import '../../../../custom_widgets/buttons/custom_button.dart';
import '../../../../custom_widgets/custom_app_bar/custom_app_bar.dart';
import '../../../../custom_widgets/custom_loading/custom_loading.dart';
import '../controller/request_delegate_controller.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class SelectLocationFromMapScreenArgs {
  final bool isFromAddress;

  SelectLocationFromMapScreenArgs({required this.isFromAddress});
}

class SelectLocationFromMapScreen extends StatefulWidget {
  static const routeName = 'SelectLocationFromMapScreen';
  final SelectLocationFromMapScreenArgs? args;
  const SelectLocationFromMapScreen({super.key, this.args});

  @override
  State<SelectLocationFromMapScreen> createState() => _SelectLocationFromMapScreenState();
}

class _SelectLocationFromMapScreenState extends State<SelectLocationFromMapScreen> with WidgetsBindingObserver {
  StreamSubscription<Position>? positionStream;
  List<Placemark>? placemarks;
  double? currentLat;
  double? currentLng;
  GoogleMapController? gmc;
  Set<Marker> markers = {};
  Timer? _debounce;
  String? _mapStyle;

  Future<void> _determinePosition() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        serviceEnabled = await Geolocator.isLocationServiceEnabled();
        setState(() {});
        if (!serviceEnabled) {
          log('Location services are still disabled.');
          return;
        }
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.unableToDetermine ||
          permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          log('Location permissions are denied');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        log('Location permissions are permanently denied, we cannot request permissions.');
        return;
      }

      Position position = await Geolocator.getCurrentPosition();
      _updateLocation(position.latitude, position.longitude);
    } catch (e) {
      log('Failed to get location: $e');
    }
  }

  void _updateLocation(double lat, double lng) async {
    setState(() {
      currentLat = lat;
      currentLng = lng;
      markers.clear();
      markers.add(Marker(markerId: const MarkerId('currentLocation'), position: LatLng(lat, lng)));
    });

    if (gmc != null) {
      gmc!.animateCamera(CameraUpdate.newLatLng(LatLng(lat, lng)));
    }

    placemarks = await placemarkFromCoordinates(lat, lng);
    setState(() {
      log(placemarks![0].locality.toString());
      log(placemarks![0].country.toString());
      log(placemarks![0].subLocality.toString());
      log(placemarks![0].subLocality.toString());
    });
  }

  void _onMapTap(LatLng latLng) {
    final requestDelegateController = Provider.of<RequestDelegateController>(context, listen: false);

    if (widget.args?.isFromAddress == true) {
      requestDelegateController.setFromLat(latLng.latitude.toString());
      requestDelegateController.setFromLatLng(LatLng(latLng.latitude, latLng.longitude));
      requestDelegateController.setFromLan(latLng.longitude.toString());
      log('${requestDelegateController.fromLat} ${requestDelegateController.fromLan}');
    } else {
      requestDelegateController.setToLat(latLng.latitude.toString());
      requestDelegateController.setToLan(latLng.longitude.toString());
      requestDelegateController.setToLatLng(LatLng(latLng.latitude, latLng.longitude));
      log('${requestDelegateController.toLat} ${requestDelegateController.toLan}');
    }
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      _updateLocation(latLng.latitude, latLng.longitude);
    });

    if (gmc != null) {
      gmc!.animateCamera(CameraUpdate.newLatLng(LatLng(latLng.latitude, latLng.longitude)));
    }

    setState(() {
      markers.clear();
      if (widget.args!.isFromAddress) {}
      markers.add(
        Marker(markerId: const MarkerId('currentLocation'), position: LatLng(latLng.latitude, latLng.longitude)),
      );
    });
  }

  @override
  void initState() {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   FocusManager.instance.primaryFocus?.unfocus();
    // });

    initMapStyle();
    _determinePosition();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<RequestDelegateController>(context, listen: false);
    });
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  bool isCheckingLocation = false;
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // When the app comes back from the settings, recheck location status
      _recheckLocationServices();
    }
  }

  Future<void> _recheckLocationServices() async {
    setState(() {
      isCheckingLocation = true; // Show loading state while checking
    });

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (serviceEnabled) {
      await _determinePosition(); // Recheck location if enabled
    } else {
      log('Location services are still disabled.');
    }

    setState(() {
      isCheckingLocation = false; // End loading state after check
    });
  }

  bool isMapInteracting = false;

  // void _onMapInteractionStart() {
  //   setState(() {
  //     isMapInteracting = true;
  //   });
  // }

  // void _onMapInteractionEnd() {
  //   setState(() {
  //     isMapInteracting = false;
  //   });
  // }

  void initMapStyle() async {
    var mapStyle = await DefaultAssetBundle.of(context).loadString('assets/map_styles/dark_map_style.json');
    setState(() {
      _mapStyle = mapStyle;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RequestDelegateController>(
      builder: (context, requestDelegateController, child) {
        return GestureDetector(
          child: Scaffold(
            backgroundColor: AppColor.blackColor(context),
            resizeToAvoidBottomInset: false,
            extendBody: true,
            appBar: CustomAppBar(
              appBarColor: AppColor.blackColor(context),
              radius: 40,
              context,
              title: Text(AppLocaleKey.choseLocationFromMap.tr()),
            ),
            body: currentLat != null && currentLng != null
                ? GoogleMap(
                    style: _mapStyle,
                    zoomControlsEnabled: false,
                    onTap: _onMapTap,
                    markers: {
                      Marker(markerId: const MarkerId('currentLocation'), position: LatLng(currentLat!, currentLng!)),
                    },
                    mapType: MapType.normal,
                    onMapCreated: (GoogleMapController controller) {
                      gmc = controller;

                      gmc!.animateCamera(CameraUpdate.newLatLng(LatLng(currentLat!, currentLng!)));
                    },
                    initialCameraPosition: CameraPosition(target: LatLng(currentLat!, currentLng!), zoom: 12),
                  )
                : const Center(child: CustomLoading()),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(18.0),
              child: CustomButton(
                text: AppLocaleKey.ok.tr(),
                onPressed: () {
                  if (widget.args?.isFromAddress == true) {
                    requestDelegateController.setFromAddress('${placemarks![0].locality!} ${placemarks![0].street!}');
                    requestDelegateController.setFromController(
                      '${placemarks![0].locality!} ${placemarks![0].street!}',
                    );

                    log('${placemarks![0].locality!} ${placemarks![0].street!}');
                  } else {
                    requestDelegateController.setToAddress('${placemarks![0].locality!} ${placemarks![0].street!}');
                    requestDelegateController.setToController('${placemarks![0].locality!} ${placemarks![0].street!}');

                    log('${placemarks![0].locality!} ${placemarks![0].street!}');
                  }
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
