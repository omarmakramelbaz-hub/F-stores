import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import '../routes/app_routers_import.dart';

class PermissionService {
  static Future<PermissionStatus> requestPermission(Permission permission) async => await permission.request();
  static Future<bool> checkAndRequestLocationPermission(BuildContext context) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('خدمة الموقع مغلقة'),
            content: const Text('من فضلك فعّل خدمة الموقع (GPS) علشان تقدر تستخدم الخريطة.'),
            actions: [TextButton(onPressed: () => NamedNavigatorImpl.pop(context), child: const Text('تم'))],
          ),
        );
      }
      return false;
    }
    var status = await Permission.location.status;

    if (status.isGranted) {
      return true;
    }

    if (status.isDenied) {
      var result = await Permission.location.request();
      if (result.isGranted) {
        return true;
      }
    }

    if (status.isPermanentlyDenied) {
      await openAppSettings();
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('إذن الموقع مرفوض'),
            content: const Text('لازم تفتح إعدادات التطبيق وتسمح بإذن الموقع علشان تستخدم الخريطة.'),
            actions: [TextButton(onPressed: () => NamedNavigatorImpl.pop(context), child: const Text('تم'))],
          ),
        );
      }
      return false;
    }

    return false;
  }

  static Future<Map<Permission, PermissionStatus>> requestPermissions(List<Permission> permissions) async =>
      await permissions.request();

  static Future<bool> isPermissionGranted(Permission permission) async => await permission.status.isGranted;

  static Future<PermissionStatus> requestNotification() async => await Permission.notification.request();
  static Future<PermissionStatus> requestLocation() async => await Permission.location.request();
  static Future<PermissionStatus> requestCamera() async => await Permission.camera.request();

  static Future<PermissionStatus> requestCalendarWriteOnly() async => await Permission.calendarWriteOnly.request();
  static Future<PermissionStatus> requestCalendarFullAccess() async => await Permission.calendarFullAccess.request();
  static Future<PermissionStatus> requestContacts() async => await Permission.contacts.request();
  static Future<PermissionStatus> requestMediaLibrary() async => await Permission.mediaLibrary.request();
  static Future<PermissionStatus> requestMicrophone() async => await Permission.microphone.request();
  static Future<PermissionStatus> requestPhotos() async => await Permission.photos.request();
  static Future<PermissionStatus> requestPhotosAddOnly() async => await Permission.photosAddOnly.request();
  static Future<PermissionStatus> requestReminders() async => await Permission.reminders.request();
  static Future<PermissionStatus> requestSensors() async => await Permission.sensors.request();
  static Future<PermissionStatus> requestSms() async => await Permission.sms.request();
  static Future<PermissionStatus> requestSpeech() async => await Permission.speech.request();
  static Future<PermissionStatus> requestStorage() async => await Permission.storage.request();
  static Future<PermissionStatus> requestIgnoreBatteryOptimizations() async =>
      await Permission.ignoreBatteryOptimizations.request();
  static Future<PermissionStatus> requestAccessMediaLocation() async => await Permission.accessMediaLocation.request();
  static Future<PermissionStatus> requestActivityRecognition() async => await Permission.activityRecognition.request();
  static Future<PermissionStatus> requestUnknown() async => await Permission.unknown.request();
  static Future<PermissionStatus> requestManageExternalStorage() async =>
      await Permission.manageExternalStorage.request();
  static Future<PermissionStatus> requestSystemAlertWindow() async => await Permission.systemAlertWindow.request();
  static Future<PermissionStatus> requestRequestInstallPackages() async =>
      await Permission.requestInstallPackages.request();
  static Future<PermissionStatus> requestAppTrackingTransparency() async =>
      await Permission.appTrackingTransparency.request();
  static Future<PermissionStatus> requestCriticalAlerts() async => await Permission.criticalAlerts.request();
  static Future<PermissionStatus> requestAccessNotificationPolicy() async =>
      await Permission.accessNotificationPolicy.request();
  static Future<PermissionStatus> requestBluetoothScan() async => await Permission.bluetoothScan.request();
  static Future<PermissionStatus> requestBluetoothAdvertise() async => await Permission.bluetoothAdvertise.request();
  static Future<PermissionStatus> requestBluetoothConnect() async => await Permission.bluetoothConnect.request();
  static Future<PermissionStatus> requestNearbyWifiDevices() async => await Permission.nearbyWifiDevices.request();
  static Future<PermissionStatus> requestVideos() async => await Permission.videos.request();
  static Future<PermissionStatus> requestAudio() async => await Permission.audio.request();
  static Future<PermissionStatus> requestScheduleExactAlarm() async => await Permission.scheduleExactAlarm.request();
  static Future<PermissionStatus> requestSensorsAlways() async => await Permission.sensorsAlways.request();
  static Future<PermissionStatus> requestAssistant() async => await Permission.assistant.request();
  static Future<PermissionStatus> requestBackgroundRefresh() async => await Permission.backgroundRefresh.request();
}
