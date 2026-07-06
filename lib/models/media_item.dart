import 'package:hive/hive.dart';
part 'media_item.g.dart';

@HiveType(typeId: 0)
class MediaItem extends HiveObject {
  @HiveField(0) late String id;
  @HiveField(1) late String path;
  @HiveField(2) late DateTime capturedAt;
  @HiveField(3) DateTime? scheduledDeleteAt;
  @HiveField(4) String? geoZoneId;
  @HiveField(5) late bool inSafeVault;
  @HiveField(6) late String type; // screenshot | duplicate | geoExpired
  @HiveField(7) DateTime? permanentDeleteAt; // 30 days after vault staging
}
