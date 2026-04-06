import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/settings_provider.dart';

/// Premium glassmorphism PIN lock screen with shake animation on wrong PIN.
class LockScreen extends ConsumerStatefulWidget {
  const LockScreen({super.key});

  @override
  ConsumerState<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends ConsumerState<LockScreen>
    with SingleTickerProviderStateMixin {
  final List<int> _pin = [];
  String _error = '';
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void _onKeyTap(int value) {
    if (_pin.length < 4) {
      setState(() {
        _pin.add(value);
        _error = '';
      });
    }
    if (_pin.length == 4) _verify();
  }

  void _onBackspace() {
    if (_pin.isNotEmpty) {
      setState(() => _pin.removeLast());
    }
  }

  void _verify() {
    final settings = ref.read(settingsNotifierProvider).value;
    final enteredPin = _pin.join();

    if (settings != null && settings.pinHash == enteredPin) {
      HapticFeedback.lightImpact();
      context.go('/dashboard');
    } else {
      HapticFeedback.heavyImpact();
      _shakeController.reset();
      _shakeController.forward();
      setState(() {
        _pin.clear();
        _error = 'Incorrect PIN. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.bgColor,
      body: Stack(
        children: [
          // Subtle purple glow in background
          Positioned(
            top: -100,
            left: -50,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primary.withOpacity(0.15),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                const Spacer(flex: 2),

                // Lock icon
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.primaryDark],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.4),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.lock_rounded, color: Colors.white, size: 36),
                ),
                const SizedBox(height: 28),
                Text(
                  'Enter PIN',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: context.textPrimaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Enter your 4-digit PIN to continue',
                  style: TextStyle(fontSize: 14, color: context.textSecondaryColor),
                ),
                const SizedBox(height: 40),

                // PIN dots with shake animation
                AnimatedBuilder(
                  animation: _shakeAnimation,
                  builder: (context, child) {
                    final offset =
                        _shakeController.isAnimating ? 12 * (_shakeAnimation.value % 0.5) * ((_shakeAnimation.value * 10).toInt().isEven ? 1 : -1) : 0.0;
                    return Transform.translate(
                      offset: Offset(offset, 0),
                      child: child,
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(4, (index) {
                      final filled = index < _pin.length;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: filled ? AppColors.primary : Colors.transparent,
                          border: Border.all(
                            color: filled ? AppColors.primary : context.glassBdColor,
                            width: 2,
                          ),
                          boxShadow: filled
                              ? [
                                  BoxShadow(
                                    color: AppColors.primary.withOpacity(0.5),
                                    blurRadius: 8,
                                    spreadRadius: 1,
                                  ),
                                ]
                              : null,
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 16),

                // Error message
                AnimatedOpacity(
                  opacity: _error.isNotEmpty ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: Text(
                    _error,
                    style: const TextStyle(color: AppColors.expense, fontSize: 13),
                  ),
                ),

                const Spacer(flex: 2),

                // Numpad
                _buildNumpad(),
                const SizedBox(height: 48),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumpad() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: Column(
        children: [
          for (var row = 0; row < 3; row++)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (var col = 1; col <= 3; col++) _buildKey(row * 3 + col),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(width: 80, height: 80),
                _buildKey(0),
                _buildBackspaceKey(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKey(int value) {
    return GestureDetector(
      onTap: () => _onKeyTap(value),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: context.glassColor,
              border: Border.all(color: context.glassBdColor, width: 0.5),
            ),
            alignment: Alignment.center,
            child: Text(
              value.toString(),
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w500,
                color: context.textPrimaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackspaceKey() {
    return GestureDetector(
      onTap: _onBackspace,
      child: Container(
        width: 80,
        height: 80,
        alignment: Alignment.center,
        child: Icon(
          Icons.backspace_rounded,
          color: context.textSecondaryColor,
          size: 28,
        ),
      ),
    );
  }
}
