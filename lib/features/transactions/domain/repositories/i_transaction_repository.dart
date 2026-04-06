import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/transaction.dart';

abstract class ITransactionRepository {
  Future<Either<Failure, Unit>> add(Transaction transaction);
  Future<Either<Failure, Unit>> update(Transaction transaction);
  Future<Either<Failure, Unit>> delete(String id);
  Stream<List<Transaction>> watchAll();
}
