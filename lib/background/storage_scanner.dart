import 'package:photo_manager/photo_manager.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/media_item.dart';

class StorageScanner {
  Future<void> run() async {
    final permitted = await PhotoManager.requestPermissionExtend();
    if (!permitted.isAuth) return;

    final albums = await PhotoManager.getAssetPathList(type: RequestType.image);
    if (albums.isEmpty) return;

    final assets = await albums[0].getAssetListRange(start: 0, end: 300);
    final box = await Hive.openBox<MediaItem>('media_items');

    for (final asset in assets) {
      // Skip if already tracked
      if (box.values.any((m) => m.id == asset.id)) continue;

      if (_isScreenshot(asset)) {
        final item = MediaItem()
          ..id = asset.id
          ..path = (await asset.file)?.path ?? ''
          ..capturedAt = asset.createDateTime
          ..type = 'screenshot'
          ..inSafeVault = false
          ..scheduledDeleteAt = DateTime.now().add(const Duration(hours: 48));
        box.add(item);
      }
    }
  }

  bool _isScreenshot(AssetEntity e) {
    final title = e.title?.toLowerCase() ?? '';
    final path = e.relativePath?.toLowerCase() ?? '';
    return title.contains('screenshot') || path.contains('screenshot');
  }
}
