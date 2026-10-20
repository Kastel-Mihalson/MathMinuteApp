import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'game/problem.dart';
import 'levels.dart';

/// Результат одной сыгранной минуты.
class GameRecord {
  const GameRecord({
    required this.date,
    required this.difficulty,
    required this.correct,
    required this.wrong,
    required this.bestStreak,
  });

  final DateTime date;
  final Difficulty difficulty;
  final int correct;
  final int wrong;
  final int bestStreak;

  int get score => correct * difficulty.points;

  double get accuracy =>
      (correct + wrong) == 0 ? 0 : correct / (correct + wrong);

  Map<String, dynamic> toJson() => {
        'd': date.millisecondsSinceEpoch,
        'df': difficulty.index,
        'c': correct,
        'w': wrong,
        's': bestStreak,
      };

  factory GameRecord.fromJson(Map<String, dynamic> j) => GameRecord(
        date: DateTime.fromMillisecondsSinceEpoch((j['d'] as num).toInt()),
        difficulty: Difficulty.values[(j['df'] as num).toInt()],
        correct: (j['c'] as num).toInt(),
        wrong: (j['w'] as num).toInt(),
        bestStreak: (j['s'] as num).toInt(),
      );
}

/// Всё состояние приложения: настройки, профиль и статистика.
/// Хранится локально на устройстве одной JSON-строкой.
class AppState extends ChangeNotifier {
  static const String _key = 'minutka_state_v1';

  SharedPreferences? _prefs;

  /// Если не удалось прочитать или записать данные — здесь текст ошибки.
  /// Он показывается в профиле, чтобы проблему было видно.
  String? storageWarning;

  ThemeMode themeMode = ThemeMode.system;
  bool soundEnabled = true;
  String name = 'Игрок';
  Difficulty difficulty = Difficulty.easy;

  int xp = 0;
  int games = 0;
  int correct = 0;
  int wrong = 0;
  int bestStreak = 0;
  List<int> bestScores = [0, 0, 0];
  List<GameRecord> history = [];

  int get level => levelFromXp(xp);
  String get title => titleForLevel(level);
  double get accuracy =>
      (correct + wrong) == 0 ? 0 : correct / (correct + wrong);
  double get avgCorrectPerGame => games == 0 ? 0 : correct / games;

  int _int(dynamic v, [int fallback = 0]) => v is num ? v.toInt() : fallback;

  int _index(dynamic v, int length) {
    final i = _int(v);
    return (i < 0 || i >= length) ? 0 : i;
  }

  Map<String, dynamic> _toJson() => {
        'theme': themeMode.index,
        'sound': soundEnabled,
        'name': name,
        'difficulty': difficulty.index,
        'xp': xp,
        'games': games,
        'correct': correct,
        'wrong': wrong,
        'bestStreak': bestStreak,
        'best': bestScores,
        'history': history.map((r) => r.toJson()).toList(),
      };

  void _fromJson(Map<String, dynamic> j) {
    themeMode = ThemeMode.values[_index(j['theme'], 3)];
    soundEnabled = j['sound'] != false;
    final n = j['name'];
    name = (n is String && n.isNotEmpty) ? n : 'Игрок';
    difficulty = Difficulty.values[_index(j['difficulty'], 3)];
    xp = _int(j['xp']);
    games = _int(j['games']);
    correct = _int(j['correct']);
    wrong = _int(j['wrong']);
    bestStreak = _int(j['bestStreak']);

    final best = j['best'];
    if (best is List && best.length == 3) {
      bestScores = best.map((e) => _int(e)).toList();
    }

    final parsed = <GameRecord>[];
    final raw = j['history'];
    if (raw is List) {
      for (final item in raw) {
        try {
          parsed.add(GameRecord.fromJson(item as Map<String, dynamic>));
        } catch (_) {
          // Повреждённая запись — пропускаем.
        }
      }
    }
    history = parsed;
  }

  Future<void> load() async {
    try {
      final p = await SharedPreferences.getInstance();
      _prefs = p;
      final raw = p.getString(_key);
      if (raw != null) {
        _fromJson(jsonDecode(raw) as Map<String, dynamic>);
      }
    } catch (e) {
      storageWarning = 'Не удалось загрузить данные: $e';
    }
  }

  Future<void> _save() async {
    try {
      var p = _prefs;
      // Если при запуске хранилище не открылось — пробуем ещё раз.
      p ??= _prefs = await SharedPreferences.getInstance();
      final ok = await p.setString(_key, jsonEncode(_toJson()));
      if (ok) {
        if (storageWarning != null) {
          storageWarning = null;
          notifyListeners();
        }
      } else {
        storageWarning = 'Устройство отказалось сохранить данные';
        notifyListeners();
      }
    } catch (e) {
      storageWarning = 'Не удалось сохранить данные: $e';
      notifyListeners();
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    themeMode = mode;
    notifyListeners();
    await _save();
  }

  Future<void> setSoundEnabled(bool value) async {
    soundEnabled = value;
    notifyListeners();
    await _save();
  }

  Future<void> setDifficulty(Difficulty d) async {
    difficulty = d;
    notifyListeners();
    await _save();
  }

  Future<void> setName(String value) async {
    name = value;
    notifyListeners();
    await _save();
  }

  /// Сохраняет результат игры и начисляет опыт (XP = очки).
  Future<void> addGame(GameRecord r) async {
    xp += r.score;
    games++;
    correct += r.correct;
    wrong += r.wrong;
    if (r.bestStreak > bestStreak) bestStreak = r.bestStreak;
    final i = r.difficulty.index;
    if (r.score > bestScores[i]) bestScores[i] = r.score;
    history.insert(0, r);
    if (history.length > 20) history = history.sublist(0, 20);
    notifyListeners();
    await _save();
  }
}

final AppState appState = AppState();
