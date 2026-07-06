import 'package:hive_flutter/hive_flutter.dart';
import 'dart:io';
import '../models/media_item.dart';
import '../models/subscription.dart';

class ReportData {
  final int filesTagged;
  final double mbSaved;
  final int subscriptionsDetected;
  final double estimatedMoneySaved;
  final List<String> subNames;
  ReportData({ required this.filesTagged, required this.mbSaved,
    required this.subscriptionsDetected, required this.estimatedMoneySaved,
    required this.subNames });
}

class ReportService {
  Future<ReportData> generateReport() async {
    final mediaBox = await Hive.openBox<MediaItem>('media_items');
    final subBox   = await Hive.openBox<Subscription>('subscriptions');

    int filesTagged = mediaBox.values.where((m) => m.inSafeVault).length;
    double totalBytes = 0;
for (final item in mediaBox.values.where((m) => m.inSafeVault)) {
      final file = File(item.path);
      if (await file.exists()) totalBytes += await file.length();
    }

    final subs = subBox.values.toList();
    final moneySaved = subs.fold<double>(0, (sum, s) => sum + s.amount);

    return ReportData(
      filesTagged: filesTagged,
      mbSaved: totalBytes / 1024 / 1024,
      subscriptionsDetected: subs.length,
      estimatedMoneySaved: moneySaved,
      subNames: subs.map((s) => s.appName).toList(),
    );
  }
}
