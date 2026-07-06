import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/subscription.dart';

class SubscriptionService {
  Future<void> processPendingNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final pending = prefs.getStringList('pending') ?? [];

    for (final raw in pending) {
      final data = <String, String>{};
      for (final part in raw.split('|')) {
        final idx = part.indexOf('=');
        if (idx != -1) {
          data[part.substring(0, idx)] = part.substring(idx + 1);
        }
      }
      await _saveSubscription(data);
    }

    await prefs.remove('pending');
  }

  Future<void> _saveSubscription(Map<String, String> data) async {
    final box = await Hive.openBox<Subscription>('subscriptions');
    final exists = box.values.any((s) => s.packageName == data['package']);
    if (exists) return;

    final sub = Subscription()
      ..id = DateTime.now().millisecondsSinceEpoch.toString()
      ..appName = data['title'] ?? data['package'] ?? 'Unknown'
      ..packageName = data['package'] ?? ''
      ..amount = double.tryParse(
          data['amount']?.replaceAll(RegExp(r'[^\d.]'), '') ?? '0') ?? 0.0
      ..currency = 'USD'
      ..renewalDate = DateTime.now().add(const Duration(days: 30))
      ..detectedAt = DateTime.now();
    box.add(sub);
  }
}