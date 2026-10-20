import 'package:audioplayers/audioplayers.dart';

import 'app_state.dart';

/// Звуковые эффекты. Любая ошибка звука игнорируется, игра от неё не страдает.
class Sfx {
  static AudioPlayer? _ok;
  static AudioPlayer? _bad;

  static Future<AudioPlayer> _make() async {
    final p = AudioPlayer();
    await p.setPlayerMode(PlayerMode.lowLatency);
    return p;
  }

  static Future<AudioPlayer> _player(bool good) async {
    if (good) {
      return _ok ??= await _make();
    }
    return _bad ??= await _make();
  }

  /// Заранее создаёт плееры, чтобы первый звук не запаздывал.
  static Future<void> warmUp() async {
    try {
      await _player(true);
      await _player(false);
    } catch (_) {}
  }

  static void correct() => _play(true);

  static void wrong() => _play(false);

  static Future<void> _play(bool good) async {
    if (!appState.soundEnabled) return;
    try {
      final player = await _player(good);
      await player.play(
        AssetSource(good ? 'sounds/correct.wav' : 'sounds/wrong.wav'),
      );
    } catch (_) {}
  }
}
