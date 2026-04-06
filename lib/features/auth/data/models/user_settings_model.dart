import 'package:hive/hive.dart';

part 'user_settings_model.g.dart';

@HiveType(typeId: 2)
class UserSettingsModel extends HiveObject {
  @HiveField(0)
  String currency = 'INR';

  @HiveField(1)
  double? monthlyBudget;

  @HiveField(2)
  bool isDarkMode = false;

  @HiveField(3)
  bool isPinEnabled = false;

  @HiveField(4)
  String? pinHash;

  @HiveField(5)
  bool onboardingDone = false;

  @HiveField(6)
  bool notificationsEnabled = true;

  @HiveField(7)
  String defaultCategory = 'General';
}
