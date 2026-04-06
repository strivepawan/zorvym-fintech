import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app.dart';
import 'core/constants/hive_boxes.dart';
import 'features/transactions/data/models/transaction_model.dart';
import 'features/transactions/data/models/txn_type.dart';
import 'features/goals/data/models/goal_model.dart';
import 'features/goals/data/models/goal_type.dart';
import 'features/auth/data/models/user_settings_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  
  // Register Hive adapters
  Hive.registerAdapter(TransactionModelAdapter());
  Hive.registerAdapter(TxnTypeAdapter());
  Hive.registerAdapter(GoalModelAdapter());
  Hive.registerAdapter(GoalTypeAdapter());
  Hive.registerAdapter(UserSettingsModelAdapter());
  
  // Open Hive boxes
  await Future.wait([
    Hive.openBox<TransactionModel>(HiveBoxes.transactions),
    Hive.openBox<GoalModel>(HiveBoxes.goals),
    Hive.openBox<UserSettingsModel>(HiveBoxes.userSettings),
  ]);

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}
