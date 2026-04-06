import 'package:dartz/dartz.dart';
import 'package:zorvym/features/auth/data/models/user_settings_model.dart';
import '../../../../core/error/failures.dart';

abstract class ISettingsRepository {
  Future<Either<Failure, UserSettingsModel>> getSettings();
  Future<Either<Failure, Unit>> saveSettings(UserSettingsModel settings);
}
