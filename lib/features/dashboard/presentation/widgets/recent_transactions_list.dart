import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zorvym/core/theme/app_colors.dart';
import 'package:zorvym/features/transactions/data/models/txn_type.dart';
import 'package:zorvym/features/transactions/domain/entities/transaction.dart';
import '../../../../shared/widgets/amount_display.dart';

/// Shows the 5 most recent transactions with category emoji icons.
///
/// Parameters:
/// - [transactions] — full list of transactions (will be sorted and sliced)
/// - [onSeeAll] — callback for the "See All" button
class RecentTransactionsList extends StatelessWidget {
  final List<Transaction> transactions;
  final VoidCallback? onSeeAll;

  const RecentTransactionsList({
    super.key,
    required this.transactions,
    this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    final recent = List<Transaction>.from(transactions)
      ..sort((a, b) => b.date.compareTo(a.date));
    final displayList = recent.take(5).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Section header ────────────────────────────────────────────────
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Transactions',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: context.textPrimaryColor,
              ),
            ),
            if (onSeeAll != null)
              GestureDetector(
                onTap: onSeeAll,
                child: const Text(
                  'See All',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),

        // ── Transaction tiles ─────────────────────────────────────────────
        if (displayList.isEmpty)
          _EmptyState()
        else
          Container(
            decoration: BoxDecoration(
              color: context.cardColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: context.glassBdColor, width: 0.5),
            ),
            child: Column(
              children: [
                for (int i = 0; i < displayList.length; i++) ...[
                  _TransactionTile(txn: displayList[i]),
                  if (i < displayList.length - 1)
                    const Divider(height: 1, indent: 72),
                ],
              ],
            ),
          ),
      ],
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final Transaction txn;

  const _TransactionTile({required this.txn});

  static const Map<String, String> _categoryEmoji = {
    'Food': '🍔',
    'Transport': '🚗',
    'Shopping': '🛍️',
    'Entertainment': '🎬',
    'Bills': '💡',
    'Salary': '💼',
    'Freelance': '💻',
    'Other': '📌',
  };

  static const Map<String, Color> _categoryColor = {
    'Food': AppColors.catFood,
    'Transport': AppColors.catTransport,
    'Shopping': AppColors.catShopping,
    'Entertainment': AppColors.catEntertainment,
    'Bills': AppColors.catBills,
    'Salary': AppColors.catSalary,
    'Freelance': AppColors.catFreelance,
    'Other': AppColors.catOther,
  };

  @override
  Widget build(BuildContext context) {
    final isIncome = txn.type == TxnType.income;
    final emoji = _categoryEmoji[txn.category] ?? '📌';
    final catColor = _categoryColor[txn.category] ?? AppColors.catOther;
    final amountColor = isIncome ? AppColors.income : AppColors.expense;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Category avatar
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: catColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(child: Text(emoji, style: const TextStyle(fontSize: 20))),
          ),
          const SizedBox(width: 14),

          // Title & date
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  txn.category,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: context.textPrimaryColor,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  DateFormat('MMM dd, yyyy').format(txn.date),
                  style: TextStyle(fontSize: 12, color: context.textMutedColor),
                ),
              ],
            ),
          ),

          // Amount
          AmountDisplay(
            amount: txn.amount,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: amountColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      alignment: Alignment.center,
      child: Column(
        children: [
          const Text('💸', style: TextStyle(fontSize: 40)),
          const SizedBox(height: 12),
          Text(
            'No transactions yet',
            style: TextStyle(
              color: context.textSecondaryColor,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Tap + to add your first transaction',
            style: TextStyle(color: context.textMutedColor, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
