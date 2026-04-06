import 'package:hive/hive.dart';
import 'package:zorvym/features/goals/domain/entities/goal.dart';
import 'goal_type.dart';

part 'goal_model.g.dart';

@HiveType(typeId: 1)
class GoalModel extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String title;

  @HiveField(2)
  late GoalType type;

  @HiveField(3)
  late double targetAmount;

  @HiveField(4)
  late double currentAmount;

  @HiveField(5)
  late DateTime deadline;

  @HiveField(6)
  int streakDays = 0;

  @HiveField(7)
  bool isActive = true;

  Goal toEntity() => Goal(
        id: id,
        title: title,
        type: type,
        targetAmount: targetAmount,
        currentAmount: currentAmount,
        deadline: deadline,
        streakDays: streakDays,
        isActive: isActive,
      );

  static GoalModel fromEntity(Goal e) => GoalModel()
    ..id = e.id
    ..title = e.title
    ..type = e.type
    ..targetAmount = e.targetAmount
    ..currentAmount = e.currentAmount
    ..deadline = e.deadline
    ..streakDays = e.streakDays
    ..isActive = e.isActive;
}
