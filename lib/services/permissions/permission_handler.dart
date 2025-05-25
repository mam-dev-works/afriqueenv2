import 'package:permission_handler/permission_handler.dart';

class AppPermission {
  static Future<bool> requestCameraPermission() async {
    PermissionStatus status = await Permission.camera.request();
    return status.isGranted;
  }

  static Future<bool> requestLocationPermission() async {
    PermissionStatus status = await Permission.location.request();
    return status.isGranted;
  }

  static Future<bool> requestStoragePermission() async {
    PermissionStatus status = await Permission.storage.request();
    return status.isGranted;
  }

  static Future<bool> requestPhotosPermission() async {
    PermissionStatus status = await Permission.photos.request();
    return status.isGranted;
  }

  static Future<bool> requestPhonePermission() async {
    PermissionStatus status = await Permission.phone.request();
    return status.isGranted;
  }

  static Future<void> openAppSettingsIfDenied(Permission permission) async {
    if (await permission.status.isPermanentlyDenied) {
      await openAppSettings();
    }
  }
}
