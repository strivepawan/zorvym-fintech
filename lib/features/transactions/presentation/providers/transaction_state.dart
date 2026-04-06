import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/transaction.dart';

part 'transaction_state.freezed.dart';

@freezed
class TransactionState with _$TransactionState {
  const factory TransactionState.initial() = Initial;
  const factory TransactionState.loading() = Loading;
  const factory TransactionState.success(List<Transaction> transactions) = Success;
  const factory TransactionState.error(String message) = Error;
}
