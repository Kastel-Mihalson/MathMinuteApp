import 'package:flutter/material.dart';

import '../app_state.dart';
import '../game/problem.dart';
import '../theme.dart';
import '../widgets.dart';
import 'game_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _openProfile(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const ProfileScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        final theme = Theme.of(context);
        final dark = theme.brightness == Brightness.dark;
        final d = appState.difficulty;

        return AppBackground(
          child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text(
              'Минутка',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 26),
            ),
            actions: [
              IconButton(
                tooltip: appState.soundEnabled ? 'Выключить звук' : 'Включить звук',
                icon: Icon(
                  appState.soundEnabled
                      ? Icons.volume_up_rounded
                      : Icons.volume_off_rounded,
                ),
                onPressed: () => appState.setSoundEnabled(!appState.soundEnabled),
              ),
              IconButton(
                tooltip: dark ? 'Светлая тема' : 'Тёмная тема',
                icon: Icon(
                  dark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                ),
                onPressed: () => appState
                    .setThemeMode(dark ? ThemeMode.light : ThemeMode.dark),
              ),
              IconButton(
                tooltip: 'Профиль',
                icon: const Icon(Icons.person_rounded),
                onPressed: () => _openProfile(context),
              ),
              const SizedBox(width: 4),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            children: [
              LevelCard(onTap: () => _openProfile(context)),
              const SizedBox(height: 28),
              Text(
                'Сложность',
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  for (final x in Difficulty.values) ...[
                    Expanded(child: _DifficultyCard(difficulty: x)),
                    if (x != Difficulty.values.last) const SizedBox(width: 10),
                  ],
                ],
              ),
              const SizedBox(height: 18),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(d.description, style: theme.textTheme.bodyLarge),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.emoji_events_rounded, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Лучший результат: ${appState.bestScores[d.index]}',
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: Container(
                height: 66,
                decoration: BoxDecoration(
                  gradient: accentGradient(context),
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: context.pal.primary.withValues(alpha: 0.35),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(22),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => GameScreen(difficulty: d),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Старт · 60 секунд',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: context.pal.onPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          ),
        );
      },
    );
  }
}

class _DifficultyCard extends StatelessWidget {
  const _DifficultyCard({required this.difficulty});

  final Difficulty difficulty;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final selected = appState.difficulty == difficulty;
    final icon = switch (difficulty) {
      Difficulty.easy => Icons.spa_rounded,
      Difficulty.medium => Icons.bolt_rounded,
      Difficulty.hard => Icons.local_fire_department_rounded,
    };

    return GestureDetector(
      onTap: () => appState.setDifficulty(difficulty),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: selected ? cs.primary : cardColorOf(context),
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: (selected ? cs.primary : Colors.black)
                  .withValues(alpha: selected ? 0.30 : 0.05),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: selected ? cs.onPrimary : cs.primary, size: 28),
            const SizedBox(height: 8),
            Text(
              difficulty.label,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: selected ? cs.onPrimary : cs.onSurface,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '+${difficulty.points}',
              style: TextStyle(
                fontSize: 12,
                color: selected
                    ? cs.onPrimary.withValues(alpha: 0.85)
                    : cs.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
