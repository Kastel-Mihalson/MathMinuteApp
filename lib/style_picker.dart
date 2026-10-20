import 'package:flutter/material.dart';

import 'app_state.dart';
import 'app_style.dart';
import 'theme.dart';

/// Выбор стиля оформления и светлой/тёмной темы.
class StylePicker extends StatelessWidget {
  const StylePicker({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.3,
          children: [
            for (final s in AppStyle.values) _StyleTile(style: s),
          ],
        ),
        const SizedBox(height: 14),
        const _ModeSwitch(),
      ],
    );
  }
}

class _StyleTile extends StatelessWidget {
  const _StyleTile({required this.style});

  final AppStyle style;

  @override
  Widget build(BuildContext context) {
    // Плитка рисуется цветами самого стиля в текущей яркости.
    final p = paletteFor(style, Theme.of(context).brightness);
    final selected = appState.style == style;

    return Semantics(
      button: true,
      selected: selected,
      label: 'Стиль ${style.label}',
      child: GestureDetector(
        onTap: () => appState.setStyle(style),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [p.bgTop, p.bgBottom],
            ),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: selected ? p.primary : p.outline,
              width: selected ? 3 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 30,
                decoration: BoxDecoration(
                  gradient: p.gradient,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _dot(p.correct),
                  const SizedBox(width: 4),
                  _dot(p.wrong),
                  const SizedBox(width: 4),
                  _dot(p.card, border: p.outline),
                ],
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      style.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: p.text,
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  if (selected)
                    Icon(Icons.check_circle_rounded, color: p.primary, size: 20),
                ],
              ),
              Text(
                style.description,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: p.muted, fontSize: 11),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dot(Color c, {Color? border}) => Container(
        width: 14,
        height: 14,
        decoration: BoxDecoration(
          color: c,
          shape: BoxShape.circle,
          border: border == null ? null : Border.all(color: border),
        ),
      );
}

/// Переключатель «Светлая / Тёмная / Авто».
class _ModeSwitch extends StatelessWidget {
  const _ModeSwitch();

  @override
  Widget build(BuildContext context) {
    final pal = context.pal;

    Widget item(ThemeMode mode, IconData icon, String label) {
      final selected = appState.themeMode == mode;
      return Expanded(
        child: Semantics(
          button: true,
          selected: selected,
          label: label,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => appState.setThemeMode(mode),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              height: 48,
              decoration: BoxDecoration(
                color: selected ? pal.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 18, color: selected ? pal.onPrimary : pal.muted),
                  const SizedBox(width: 6),
                  Text(
                    label,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: selected ? pal.onPrimary : pal.text,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: pal.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: pal.outline),
      ),
      child: Row(
        children: [
          item(ThemeMode.light, Icons.light_mode_rounded, 'Светлая'),
          item(ThemeMode.dark, Icons.dark_mode_rounded, 'Тёмная'),
          item(ThemeMode.system, Icons.brightness_auto_rounded, 'Авто'),
        ],
      ),
    );
  }
}
