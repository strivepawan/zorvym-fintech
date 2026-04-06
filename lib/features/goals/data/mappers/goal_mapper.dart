import 'package:zorvym/features/goals/data/models/goal_model.dart';
import '../../domain/entities/goal.dart';

class GoalMapper {
  static Goal toEntity(GoalModel model) {
    return Goal(
      id: model.id,
      title: model.title,
      targetAmount: model.targetAmount,
      currentAmount: model.currentAmount,
      type: model.type,
      deadline: model.deadline,
      streakDays: model.streakDays,
      isActive: model.isActive,
    );
  }

  static GoalModel fromEntity(Goal e) {
    return GoalModel()
      ..id = e.id
      ..title = e.title
      ..targetAmount = e.targetAmount
      ..currentAmount = e.currentAmount
      ..type = e.type
      ..deadline = e.deadline
      ..streakDays = e.streakDays
      ..isActive = e.isActive;
  }
}
