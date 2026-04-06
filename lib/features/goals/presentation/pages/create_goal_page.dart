import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:zorvym/core/theme/app_colors.dart';
import '../../data/models/goal_type.dart';
import '../providers/goal_provider.dart';
import '../../domain/usecases/add_goal.dart';

/// Premium form to create a new financial goal with visual type selectors.
class CreateGoalPage extends ConsumerStatefulWidget {
  const CreateGoalPage({super.key});

  @override
  ConsumerState<CreateGoalPage> createState() => _CreateGoalPageState();
}

class _CreateGoalPageState extends ConsumerState<CreateGoalPage> {
  final _titleController = TextEditingController();
  final _targetAmountController = TextEditingController();
  GoalType _type = GoalType.monthlySavings;
  DateTime? _endDate;
  String? _titleError;
  String? _amountError;

  @override
  void dispose() {
    _titleController.dispose();
    _targetAmountController.dispose();
    super.dispose();
  }

  void _submit() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      setState(() => _titleError = 'Title is required');
      return;
    } else {
      setState(() => _titleError = null);
    }

    final amountText = _targetAmountController.text.trim();
    final amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) {
      setState(() => _amountError = 'Enter a valid amount');
      return;
    } else {
      setState(() => _amountError = null);
    }

    final params = AddGoalParams(
      title: title,
      targetAmount: amount,
      type: _type,
      endDate: _endDate,
    );

    await ref.read(goalNotifierProvider.notifier).add(params);
    
    final state = ref.read(goalNotifierProvider);
    if (state.hasError) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.error.toString()),
            backgroundColor: AppColors.expense,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } else {
      if (mounted) context.pop();
    }
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme(
              brightness: Theme.of(context).brightness,
              primary: AppColors.primary,
              onPrimary: Colors.white,
              secondary: AppColors.primary,
              onSecondary: Colors.white,
              error: AppColors.expense,
              onError: Colors.white,
              surface: context.cardColor,
              onSurface: context.textPrimaryColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _endDate) {
      setState(() => _endDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(goalNotifierProvider).isLoading;

    Color activeColor;
    switch (_type) {
      case GoalType.monthlySavings: activeColor = AppColors.primary; break;
      case GoalType.budgetLimit: activeColor = AppColors.warning; break;
      case GoalType.noSpendChallenge: activeColor = AppColors.expense; break;
      case GoalType.weeklyTarget:
        // TODO: Handle this case.
        throw UnimplementedError();
    }

    return Scaffold(
      backgroundColor: context.bgColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => context.pop(),
        ),
        title: const Text('New Goal'),
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
                  // ── Goal Title ──────────────────────────────────────────
                  Text('Goal Title', style: TextStyle(color: context.textSecondaryColor, fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _titleController,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: context.textPrimaryColor),
                    decoration: InputDecoration(
                      hintText: 'e.g. New Laptop, Paris Trip...',
                      errorText: _titleError,
                    ),
                  ),
                  const SizedBox(height: 28),

                  // ── Target Amount ───────────────────────────────────────
                  Text('Target Amount', style: TextStyle(color: context.textSecondaryColor, fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _targetAmountController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: activeColor),
                    decoration: InputDecoration(
                      prefixText: '₹ ',
                      prefixStyle: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: context.textPrimaryColor),
                      errorText: _amountError,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: activeColor, width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // ── Goal Type Selector ─────────────────────────────────
                  Text('Goal Type', style: TextStyle(color: context.textSecondaryColor, fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  _TypeSelector(
                    title: 'Savings Goal',
                    subtitle: 'Save up for something special',
                    icon: Icons.savings_rounded,
                    color: AppColors.primary,
                    isSelected: _type == GoalType.monthlySavings,
                    onTap: () => setState(() => _type = GoalType.monthlySavings),
                  ),
                  const SizedBox(height: 12),
                  _TypeSelector(
                    title: 'Budget Limit',
                    subtitle: 'Set a maximum limit on spending',
                    icon: Icons.account_balance_wallet_rounded,
                    color: AppColors.warning,
                    isSelected: _type == GoalType.budgetLimit,
                    onTap: () => setState(() => _type = GoalType.budgetLimit),
                  ),
                  const SizedBox(height: 12),
                  _TypeSelector(
                    title: 'No Spend Challenge',
                    subtitle: 'Challenge yourself not to spend',
                    icon: Icons.money_off_rounded,
                    color: AppColors.expense,
                    isSelected: _type == GoalType.noSpendChallenge,
                    onTap: () => setState(() => _type = GoalType.noSpendChallenge),
                  ),
                  const SizedBox(height: 32),

                  // ── End Date ────────────────────────────────────────────
                  Text('Target Date (Optional)', style: TextStyle(color: context.textSecondaryColor, fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: _selectDate,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                      decoration: BoxDecoration(
                        color: context.cardColor,
                        border: Border.all(color: context.glassBdColor),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_month_rounded, color: _endDate != null ? AppColors.primary : context.textMutedColor),
                          const SizedBox(width: 16),
                          Text(
                            _endDate == null ? 'Select a date' : DateFormat('MMMM d, yyyy').format(_endDate!),
                            style: TextStyle(
                              fontSize: 16,
                              color: _endDate != null ? context.textPrimaryColor : context.textMutedColor,
                              fontWeight: _endDate != null ? FontWeight.w600 : FontWeight.w400,
                            ),
                          ),
                          const Spacer(),
                          if (_endDate != null)
                            GestureDetector(
                              onTap: () => setState(() => _endDate = null),
                              child: Icon(Icons.close_rounded, color: context.textMutedColor, size: 20),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 60),

                  // ── Save Button ─────────────────────────────────────────
                  GestureDetector(
                    onTap: isLoading ? null : _submit,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      decoration: BoxDecoration(
                        color: activeColor,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(color: activeColor.withOpacity(0.3), blurRadius: 16, offset: const Offset(0, 6)),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: isLoading
                          ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white))
                          : const Text(
                              'Create Goal',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
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

class _TypeSelector extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _TypeSelector({
    required this.title,
    required this.subtitle,
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.12) : context.cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? color : context.glassBdColor,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected ? color : context.surfaceColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: isSelected ? Colors.white : context.textMutedColor, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                      color: isSelected ? color : context.textPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: context.textSecondaryColor),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle_rounded, color: color)
            else
              Icon(Icons.circle_outlined, color: context.textMutedColor),
          ],
        ),
      ),
    );
  }
}
