import 'package:flutter/material.dart';

import 'app_style.dart';
import 'game/problem.dart';

/// Цвет верного ответа по умолчанию.
const Color kGreen = Color(0xFF22B573);

/// Цвет ошибки по умолчанию.
const Color kRed = Color(0xFFEF4444);

/// Основной фирменный цвет классического стиля.
const Color kBrand = Color(0xFF6C5CE7);

/// Тёплый акцентный цвет (иконки статистики).
const Color kAmber = Color(0xFFF5A524);

/// Набор цветов и форм выбранного стиля. Лежит в теме, доступен как `context.pal`.
@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  const AppPalette({
    required this.bgTop,
    required this.bgBottom,
    required this.card,
    required this.outline,
    required this.primary,
    required this.primary2,
    required this.onPrimary,
    required this.text,
    required this.muted,
    required this.correct,
    required this.wrong,
    required this.cardRadius,
    required this.keyRadius,
    required this.borderWidth,
    required this.glow,
  });

  final Color bgTop;
  final Color bgBottom;
  final Color card;
  final Color outline;

  /// Главный акцент и второй цвет градиента.
  final Color primary;
  final Color primary2;

  /// Цвет текста и иконок поверх акцента.
  final Color onPrimary;
  final Color text;
  final Color muted;
  final Color correct;
  final Color wrong;
  final double cardRadius;
  final double keyRadius;

  /// Толщина обводки карточек и клавиш (0 — без обводки).
  final double borderWidth;

  /// Светящиеся тени у подсветки ответа.
  final bool glow;

  LinearGradient get gradient => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [primary, primary2],
      );

  @override
  AppPalette copyWith() => this;

  @override
  AppPalette lerp(ThemeExtension<AppPalette>? other, double t) {
    if (other is! AppPalette) return this;
    return t < 0.5 ? this : other;
  }
}

/// Палитра для сочетания «стиль + светлая/тёмная тема».
AppPalette paletteFor(AppStyle style, Brightness brightness) {
  final dark = brightness == Brightness.dark;
  switch (style) {
    case AppStyle.classic:
      return dark
          ? const AppPalette(
              bgTop: Color(0xFF1C1A31),
              bgBottom: Color(0xFF15141D),
              card: Color(0xFF211F2E),
              outline: Color(0xFF2E2B45),
              primary: Color(0xFF6C5CE7),
              primary2: Color(0xFF8E54E9),
              onPrimary: Colors.white,
              text: Color(0xFFE6E1E9),
              muted: Color(0xFFCAC4D0),
              correct: kGreen,
              wrong: kRed,
              cardRadius: 24,
              keyRadius: 22,
              borderWidth: 0,
              glow: false,
            )
          : const AppPalette(
              bgTop: Color(0xFFEBE8FF),
              bgBottom: Color(0xFFF8F7FF),
              card: Colors.white,
              outline: Color(0xFFD9D5F2),
              primary: Color(0xFF6C5CE7),
              primary2: Color(0xFF9B6BFF),
              onPrimary: Colors.white,
              text: Color(0xFF1C1B1F),
              muted: Color(0xFF49454F),
              correct: kGreen,
              wrong: kRed,
              cardRadius: 24,
              keyRadius: 22,
              borderWidth: 0,
              glow: false,
            );
    case AppStyle.neon:
      return dark
          ? const AppPalette(
              bgTop: Color(0xFF0E0E1C),
              bgBottom: Color(0xFF0A0A12),
              card: Color(0xFF14142A),
              outline: Color(0xFF26264A),
              primary: Color(0xFF22E4FF),
              primary2: Color(0xFF5B8CFF),
              onPrimary: Color(0xFF04131A),
              text: Color(0xFFF2F3FF),
              muted: Color(0xFF8D90B8),
              correct: Color(0xFF7CFF5B),
              wrong: Color(0xFFFF4D6D),
              cardRadius: 24,
              keyRadius: 20,
              borderWidth: 1,
              glow: true,
            )
          : const AppPalette(
              bgTop: Color(0xFFF2FBFF),
              bgBottom: Color(0xFFE6F6FC),
              card: Colors.white,
              outline: Color(0xFFCDE3EC),
              primary: Color(0xFF087C99),
              primary2: Color(0xFF3A63E0),
              onPrimary: Colors.white,
              text: Color(0xFF10131F),
              muted: Color(0xFF566073),
              correct: Color(0xFF1F9D3A),
              wrong: Color(0xFFD6244A),
              cardRadius: 24,
              keyRadius: 20,
              borderWidth: 1,
              glow: false,
            );
    case AppStyle.forest:
      return dark
          ? const AppPalette(
              bgTop: Color(0xFF18241E),
              bgBottom: Color(0xFF111A15),
              card: Color(0xFF1F2E26),
              outline: Color(0xFF2D4036),
              primary: Color(0xFF7FA88F),
              primary2: Color(0xFFA8CDB6),
              onPrimary: Color(0xFF10261D),
              text: Color(0xFFE8F0EA),
              muted: Color(0xFFA5B8AC),
              correct: Color(0xFF5BD38C),
              wrong: Color(0xFFE37B62),
              cardRadius: 28,
              keyRadius: 26,
              borderWidth: 0,
              glow: false,
            )
          : const AppPalette(
              bgTop: Color(0xFFF3F6EE),
              bgBottom: Color(0xFFE8EEE1),
              card: Colors.white,
              outline: Color(0xFFD5DECF),
              primary: Color(0xFF24463A),
              primary2: Color(0xFF3F7A62),
              onPrimary: Colors.white,
              text: Color(0xFF1E2B25),
              muted: Color(0xFF55655C),
              correct: Color(0xFF2F8F5B),
              wrong: Color(0xFFB8472F),
              cardRadius: 28,
              keyRadius: 26,
              borderWidth: 0,
              glow: false,
            );
    case AppStyle.space:
      return dark
          ? const AppPalette(
              bgTop: Color(0xFF10163F),
              bgBottom: Color(0xFF0A0D28),
              card: Color(0xFF161B4A),
              outline: Color(0xFF2A3170),
              primary: Color(0xFFFFC857),
              primary2: Color(0xFFFFA94D),
              onPrimary: Color(0xFF0C1030),
              text: Color(0xFFF3F4FF),
              muted: Color(0xFFA3A9E0),
              correct: Color(0xFF5BE3A4),
              wrong: Color(0xFFFF7A8A),
              cardRadius: 28,
              keyRadius: 40,
              borderWidth: 1,
              glow: true,
            )
          : const AppPalette(
              bgTop: Color(0xFFEEF0FF),
              bgBottom: Color(0xFFE3E7FF),
              card: Colors.white,
              outline: Color(0xFFD5D9F5),
              primary: Color(0xFF3D44C4),
              primary2: Color(0xFF7B5CFF),
              onPrimary: Colors.white,
              text: Color(0xFF111433),
              muted: Color(0xFF565B8F),
              correct: Color(0xFF1E9E6A),
              wrong: Color(0xFFD6455A),
              cardRadius: 28,
              keyRadius: 40,
              borderWidth: 1,
              glow: false,
            );
  }
}

