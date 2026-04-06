import 'package:hive/hive.dart';

part 'goal_type.g.dart';

@HiveType(typeId: 4)
enum GoalType {
  @HiveField(0)
  monthlySavings,
  @HiveField(1)
  budgetLimit,
  @HiveField(2)
  noSpendChallenge,
  @HiveField(3)
  weeklyTarget,
}
