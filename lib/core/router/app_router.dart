import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/transactions/presentation/pages/transactions_page.dart';
import '../../features/transactions/presentation/pages/add_transaction_page.dart';
import '../../features/goals/presentation/pages/goals_page.dart';
import '../../features/goals/presentation/pages/create_goal_page.dart';
import '../../features/insights/presentation/pages/insights_page.dart';
import '../../features/auth/presentation/pages/onboarding_page.dart';
import '../../features/auth/presentation/pages/lock_screen.dart';
import '../../features/auth/presentation/providers/settings_provider.dart';
import '../../shared/layout/app_scaffold.dart';
import '../../shared/widgets/placeholder_page.dart';
import 'route_names.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final settings = ref.watch(settingsNotifierProvider).value;

  return GoRouter(
    initialLocation: (settings == null || !settings.onboardingDone) 
        ? RouteNames.onboarding 
        : (settings.isPinEnabled ? RouteNames.lockScreen : RouteNames.dashboard),
    routes: [
      ShellRoute(
        builder: (context, state, child) => AppScaffold(child: child),
        routes: [
          GoRoute(
            path: RouteNames.dashboard,
            builder: (context, state) => const DashboardPage(),
          ),
          GoRoute(
            path: RouteNames.transactions,
            builder: (context, state) => const TransactionsPage(),
          ),
          GoRoute(
            path: RouteNames.goals,
            builder: (context, state) => const GoalsPage(),
          ),
          GoRoute(
            path: RouteNames.insights,
            builder: (context, state) => const InsightsPage(),
          ),
        ],
      ),
      GoRoute(
        path: '/add-transaction',
        builder: (context, state) => const AddTransactionPage(),
      ),
      GoRoute(
        path: '/create-goal',
        builder: (context, state) => const CreateGoalPage(),
      ),
      GoRoute(
        path: RouteNames.onboarding,
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: RouteNames.lockScreen,
        builder: (context, state) => const LockScreen(),
      ),
    ],
  );
});
