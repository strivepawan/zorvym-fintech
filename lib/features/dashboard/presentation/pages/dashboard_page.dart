import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zorvym/core/theme/app_colors.dart';
import 'package:zorvym/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:zorvym/features/transactions/presentation/providers/transaction_provider.dart';
import 'package:zorvym/core/theme/theme_provider.dart';
import '../widgets/balance_card.dart';
import '../widgets/recent_transactions_list.dart';
import '../widgets/spending_chart_section.dart';

/// Main dashboard screen with a custom header, balance card, spending chart,
/// and recent transactions list.
class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(financialSummaryProvider);
    final transactionsAsync = ref.watch(transactionListProvider);

    return Scaffold(
      backgroundColor: context.bgColor,
      extendBodyBehindAppBar: true,
      body: summaryAsync.when(
        data: (summary) => CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ── Custom SliverAppBar header ───────────────────────────────
            SliverToBoxAdapter(
              child: _DashboardHeader(
                onAddTap: () => context.push('/add-transaction'),
                ref: ref,
              ),
            ),

            // ── Balance card ─────────────────────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              sliver: SliverToBoxAdapter(child: BalanceCard(summary: summary)),
            ),

            // ── Charts & Transactions ─────────────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
              sliver: SliverToBoxAdapter(
                child: transactionsAsync.when(
                  data: (txns) => Column(
                    children: [
                      SpendingChartSection(transactions: txns),
                      const SizedBox(height: 28),
                      RecentTransactionsList(
                        transactions: txns,
                        onSeeAll: () => context.go('/transactions'),
                      ),
                    ],
                  ),
                  loading: () => const SizedBox.shrink(),
                  error: (e, s) => Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text('Error loading data: $e',
                        style: const TextStyle(color: AppColors.expense)),
                  ),
                ),
              ),
            ),
          ],
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (err, stack) => Center(
          child: Text('Error: $err', style: const TextStyle(color: AppColors.expense)),
        ),
      ),
      floatingActionButton: _GradientFab(
        onTap: () => context.push('/add-transaction'),
      ),
    );
  }
}

// ─── Header ──────────────────────────────────────────────────────────────────

class _DashboardHeader extends StatelessWidget {
  final VoidCallback onAddTap;
  final WidgetRef ref;

  const _DashboardHeader({required this.onAddTap, required this.ref});

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          20, MediaQuery.of(context).padding.top + 16, 20, 20),
      // To transition smoothly we can just use the scaffold background here as it fades
      color: context.bgColor,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _greeting() + ' 👋',
                  style: TextStyle(
                    fontSize: 14,
                    color: context.textSecondaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Zorvym Finance',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: context.textPrimaryColor,
                  ),
                ),
              ],
            ),
          ),
          // Notification bell
          _GlassIconButton(
            icon: Icons.notifications_outlined,
            onTap: () {},
          ),
          const SizedBox(width: 12),
          // Theme toggler
          _GlassIconButton(
            icon: ref.watch(themeModeProvider) == ThemeMode.dark
                ? Icons.light_mode_rounded
                : Icons.dark_mode_rounded,
            onTap: () => ref.read(themeModeProvider.notifier).toggleTheme(),
          ),
        ],
      ),
    );
  }
}

class _GlassIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _GlassIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: context.glassColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: context.glassBdColor),
            ),
            child: Icon(icon, color: context.textSecondaryColor, size: 22),
          ),
        ),
      ),
    );
  }
}

// ─── Gradient FAB ─────────────────────────────────────────────────────────────

class _GradientFab extends StatelessWidget {
  final VoidCallback onTap;

  const _GradientFab({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
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
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 30),
      ),
    );
  }
}
