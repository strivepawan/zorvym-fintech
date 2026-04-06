import 'package:hive/hive.dart';

part 'txn_type.g.dart';

@HiveType(typeId: 3)
enum TxnType {
  @HiveField(0)
  income,
  @HiveField(1)
  expense,
}
