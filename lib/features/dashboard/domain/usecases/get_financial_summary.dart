import 'package:dartz/dartz.dart';
import 'package:zorvym/features/transactions/data/models/txn_type.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../transactions/domain/entities/transaction.dart';
import '../entities/financial_summary.dart';

class GetFinancialSummary extends UseCase<FinancialSummary, List<Transaction>> {
  @override
  Future<Either<Failure, FinancialSummary>> call(List<Transaction> transactions) async {
    double totalIncome = 0;
    double totalExpense = 0;

    for (final txn in transactions) {
      if (txn.type == TxnType.income) {
        totalIncome += txn.amount;
      } else {
        totalExpense += txn.amount;
      }
    }

    return right(FinancialSummary(
      totalIncome: totalIncome,
      totalExpense: totalExpense,
      currentBalance: totalIncome - totalExpense,
    ));
  }
}
