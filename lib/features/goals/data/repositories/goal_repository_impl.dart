import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';
import '../../../../core/error/failures.dart';
import '../mappers/goal_mapper.dart';
import '../models/goal_model.dart';
import '../../domain/entities/goal.dart';
import '../../domain/repositories/i_goal_repository.dart';

class GoalRepositoryImpl implements IGoalRepository {
  final Box<GoalModel> _box;

  GoalRepositoryImpl(this._box);

  @override
  Future<Either<Failure, List<Goal>>> getAll() async {
    try {
      final goals = _box.values.map(GoalMapper.toEntity).toList();
      return right(goals);
    } catch (e) {
      return left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Stream<List<Goal>> watchAll() async* {
    yield _box.values.map(GoalMapper.toEntity).toList();
    yield* _box.watch().map((_) => _box.values.map(GoalMapper.toEntity).toList());
  }

  @override
  Future<Either<Failure, Unit>> add(Goal goal) async {
    try {
      await _box.put(goal.id, GoalMapper.fromEntity(goal));
      return right(unit);
    } catch (e) {
      return left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> update(Goal goal) async {
    try {
      await _box.put(goal.id, GoalMapper.fromEntity(goal));
      return right(unit);
    } catch (e) {
      return left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> delete(String id) async {
    try {
      await _box.delete(id);
      return right(unit);
    } catch (e) {
      return left(DatabaseFailure(e.toString()));
    }
  }
}
