import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';
import '../../../../core/error/failures.dart';
import '../models/user_settings_model.dart';
import '../../domain/repositories/i_settings_repository.dart';

class SettingsRepositoryImpl implements ISettingsRepository {
  final Box<UserSettingsModel> _box;

  SettingsRepositoryImpl(this._box);

  @override
  Future<Either<Failure, UserSettingsModel>> getSettings() async {
    try {
      final settings = _box.get('current_settings') ?? UserSettingsModel();
      return right(settings);
    } catch (e) {
      return left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> saveSettings(UserSettingsModel settings) async {
    try {
      await _box.put('current_settings', settings);
      return right(unit);
    } catch (e) {
      return left(DatabaseFailure(e.toString()));
    }
  }
}
