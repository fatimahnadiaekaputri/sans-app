import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart' as handler;
import 'package:SANS/src/api/location_controller.dart';
import 'package:get/route_manager.dart';

class LocationService {
  LocationService.init();
  static LocationService instance = LocationService.init();

  final _location = Location();
  Future<bool> checkForServiceAvailability() async {
    bool isEnabled = await _location.serviceEnabled();
    if (isEnabled) {
      return Future.value(true);
    }

    isEnabled = await _location.requestService();

    if (isEnabled) {
      return Future.value(true);
    }
    return Future.error('Layanan lokasi tidak tersedia');
  }

  Future<bool> checkForPermission() async {
    PermissionStatus status = await _location.hasPermission();

    if (status == PermissionStatus.denied) {
      status = await _location.requestPermission();

      if (status == PermissionStatus.granted) {
        return true;
      }
      return false;
    }
    if (status == PermissionStatus.deniedForever) {
      Get.snackbar('Izin dibutuhkan',
          'Kami membutuhkan izin untuk mendapatkan lokasi Anda',
          onTap: (snack) async {
        await handler.openAppSettings();
      }).show();
      return false;
    }

    return Future.value(true);
  }

  Future<void> getUserLocation({required LocationController controller}) async {
    controller.updateIsAccessingLocation(true);
    if (!(await checkForServiceAvailability())) {
      controller.errorDescription.value = 'layanan tidak diaktifkan';
      controller.updateIsAccessingLocation(false);
      return;
    }

    if (!(await checkForPermission())) {
      controller.errorDescription.value = 'Izin tidak diberikan';
      controller.updateIsAccessingLocation(false);
      return;
    }

    final LocationData data = await _location.getLocation();
    controller.updateUserLocation(data);
    controller.updateIsAccessingLocation(false);
  }
}
