import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/models/goal_type.dart';

part 'goal.freezed.dart';

@freezed
class Goal with _$Goal {
  const factory Goal({
    required String id,
    required String title,
    required GoalType type,
    required double targetAmount,
    required double currentAmount,
    required DateTime deadline,
    @Default(0) int streakDays,
    @Default(true) bool isActive,
  }) = _Goal;
}
