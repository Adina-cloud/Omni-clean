import 'package:geolocator/geolocator.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/geo_zone.dart';
import '../models/media_item.dart';

class GeoZoneManager {
  String? _activeZoneId;

  Future<void> startMonitoring() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.medium,
        distanceFilter: 50,
      ),
    ).listen(_onPositionChanged);
  }

  Future<void> checkAndTag(Map<String, dynamic>? data) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;
    final pos = await Geolocator.getCurrentPosition();
    await _onPositionChanged(pos);
  }

  Future<void> _onPositionChanged(Position pos) async {
    final box = await Hive.openBox<GeoZone>('geo_zones');
    final zones = box.values.where((z) => z.isActive);

    GeoZone? insideZone;
    for (final zone in zones) {
      final dist = Geolocator.distanceBetween(
          pos.latitude, pos.longitude, zone.lat, zone.lng);
      if (dist <= zone.radiusMeters) {
        insideZone = zone;
        break;
      }
    }

    if (insideZone != null && _activeZoneId != insideZone.id) {
      _activeZoneId = insideZone.id;
    } else if (insideZone == null && _activeZoneId != null) {
      await _scheduleZoneDeletion(_activeZoneId!);
      _activeZoneId = null;
    }
  }

  Future<void> _scheduleZoneDeletion(String zoneId) async {
    final box = await Hive.openBox<MediaItem>('media_items');
    for (final item in box.values.where((m) => m.geoZoneId == zoneId)) {
      item.scheduledDeleteAt = DateTime.now().add(const Duration(days: 7));
      item.save();
    }
  }

  String? get activeZoneId => _activeZoneId;
}