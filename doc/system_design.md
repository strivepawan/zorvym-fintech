# Personal Finance Companion — System Design
### Flutter + Riverpod Architecture

---

## Table of Contents

1. [Project Overview](#1-project-overview)
2. [Architecture Pattern](#2-architecture-pattern)
3. [Folder Structure](#3-folder-structure)
4. [State Management — Riverpod](#4-state-management--riverpod)
5. [Feature Modules](#5-feature-modules)
6. [Data Layer Design](#6-data-layer-design)
7. [Domain Layer Design](#7-domain-layer-design)
8. [Presentation Layer Design](#8-presentation-layer-design)
9. [Navigation Design](#9-navigation-design)
10. [Local Database Schema](#10-local-database-schema)
11. [Dependency Injection](#11-dependency-injection)
12. [Error Handling Strategy](#12-error-handling-strategy)
13. [Package Dependencies](#13-package-dependencies)
14. [Key Design Decisions](#14-key-design-decisions)

---

## 1. Project Overview

The Personal Finance Companion is a mobile-first Flutter application that helps users understand their daily money habits. It is a lightweight finance companion — not a banking app — that enables:

- Transaction tracking (income and expense entries)
- Visual spending analysis and insights
- Goal and challenge management
- Streak-based saving habit system
- Smart spending alerts

**Platform targets:** Android, iOS (cross-platform via Flutter)  
**State management:** Riverpod (flutter_riverpod + riverpod_annotation)  
**Local storage:** Hive (offline-first, no network required)  
**Architecture:** Clean Architecture with feature-first folder organisation

---

## 2. Architecture Pattern

The project follows **Clean Architecture** with three strict layers. Each feature owns its own vertical slice of all three layers. Dependencies flow in one direction only — inward.

```
┌─────────────────────────────────────────────┐
│           PRESENTATION LAYER                │
│   Riverpod Providers · Widgets · Pages      │
├─────────────────────────────────────────────┤
│              DOMAIN LAYER                   │
│   Entities · Use Cases · Repository Contracts│
├─────────────────────────────────────────────┤
│               DATA LAYER                    │
│   Hive Models · Datasources · Repo Impls    │
├─────────────────────────────────────────────┤
│           STORAGE / DEVICE                  │
│           Hive Local Database               │
└─────────────────────────────────────────────┘
```

**Dependency rule:** Presentation → Domain ← Data. The domain layer has zero dependencies on Flutter or Hive. It is pure Dart.

---

## 3. Folder Structure

```
finance_app/
├── lib/
│   ├── main.dart                          # App entry — bootstraps DI + Hive + ProviderScope
│   ├── app.dart                           # MaterialApp.router + GoRouter + theme
│   │
│   ├── core/                              # Zero-feature shared utilities
│   │   ├── di/
│   │   │   └── providers.dart             # Global GetIt / Riverpod override registration
│   │   ├── router/
│   │   │   ├── app_router.dart            # GoRouter config with routes
│   │   │   ├── route_names.dart           # Named route constants
│   │   │   └── auth_guard.dart            # Redirect guard for biometric lock
│   │   ├── theme/
│   │   │   ├── app_theme.dart
│   │   │   ├── app_colors.dart
│   │   │   └── app_text_styles.dart
│   │   ├── constants/
│   │   │   ├── app_constants.dart
│   │   │   └── hive_boxes.dart            # Typed Hive box name constants
│   │   ├── utils/
│   │   │   ├── currency_formatter.dart
│   │   │   ├── date_formatter.dart
│   │   │   ├── validators.dart
│   │   │   └── extensions.dart
│   │   ├── error/
│   │   │   ├── failures.dart              # Typed Failure sealed classes
│   │   │   └── exceptions.dart
│   │   └── usecases/
│   │       ├── usecase.dart               # Abstract UseCase<T, Params> base
│   │       └── no_params.dart
│   │
│   ├── shared/                            # Reusable UI components
│   │   ├── widgets/
│   │   │   ├── app_button.dart
│   │   │   ├── app_text_field.dart
│   │   │   ├── app_card.dart
│   │   │   ├── amount_display.dart
│   │   │   ├── category_icon.dart
│   │   │   ├── empty_state_widget.dart
│   │   │   ├── error_widget.dart
│   │   │   ├── loading_overlay.dart
│   │   │   ├── shimmer_loader.dart
│   │   │   └── confirmation_dialog.dart
│   │   ├── charts/
│   │   │   ├── bar_chart_widget.dart
│   │   │   ├── pie_chart_widget.dart
│   │   │   └── line_chart_widget.dart
│   │   └── layout/
│   │       ├── app_scaffold.dart
│   │       └── responsive_builder.dart
│   │
│   └── features/
│       ├── dashboard/
│       │   ├── data/
│       │   │   ├── datasources/
│       │   │   │   └── dashboard_local_datasource.dart
│       │   │   ├── models/
│       │   │   │   ├── summary_model.dart
│       │   │   │   └── chart_data_model.dart
│       │   │   └── repositories/
│       │   │       └── dashboard_repository_impl.dart
│       │   ├── domain/
│       │   │   ├── entities/
│       │   │   │   └── financial_summary.dart
│       │   │   ├── repositories/
│       │   │   │   └── dashboard_repository.dart
│       │   │   └── usecases/
│       │   │       ├── get_financial_summary.dart
│       │   │       └── get_spending_chart_data.dart
│       │   └── presentation/
│       │       ├── providers/
│       │       │   ├── dashboard_provider.dart        # Riverpod providers
│       │       │   └── dashboard_state.dart
│       │       ├── pages/
│       │       │   └── dashboard_page.dart
│       │       └── widgets/
│       │           ├── balance_card.dart
│       │           ├── income_expense_row.dart
│       │           ├── spending_chart_section.dart
│       │           └── recent_transactions_list.dart
│       │
│       ├── transactions/
│       │   ├── data/ ...
│       │   ├── domain/ ...
│       │   └── presentation/
│       │       ├── providers/
│       │       │   ├── transaction_provider.dart
│       │       │   ├── transaction_state.dart
│       │       │   └── transaction_filter_provider.dart
│       │       ├── pages/
│       │       │   ├── transactions_page.dart
│       │       │   └── add_edit_transaction_page.dart
│       │       └── widgets/ ...
│       │
│       ├── goals/
│       │   ├── data/ ...
│       │   ├── domain/ ...
│       │   └── presentation/
│       │       ├── providers/
│       │       │   ├── goal_provider.dart
│       │       │   └── goal_state.dart
│       │       ├── pages/
│       │       │   ├── goals_page.dart
│       │       │   └── create_goal_page.dart
│       │       └── widgets/ ...
│       │
│       ├── insights/
│       │   ├── data/ ...
│       │   ├── domain/ ...
│       │   └── presentation/
│       │       ├── providers/
│       │       │   ├── insights_provider.dart
│       │       │   └── insights_state.dart
│       │       ├── pages/
│       │       │   └── insights_page.dart
│       │       └── widgets/ ...
│       │
│       └── auth/
│           ├── data/ ...
│           ├── domain/ ...
│           └── presentation/
│               ├── providers/
│               │   ├── auth_provider.dart
│               │   └── auth_state.dart
│               ├── pages/
│               │   ├── lock_screen_page.dart
│               │   └── onboarding_page.dart
│               └── widgets/
│                   └── biometric_prompt.dart
│
├── test/
│   ├── unit/
│   │   ├── features/
│   │   │   ├── transactions/
│   │   │   │   ├── add_transaction_test.dart
│   │   │   │   └── transaction_repository_test.dart
│   │   │   ├── goals/
│   │   │   │   └── goal_provider_test.dart
│   │   │   └── insights/
│   │   │       └── get_category_breakdown_test.dart
│   │   └── core/
│   │       ├── validators_test.dart
│   │       └── currency_formatter_test.dart
│   ├── widget/
│   │   └── shared/
│   │       ├── app_button_test.dart
│   │       └── transaction_list_tile_test.dart
│   ├── integration/
│   │   └── add_and_view_transaction_test.dart
│   └── helpers/
│       ├── mock_transaction_repository.dart
│       └── test_fixtures.dart
│
├── assets/
│   ├── images/
│   ├── icons/
│   └── fonts/
│
├── pubspec.yaml
├── analysis_options.yaml
└── README.md
```

---

## 4. State Management — Riverpod

### Why Riverpod over BLoC

| Concern | BLoC | Riverpod |
|---|---|---|
| Boilerplate | High (event + state + bloc files) | Low (single provider file) |
| Testability | Good | Excellent (ProviderContainer in tests) |
| Async handling | Manual stream/sink | Built-in AsyncValue |
| Dependency overriding | Manual mocking | Native `overrideWithValue` |
| Code generation | Optional | `riverpod_generator` (recommended) |
| Family params | Via constructor | `provider.family` |

### Provider Types Used

```dart
// 1. StateNotifierProvider — mutable state with methods
final transactionProvider = StateNotifierProvider<TransactionNotifier, TransactionState>(
  (ref) => TransactionNotifier(ref.watch(addTransactionUseCaseProvider)),
);

// 2. FutureProvider — async one-shot data
final financialSummaryProvider = FutureProvider.autoDispose<FinancialSummary>(
  (ref) => ref.watch(getFinancialSummaryUseCaseProvider).call(NoParams()),
);

// 3. StreamProvider — reactive live data from Hive
final transactionListProvider = StreamProvider.autoDispose<List<Transaction>>(
  (ref) => ref.watch(transactionRepositoryProvider).watchAll(),
);

// 4. Provider — synchronous, derived / computed values
final totalExpenseProvider = Provider<double>((ref) {
  final txns = ref.watch(transactionListProvider).valueOrNull ?? [];
  return txns.where((t) => t.type == TxnType.expense).fold(0.0, (s, t) => s + t.amount);
});

// 5. provider.family — parameterised providers
final transactionByIdProvider = Provider.family<Transaction?, String>((ref, id) {
  final txns = ref.watch(transactionListProvider).valueOrNull ?? [];
  return txns.firstWhereOrNull((t) => t.id == id);
});
```

### State Classes

All state classes use `freezed` for immutability and `copyWith` generation.

```dart
// transactions/presentation/providers/transaction_state.dart

@freezed
class TransactionState with _$TransactionState {
  const factory TransactionState.initial() = _Initial;
  const factory TransactionState.loading() = _Loading;
  const factory TransactionState.success(List<Transaction> transactions) = _Success;
  const factory TransactionState.error(String message) = _Error;
}
```

### StateNotifier Pattern

```dart
// transactions/presentation/providers/transaction_provider.dart

class TransactionNotifier extends StateNotifier<TransactionState> {
  final AddTransaction _addTransaction;
  final DeleteTransaction _deleteTransaction;
  final GetTransactions _getTransactions;

  TransactionNotifier({
    required AddTransaction addTransaction,
    required DeleteTransaction deleteTransaction,
    required GetTransactions getTransactions,
  })  : _addTransaction = addTransaction,
        _deleteTransaction = deleteTransaction,
        _getTransactions = getTransactions,
        super(const TransactionState.initial());

  Future<void> add(TransactionParams params) async {
    state = const TransactionState.loading();
    final result = await _addTransaction(params);
    state = result.fold(
      (failure) => TransactionState.error(failure.message),
      (_) => const TransactionState.success([]),  // list refreshed via StreamProvider
    );
  }

  Future<void> delete(String id) async {
    final result = await _deleteTransaction(DeleteParams(id: id));
    result.fold(
      (failure) => state = TransactionState.error(failure.message),
      (_) {},
    );
  }
}
```

### AsyncValue Usage in UI

```dart
// Consuming a StreamProvider in a widget
class TransactionListWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final txnsAsync = ref.watch(transactionListProvider);

    return txnsAsync.when(
      loading: () => const ShimmerLoader(),
      error: (e, _) => AppErrorWidget(message: e.toString()),
      data: (transactions) => transactions.isEmpty
          ? const EmptyStateWidget(message: 'No transactions yet')
          : ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (_, i) => TransactionListTile(txn: transactions[i]),
            ),
    );
  }
}
```

### Filter Provider Pattern

```dart
// Reactive filter — changing filter auto-refreshes the list
final transactionFilterProvider = StateProvider<TransactionFilter>(
  (ref) => const TransactionFilter.all(),
);

final filteredTransactionsProvider = Provider<List<Transaction>>((ref) {
  final allTxns = ref.watch(transactionListProvider).valueOrNull ?? [];
  final filter = ref.watch(transactionFilterProvider);
  return filter.apply(allTxns);
});
```

---

## 5. Feature Modules

### Dashboard

**Responsibility:** Aggregate and display the user's financial overview.

| Provider | Type | Purpose |
|---|---|---|
| `financialSummaryProvider` | `FutureProvider` | Balance, total income, total expense |
| `spendingChartDataProvider` | `FutureProvider` | Weekly bar chart data |
| `recentTransactionsProvider` | `Provider` | Last 5 transactions derived from stream |

### Transactions

**Responsibility:** Full CRUD management of income/expense entries.

| Provider | Type | Purpose |
|---|---|---|
| `transactionListProvider` | `StreamProvider` | Live list from Hive |
| `transactionProvider` | `StateNotifierProvider` | Add, edit, delete actions |
| `transactionFilterProvider` | `StateProvider` | Current filter selection |
| `filteredTransactionsProvider` | `Provider` | Derived filtered list |
| `transactionByIdProvider` | `Provider.family` | Single transaction by ID |

**Transaction model fields:**

```dart
@freezed
class Transaction with _$Transaction {
  const factory Transaction({
    required String id,
    required double amount,
    required TxnType type,           // income | expense
    required String category,
    required DateTime date,
    String? notes,
    required DateTime createdAt,
  }) = _Transaction;
}

enum TxnType { income, expense }
```

### Goals

**Responsibility:** Monthly savings goals, budget limits, and streak tracking.

| Provider | Type | Purpose |
|---|---|---|
| `activeGoalsProvider` | `StreamProvider` | Live list of active goals |
| `goalProvider` | `StateNotifierProvider` | Create, update, complete actions |
| `goalProgressProvider` | `Provider.family` | Progress percentage per goal ID |
| `streakProvider` | `Provider` | Current consecutive saving days |

**Goal types supported:**

```dart
enum GoalType {
  monthlySavings,     // Save $X by end of month
  budgetLimit,        // Don't exceed $X in a category
  noSpendChallenge,   // Zero expense days streak
  weeklyTarget,       // Save $X per week
}
```

### Insights

**Responsibility:** Spending patterns, category breakdowns, weekly comparisons.

| Provider | Type | Purpose |
|---|---|---|
| `categoryBreakdownProvider` | `FutureProvider` | Pie chart by category |
| `weeklyTrendProvider` | `FutureProvider` | This week vs last week |
| `topSpendingProvider` | `Provider` | Highest spend category |
| `monthlyTrendProvider` | `FutureProvider` | 6-month bar chart data |

### Auth

**Responsibility:** Biometric lock, PIN protection, onboarding flow.

| Provider | Type | Purpose |
|---|---|---|
| `authStateProvider` | `StateNotifierProvider` | Authenticated / locked state |
| `settingsProvider` | `StateNotifierProvider` | User preferences (currency, dark mode) |
| `isPinEnabledProvider` | `Provider` | Derived from settings |

---

## 6. Data Layer Design

### Hive Models

All models use `@HiveType` and `@HiveField` annotations. Code is generated via `build_runner`.

```dart
// transactions/data/models/transaction_model.dart

@HiveType(typeId: 0)
class TransactionModel extends HiveObject {
  @HiveField(0) late String id;
  @HiveField(1) late double amount;
  @HiveField(2) late int type;           // 0 = income, 1 = expense
  @HiveField(3) late String category;
  @HiveField(4) late DateTime date;
  @HiveField(5) String? notes;
  @HiveField(6) late DateTime createdAt;
  @HiveField(7) late bool isDeleted;     // soft delete

  // Maps to domain entity
  Transaction toEntity() => Transaction(
    id: id, amount: amount,
    type: type == 0 ? TxnType.income : TxnType.expense,
    category: category, date: date,
    notes: notes, createdAt: createdAt,
  );

  static TransactionModel fromEntity(Transaction e) => TransactionModel()
    ..id = e.id ..amount = e.amount
    ..type = e.type == TxnType.income ? 0 : 1
    ..category = e.category ..date = e.date
    ..notes = e.notes ..createdAt = e.createdAt
    ..isDeleted = false;
}
```

### Hive Type IDs

| Model | typeId |
|---|---|
| `TransactionModel` | 0 |
| `GoalModel` | 1 |
| `UserSettingsModel` | 2 |
| `TxnTypeAdapter` (enum) | 3 |
| `GoalTypeAdapter` (enum) | 4 |

### Repository Implementation Pattern

```dart
// transactions/data/repositories/transaction_repository_impl.dart

class TransactionRepositoryImpl implements ITransactionRepository {
  final TransactionLocalDatasource _local;

  TransactionRepositoryImpl(this._local);

  @override
  Future<Either<Failure, Unit>> add(Transaction transaction) async {
    try {
      await _local.save(TransactionModel.fromEntity(transaction));
      return right(unit);
    } on HiveError catch (e) {
      return left(CacheFailure(e.message));
    }
  }

  @override
  Stream<List<Transaction>> watchAll() {
    return _local.watchAll().map(
      (models) => models
          .where((m) => !m.isDeleted)
          .map((m) => m.toEntity())
          .toList(),
    );
  }
}
```

### Local Datasource Pattern

```dart
// transactions/data/datasources/transaction_local_datasource.dart

class TransactionLocalDatasource {
  final Box<TransactionModel> _box;

  TransactionLocalDatasource(this._box);

  Future<void> save(TransactionModel model) async {
    await _box.put(model.id, model);
  }

  Stream<List<TransactionModel>> watchAll() {
    return _box.watch().map((_) => _box.values.toList()).startWith(_box.values.toList());
  }

  Future<void> delete(String id) async {
    await _box.get(id)?.delete();
  }
}
```

---

## 7. Domain Layer Design

The domain layer contains pure Dart code with zero platform dependencies.

### Use Case Base Class

```dart
// core/usecases/usecase.dart

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams extends Equatable {
  @override List<Object?> get props => [];
}
```

### Use Cases Per Feature

**Transactions:**

```dart
class AddTransaction extends UseCase<Unit, TransactionParams> {
  final ITransactionRepository _repository;
  AddTransaction(this._repository);

  @override
  Future<Either<Failure, Unit>> call(TransactionParams params) async {
    if (params.amount <= 0) return left(const ValidationFailure('Amount must be > 0'));
    final transaction = Transaction(
      id: const Uuid().v4(), amount: params.amount,
      type: params.type, category: params.category,
      date: params.date, notes: params.notes,
      createdAt: DateTime.now(),
    );
    return _repository.add(transaction);
  }
}

class GetTransactions extends UseCase<List<Transaction>, FilterParams> { ... }
class UpdateTransaction extends UseCase<Unit, UpdateTransactionParams> { ... }
class DeleteTransaction extends UseCase<Unit, DeleteParams> { ... }
class FilterTransactions extends UseCase<List<Transaction>, FilterParams> { ... }
```

**Goals:**

```dart
class CreateGoal extends UseCase<Unit, CreateGoalParams> { ... }
class UpdateGoalProgress extends UseCase<Unit, UpdateGoalParams> { ... }
class GetActiveGoals extends UseCase<List<Goal>, NoParams> { ... }
```

**Insights:**

```dart
class GetCategoryBreakdown extends UseCase<List<CategoryInsight>, DateRangeParams> { ... }
class GetWeeklyTrend extends UseCase<WeeklyTrend, NoParams> { ... }
class GetTopSpending extends UseCase<CategoryInsight, NoParams> { ... }
```

### Repository Contracts

```dart
// transactions/domain/repositories/i_transaction_repository.dart

abstract class ITransactionRepository {
  Future<Either<Failure, Unit>> add(Transaction transaction);
  Future<Either<Failure, Unit>> update(Transaction transaction);
  Future<Either<Failure, Unit>> delete(String id);
  Stream<List<Transaction>> watchAll();
  Future<Either<Failure, List<Transaction>>> getFiltered(FilterParams params);
}
```

---

## 8. Presentation Layer Design

### Provider Registration (per feature)

```dart
// transactions/presentation/providers/transaction_provider.dart

// Repository provider
final transactionRepositoryProvider = Provider<ITransactionRepository>((ref) {
  final box = Hive.box<TransactionModel>(HiveBoxes.transactions);
  final datasource = TransactionLocalDatasource(box);
  return TransactionRepositoryImpl(datasource);
});

// Use case providers
final addTransactionUseCaseProvider = Provider<AddTransaction>(
  (ref) => AddTransaction(ref.watch(transactionRepositoryProvider)),
);

final getTransactionsUseCaseProvider = Provider<GetTransactions>(
  (ref) => GetTransactions(ref.watch(transactionRepositoryProvider)),
);

// Live stream provider
final transactionListProvider = StreamProvider.autoDispose<List<Transaction>>((ref) {
  return ref.watch(transactionRepositoryProvider).watchAll();
});

// Notifier provider for mutations
final transactionNotifierProvider =
    StateNotifierProvider<TransactionNotifier, TransactionState>((ref) {
  return TransactionNotifier(
    addTransaction: ref.watch(addTransactionUseCaseProvider),
    deleteTransaction: ref.watch(deleteTransactionUseCaseProvider),
    getTransactions: ref.watch(getTransactionsUseCaseProvider),
  );
});
```

### Page Pattern

```dart
// transactions/presentation/pages/add_edit_transaction_page.dart

class AddEditTransactionPage extends ConsumerStatefulWidget {
  final Transaction? existingTransaction;    // null = add mode
  const AddEditTransactionPage({this.existingTransaction});

  @override
  ConsumerState<AddEditTransactionPage> createState() => _AddEditTransactionPageState();
}

class _AddEditTransactionPageState extends ConsumerState<AddEditTransactionPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _amountController;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
      text: widget.existingTransaction?.amount.toString() ?? '',
    );
  }

  Future<void> _onSave() async {
    if (!_formKey.currentState!.validate()) return;
    final notifier = ref.read(transactionNotifierProvider.notifier);
    await notifier.add(TransactionParams( /* ... */ ));

    ref.read(transactionNotifierProvider).whenOrNull(
      error: (msg) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg))),
      success: (_) => context.pop(),
    );
  }

  @override
  Widget build(BuildContext context) { /* form UI */ }
}
```

---

## 9. Navigation Design

GoRouter is used for type-safe declarative routing with an `AuthGuard` redirect.

```dart
// core/router/app_router.dart

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: RouteNames.dashboard,
    redirect: (context, state) {
      final isLocked = authState is AuthStateLocked;
      final onLockScreen = state.location == RouteNames.lockScreen;
      if (isLocked && !onLockScreen) return RouteNames.lockScreen;
      if (!isLocked && onLockScreen) return RouteNames.dashboard;
      return null;
    },
    routes: [
      ShellRoute(
        builder: (_, __, child) => AppScaffold(child: child),
        routes: [
          GoRoute(path: RouteNames.dashboard,     builder: (_, __) => const DashboardPage()),
          GoRoute(path: RouteNames.transactions,  builder: (_, __) => const TransactionsPage()),
          GoRoute(path: RouteNames.goals,         builder: (_, __) => const GoalsPage()),
          GoRoute(path: RouteNames.insights,      builder: (_, __) => const InsightsPage()),
        ],
      ),
      GoRoute(path: RouteNames.addTransaction,    builder: (_, s) => AddEditTransactionPage()),
      GoRoute(path: RouteNames.editTransaction,   builder: (_, s) => AddEditTransactionPage(
        existingTransaction: s.extra as Transaction,
      )),
      GoRoute(path: RouteNames.createGoal,        builder: (_, __) => const CreateGoalPage()),
      GoRoute(path: RouteNames.lockScreen,        builder: (_, __) => const LockScreenPage()),
      GoRoute(path: RouteNames.onboarding,        builder: (_, __) => const OnboardingPage()),
    ],
  );
});
```

### Route Names

```dart
// core/router/route_names.dart

abstract class RouteNames {
  static const dashboard      = '/';
  static const transactions   = '/transactions';
  static const addTransaction = '/transactions/add';
  static const editTransaction= '/transactions/edit';
  static const goals          = '/goals';
  static const createGoal     = '/goals/create';
  static const insights       = '/insights';
  static const lockScreen     = '/lock';
  static const onboarding     = '/onboarding';
}
```

---

## 10. Local Database Schema

All data is stored on-device using Hive. No network connection is required.

### Hive Boxes

| Box name | Model | Key |
|---|---|---|
| `transactions_box` | `TransactionModel` | `transaction.id` (UUID) |
| `goals_box` | `GoalModel` | `goal.id` (UUID) |
| `settings_box` | `UserSettingsModel` | `"user_settings"` (singleton) |

### TransactionModel

| Field | Type | Notes |
|---|---|---|
| `id` | `String` | UUID v4, primary key |
| `amount` | `double` | Always positive |
| `type` | `int` | 0 = income, 1 = expense |
| `category` | `String` | e.g. "Food", "Transport" |
| `date` | `DateTime` | User-selected transaction date |
| `notes` | `String?` | Optional description |
| `createdAt` | `DateTime` | Auto-set on creation |
| `isDeleted` | `bool` | Soft delete flag |

### GoalModel

| Field | Type | Notes |
|---|---|---|
| `id` | `String` | UUID v4 |
| `title` | `String` | Goal name |
| `type` | `int` | GoalType enum index |
| `targetAmount` | `double` | Target value |
| `currentAmount` | `double` | Current progress |
| `deadline` | `DateTime` | Goal end date |
| `streakDays` | `int` | Consecutive days met |
| `isActive` | `bool` | Active / completed |

### UserSettingsModel

| Field | Type | Notes |
|---|---|---|
| `currency` | `String` | e.g. "INR", "USD" |
| `monthlyBudget` | `double` | Overall monthly limit |
| `isDarkMode` | `bool` | Theme preference |
| `isPinEnabled` | `bool` | Biometric/PIN lock toggle |
| `pinHash` | `String?` | Hashed PIN value |
| `onboardingDone` | `bool` | Onboarding shown flag |
| `notifEnabled` | `bool` | Notification permission |
| `defaultCategory` | `String` | Pre-selected category |

### Derived Data (Never Stored)

The following are computed at query time by use cases and are never persisted:

- `FinancialSummary` — totalIncome, totalExpense, currentBalance
- `CategoryInsight` — category name, total spend, percentage of total
- `WeeklyTrend` — thisWeekTotal, lastWeekTotal, percentageChange
- `ChartDataPoint` — date + amount pairs for FL Chart

---

## 11. Dependency Injection

Riverpod itself acts as the DI container. Providers declare their dependencies by reading other providers via `ref.watch` or `ref.read`. No external DI package is required.

```dart
// Providers form a dependency graph resolved at runtime

datasourceProvider
  └── repositoryProvider (reads datasource)
       └── useCaseProvider (reads repository)
            └── notifierProvider (reads use case)
                 └── widget (watches notifier)
```

### Hive Box Providers

```dart
// core/di/providers.dart

final transactionBoxProvider = Provider<Box<TransactionModel>>((ref) {
  return Hive.box<TransactionModel>(HiveBoxes.transactions);
});

final goalBoxProvider = Provider<Box<GoalModel>>((ref) {
  return Hive.box<GoalModel>(HiveBoxes.goals);
});

final settingsBoxProvider = Provider<Box<UserSettingsModel>>((ref) {
  return Hive.box<UserSettingsModel>(HiveBoxes.settings);
});
```

### Hive Initialisation in main.dart

```dart
// main.dart

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(TransactionModelAdapter());
  Hive.registerAdapter(GoalModelAdapter());
  Hive.registerAdapter(UserSettingsModelAdapter());

  await Future.wait([
    Hive.openBox<TransactionModel>(HiveBoxes.transactions),
    Hive.openBox<GoalModel>(HiveBoxes.goals),
    Hive.openBox<UserSettingsModel>(HiveBoxes.settings),
  ]);

  runApp(
    const ProviderScope(         // Riverpod root
      child: MyApp(),
    ),
  );
}
```

### Testing — Provider Override

```dart
// In tests, override any provider with a mock:

testWidgets('shows transactions list', (tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        transactionRepositoryProvider.overrideWithValue(MockTransactionRepository()),
      ],
      child: const MaterialApp(home: TransactionsPage()),
    ),
  );
});
```

---

## 12. Error Handling Strategy

All use cases return `Either<Failure, T>` from the `dartz` package. Failures are typed sealed classes.

### Failure Types

```dart
// core/error/failures.dart

sealed class Failure {
  final String message;
  const Failure(this.message);
}

class CacheFailure extends Failure {
  const CacheFailure([String message = 'Local storage error']) : super(message);
}

class ValidationFailure extends Failure {
  const ValidationFailure(String message) : super(message);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure(String message) : super(message);
}
```

### UI Error States

```dart
// Every notifier maps failures to typed state:

state = result.fold(
  (failure) => switch (failure) {
    ValidationFailure(:final message) => TransactionState.error(message),
    CacheFailure()                    => const TransactionState.error('Storage error. Try again.'),
    _                                 => const TransactionState.error('Something went wrong.'),
  },
  (_) => const TransactionState.success([]),
);
```

### AsyncValue Error Handling

```dart
// FutureProvider / StreamProvider use AsyncValue.when:

insightsAsync.when(
  loading: () => const ShimmerLoader(),
  error: (err, stack) => AppErrorWidget(
    message: 'Could not load insights',
    onRetry: () => ref.invalidate(categoryBreakdownProvider),
  ),
  data: (data) => CategoryPieSection(data: data),
);
```

---

## 13. Package Dependencies

```yaml
# pubspec.yaml

dependencies:
  flutter:
    sdk: flutter

  # State management
  flutter_riverpod: ^2.5.1
  riverpod_annotation: ^2.3.5

  # Navigation
  go_router: ^13.2.0

  # Local storage
  hive: ^2.2.3
  hive_flutter: ^1.1.0

  # Functional error handling
  dartz: ^0.10.1

  # Code generation helpers
  freezed_annotation: ^2.4.1
  json_annotation: ^4.8.1

  # UI and charts
  fl_chart: ^0.67.0

  # Utilities
  uuid: ^4.3.3
  equatable: ^2.0.5
  collection: ^1.18.0
  intl: ^0.19.0

  # Biometric auth
  local_auth: ^2.1.8

dev_dependencies:
  flutter_test:
    sdk: flutter

  # Code generation
  build_runner: ^2.4.9
  riverpod_generator: ^2.3.10
  freezed: ^2.5.2
  hive_generator: ^2.0.1
  json_serializable: ^6.7.1

  # Testing
  mockito: ^5.4.4
  mocktail: ^1.0.3
  fake_async: ^1.3.1

  # Linting
  flutter_lints: ^3.0.1
  custom_lint: ^0.6.4
  riverpod_lint: ^2.3.10
```

---

## 14. Key Design Decisions

### Offline-first

The app has no network dependency. Hive provides fast synchronous reads and reactive `watchBox` streams that emit on every write. The `StreamProvider` in Riverpod wraps these streams so the UI rebuilds automatically when data changes.

### Riverpod over BLoC

Riverpod's `StateNotifier` replaces the BLoC event/state file triad with a single provider file. The `Either<Failure, T>` pattern is preserved from the domain layer, with the notifier translating failures into state variants.

### Soft Delete

Transactions use `isDeleted: bool` rather than hard deletion. This supports potential undo/redo functionality and keeps audit history intact. The repository filters `isDeleted == true` entries from all query results.

### Derived Data vs Stored Aggregates

Financial summaries, category breakdowns, and weekly trends are computed at query time from raw transaction records. This avoids stale cache problems and ensures that editing a past transaction automatically updates all dependent views via Riverpod's reactive graph.

### Freezed for Immutable State

All state classes and domain entities use `freezed` for safe `copyWith`, pattern matching with `when`/`map`, and value equality. This prevents accidental mutation bugs and makes `AsyncValue.when` fully type-safe.

### Code Generation Strategy

Run the following command once after modifying any annotated file:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Files generated automatically:
- `*.g.dart` — Hive adapters, JSON serializers
- `*.freezed.dart` — Immutable classes with copyWith
- `*.g.dart` (Riverpod) — Provider boilerplate via `riverpod_generator`

---

*Document version: 1.0 — Personal Finance Companion Flutter App*
