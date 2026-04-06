import 'package:hive/hive.dart';
import '../models/transaction_model.dart';

class TransactionLocalDatasource {
  final Box<TransactionModel> _box;

  TransactionLocalDatasource(this._box);

  Future<void> save(TransactionModel model) async {
    await _box.put(model.id, model);
  }

  Stream<List<TransactionModel>> watchAll() async* {
    yield _box.values.toList();
    yield* _box.watch().map((_) => _box.values.toList());
  }

  Future<void> delete(String id) async {
    final model = _box.get(id);
    if (model != null) {
      model.isDeleted = true;
      await model.save();
    }
  }
}
