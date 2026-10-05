import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<LocationPermission> getPermissionStatus() {
    return Geolocator.checkPermission();
  }

  Future<LocationPermission> requestPermission() {
    return Geolocator.requestPermission();
  }

  Future<bool> isLocationServiceEnabled() {
    return Geolocator.isLocationServiceEnabled();
  }

  Future<bool> openLocationSettings() {
    return Geolocator.openLocationSettings();
  }

  Future<bool> openAppSettings() {
    return Geolocator.openAppSettings();
  }

  Future<Position> getCurrentPosition() {
    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );
  }

  Future<bool> hasRequiredAccess() async {
    final serviceEnabled = await isLocationServiceEnabled();

    if (!serviceEnabled) {
      return false;
    }

    final permission = await getPermissionStatus();

    return permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
  }
}