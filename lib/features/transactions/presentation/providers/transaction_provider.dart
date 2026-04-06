import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/constants/hive_boxes.dart';
import '../../data/datasources/transaction_local_datasource.dart';
import '../../data/models/transaction_model.dart';
import '../../data/repositories/transaction_repository_impl.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/repositories/i_transaction_repository.dart';
import '../../domain/usecases/add_transaction.dart';
import 'transaction_state.dart';

part 'transaction_provider.g.dart';

@riverpod
ITransactionRepository transactionRepository(TransactionRepositoryRef ref) {
  final box = Hive.box<TransactionModel>(HiveBoxes.transactions);
  final datasource = TransactionLocalDatasource(box);
  return TransactionRepositoryImpl(datasource);
}

@riverpod
AddTransaction addTransactionUseCase(AddTransactionUseCaseRef ref) {
  return AddTransaction(ref.watch(transactionRepositoryProvider));
}

@riverpod
Stream<List<Transaction>> transactionList(TransactionListRef ref) {
  return ref.watch(transactionRepositoryProvider).watchAll();
}

@riverpod
class TransactionNotifier extends _$TransactionNotifier {
  @override
  TransactionState build() {
    return const TransactionState.initial();
  }

  Future<void> add(TransactionParams params) async {
    state = const TransactionState.loading();
    final result = await ref.read(addTransactionUseCaseProvider).call(params);
    state = result.fold(
      (failure) => TransactionState.error(failure.message),
      (_) => const TransactionState.success([]), // refreshed via stream
    );
  }
}
