import 'package:flutter/material.dart';

/// Centralized color design tokens for the Zorvym fintech app.
///
/// All feature UI files should reference these constants instead of
/// using hard-coded [Color] literals so that re-theming is one-stop.
abstract class AppColors {
  // ─── Brand ───────────────────────────────────────────────────────────────
  /// Electric Violet – primary brand accent (buttons, active icons, highlights)
  static const Color primary = Color(0xFF6C47FF);

  /// Deeper violet for gradient end-stops and pressed states
  static const Color primaryDark = Color(0xFF4A29D8);

  /// Teal Mint – secondary accent (income indicators, success states)
  static const Color secondary = Color(0xFF00D09C);

  /// Amber – used for budget/warning indicators
  static const Color warning = Color(0xFFFFC107);

  // ─── Backgrounds ─────────────────────────────────────────────────────────
  /// Deepest background layer – page scaffolds (dark mode)
  static const Color bgDark = Color(0xFF0D0F1C);

  /// Mid-level surface – cards, sheets (dark mode)
  static const Color surfaceDark = Color(0xFF13152A);

  /// Card surface slightly lighter – nested card areas
  static const Color cardDark = Color(0xFF1C1F36);

  /// Light-mode page background
  static const Color bgLight = Color(0xFFF5F6FF);

  /// Light-mode surface / card
  static const Color surfaceLight = Color(0xFFFFFFFF);

  // ─── Financial semantics ──────────────────────────────────────────────────
  /// Income / positive amounts
  static const Color income = Color(0xFF00D09C);

  /// Expense / negative amounts
  static const Color expense = Color(0xFFFF4D6A);

  // ─── Text ─────────────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B3CC);
  static const Color textMuted = Color(0xFF6B6F8A);

  static const Color textPrimaryLight = Color(0xFF0D0F1C);
  static const Color textSecondaryLight = Color(0xFF4A4E6A);

  // ─── Gradients ────────────────────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF1E2140), Color(0xFF13152A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient incomeGradient = LinearGradient(
    colors: [Color(0xFF00D09C), Color(0xFF00A57A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient expenseGradient = LinearGradient(
    colors: [Color(0xFFFF4D6A), Color(0xFFCC2D47)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ─── Category colors ─────────────────────────────────────────────────────
  static const Color catFood = Color(0xFFFF8C42);
  static const Color catTransport = Color(0xFF4ECDC4);
  static const Color catShopping = Color(0xFFFF6B9D);
  static const Color catEntertainment = Color(0xFFA855F7);
  static const Color catBills = Color(0xFF60A5FA);
  static const Color catSalary = Color(0xFF00D09C);
  static const Color catFreelance = Color(0xFF34D399);
  static const Color catOther = Color(0xFF94A3B8);

  // ─── Glassmorphism helpers ────────────────────────────────────────────────
  static const Color glassWhite = Color(0x1AFFFFFF); // 10% white
  static const Color glassBorder = Color(0x33FFFFFF); // 20% white
}

extension AppThemeContext on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
  
  Color get bgColor => isDark ? AppColors.bgDark : AppColors.bgLight;
  Color get surfaceColor => isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
  Color get cardColor => isDark ? AppColors.cardDark : AppColors.surfaceLight;
  
  Color get textPrimaryColor => isDark ? AppColors.textPrimary : AppColors.textPrimaryLight;
  Color get textSecondaryColor => isDark ? AppColors.textSecondary : AppColors.textSecondaryLight;
  Color get textMutedColor => isDark ? AppColors.textMuted : AppColors.textSecondaryLight.withOpacity(0.8);
  
  // Glassmorphism adapts to theme
  Color get glassColor => isDark ? AppColors.glassWhite : const Color(0x1F000000); 
  Color get glassBdColor => isDark ? AppColors.glassBorder : const Color(0x26000000); 
}
