import 'package:hive/hive.dart';
import 'package:zorvym/features/transactions/domain/entities/transaction.dart';
import 'txn_type.dart';

part 'transaction_model.g.dart';

@HiveType(typeId: 0)
class TransactionModel extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late double amount;

  @HiveField(2)
  late TxnType type;

  @HiveField(3)
  late String category;

  @HiveField(4)
  late DateTime date;

  @HiveField(5)
  String? notes;

  @HiveField(6)
  late DateTime createdAt;

  @HiveField(7)
  bool isDeleted = false;

  Transaction toEntity() => Transaction(
        id: id,
        amount: amount,
        type: type,
        category: category,
        date: date,
        notes: notes,
        createdAt: createdAt,
      );

  static TransactionModel fromEntity(Transaction e) => TransactionModel()
    ..id = e.id
    ..amount = e.amount
    ..type = e.type
    ..category = e.category
    ..date = e.date
    ..notes = e.notes
    ..createdAt = e.createdAt
    ..isDeleted = false;
}
