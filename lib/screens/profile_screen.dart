import 'package:flutter/material.dart';

import '../app_state.dart';
import '../game/problem.dart';
import '../levels.dart';
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
        final theme = Theme.of(context);
        final cs = theme.colorScheme;
        final tt = theme.textTheme;
        final level = appState.level;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Профиль'),
            actions: [
              IconButton(
                tooltip: 'Изменить имя',
                icon: const Icon(Icons.edit_outlined),
                onPressed: () => _editName(context),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const LevelCard(),
              const SizedBox(height: 20),
              Text('Статистика', style: tt.titleMedium),
              const SizedBox(height: 10),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.7,
                children: [
                  StatTile(value: '${appState.games}', label: 'Игр сыграно'),
                  StatTile(
                    value: '${appState.correct}',
                    label: 'Верных ответов',
                  ),
                  StatTile(
                    value: '${(appState.accuracy * 100).round()}%',
                    label: 'Точность',
                  ),
                  StatTile(
                    value: '${appState.bestStreak}',
                    label: 'Лучшая серия',
                  ),
                  StatTile(
                    value: appState.avgCorrectPerGame.toStringAsFixed(1),
                    label: 'Верных за игру',
                  ),
                  StatTile(value: '${appState.xp}', label: 'Всего XP'),
                ],
              ),
              const SizedBox(height: 20),
              Text('Лучшие результаты', style: tt.titleMedium),
              const SizedBox(height: 6),
              for (final d in Difficulty.values)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(d.label),
                  trailing: Text(
                    '${appState.bestScores[d.index]}',
                    style: tt.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w800),
                  ),
                ),
              const SizedBox(height: 12),
              ExpansionTile(
                tilePadding: EdgeInsets.zero,
                title: Text('Титулы', style: tt.titleMedium),
                children: [
                  for (var i = 0; i < kTitles.length; i++)
                    ListTile(
                      dense: true,
                      leading: Icon(
                        level >= i + 1
                            ? Icons.check_circle
                            : Icons.lock_outline,
                        color: level >= i + 1 ? cs.primary : cs.outline,
                      ),
                      title: Text(
                        kTitles[i],
                        style: TextStyle(
                          color: level >= i + 1 ? cs.onSurface : cs.outline,
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
              const SizedBox(height: 12),
              Text('Последние игры', style: tt.titleMedium),
              const SizedBox(height: 6),
              if (appState.history.isEmpty)
                Text('Пока нет сыгранных игр', style: tt.bodyMedium)
              else
                for (final r in appState.history.take(10))
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('${r.difficulty.label} · ${r.score} очков'),
                    subtitle: Text(
                      '${r.correct} верно, ${r.wrong} ошибок · ${_fmt(r.date)}',
                    ),
                  ),
            ],
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
