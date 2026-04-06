import 'package:dartz/dartz.dart';
import 'package:zorvym/features/transactions/data/models/txn_type.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/repositories/i_transaction_repository.dart';
import '../datasources/transaction_local_datasource.dart';
import '../models/transaction_model.dart';

class TransactionRepositoryImpl implements ITransactionRepository {
  final TransactionLocalDatasource _local;

  TransactionRepositoryImpl(this._local);

  @override
  Future<Either<Failure, Unit>> add(Transaction transaction) async {
    try {
      await _local.save(TransactionModel.fromEntity(transaction));
      return right(unit);
    } catch (e) {
      return left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> delete(String id) async {
    try {
      await _local.delete(id);
      return right(unit);
    } catch (e) {
      return left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> update(Transaction transaction) async {
    try {
      await _local.save(TransactionModel.fromEntity(transaction));
      return right(unit);
    } catch (e) {
      return left(CacheFailure(e.toString()));
    }
  }

  @override
  Stream<List<Transaction>> watchAll() {
    return _local.watchAll().map((models) {
      final transactions = models
          .where((m) => !m.isDeleted)
          .map((m) => m.toEntity())
          .toList();

      if (transactions.isEmpty) {
        return _getDummyTransactions();
      }

      return transactions;
    });
  }

  List<Transaction> _getDummyTransactions() {
    final now = DateTime.now();
    return [
      Transaction(
        id: '1',
        amount: 25000,
        type: TxnType.income,
        category: 'Salary',
        date: now.subtract(const Duration(days: 2)),
        createdAt: now.subtract(const Duration(days: 2)),
        notes: 'Monthly salary',
      ),
      Transaction(
        id: '2',
        amount: 1500,
        type: TxnType.expense,
        category: 'Food',
        date: now.subtract(const Duration(days: 1)),
        createdAt: now.subtract(const Duration(days: 1)),
        notes: 'Dinner with friends',
      ),
      Transaction(
        id: '3',
        amount: 500,
        type: TxnType.expense,
        category: 'Transport',
        date: now,
        createdAt: now,
        notes: 'Taxi to work',
      ),
      Transaction(
        id: '4',
        amount: 1200,
        type: TxnType.expense,
        category: 'Shopping',
        date: now.subtract(const Duration(hours: 5)),
        createdAt: now.subtract(const Duration(hours: 5)),
        notes: 'New shirt',
      ),
      Transaction(
        id: '5',
        amount: 3000,
        type: TxnType.income,
        category: 'Freelance',
        date: now.subtract(const Duration(days: 3)),
        createdAt: now.subtract(const Duration(days: 3)),
        notes: 'Logo design project',
      ),
    ];
  }
}
