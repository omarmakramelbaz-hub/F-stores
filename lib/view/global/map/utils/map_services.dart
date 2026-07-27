import 'dart:math';

import '../../../../helpers/utils/location_service.dart';
import '../model/location_info/lat_lng.dart';
import '../model/location_info/location.dart';
import '../model/location_info/location_info.dart';
import '../model/place_autocomplete_model/place_autocomplete_model.dart';
import '../model/place_details_model/place_details_model.dart';
import '../model/routes_model/routes_model.dart';
import 'google_maps_place_service.dart';
import 'routes_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapServices {
  PlacesService placesService = PlacesService();
  LocationService locationService = LocationService();
  RoutesService routesService = RoutesService();
  LatLng? currentLocation;
  Future<void> getPredictions({
    required String input,
    required String sesstionToken,
    required List<PlaceModel> places,
  }) async {
    if (input.isNotEmpty) {
      var result = await placesService.getPredictions(sesstionToken: sesstionToken, input: input);

      places.clear();
      places.addAll(result);
    } else {
      places.clear();
    }
  }

  Future<List<LatLng>> getRouteData({required LatLng originFrom, required LatLng desintation}) async {
    LocationInfoModel origin = LocationInfoModel(
      location: LocationModel(
        latLng: LatLngModel(latitude: originFrom.latitude, longitude: originFrom.longitude),
      ),
    );
    LocationInfoModel destination = LocationInfoModel(
      location: LocationModel(
        latLng: LatLngModel(latitude: desintation.latitude, longitude: desintation.longitude),
      ),
    );

    RoutesModel routes = await routesService.fetchRoutes(origin: origin, destination: destination);
    PolylinePoints polylinePoints = PolylinePoints();
    List<LatLng> points = await getDecodedRoute(polylinePoints, routes);
    return points;
  }

  Future<List<LatLng>> getDecodedRoute(PolylinePoints polylinePoints, RoutesModel routes) async {
    List<PointLatLng> result = polylinePoints.decodePolyline(routes.routes!.first.polyline!.encodedPolyline!);

    List<LatLng> points = result.map((e) => LatLng(e.latitude, e.longitude)).toList();
    return points;
  }

  void displayRoute(
    List<LatLng> points, {
    required Set<Polyline> polyLines,
    required GoogleMapController googleMapController,
  }) {
    Polyline route = Polyline(color: Colors.orange, width: 5, polylineId: const PolylineId('route'), points: points);

    polyLines.add(route);

    LatLngBounds bounds = getLatLngBounds(points);
    googleMapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 32));
  }

  LatLngBounds getLatLngBounds(List<LatLng> points) {
    var southWestLatitude = points.first.latitude;
    var southWestLongitude = points.first.longitude;
    var northEastLatitude = points.first.latitude;
    var northEastLongitude = points.first.longitude;

    for (var point in points) {
      southWestLatitude = min(southWestLatitude, point.latitude);
      southWestLongitude = min(southWestLongitude, point.longitude);
      northEastLatitude = max(northEastLatitude, point.latitude);
      northEastLongitude = max(northEastLongitude, point.longitude);
    }

    return LatLngBounds(
      southwest: LatLng(southWestLatitude, southWestLongitude),
      northeast: LatLng(northEastLatitude, northEastLongitude),
    );
  }

  void updateCurrentLocation({
    required GoogleMapController googleMapController,
    required Set<Marker> markers,
    required Function onUpdatecurrentLocation,
  }) {
    locationService.getLocationData((locationData) {
      currentLocation = LatLng(locationData.latitude!, locationData.longitude!);

      Marker currentLocationMarker = Marker(markerId: const MarkerId('my location'), position: currentLocation!);
      CameraPosition myCurrentCameraPoistion = CameraPosition(target: currentLocation!, zoom: 17);
      googleMapController.animateCamera(CameraUpdate.newCameraPosition(myCurrentCameraPoistion));
      markers.add(currentLocationMarker);
      onUpdatecurrentLocation();
    });
  }

  Future<PlaceDetailsModel> getPlaceDetails({required String placeId}) async {
    return await placesService.getPlaceDetails(placeId: placeId);
  }
}
