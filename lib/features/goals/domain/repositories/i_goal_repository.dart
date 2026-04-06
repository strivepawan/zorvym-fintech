import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/goal.dart';

abstract class IGoalRepository {
  Future<Either<Failure, List<Goal>>> getAll();
  Stream<List<Goal>> watchAll();
  Future<Either<Failure, Unit>> add(Goal goal);
  Future<Either<Failure, Unit>> update(Goal goal);
  Future<Either<Failure, Unit>> delete(String id);
}
