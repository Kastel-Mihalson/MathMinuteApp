import 'dart:async';

import 'package:audioplayers/audioplayers.dart';

import 'app_state.dart';

/// Звуковые эффекты. Любая ошибка звука игнорируется, игра от неё не страдает.
/// Для каждого звука создаётся новый плеер, который удаляется после
/// воспроизведения: так звук не зависит от состояния предыдущего.
class Sfx {
  Sfx._();

  /// Последняя ошибка воспроизведения (показывается в профиле для диагностики).
  static String? lastError;

  /// Заранее загружает звуковые файлы, чтобы первый сигнал не запаздывал.
  static Future<void> warmUp() async {
    try {
      await AudioCache.instance.loadAll(
        const ['sounds/correct.wav', 'sounds/wrong.wav'],
      );
    } catch (_) {}
  }

  static void correct() => _play('sounds/correct.wav');

  static void wrong() => _play('sounds/wrong.wav');

  static Future<void> _play(String asset) async {
    if (!appState.soundEnabled) return;
    AudioPlayer? player;
    try {
      final p = AudioPlayer();
      player = p;
      var released = false;
      Future<void> release() async {
        if (released) return;
        released = true;
        try {
          await p.dispose();
        } catch (_) {}
      }

      p.onPlayerComplete.listen((_) => release());
      // На случай, если сигнал завершения не придёт.
      Timer(const Duration(seconds: 4), release);
      await p.play(AssetSource(asset));
    } catch (e) {
      lastError = 'Звук: $e';
      try {
        await player?.dispose();
      } catch (_) {}
    }
  }
}
