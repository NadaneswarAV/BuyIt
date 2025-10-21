import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  static Future<bool> ensurePermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Try to open location settings and re-check
      await Geolocator.openLocationSettings();
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) {
      // Open app settings so user can enable manually
      await Geolocator.openAppSettings();
      permission = await Geolocator.checkPermission();
    }

    return permission == LocationPermission.always || permission == LocationPermission.whileInUse;
  }

  static Future<String?> getCurrentPlacemarkName() async {
    final ok = await ensurePermission();
    if (!ok) return null;
    final pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.medium);
    final placemarks = await placemarkFromCoordinates(pos.latitude, pos.longitude);
    if (placemarks.isNotEmpty) {
      final p = placemarks.first;
      final parts = [p.locality, p.subLocality, p.administrativeArea]
          .where((e) => e != null && e!.isNotEmpty)
          .map((e) => e!)
          .toList();
      if (parts.isEmpty) return null;
      return parts.take(2).join(', ');
    }
    return null;
  }
}
