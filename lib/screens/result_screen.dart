import 'package:flutter/material.dart';

import '../app_state.dart';
import '../game/problem.dart';
import '../levels.dart';
import '../theme.dart';
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

    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
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
                          Container(
                            width: 84,
                            height: 84,
                            decoration: BoxDecoration(
                              gradient: context.brandGradient,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: kBrand.withValues(alpha: 0.35),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Icon(
                              isRecord
                                  ? Icons.emoji_events_rounded
                                  : Icons.timer_rounded,
                              color: Colors.white,
                              size: 44,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            isRecord ? 'Новый рекорд!' : 'Время вышло!',
                            style: tt.headlineMedium
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 8),
                          TweenAnimationBuilder<int>(
                            tween: IntTween(begin: 0, end: record.score),
                            duration: const Duration(milliseconds: 900),
                            curve: Curves.easeOutCubic,
                            builder: (context, value, _) => Text(
                              '$value',
                              style: TextStyle(
                                fontSize: 84,
                                fontWeight: FontWeight.w800,
                                color: cs.primary,
                                height: 1.1,
                              ),
                            ),
                          ),
                          Text(
                            'очков · ${record.difficulty.label} уровень',
                            style: tt.bodyLarge
                                ?.copyWith(color: context.appMuted),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              Expanded(
                                child: StatTile(
                                  value: '${record.correct}',
                                  label: 'Верно',
                                  icon: Icons.check_circle_rounded,
                                  color: kGreen,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: StatTile(
                                  value: '${record.wrong}',
                                  label: 'Ошибки',
                                  icon: Icons.cancel_rounded,
                                  color: kRed,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: StatTile(
                                  value:
                                      '${(record.accuracy * 100).round()}%',
                                  label: 'Точность',
                                  icon: Icons.track_changes_rounded,
                                  color: cs.primary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '+${record.score} XP',
                            style: tt.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: cs.primary,
                            ),
                          ),
                          if (leveledUp) ...[
                            const SizedBox(height: 16),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                gradient: context.brandGradient,
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    'Новый уровень!',
                                    style: TextStyle(
                                      color: Colors.white.withValues(
                                        alpha: 0.9,
                                      ),
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '$newLevel · ${titleForLevel(newLevel)}',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
                GradientButton(
                  label: 'Играть снова',
                  icon: Icons.replay_rounded,
                  onPressed: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute<void>(
                      builder: (_) =>
                          GameScreen(difficulty: record.difficulty),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: TextButton(
                    onPressed: () =>
                        Navigator.of(context).popUntil((r) => r.isFirst),
                    child: const Text(
                      'На главную',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
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
