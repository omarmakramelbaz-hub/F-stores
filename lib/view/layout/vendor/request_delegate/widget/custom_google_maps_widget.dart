import '../../../../../helpers/utils/location_service.dart';
import '../controller/request_delegate_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class CustomGoogleMapsWidget extends StatefulWidget {
  const CustomGoogleMapsWidget({super.key, required this.addressLat, required this.addressLan, this.showCircle});
  final double addressLat;
  final double addressLan;
  final bool? showCircle;

  @override
  State<CustomGoogleMapsWidget> createState() => _CustomGoogleMapsWidgetState();
}

class _CustomGoogleMapsWidgetState extends State<CustomGoogleMapsWidget> {
  String? _mapStyle;
  CameraPosition? initialCameraPosition;
  GoogleMapController? googleMapController;
  // Set<Polyline> polylines = {};
  // Set<Polygon> polygones = {};
  Set<Marker> markers = {};
  Set<Circle> circles = {};

  late Location location;
  late LocationService locationService;
  bool isFirstCall = true;
  @override
  void initState() {
    initialCameraPosition = CameraPosition(target: LatLng(widget.addressLat, widget.addressLan), zoom: 14);

    locationService = LocationService();

    // updateMyLocation();

    initMapStyle();
    initialDelegatesOnMap();

    // initPolyLines();
    //initPolygons();
    initCircles();
    setMyLocationMarker();
    super.initState();
  }

  @override
  void dispose() {
    googleMapController!.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          circles: circles,
          // polygons: polygones,
          // polylines: polylines,
          // false to hide the zoom controls
          zoomControlsEnabled: false,
          style: _mapStyle,
          markers: markers,

          onMapCreated: (controller) {
            googleMapController = controller;
            markers.add(
              Marker(markerId: const MarkerId('my_location'), position: LatLng(widget.addressLat, widget.addressLan)),
            );
            setState(() {});
          },
          initialCameraPosition:
              initialCameraPosition ?? CameraPosition(target: LatLng(widget.addressLat, widget.addressLan), zoom: 14),
        ),
      ],
    );
  }

  void initMapStyle() async {
    var mapStyle = await DefaultAssetBundle.of(context).loadString('assets/map_styles/dark_map_style.json');
    setState(() {
      _mapStyle = mapStyle;
    });
  }

  // void updateMyLocation() async {
  // var customMarkerIcon = await BitmapDescriptor.asset(
  //     const ImageConfiguration(), "assets/images/markerIcon.png",
  //     height: 50);
  //   await locationService.checkAndRequestLocationService();
  //   var hasPermission =
  //       await locationService.checkAndRequestLocationPermission();
  //   if (hasPermission) {
  //     locationService.getLocationData((locationData) {
  //       setMyLocationMarker(customMarkerIcon, locationData);
  //       setMyCameraPosition(locationData);
  //     });
  //   } else {}
  // }
  // void setMyCameraPosition(LocationData locationData) {
  //   var cameraPosition = CameraPosition(
  //     target: LatLng(locationData.latitude!, locationData.longitude!),
  //     zoom: 15.0,
  //   );
  //   var latLong = LatLng(locationData.latitude!, locationData.longitude!);
  //   if (isFirstCall) {
  //     if (mounted) {
  //       googleMapController
  //           ?.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  //     }
  //     isFirstCall = false;
  //   } else {
  //     if (mounted) {
  //       googleMapController?.animateCamera(CameraUpdate.newLatLng(latLong));
  //     }
  //   }
  // }

  void setMyLocationMarker() async {
    var customMarkerIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(),
      'assets/images/markerIcon.png',
      height: 50,
    );
    var myLocationMarker = Marker(
      icon: customMarkerIcon,
      markerId: const MarkerId('my_location'),
      position: LatLng(widget.addressLat, widget.addressLan),
    );
    markers.add(myLocationMarker);
    if (mounted) {
      setState(() {});
    }
  }

  void initCircles() {
    if (widget.showCircle == true) {
      circles.add(
        Circle(
          circleId: const CircleId('currentLocation'),
          center: LatLng(widget.addressLat, widget.addressLan),
          radius: 1000,
          fillColor: Colors.orange.withOpacity(0.5),
          strokeColor: Colors.orange,
          strokeWidth: 1,
        ),
      );
    }
  }

  void initialDelegatesOnMap() async {
    final requestDelegateController = Provider.of<RequestDelegateController>(context, listen: false);
    final acceptedDelegates = requestDelegateController.acceptedDelegate?.delegates;
    var customMarkerIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(),
      'assets/images/motorcycleImage.png',
      height: 50,
    );
    if (acceptedDelegates != null) {
      for (var delegate in acceptedDelegates) {
        final delegateMarker = Marker(
          markerId: MarkerId(delegate.id.toString()),
          position: LatLng(
            double.tryParse(delegate.lat.toString()) ?? 0.0,
            double.tryParse(delegate.lng.toString()) ?? 0.0,
          ),
          icon: customMarkerIcon,
          infoWindow: InfoWindow(title: delegate.name, snippet: delegate.name),
        );
        markers.add(delegateMarker);
      }
      if (mounted) {
        setState(() {});
      }
    }
  }
}

// Zoom Level
// world view 0 -> 3
// country view 4-> 6
// city view 10-> 12
// street view 13 -> 17
// building view 18 -> 20
