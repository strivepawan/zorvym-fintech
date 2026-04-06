import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:zorvym/core/theme/app_colors.dart';
import '../../domain/entities/financial_summary.dart';
import '../../../../shared/widgets/amount_display.dart';

/// Premium glassmorphism balance card shown at the top of the Dashboard.
class BalanceCard extends StatelessWidget {
  final FinancialSummary summary;

  const BalanceCard({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF2A1F6F), Color(0xFF1A1040)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: context.glassBdColor, width: 0.8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header row ───────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Balance',
                    style: TextStyle(
                      color: Color(
                        0xFFB0B3CC,
                      ), // Keeping explicitly light-on-dark for the gradient
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.secondary.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.secondary,
                          ),
                        ),
                        const SizedBox(width: 5),
                        const Text(
                          'This Month',
                          style: TextStyle(
                            color: AppColors.secondary,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // ── Balance amount ────────────────────────────────────────
              AmountDisplay(
                amount: summary.currentBalance,
                style: const TextStyle(
                  color: Colors
                      .white, // Since it's against a dark gradient backing, force white
                  fontSize: 38,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 28),

              // ── Divider ───────────────────────────────────────────────
              Container(height: 0.5, color: context.glassBdColor),
              const SizedBox(height: 20),

              // ── Income / Expense row ──────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: _FinancialPill(
                      label: 'Income',
                      amount: summary.totalIncome,
                      icon: Icons.arrow_upward_rounded,
                      color: AppColors.income,
                    ),
                  ),
                  Container(
                    width: 0.5,
                    height: 40,
                    color: context.glassBdColor,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  Expanded(
                    child: _FinancialPill(
                      label: 'Expense',
                      amount: summary.totalExpense,
                      icon: Icons.arrow_downward_rounded,
                      color: AppColors.expense,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FinancialPill extends StatelessWidget {
  final String label;
  final double amount;
  final IconData icon;
  final Color color;

  const _FinancialPill({
    required this.label,
    required this.amount,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Color(
                  0xFFB0B3CC,
                ), // Force white-transparent against gradient
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 2),
            AmountDisplay(
              amount: amount,
              style: const TextStyle(
                color: Colors.white, // Force white against gradient
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
