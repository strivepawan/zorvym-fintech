import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zorvym/features/dashboard/domain/entities/financial_summary.dart';
import 'package:zorvym/features/dashboard/domain/usecases/get_financial_summary.dart';
import '../../../transactions/presentation/providers/transaction_provider.dart';


part 'dashboard_provider.g.dart';

@riverpod
GetFinancialSummary getFinancialSummaryUseCase(GetFinancialSummaryUseCaseRef ref) {
  return GetFinancialSummary();
}

@riverpod
Future<FinancialSummary> financialSummary(FinancialSummaryRef ref) async {
  final transactions = await ref.watch(transactionListProvider.future);
  final result = await ref.watch(getFinancialSummaryUseCaseProvider).call(transactions);
  return result.fold(
    (failure) => throw failure.message,
    (summary) => summary,
  );
}
