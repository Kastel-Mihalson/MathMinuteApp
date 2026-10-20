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
              bgTop: Color(0xFF13141D),
              bgBottom: Color(0xFF0F1018),
              card: Color(0xFF1A1C28),
              outline: Color(0xFF2D3040),
              primary: Color(0xFF63B4C4),
              primary2: Color(0xFF7388C6),
              onPrimary: Color(0xFF0B1A1F),
              text: Color(0xFFE6E8F0),
              muted: Color(0xFF9396AC),
              correct: Color(0xFF86C795),
              wrong: Color(0xFFE08394),
              cardRadius: 24,
              keyRadius: 20,
              borderWidth: 1,
              glow: true,
            )
          : const AppPalette(
              bgTop: Color(0xFFF0F4F6),
              bgBottom: Color(0xFFE7EDF0),
              card: Colors.white,
              outline: Color(0xFFD5DEE3),
              primary: Color(0xFF3A7F90),
              primary2: Color(0xFF5E78B5),
              onPrimary: Colors.white,
              text: Color(0xFF1B2128),
              muted: Color(0xFF5B6670),
              correct: Color(0xFF3F8F5A),
              wrong: Color(0xFFBD5262),
              cardRadius: 24,
              keyRadius: 20,
              borderWidth: 1,
              glow: false,
            );
    case AppStyle.forest:
      return dark
          ? const AppPalette(
              bgTop: Color(0xFF1B241F),
              bgBottom: Color(0xFF151C18),
              card: Color(0xFF222D27),
              outline: Color(0xFF31403A),
              primary: Color(0xFF93B2A0),
              primary2: Color(0xFFAAC4B4),
              onPrimary: Color(0xFF14221B),
              text: Color(0xFFE4EBE6),
              muted: Color(0xFFA0B2A7),
              correct: Color(0xFF86C29E),
              wrong: Color(0xFFD98F7C),
              cardRadius: 28,
              keyRadius: 26,
              borderWidth: 0,
              glow: false,
            )
          : const AppPalette(
              bgTop: Color(0xFFF2F4EE),
              bgBottom: Color(0xFFE9EDE4),
              card: Color(0xFFFCFDFB),
              outline: Color(0xFFD9E0D4),
              primary: Color(0xFF446656),
              primary2: Color(0xFF648A75),
              onPrimary: Colors.white,
              text: Color(0xFF26332C),
              muted: Color(0xFF5E6C63),
              correct: Color(0xFF4A8F69),
              wrong: Color(0xFFB5614C),
              cardRadius: 28,
              keyRadius: 26,
              borderWidth: 0,
              glow: false,
            );
    case AppStyle.space:
      return dark
          ? const AppPalette(
              bgTop: Color(0xFF161B3A),
              bgBottom: Color(0xFF10142F),
              card: Color(0xFF1D2248),
              outline: Color(0xFF2F3563),
              primary: Color(0xFFD6B878),
              primary2: Color(0xFFC9A468),
              onPrimary: Color(0xFF14172E),
              text: Color(0xFFECEDF7),
              muted: Color(0xFF9EA3CF),
              correct: Color(0xFF7FC9A8),
              wrong: Color(0xFFE08C98),
              cardRadius: 28,
              keyRadius: 40,
              borderWidth: 1,
              glow: true,
            )
          : const AppPalette(
              bgTop: Color(0xFFEEEFF8),
              bgBottom: Color(0xFFE5E7F4),
              card: Colors.white,
              outline: Color(0xFFD7DAEC),
              primary: Color(0xFF4C52A6),
              primary2: Color(0xFF6C66B6),
              onPrimary: Colors.white,
              text: Color(0xFF1A1D3A),
              muted: Color(0xFF5E6390),
              correct: Color(0xFF3F9577),
              wrong: Color(0xFFBF5565),
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
            color: pal.primary.withValues(alpha: pal.glow ? 0.25 : 0.35),
            blurRadius: pal.glow ? 20 : 16,
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
