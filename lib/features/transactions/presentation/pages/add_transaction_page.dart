import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zorvym/core/theme/app_colors.dart';
import '../../data/models/txn_type.dart';
import '../../domain/usecases/add_transaction.dart';
import '../providers/transaction_provider.dart';
import '../providers/transaction_state.dart' as txn_state;

/// Premium full-page form to add a new transaction using visual cards
/// for type selection and a neat grid for category selection.
class AddTransactionPage extends ConsumerStatefulWidget {
  const AddTransactionPage({super.key});

  @override
  ConsumerState<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends ConsumerState<AddTransactionPage> {
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  TxnType _type = TxnType.expense;
  String _category = 'Food';
  String? _amountError;

  final List<String> _categories = [
    'Food',
    'Transport',
    'Shopping',
    'Entertainment',
    'Bills',
    'Salary',
    'Freelance',
    'Other'
  ];

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

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _submit() async {
    final amountText = _amountController.text.trim();
    if (amountText.isEmpty) {
      setState(() => _amountError = 'Amount is required');
      return;
    }
    final amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) {
      setState(() => _amountError = 'Enter a valid amount');
      return;
    }
    setState(() => _amountError = null);

    final params = TransactionParams(
      amount: amount,
      type: _type,
      category: _category,
      date: DateTime.now(),
      notes: _notesController.text.isEmpty ? null : _notesController.text,
    );

    await ref.read(transactionNotifierProvider.notifier).add(params);
    
    final state = ref.read(transactionNotifierProvider);
    if (state is txn_state.Success) {
      if (mounted) context.pop();
    } else if (state is txn_state.Error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text((state as txn_state.Error).message),
            backgroundColor: AppColors.expense,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(transactionNotifierProvider);
    final isLoading = state is txn_state.Loading;

    return Scaffold(
      backgroundColor: context.bgColor,
      // Minimal app bar
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => context.pop(),
        ),
        title: const Text('Add Transaction'),
        centerTitle: true,
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Type Selector ───────────────────────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: _TypeCard(
                          title: 'Expense',
                          icon: Icons.arrow_downward_rounded,
                          color: AppColors.expense,
                          isSelected: _type == TxnType.expense,
                          onTap: () => setState(() => _type = TxnType.expense),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _TypeCard(
                          title: 'Income',
                          icon: Icons.arrow_upward_rounded,
                          color: AppColors.income,
                          isSelected: _type == TxnType.income,
                          onTap: () => setState(() => _type = TxnType.income),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // ── Amount Input ────────────────────────────────────────
                  Text(
                    'Amount',
                    style: TextStyle(
                      color: context.textSecondaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _amountController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                      color: _type == TxnType.expense ? AppColors.expense : AppColors.income,
                    ),
                    decoration: InputDecoration(
                      prefixText: '₹ ',
                      prefixStyle: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w800,
                        color: context.textPrimaryColor,
                      ),
                      errorText: _amountError,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: _type == TxnType.expense ? AppColors.expense : AppColors.income,
                          width: 2,
                        ),
                      ),
                      filled: true,
                      fillColor: context.cardColor,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // ── Category Grid ───────────────────────────────────────
                  Text(
                    'Category',
                    style: TextStyle(
                      color: context.textSecondaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: _categories.map((c) {
                      final isSelected = c == _category;
                      return GestureDetector(
                        onTap: () => setState(() => _category = c),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primary.withOpacity(0.15) : context.cardColor,
                            border: Border.all(
                              color: isSelected ? AppColors.primary : context.glassBdColor,
                              width: isSelected ? 1.5 : 1,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(_categoryEmoji[c] ?? '📌', style: const TextStyle(fontSize: 16)),
                              const SizedBox(width: 8),
                              Text(
                                c,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                  color: isSelected ? AppColors.primary : context.textPrimaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 32),

                  // ── Notes Input ─────────────────────────────────────────
                  Text(
                    'Notes (Optional)',
                    style: TextStyle(
                      color: context.textSecondaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _notesController,
                    maxLines: 2,
                    style: TextStyle(color: context.textPrimaryColor, fontSize: 15),
                  ),
                  const SizedBox(height: 60),

                  // ── Save Button ─────────────────────────────────────────
                  GestureDetector(
                    onTap: isLoading ? null : _submit,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.4),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: isLoading
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                            )
                          : const Text(
                              'Save Transaction',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TypeCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _TypeCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.15) : context.cardColor,
          border: Border.all(
            color: isSelected ? color : context.glassBdColor,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: isSelected
              ? [BoxShadow(color: color.withOpacity(0.2), blurRadius: 12, spreadRadius: -2)]
              : [],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected ? color : color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : color,
                size: 24,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? color : context.textSecondaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
