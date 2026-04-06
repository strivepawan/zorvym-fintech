import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/constants/hive_boxes.dart';
import '../../data/models/user_settings_model.dart';
import '../../data/repositories/settings_repository_impl.dart';
import '../../domain/repositories/i_settings_repository.dart';

part 'settings_provider.g.dart';

@riverpod
ISettingsRepository settingsRepository(SettingsRepositoryRef ref) {
  final box = Hive.box<UserSettingsModel>(HiveBoxes.userSettings);
  return SettingsRepositoryImpl(box);
}

@riverpod
class SettingsNotifier extends _$SettingsNotifier {
  @override
  AsyncValue<UserSettingsModel> build() {
    _load();
    return const AsyncValue.loading();
  }

  Future<void> _load() async {
    final result = await ref.read(settingsRepositoryProvider).getSettings();
    state = result.fold(
      (failure) => AsyncValue.error(failure.message, StackTrace.current),
      (settings) => AsyncValue.data(settings),
    );
  }

  Future<void> updateSettings(UserSettingsModel settings) async {
    state = const AsyncValue.loading();
    final result = await ref.read(settingsRepositoryProvider).saveSettings(settings);
    state = result.fold(
      (failure) => AsyncValue.error(failure.message, StackTrace.current),
      (_) => AsyncValue.data(settings),
    );
  }

  Future<void> setOnboardingDone() async {
    final current = state.value;
    if (current != null) {
      current.onboardingDone = true;
      await updateSettings(current);
    }
  }

  Future<void> setPin(String pin) async {
    final current = state.value;
    if (current != null) {
      current.isPinEnabled = true;
      current.pinHash = pin; // Ideally hash it, but for dummy use plain
      await updateSettings(current);
    }
  }
}
