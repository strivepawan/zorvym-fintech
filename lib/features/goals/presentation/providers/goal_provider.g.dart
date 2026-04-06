// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$goalRepositoryHash() => r'e45cb9b618117dc2ee4dfe1138a70f31228335bd';

/// See also [goalRepository].
@ProviderFor(goalRepository)
final goalRepositoryProvider = AutoDisposeProvider<IGoalRepository>.internal(
  goalRepository,
  name: r'goalRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$goalRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GoalRepositoryRef = AutoDisposeProviderRef<IGoalRepository>;
String _$addGoalUseCaseHash() => r'8a18c58e0d83ef57ceec60c3a745798333a02e33';

/// See also [addGoalUseCase].
@ProviderFor(addGoalUseCase)
final addGoalUseCaseProvider = AutoDisposeProvider<AddGoal>.internal(
  addGoalUseCase,
  name: r'addGoalUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$addGoalUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AddGoalUseCaseRef = AutoDisposeProviderRef<AddGoal>;
String _$goalListHash() => r'14741c7be178afc23dae40b3280bca0bd570002b';

/// See also [goalList].
@ProviderFor(goalList)
final goalListProvider = AutoDisposeStreamProvider<List<Goal>>.internal(
  goalList,
  name: r'goalListProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$goalListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GoalListRef = AutoDisposeStreamProviderRef<List<Goal>>;
String _$goalNotifierHash() => r'7318ebfd2ab9be0095a83749a2d6aa1fafc99aff';

/// See also [GoalNotifier].
@ProviderFor(GoalNotifier)
final goalNotifierProvider =
    AutoDisposeNotifierProvider<GoalNotifier, AsyncValue<void>>.internal(
  GoalNotifier.new,
  name: r'goalNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$goalNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$GoalNotifier = AutoDisposeNotifier<AsyncValue<void>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
