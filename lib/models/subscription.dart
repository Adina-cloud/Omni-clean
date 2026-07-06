import 'package:hive/hive.dart';
part 'subscription.g.dart';

@HiveType(typeId: 2)
class Subscription extends HiveObject {
  @HiveField(0) late String id;
  @HiveField(1) late String appName;
  @HiveField(2) late String packageName;
  @HiveField(3) late double amount;
  @HiveField(4) late String currency;
  @HiveField(5) late DateTime renewalDate;
  @HiveField(6) late DateTime detectedAt;
}
