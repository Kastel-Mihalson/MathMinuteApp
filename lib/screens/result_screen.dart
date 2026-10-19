import 'package:flutter/material.dart';

import '../app_state.dart';
import '../game/problem.dart';
import '../levels.dart';
import '../widgets.dart';
import 'game_screen.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({
    super.key,
    required this.record,
    required this.oldLevel,
    required this.isRecord,
  });

  final GameRecord record;
  final int oldLevel;
  final bool isRecord;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final newLevel = appState.level;
    final leveledUp = newLevel > oldLevel;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(
                          isRecord ? 'Новый рекорд!' : 'Время вышло!',
                          style: tt.headlineMedium
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${record.score}',
                          style: TextStyle(
                            fontSize: 80,
                            fontWeight: FontWeight.w800,
                            color: cs.primary,
                          ),
                        ),
                        Text('очков · ${record.difficulty.label} уровень',
                            style: tt.bodyLarge),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: StatTile(
                                value: '${record.correct}',
                                label: 'Верно',
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: StatTile(
                                value: '${record.wrong}',
                                label: 'Ошибки',
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: StatTile(
                                value:
                                    '${(record.accuracy * 100).round()}%',
                                label: 'Точность',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '+${record.score} XP',
                          style: tt.titleLarge
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        if (leveledUp) ...[
                          const SizedBox(height: 16),
                          Card(
                            color: cs.primaryContainer,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  Text(
                                    'Новый уровень!',
                                    style: tt.titleMedium?.copyWith(
                                      color: cs.onPrimaryContainer,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '$newLevel · ${titleForLevel(newLevel)}',
                                    textAlign: TextAlign.center,
                                    style: tt.headlineSmall?.copyWith(
                                      fontWeight: FontWeight.w800,
                                      color: cs.onPrimaryContainer,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: FilledButton(
                  onPressed: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute<void>(
                      builder: (_) =>
                          GameScreen(difficulty: record.difficulty),
                    ),
                  ),
                  child: const Text(
                    'Играть снова',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton(
                  onPressed: () =>
                      Navigator.of(context).popUntil((r) => r.isFirst),
                  child: const Text(
                    'На главную',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
