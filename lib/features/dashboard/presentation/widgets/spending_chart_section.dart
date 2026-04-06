import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zorvym/core/theme/app_colors.dart';
import 'package:zorvym/features/transactions/data/models/txn_type.dart';
import 'package:zorvym/features/transactions/domain/entities/transaction.dart';

/// Weekly spending bar chart section with gradient bars and currency axis labels.
class SpendingChartSection extends StatelessWidget {
  final List<Transaction> transactions;

  const SpendingChartSection({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    final expenseData = _getWeeklyExpenseData();
    final incomeData = _getWeeklyIncomeData();
    final maxY = _getMaxY([...expenseData, ...incomeData]);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: context.glassBdColor, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header row ─────────────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Weekly Overview',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: context.textPrimaryColor,
                ),
              ),
              Row(
                children: [
                  _Legend(color: AppColors.primary, label: 'Expense'),
                  const SizedBox(width: 12),
                  _Legend(color: AppColors.income, label: 'Income'),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ── Bar chart ──────────────────────────────────────────────────
          SizedBox(
            height: 180,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxY,
                minY: 0,
                groupsSpace: 12,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    // getTooltipColor: (_) => context.surfaceColor,
                    tooltipRoundedRadius: 10,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final formatter = NumberFormat.compactCurrency(symbol: '₹');
                      return BarTooltipItem(
                        formatter.format(rod.toY),
                        TextStyle(
                          color: context.textPrimaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      getTitlesWidget: (value, meta) {
                        const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            days[value.toInt() % 7],
                            style: TextStyle(
                              color: context.textMutedColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: maxY / 4,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: context.glassBdColor,
                    strokeWidth: 0.5,
                    dashArray: [5, 5],
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(7, (i) {
                  return BarChartGroupData(
                    x: i,
                    groupVertically: false,
                    barRods: [
                      BarChartRodData(
                        toY: expenseData[i],
                        width: 8,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                        gradient: const LinearGradient(
                          colors: [AppColors.primary, AppColors.primaryDark],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      BarChartRodData(
                        toY: incomeData[i],
                        width: 8,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                        gradient: const LinearGradient(
                          colors: [AppColors.income, Color(0xFF00A57A)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<double> _getWeeklyExpenseData() {
    final now = DateTime.now();
    final weekData = List.filled(7, 0.0);
    for (final txn in transactions) {
      if (txn.type == TxnType.expense) {
        final diff = now.difference(txn.date).inDays;
        if (diff >= 0 && diff < 7) {
          final dayIndex = (now.weekday - 1 - diff) % 7;
          weekData[dayIndex >= 0 ? dayIndex : 7 + dayIndex] += txn.amount;
        }
      }
    }
    return weekData;
  }

  List<double> _getWeeklyIncomeData() {
    final now = DateTime.now();
    final weekData = List.filled(7, 0.0);
    for (final txn in transactions) {
      if (txn.type == TxnType.income) {
        final diff = now.difference(txn.date).inDays;
        if (diff >= 0 && diff < 7) {
          final dayIndex = (now.weekday - 1 - diff) % 7;
          weekData[dayIndex >= 0 ? dayIndex : 7 + dayIndex] += txn.amount;
        }
      }
    }
    return weekData;
  }

  double _getMaxY(List<double> data) {
    double max = 0;
    for (final val in data) {
      if (val > max) max = val;
    }
    return max == 0 ? 1000 : max * 1.25;
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String label;

  const _Legend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)),
        ),
        const SizedBox(width: 5),
        Text(label, style: TextStyle(color: context.textMutedColor, fontSize: 11)),
      ],
    );
  }
}
