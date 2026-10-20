import 'package:flutter/material.dart';

import 'game/problem.dart';

/// Цвет верного ответа.
const Color kGreen = Color(0xFF22B573);

/// Цвет ошибки.
const Color kRed = Color(0xFFEF4444);

/// Тёплый акцентный цвет (иконки статистики).
const Color kAmber = Color(0xFFF5A524);

/// Цвет карточек и клавиш в зависимости от темы.
Color cardColorOf(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF211F2E)
        : Colors.white;

/// Градиент для акцентных элементов (карточка уровня, кнопка старта).
LinearGradient accentGradient(BuildContext context) {
  final dark = Theme.of(context).brightness == Brightness.dark;
  return LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: dark
        ? const [Color(0xFF6C5CE7), Color(0xFF8E54E9)]
        : const [Color(0xFF6C5CE7), Color(0xFF9B6BFF)],
  );
}

/// Светлая и тёмная темы строятся из одного базового цвета.
ThemeData buildTheme(Brightness brightness) {
  final dark = brightness == Brightness.dark;
  final scheme = ColorScheme.fromSeed(
    seedColor: const Color(0xFF6C5CE7),
    brightness: brightness,
  ).copyWith(
    surface: dark ? const Color(0xFF15141D) : const Color(0xFFF6F5FF),
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: scheme.surface,
    appBarTheme: AppBarTheme(
      backgroundColor: scheme.surface,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
    ),
    cardTheme: CardThemeData(
      color: dark ? const Color(0xFF211F2E) : Colors.white,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    ),
  );
}

extension AppColors on BuildContext {
  /// Приглушённый цвет для второстепенного текста.
  Color get appMuted => Theme.of(this).colorScheme.onSurfaceVariant;

  /// Фирменный градиент.
  LinearGradient get brandGradient => accentGradient(this);
}

extension DifficultyStyle on Difficulty {
  IconData get icon => switch (this) {
        Difficulty.easy => Icons.spa_rounded,
        Difficulty.medium => Icons.bolt_rounded,
        Difficulty.hard => Icons.local_fire_department_rounded,
      };

  Color get color => switch (this) {
        Difficulty.easy => kGreen,
        Difficulty.medium => kAmber,
        Difficulty.hard => kRed,
      };
}

/// Фон экрана с мягким градиентом.
class AppBackground extends StatelessWidget {
  const AppBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: dark
              ? const [Color(0xFF1C1A31), Color(0xFF15141D)]
              : const [Color(0xFFEBE8FF), Color(0xFFF8F7FF)],
        ),
      ),
      child: child,
    );
  }
}

/// Мягкая карточка со скруглением и тенью.
class SoftCard extends StatelessWidget {
  const SoftCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: cardColorOf(context),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }
}
