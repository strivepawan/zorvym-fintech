import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/models/txn_type.dart';

part 'transaction.freezed.dart';

@freezed
class Transaction with _$Transaction {
  const factory Transaction({
    required String id,
    required double amount,
    required TxnType type,
    required String category,
    required DateTime date,
    String? notes,
    required DateTime createdAt,
  }) = _Transaction;
}
