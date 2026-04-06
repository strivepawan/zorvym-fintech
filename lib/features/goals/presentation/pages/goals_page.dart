import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:zorvym/core/theme/app_colors.dart';
import 'package:zorvym/features/goals/data/models/goal_type.dart';
import '../../../../shared/widgets/amount_display.dart';
import '../providers/goal_provider.dart';

/// Premium goals tracking page with progress bar cards.
class GoalsPage extends ConsumerWidget {
  const GoalsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalsAsync = ref.watch(goalListProvider);

    return Scaffold(
      backgroundColor: context.bgColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ── Header ──────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Financial Goals',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: context.textPrimaryColor,
                  ),
                ),
              ),
            ),

            // ── Goals List ──────────────────────────────────────────────
            Expanded(
              child: goalsAsync.when(
                data: (goals) {
                  if (goals.isEmpty) {
                    return const _EmptyState();
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
                    physics: const BouncingScrollPhysics(),
                    itemCount: goals.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      return _GoalCard(goal: goals[index]);
                    },
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
                error: (e, s) => Center(
                  child: Text(
                    'Error: $e',
                    style: const TextStyle(color: AppColors.expense),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: GestureDetector(
        onTap: () => context.push('/create-goal'),
        child: Container(
          width: 60,
          height: 60,
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppColors.primaryGradient,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.45),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Icon(
            Icons.add_task_rounded,
            color: Colors.white,
            size: 28,
          ),
        ),
      ),
    );
  }
}

class _GoalCard extends StatelessWidget {
  final dynamic goal;

  const _GoalCard({required this.goal});

  @override
  Widget build(BuildContext context) {
    // Determine colors and icons based on goal type
    Color accentColor;
    IconData icon;
    String typeLabel;

    switch (goal.type as GoalType) {
      case GoalType.monthlySavings:
        accentColor = AppColors.primary;
        icon = Icons.savings_rounded;
        typeLabel = 'Savings';
        break;
      case GoalType.budgetLimit:
        accentColor = AppColors.warning;
        icon = Icons.account_balance_wallet_rounded;
        typeLabel = 'Budget';
        break;
      case GoalType.noSpendChallenge:
        accentColor = AppColors.expense;
        icon = Icons.money_off_rounded;
        typeLabel = 'Challenge';
        break;
      case GoalType.weeklyTarget:
        accentColor = AppColors.primary;
        icon = Icons.track_changes_rounded;
        typeLabel = 'Target';
        break;
    }

    final progress = (goal.currentAmount / goal.targetAmount).clamp(0.0, 1.0);
    final daysLeft = goal.endDate != null
        ? goal.endDate!.difference(DateTime.now()).inDays
        : null;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: context.glassBdColor, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header Row ──────────────────────────────────────────────
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: accentColor, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      goal.title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: context.textPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      typeLabel,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: context.textSecondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              if (daysLeft != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: daysLeft < 7
                        ? AppColors.expense.withOpacity(0.15)
                        : context.surfaceColor,
                    border: Border.all(
                      color: daysLeft < 7
                          ? AppColors.expense.withOpacity(0.3)
                          : context.glassBdColor,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    daysLeft > 0 ? '$daysLeft days left' : 'Ended',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: daysLeft < 7
                          ? AppColors.expense
                          : context.textMutedColor,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 24),

          // ── Progress Amounts ────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Current',
                    style: TextStyle(fontSize: 12, color: context.textMutedColor),
                  ),
                  const SizedBox(height: 2),
                  AmountDisplay(
                    amount: goal.currentAmount,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: accentColor,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Target',
                    style: TextStyle(fontSize: 12, color: context.textMutedColor),
                  ),
                  const SizedBox(height: 2),
                  AmountDisplay(
                    amount: goal.targetAmount,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: context.textPrimaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ── Progress Bar ────────────────────────────────────────────
          Stack(
            children: [
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: context.surfaceColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeOutCubic,
                height: 8,
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: progress,
                  child: Container(
                    decoration: BoxDecoration(
                      color: accentColor,
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        BoxShadow(
                          color: accentColor.withOpacity(0.5),
                          blurRadius: 6,
                          spreadRadius: -2,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withOpacity(0.1),
              border: Border.all(color: AppColors.primary.withOpacity(0.3)),
            ),
            child: const Center(
              child: Icon(
                Icons.flag_rounded,
                size: 48,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Set Your Sights',
            style: TextStyle(
              color: context.textPrimaryColor,
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create savings goals or budget limits\nto stay on top of your finances.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: context.textSecondaryColor,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
