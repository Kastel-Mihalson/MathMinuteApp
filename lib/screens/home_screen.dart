import 'package:flutter/material.dart';

import '../app_state.dart';
import '../game/problem.dart';
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

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Минутка',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            actions: [
              IconButton(
                tooltip: dark ? 'Светлая тема' : 'Тёмная тема',
                icon: Icon(
                  dark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                ),
                onPressed: () => appState
                    .setThemeMode(dark ? ThemeMode.light : ThemeMode.dark),
              ),
              IconButton(
                tooltip: 'Профиль',
                icon: const Icon(Icons.person_outline),
                onPressed: () => _openProfile(context),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              LevelCard(onTap: () => _openProfile(context)),
              const SizedBox(height: 28),
              Text('Сложность', style: theme.textTheme.titleMedium),
              const SizedBox(height: 10),
              SegmentedButton<Difficulty>(
                segments: [
                  for (final x in Difficulty.values)
                    ButtonSegment<Difficulty>(value: x, label: Text(x.label)),
                ],
                selected: {d},
                onSelectionChanged: (s) => appState.setDifficulty(s.first),
              ),
              const SizedBox(height: 16),
              Text(d.description, style: theme.textTheme.bodyLarge),
              const SizedBox(height: 8),
              Text(
                'За верный ответ: +${d.points} очков',
                style: theme.textTheme.bodyMedium,
              ),
              Text(
                'Лучший результат: ${appState.bestScores[d.index]}',
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: SizedBox(
                height: 64,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => GameScreen(difficulty: d),
                    ),
                  ),
                  child: const Text(
                    'Старт · 60 секунд',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
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
