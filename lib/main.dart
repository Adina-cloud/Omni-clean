import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:workmanager/workmanager.dart';
import 'background/task_dispatcher.dart';
import 'models/media_item.dart';
import 'models/geo_zone.dart';
import 'models/subscription.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Register Hive adapters
  Hive.registerAdapter(MediaItemAdapter());
  Hive.registerAdapter(GeoZoneAdapter());
  Hive.registerAdapter(SubscriptionAdapter());

  await Workmanager().initialize(callbackDispatcher, isInDebugMode: false);

  // Runs every 6 hours — scans for screenshots and duplicates
  await Workmanager().registerPeriodicTask(
    "storageScanner", "storageScanner",
    frequency: const Duration(hours: 6),
    constraints: Constraints(
      requiresBatteryNotLow: true,
      requiresCharging: false,
      networkType: NetworkType.notRequired,
    ),
  );

  // Runs every 24 hours — purges expired vault items
  await Workmanager().registerPeriodicTask(
    "vaultPurge", "vaultPurge",
    frequency: const Duration(hours: 24),
  );

  // Runs once a week — sends the summary notification
  await Workmanager().registerPeriodicTask(
    "weeklyReport", "weeklyReport",
    frequency: const Duration(days: 7),
    initialDelay: const Duration(days: 7),
  );

  runApp(const OmniCleanApp());
}

class OmniCleanApp extends StatelessWidget {
  const OmniCleanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OMNI-CLEAN',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF7C6FFF)),
      ),
      home: const Scaffold(
        body: Center(
          child: Text('OMNI-CLEAN is running.'),
        ),
      ),
    );
  }
}