extension AppColors on BuildContext {
  /// Палитра текущего стиля.
  AppPalette get pal =>
      Theme.of(this).extension<AppPalette>() ??
      paletteFor(AppStyle.classic, Theme.of(this).brightness);

  /// Приглушённый цвет для второстепенного текста.
  Color get appMuted => Theme.of(this).colorScheme.onSurfaceVariant;

  /// Фирменный градиент.
  LinearGradient get brandGradient => pal.gradient;
}

/// Цвет карточек и клавиш.
Color cardColorOf(BuildContext context) => context.pal.card;

/// Градиент для акцентных элементов (карточка уровня, кнопка старта).
LinearGradient accentGradient(BuildContext context) => context.pal.gradient;

/// Тема приложения для выбранного стиля и яркости.
ThemeData buildTheme(Brightness brightness, [AppStyle style = AppStyle.classic]) {
  final pal = paletteFor(style, brightness);

  var scheme = ColorScheme.fromSeed(
    seedColor: style == AppStyle.classic ? kBrand : pal.primary,
    brightness: brightness,
  );
  if (style == AppStyle.classic) {
    scheme = scheme.copyWith(surface: pal.bgBottom);
  } else {
    scheme = scheme.copyWith(
      primary: pal.primary,
      onPrimary: pal.onPrimary,
      surface: pal.bgBottom,
      onSurface: pal.text,
      onSurfaceVariant: pal.muted,
      outline: pal.muted,
      error: pal.wrong,
    );
  }

  final side = pal.borderWidth > 0
      ? BorderSide(color: pal.outline, width: pal.borderWidth)
      : BorderSide.none;

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: scheme.surface,
    extensions: <ThemeExtension<dynamic>>[pal],
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
    ),
    cardTheme: CardThemeData(
      color: pal.card,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(pal.cardRadius),
        side: side,
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: pal.card,
      surfaceTintColor: Colors.transparent,
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
    final pal = context.pal;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [pal.bgTop, pal.bgBottom],
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
    final pal = context.pal;
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: pal.card,
        borderRadius: BorderRadius.circular(pal.cardRadius),
        border: pal.borderWidth > 0
            ? Border.all(color: pal.outline, width: pal.borderWidth)
            : null,
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

/// Крупная кнопка с градиентом, иконкой и подписью.
class GradientButton extends StatelessWidget {
  const GradientButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  });

  final String label;
  final IconData? icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final pal = context.pal;
    return Container(
      width: double.infinity,
      height: 58,
      decoration: BoxDecoration(
        gradient: pal.gradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: pal.primary.withValues(alpha: pal.glow ? 0.45 : 0.35),
            blurRadius: pal.glow ? 24 : 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, color: pal.onPrimary),
                const SizedBox(width: 10),
              ],
              Text(
                label,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: pal.onPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
