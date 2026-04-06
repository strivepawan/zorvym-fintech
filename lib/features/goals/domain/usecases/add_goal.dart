import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/models/goal_type.dart';
import '../entities/goal.dart';
import '../repositories/i_goal_repository.dart';

class AddGoal extends UseCase<Unit, AddGoalParams> {
  final IGoalRepository _repository;

  AddGoal(this._repository);

  @override
  Future<Either<Failure, Unit>> call(AddGoalParams params) async {
    final goal = Goal(
      id: const Uuid().v4(),
      title: params.title,
      targetAmount: params.targetAmount,
      currentAmount: 0,
      type: params.type,
      deadline: params.endDate ?? DateTime.now().add(const Duration(days: 30)),
    );

    return _repository.add(goal);
  }
}

class AddGoalParams extends Equatable {
  final String title;
  final double targetAmount;
  final GoalType type;
  final DateTime? endDate;

  const AddGoalParams({
    required this.title,
    required this.targetAmount,
    required this.type,
    this.endDate,
  });

  @override
  List<Object?> get props => [title, targetAmount, type, endDate];
}
