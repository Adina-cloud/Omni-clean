import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'report_service.dart';

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    await _plugin.initialize(
      const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
    );
  }

  static Future<void> sendWeeklyReport(ReportData report) async {
    final mbText = report.mbSaved.toStringAsFixed(1);
    await _plugin.show(
      0,
      'OMNI-CLEAN: Week in review',
      'Saved ${mbText}MB storage. ${report.subscriptionsDetected} subscriptions guarded.',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'weekly_report',
          'Weekly Report',
          channelDescription: 'Your weekly digital cleanup summary',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
      ),
    );
  }
}