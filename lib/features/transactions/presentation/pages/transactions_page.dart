import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:zorvym/core/theme/app_colors.dart';
import 'package:zorvym/features/transactions/data/models/txn_type.dart';
import 'package:zorvym/features/transactions/domain/entities/transaction.dart';
import 'package:zorvym/features/transactions/presentation/providers/transaction_provider.dart';
import '../../../../shared/widgets/amount_display.dart';

/// Full screen to view all transactions, grouped by date headers.
class TransactionsPage extends ConsumerWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(transactionListProvider);

    return Scaffold(
      backgroundColor: context.bgColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ── Premium Header ──────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'All Transactions',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: context.textPrimaryColor,
                    ),
                  ),
                  _GlassIcon(
                    icon: Icons.filter_list_rounded,
                    onTap: () {
                      // TODO: Implement filtering bottom sheet
                    },
                  ),
                ],
              ),
            ),

            // ── Transaction List ────────────────────────────────────────
            Expanded(
              child: transactionsAsync.when(
                data: (transactions) {
                  if (transactions.isEmpty) {
                    return const _EmptyState();
                  }

                  // Sort by date desc
                  final sorted = List.from(transactions)
                    ..sort((a, b) => b.date.compareTo(a.date));

                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                    physics: const BouncingScrollPhysics(),
                    itemCount: sorted.length,
                    itemBuilder: (context, index) {
                      final txn = sorted[index];

                      // Should we show a date header?
                      final showHeader = index == 0 ||
                          !_isSameDay(txn.date, sorted[index - 1].date);

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (showHeader) _DateHeader(date: txn.date),
                          _TransactionListTile(txn: txn),
                          if (index < sorted.length - 1 &&
                              _isSameDay(txn.date, sorted[index + 1].date))
                            const Padding(
                              padding: EdgeInsets.only(left: 64),
                              child: Divider(),
                            )
                          else
                            const SizedBox(height: 12),
                        ],
                      );
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
        onTap: () => context.push('/add-transaction'),
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
          child: const Icon(Icons.add_rounded, color: Colors.white, size: 30),
        ),
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

class _DateHeader extends StatelessWidget {
  final DateTime date;

  const _DateHeader({required this.date});

  String _formatDate() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final txnDate = DateTime(date.year, date.month, date.day);

    if (txnDate == today) return 'Today';
    if (txnDate == yesterday) return 'Yesterday';
    return DateFormat('EEEE, MMM d, yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 12),
      child: Text(
        _formatDate(),
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: context.textSecondaryColor,
        ),
      ),
    );
  }
}

class _TransactionListTile extends StatelessWidget {
  final Transaction txn;

  const _TransactionListTile({required this.txn});

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

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.glassBdColor, width: 0.5),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: catColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(child: Text(emoji, style: const TextStyle(fontSize: 22))),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  txn.category,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: context.textPrimaryColor,
                  ),
                ),
                if (txn.notes != null && txn.notes!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    txn.notes!,
                    style: TextStyle(fontSize: 13, color: context.textMutedColor),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              AmountDisplay(
                amount: txn.amount,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: amountColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                DateFormat('h:mm a').format(txn.date),
                style: TextStyle(fontSize: 11, color: context.textMutedColor),
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
              color: context.glassColor,
              border: Border.all(color: context.glassBdColor),
            ),
            child: const Center(
              child: Text('💸', style: TextStyle(fontSize: 48)),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No transactions yet',
            style: TextStyle(
              color: context.textPrimaryColor,
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your financial journey starts here.\nTap + to add your first transaction.',
            textAlign: TextAlign.center,
            style: TextStyle(color: context.textSecondaryColor, fontSize: 14, height: 1.5),
          ),
        ],
      ),
    );
  }
}

class _GlassIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _GlassIcon({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: context.glassColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: context.glassBdColor),
            ),
            child: Icon(icon, color: context.textPrimaryColor, size: 22),
          ),
        ),
      ),
    );
  }
}
