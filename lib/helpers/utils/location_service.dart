import 'package:location/location.dart';

class LocationService {
  Location location = Location();

  //======================================= Location Service =======================================//
  Future<bool> checkAndRequestLocationService() async {
    var isServiceEnabled = await location.serviceEnabled();

    if (!isServiceEnabled) {
      isServiceEnabled = await location.requestService();
      if (!isServiceEnabled) {
        return false;
      }
    }
    return true;
  }

  //======================================= Location Permission =======================================//
  Future<bool> checkAndRequestLocationPermission() async {
    var permissionStatus = await location.hasPermission();
    if (permissionStatus == PermissionStatus.deniedForever) {
      return false;
    }
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await location.requestPermission();
      if (permissionStatus != PermissionStatus.granted) {
        return false;
      }
    }

    return true;
  }

  //======================================= Location Data =======================================//

  void getLocationData(void Function(LocationData)? onData) async {
    location.onLocationChanged.listen(onData);
  }

  //=============================================================
}
