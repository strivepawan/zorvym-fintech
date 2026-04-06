import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';
import 'package:zorvym/features/transactions/data/models/txn_type.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/transaction.dart';
import '../repositories/i_transaction_repository.dart';

class AddTransaction extends UseCase<Unit, TransactionParams> {
  final ITransactionRepository _repository;

  AddTransaction(this._repository);

  @override
  Future<Either<Failure, Unit>> call(TransactionParams params) async {
    if (params.amount <= 0) {
      return left(const ValidationFailure('Amount must be greater than zero'));
    }

    final transaction = Transaction(
      id: const Uuid().v4(),
      amount: params.amount,
      type: params.type,
      category: params.category,
      date: params.date,
      notes: params.notes,
      createdAt: DateTime.now(),
    );

    return _repository.add(transaction);
  }
}

class TransactionParams extends Equatable {
  final double amount;
  final TxnType type;
  final String category;
  final DateTime date;
  final String? notes;

  const TransactionParams({
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
    this.notes,
  });

  @override
  List<Object?> get props => [amount, type, category, date, notes];
}
