import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_state.dart';
import 'theme.dart';

/// Резервная копия данных: копирование в буфер обмена и восстановление из него.
/// Помогает перенести статистику, если приложение пришлось переустановить.
class BackupCard extends StatelessWidget {
  const BackupCard({super.key});

  Future<void> _copy(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    await Clipboard.setData(ClipboardData(text: appState.exportData()));
    messenger.showSnackBar(
      const SnackBar(
        content: Text('Данные скопированы. Сохраните их в заметках или отправьте себе.'),
      ),
    );
  }

  Future<void> _restore(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final text = await showDialog<String>(
      context: context,
      builder: (_) => const _RestoreDialog(),
    );
    if (text == null || text.trim().isEmpty) return;
    final ok = await appState.importData(text);
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          ok
              ? 'Данные восстановлены'
              : 'Не удалось прочитать данные. Скопируйте текст целиком.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final pal = context.pal;
    return SoftCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Скопируйте данные перед удалением приложения и вставьте их после '
            'установки, чтобы вернуть уровень и статистику.',
            style: tt.bodyMedium,
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _copy(context),
                  icon: Icon(Icons.copy_rounded, color: pal.primary),
                  label: const Text('Скопировать'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _restore(context),
                  icon: Icon(Icons.restore_rounded, color: pal.primary),
                  label: const Text('Восстановить'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RestoreDialog extends StatefulWidget {
  const _RestoreDialog();

  @override
  State<_RestoreDialog> createState() => _RestoreDialogState();
}

class _RestoreDialogState extends State<_RestoreDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _paste() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data?.text != null) {
      setState(() => _controller.text = data!.text!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Восстановить данные'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Вставьте скопированный ранее текст. Текущие данные будут заменены.'),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            minLines: 3,
            maxLines: 5,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Вставьте данные сюда',
            ),
          ),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: _paste,
            icon: const Icon(Icons.content_paste_rounded),
            label: const Text('Вставить из буфера'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Отмена'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(_controller.text),
          child: const Text('Восстановить'),
        ),
      ],
    );
  }
}
