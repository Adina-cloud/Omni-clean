import 'package:hive_flutter/hive_flutter.dart';
import 'dart:io';
import '../models/media_item.dart';

class SafeVault {
  // Stage an item: moves it to vault, sets 30-day permanent delete
  Future<void> stage(MediaItem item) async {
    item.inSafeVault = true;
    item.permanentDeleteAt = DateTime.now().add(const Duration(days: 30));
    await item.save();
  }

  // Restore an item from vault (user-initiated recovery)
  Future<void> restore(MediaItem item) async {
    item.inSafeVault = false;
    item.scheduledDeleteAt = null;
    item.permanentDeleteAt = null;
    item.geoZoneId = null;
    await item.save();
  }

  // Called daily by WorkManager: permanently delete expired items
  Future<void> purgeExpired() async {
    final box = await Hive.openBox<MediaItem>('media_items');
    final now = DateTime.now();

    // Stage items past their cooling period
    for (final item in box.values) {
      if (!item.inSafeVault &&
          item.scheduledDeleteAt != null &&
          now.isAfter(item.scheduledDeleteAt!)) {
        await stage(item);
      }
    }
    // Permanently delete items past 30-day vault window
    final toDelete = box.values.where((item) =>
      item.inSafeVault &&
      item.permanentDeleteAt != null &&
      now.isAfter(item.permanentDeleteAt!),
    ).toList();

    for (final item in toDelete) {
      final file = File(item.path);
      if (await file.exists()) await file.delete();
      await item.delete();
    }
  }

  // Get all items currently in vault (for UI display)
  Future<List<MediaItem>> getVaultContents() async {
    final box = await Hive.openBox<MediaItem>('media_items');
    return box.values.where((m) => m.inSafeVault).toList();
  }
}
