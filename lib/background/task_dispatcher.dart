import 'package:workmanager/workmanager.dart';
import 'storage_scanner.dart';
import 'geo_zone_manager.dart';
import '../services/safe_vault.dart';
import '../services/report_service.dart';
import '../services/notification_service.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, data) async {
    switch (task) {
      case 'storageScanner':
        await StorageScanner().run();
        break;
      case 'vaultPurge':
        await SafeVault().purgeExpired();
        break;
      case 'geoZoneCheck':
        await GeoZoneManager().checkAndTag(data);
        break;
      case 'weeklyReport':
        final report = await ReportService().generateReport();
        await NotificationService.sendWeeklyReport(report);
        break;
    }
    return Future.value(true);
  });
}
