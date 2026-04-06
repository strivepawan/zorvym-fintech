import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/constants/hive_boxes.dart';
import '../../data/models/goal_model.dart';
import '../../data/repositories/goal_repository_impl.dart';
import '../../domain/entities/goal.dart';
import '../../domain/repositories/i_goal_repository.dart';
import '../../domain/usecases/add_goal.dart';

part 'goal_provider.g.dart';

@riverpod
IGoalRepository goalRepository(GoalRepositoryRef ref) {
  final box = Hive.box<GoalModel>(HiveBoxes.goals);
  return GoalRepositoryImpl(box);
}

@riverpod
AddGoal addGoalUseCase(AddGoalUseCaseRef ref) {
  return AddGoal(ref.watch(goalRepositoryProvider));
}

@riverpod
Stream<List<Goal>> goalList(GoalListRef ref) {
  return ref.watch(goalRepositoryProvider).watchAll();
}

@riverpod
class GoalNotifier extends _$GoalNotifier {
  @override
  AsyncValue<void> build() {
    return const AsyncValue.data(null);
  }

  Future<void> add(AddGoalParams params) async {
    state = const AsyncValue.loading();
    final result = await ref.read(addGoalUseCaseProvider).call(params);
    state = result.fold(
      (failure) => AsyncValue.error(failure.message, StackTrace.current),
      (_) => const AsyncValue.data(null),
    );
  }
}
