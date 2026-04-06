import 'package:freezed_annotation/freezed_annotation.dart';

part 'financial_summary.freezed.dart';

@freezed
class FinancialSummary with _$FinancialSummary {
  const factory FinancialSummary({
    required double totalIncome,
    required double totalExpense,
    required double currentBalance,
  }) = _FinancialSummary;
}
