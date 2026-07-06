import 'package:hive/hive.dart';
part 'geo_zone.g.dart';

@HiveType(typeId: 1)
class GeoZone extends HiveObject {
@HiveField(0) late String id;
  @HiveField(1) late String name;      // e.g. "Office"
  @HiveField(2) late double lat;
  @HiveField(3) late double lng;
  @HiveField(4) late double radiusMeters;
  @HiveField(5) late int expiryDays;   // default 7
  @HiveField(6) late bool isActive;
}