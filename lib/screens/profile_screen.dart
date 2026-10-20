import 'package:flutter/material.dart';

import '../app_state.dart';
import '../game/problem.dart';
import '../levels.dart';
import '../theme.dart';
import '../widgets.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  String _fmt(DateTime d) {
    String two(int v) => v.toString().padLeft(2, '0');
    return '${two(d.day)}.${two(d.month)} ${two(d.hour)}:${two(d.minute)}';
  }

  Future<void> _editName(BuildContext context) async {
    final value = await showDialog<String>(
      context: context,
      builder: (_) => _NameDialog(initial: appState.name),
    );
    if (value != null && value.isNotEmpty) {
      appState.setName(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        final cs = Theme.of(context).colorScheme;
        final tt = Theme.of(context).textTheme;
        final level = appState.level;
        final warning = appState.storageWarning;

        Widget heading(String text) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                text,
                style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
            );

        return AppBackground(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: const Text(
                'Профиль',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              actions: [
                IconButton(
                  tooltip: 'Изменить имя',
                  icon: const Icon(Icons.edit_rounded),
                  onPressed: () => _editName(context),
                ),
              ],
            ),
            body: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              children: [
                const LevelCard(),
                const SizedBox(height: 24),
                heading('Статистика'),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.3,
                  children: [
                    StatTile(
                      value: '${appState.games}',
                      label: 'Игр сыграно',
                      icon: Icons.sports_esports_rounded,
                    ),
                    StatTile(
                      value: '${appState.correct}',
                      label: 'Верных ответов',
                      icon: Icons.check_circle_rounded,
                      color: kGreen,
                    ),
                    StatTile(
                      value: '${(appState.accuracy * 100).round()}%',
                      label: 'Точность',
                      icon: Icons.track_changes_rounded,
                      color: kAmber,
                    ),
                    StatTile(
                      value: '${appState.bestStreak}',
                      label: 'Лучшая серия',
                      icon: Icons.local_fire_department_rounded,
                      color: kRed,
                    ),
                    StatTile(
                      value: appState.avgCorrectPerGame.toStringAsFixed(1),
                      label: 'Верных за игру',
                      icon: Icons.speed_rounded,
                    ),
                    StatTile(
                      value: '${appState.xp}',
                      label: 'Всего XP',
                      icon: Icons.auto_awesome_rounded,
                      color: kAmber,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                heading('Лучшие результаты'),
                SoftCard(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  child: Column(
                    children: [
                      for (final d in Difficulty.values)
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(d.icon, color: d.color),
                          title: Text(d.label),
                          trailing: Text(
                            '${appState.bestScores[d.index]}',
                            style: tt.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                heading('Титулы'),
                SoftCard(
                  padding: EdgeInsets.zero,
                  child: ExpansionTile(
                    shape: const Border(),
                    collapsedShape: const Border(),
                    title: Text(
                      'Ваш титул: ${appState.title}',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    children: [
                      for (var i = 0; i < kTitles.length; i++)
                        ListTile(
                          dense: true,
                          leading: Icon(
                            level >= i + 1
                                ? Icons.check_circle_rounded
                                : Icons.lock_rounded,
                            color: level >= i + 1 ? cs.primary : cs.outline,
                          ),
                          title: Text(
                            kTitles[i],
                            style: TextStyle(
                              color:
                                  level >= i + 1 ? cs.onSurface : cs.outline,
                              fontWeight: level == i + 1
                                  ? FontWeight.w800
                                  : FontWeight.w400,
                            ),
                          ),
                          trailing: Text(
                            i == kTitles.length - 1
                                ? 'ур. ${i + 1}+'
                                : 'ур. ${i + 1}',
                            style: tt.bodySmall,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                heading('Последние игры'),
                if (appState.history.isEmpty)
                  SoftCard(
                    child: Text(
                      'Пока нет сыгранных игр. Самое время начать!',
                      style: tt.bodyMedium,
                    ),
                  )
                else
                  SoftCard(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    child: Column(
                      children: [
                        for (final r in appState.history.take(10))
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Icon(
                              r.difficulty.icon,
                              color: r.difficulty.color,
                            ),
                            title: Text(
                              '${r.score} очков · ${r.difficulty.label}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.w700),
                            ),
                            subtitle: Text(
                              '${r.correct} верно, ${r.wrong} ошибок · ${_fmt(r.date)}',
                            ),
                          ),
                      ],
                    ),
                  ),
                if (warning != null) ...[
                  const SizedBox(height: 24),
                  SelectableText(
                    'Служебная информация (хранилище):\n$warning',
                    style: tt.bodySmall?.copyWith(color: context.appMuted),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _NameDialog extends StatefulWidget {
  const _NameDialog({required this.initial});

  final String initial;

  @override
  State<_NameDialog> createState() => _NameDialogState();
}

class _NameDialogState extends State<_NameDialog> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.initial);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Ваше имя'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        maxLength: 16,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Отмена'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(_controller.text.trim()),
          child: const Text('Сохранить'),
        ),
      ],
    );
  }
}
