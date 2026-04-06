import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/settings_provider.dart';

/// Premium onboarding flow with animated gradient pages and pill-dot indicators.
class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _iconController;
  late Animation<double> _iconScale;

  final List<_OnboardingData> _pages = [
    _OnboardingData(
      title: 'Welcome to Zorvym',
      subtitle: 'Your personal finance\ncompanion',
      description:
          'Track spending, set savings goals, and gain deep insights into your financial health — all in one place.',
      icon: Icons.account_balance_wallet_rounded,
      gradientColors: [Color(0xFF6C47FF), Color(0xFF2E0FCC)],
      accentColor: Color(0xFF6C47FF),
    ),
    _OnboardingData(
      title: 'Track Every Rupee',
      subtitle: 'Stay on top of\nyour spending',
      description:
          'Log income and expenses by category. Beautiful charts show exactly where your money goes each week.',
      icon: Icons.show_chart_rounded,
      gradientColors: [Color(0xFF00D09C), Color(0xFF008B67)],
      accentColor: Color(0xFF00D09C),
    ),
    _OnboardingData(
      title: 'Your Data, Secured',
      subtitle: 'Private by design,\nalways',
      description:
          'Everything is stored locally on your device. Enable a PIN or biometric lock for an extra layer of privacy.',
      icon: Icons.shield_rounded,
      gradientColors: [Color(0xFFFF4D6A), Color(0xFFCC2040)],
      accentColor: Color(0xFFFF4D6A),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _iconScale = CurvedAnimation(parent: _iconController, curve: Curves.elasticOut);
    _iconController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _iconController.dispose();
    super.dispose();
  }

  void _onNext() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _finish();
    }
  }

  void _finish() async {
    await ref.read(settingsNotifierProvider.notifier).setOnboardingDone();
    if (mounted) context.go('/dashboard');
  }

  @override
  Widget build(BuildContext context) {
    final page = _pages[_currentPage];
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [context.bgColor, page.gradientColors[1].withOpacity(0.35)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ── Skip button ─────────────────────────────────────────
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: TextButton(
                    onPressed: _finish,
                    child: Text(
                      'Skip',
                      style: TextStyle(color: context.textSecondaryColor, fontSize: 14),
                    ),
                  ),
                ),
              ),

              // ── Page content ────────────────────────────────────────
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() => _currentPage = index);
                    _iconController.reset();
                    _iconController.forward();
                  },
                  itemCount: _pages.length,
                  itemBuilder: (context, index) => _buildPage(_pages[index]),
                ),
              ),

              // ── Bottom controls ─────────────────────────────────────
              _buildBottomControls(page),
              const SizedBox(height: 36),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPage(_OnboardingData data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated icon in glassmorphism container
          ScaleTransition(
            scale: _iconScale,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    data.accentColor.withOpacity(0.25),
                    data.accentColor.withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(color: data.accentColor.withOpacity(0.4), width: 1.5),
              ),
              child: ClipOval(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  child: Center(
                    child: Icon(data.icon, size: 64, color: data.accentColor),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 48),
          Text(
            data.subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w800,
              color: context.textPrimaryColor,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            data.description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: context.textSecondaryColor,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomControls(_OnboardingData page) {
    final isLast = _currentPage == _pages.length - 1;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Pill dot indicators
          Row(
            children: List.generate(_pages.length, (index) {
              final active = _currentPage == index;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: active ? 28 : 8,
                height: 8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: active ? page.accentColor : context.textMutedColor,
                ),
              );
            }),
          ),

          // CTA button
          GestureDetector(
            onTap: _onNext,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: EdgeInsets.symmetric(
                horizontal: isLast ? 32 : 20,
                vertical: 14,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: page.gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  BoxShadow(
                    color: page.accentColor.withOpacity(0.4),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isLast)
                    const Text(
                      'Get Started',
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
                    )
                  else
                    const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 22),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingData {
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final List<Color> gradientColors;
  final Color accentColor;

  const _OnboardingData({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.gradientColors,
    required this.accentColor,
  });
}
