import 'dart:async';
import 'dart:developer';

import '../controller/request_delegate_controller.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class CustomLocationGoogleMapWidget extends StatefulWidget {
  const CustomLocationGoogleMapWidget({super.key});

  @override
  State<CustomLocationGoogleMapWidget> createState() => _CustomLocationGoogleMapWidgetState();
}

class _CustomLocationGoogleMapWidgetState extends State<CustomLocationGoogleMapWidget> {
  double? currentLat;
  double? currentLng;
  GoogleMapController? gmc;
  Set<Marker> markers = {};
  Timer? _debounce;
  String? _mapStyle;
  RequestDelegateController? requestDelegateController;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _determinePosition() async {
    try {
      Position position = await Geolocator.getCurrentPosition();
      _updateLocation(position.latitude, position.longitude);
    } catch (e) {
      log('Failed to get location: $e');
    }
  }

  void initMapStyle() async {
    var mapStyle = await DefaultAssetBundle.of(context).loadString('assets/map_styles/dark_map_style.json');
    setState(() {
      _mapStyle = mapStyle;
    });
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

    setState(() {});
  }

  @override
  initState() {
    _determinePosition();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      requestDelegateController = Provider.of<RequestDelegateController>(context, listen: false);
      currentLat = double.parse(requestDelegateController!.fromLat.toString());
      currentLng = double.parse(requestDelegateController!.fromLan.toString());
    });
    initMapStyle();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      style: _mapStyle,
      markers: {const Marker(markerId: MarkerId('currentLocation'))},
      mapType: MapType.normal,
      onMapCreated: (GoogleMapController controller) {
        gmc = controller;
      },
      initialCameraPosition: CameraPosition(
        target: LatLng(double.parse(currentLat.toString()), double.parse(currentLng.toString())),
        zoom: 12,
      ),
    );
  }
}
