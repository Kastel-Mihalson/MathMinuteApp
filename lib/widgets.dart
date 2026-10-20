import 'package:flutter/material.dart';

import 'app_state.dart';
import 'levels.dart';
import 'theme.dart';

/// Карточка с уровнем, титулом и прогрессом до следующего уровня.
class LevelCard extends StatelessWidget {
  const LevelCard({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final level = appState.level;
    final start = xpForLevel(level);
    final end = xpForLevel(level + 1);

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(28),
      child: Ink(
        decoration: BoxDecoration(
          gradient: accentGradient(context),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6C5CE7).withValues(alpha: 0.30),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.22),
                      ),
                      child: Text(
                        '$level',
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            appState.title,
                            style: tt.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${appState.name} · уровень $level',
                            style: tt.bodyMedium?.copyWith(
                              color: Colors.white.withValues(alpha: 0.85),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: levelProgress(appState.xp),
                    minHeight: 10,
                    backgroundColor: Colors.white.withValues(alpha: 0.25),
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '${appState.xp - start} / ${end - start} XP до уровня ${level + 1}',
                    style: tt.bodySmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Плитка статистики: иконка, крупное значение и подпись.
class StatTile extends StatelessWidget {
  const StatTile({
    super.key,
    required this.value,
    required this.label,
    this.icon,
    this.color,
  });

  final String value;
  final String label;
  final IconData? icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final accent = color ?? Theme.of(context).colorScheme.primary;
    return SoftCard(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, color: accent, size: 24),
            const SizedBox(height: 6),
          ],
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: tt.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: accent,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(label, style: tt.bodySmall, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
