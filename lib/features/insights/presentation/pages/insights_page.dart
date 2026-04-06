import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:zorvym/core/theme/app_colors.dart';
import 'package:zorvym/features/transactions/data/models/txn_type.dart';
import 'package:zorvym/features/transactions/domain/entities/transaction.dart';
import 'package:zorvym/features/transactions/presentation/providers/transaction_provider.dart';
import '../../../../shared/widgets/amount_display.dart';

/// Premium Insights page connected to real transaction data provider.
class InsightsPage extends ConsumerWidget {
  const InsightsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(transactionListProvider);

    return Scaffold(
      backgroundColor: context.bgColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Financial Insights',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: context.textPrimaryColor,
                  ),
                ),
              ),
            ),
            Expanded(
              child: transactionsAsync.when(
                data: (transactions) {
                  if (transactions.isEmpty) {
                    return _buildEmptyState(context);
                  }
                  return _InsightsContent(transactions: transactions);
                },
                loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
                error: (e, s) => Center(child: Text('Error: $e', style: const TextStyle(color: AppColors.expense))),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.pie_chart_outline_rounded, size: 80, color: context.surfaceColor),
          const SizedBox(height: 24),
          Text(
            'Not enough data',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: context.textPrimaryColor),
          ),
          const SizedBox(height: 8),
          Text(
            'Add some transactions to see\nyour spending insights.',
            textAlign: TextAlign.center,
            style: TextStyle(color: context.textSecondaryColor, height: 1.5),
          ),
        ],
      ),
    );
  }
}

class _InsightsContent extends StatelessWidget {
  final List<Transaction> transactions;

  const _InsightsContent({required this.transactions});

  @override
  Widget build(BuildContext context) {
    // Process data for charts
    final categoryTotals = <String, double>{};
    double totalExpense = 0;
    double totalIncome = 0;

    for (final txn in transactions) {
      if (txn.type == TxnType.expense) {
        totalExpense += txn.amount;
        categoryTotals[txn.category] = (categoryTotals[txn.category] ?? 0) + txn.amount;
      } else {
        totalIncome += txn.amount;
      }
    }

    // Top spending category
    String topCategory = '';
    double topAmount = 0;
    categoryTotals.forEach((key, value) {
      if (value > topAmount) {
        topAmount = value;
        topCategory = key;
      }
    });

    final savingsRate = totalIncome > 0 ? ((totalIncome - totalExpense) / totalIncome * 100).clamp(0.0, 100.0) : 0.0;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Savings Rate Highlight ──────────────────────────────────────────
          _SavingsRateCard(savingsRate: savingsRate, totalSaved: totalIncome - totalExpense),
          const SizedBox(height: 32),

          // ── Categories Chart ─────────────────────────────────────────────
          Text('Spending Breakdown', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: context.textPrimaryColor)),
          const SizedBox(height: 24),
          if (totalExpense > 0)
            _CategoryPieChart(categoryTotals: categoryTotals, totalExpense: totalExpense)
          else
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Center(child: Text('No expenses recorded.', style: TextStyle(color: context.textMutedColor))),
            ),
          const SizedBox(height: 40),

          // ── Highlights ──────────────────────────────────────────────────
          Text('Key Highlights', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: context.textPrimaryColor)),
          const SizedBox(height: 16),
          if (topAmount > 0)
            _InsightCard(
              title: 'Highest Spending',
              value: NumberFormat.currency(symbol: '₹', decimalDigits: 0).format(topAmount),
              description: 'You spent the most on $topCategory out of all your expenses.',
              icon: Icons.local_fire_department_rounded,
              color: AppColors.expense,
            ),
          const SizedBox(height: 12),
          _InsightCard(
            title: 'Cash Flow',
            value: NumberFormat.currency(symbol: '₹', decimalDigits: 0).format(totalIncome),
            description: 'Total income recorded. Aim to keep expenses below this.',
            icon: Icons.account_balance_wallet_rounded,
            color: AppColors.income,
          ),
        ],
      ),
    );
  }
}

class _CategoryPieChart extends StatelessWidget {
  final Map<String, double> categoryTotals;
  final double totalExpense;

  const _CategoryPieChart({required this.categoryTotals, required this.totalExpense});

  static const Map<String, Color> _catColors = {
    'Food': AppColors.catFood, 'Transport': AppColors.catTransport,
    'Shopping': AppColors.catShopping, 'Entertainment': AppColors.catEntertainment,
    'Bills': AppColors.catBills, 'Other': AppColors.catOther,
  };

  @override
  Widget build(BuildContext context) {
    // Sort categories by amount
    final entries = categoryTotals.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    
    return Row(
      children: [
        SizedBox(
          width: 160,
          height: 160,
          child: PieChart(
            PieChartData(
              sectionsSpace: 4,
              centerSpaceRadius: 46,
              sections: entries.map((e) {
                final pct = (e.value / totalExpense * 100);
                final color = _catColors[e.key] ?? AppColors.primary;
                return PieChartSectionData(
                  color: color,
                  value: e.value,
                  title: '${pct.toStringAsFixed(0)}%',
                  radius: pct > 30 ? 30 : 25,
                  titleStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(width: 32),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: entries.take(5).map((e) {
              final color = _catColors[e.key] ?? AppColors.primary;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(e.key, style: TextStyle(color: context.textSecondaryColor, fontSize: 13, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _SavingsRateCard extends StatelessWidget {
  final double savingsRate;
  final double totalSaved;

  const _SavingsRateCard({required this.savingsRate, required this.totalSaved});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: context.glassBdColor, width: 0.5),
        boxShadow: [
          BoxShadow(color: AppColors.primary.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 72,
                height: 72,
                child: CircularProgressIndicator(
                  value: savingsRate / 100,
                  backgroundColor: context.surfaceColor,
                  color: AppColors.primary,
                  strokeWidth: 8,
                  strokeCap: StrokeCap.round,
                ),
              ),
              Text(
                '${savingsRate.toInt()}%',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: context.textPrimaryColor),
              ),
            ],
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Savings Rate', style: TextStyle(color: context.textSecondaryColor, fontSize: 14)),
                const SizedBox(height: 4),
                AmountDisplay(
                  amount: totalSaved > 0 ? totalSaved : 0,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: context.textPrimaryColor),
                ),
                Text(
                  totalSaved >= 0 ? 'Saved overall' : 'Overspent',
                  style: TextStyle(color: totalSaved >= 0 ? AppColors.income : AppColors.expense, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InsightCard extends StatelessWidget {
  final String title;
  final String value;
  final String description;
  final IconData icon;
  final Color color;

  const _InsightCard({
    required this.title,
    required this.value,
    required this.description,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withOpacity(0.15), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: context.textSecondaryColor)),
                const SizedBox(height: 2),
                Text(value, style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text(description, style: TextStyle(color: context.textMutedColor, fontSize: 13, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
