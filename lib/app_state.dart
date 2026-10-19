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
        date: DateTime.fromMillisecondsSinceEpoch(j['d'] as int),
        difficulty: Difficulty.values[j['df'] as int],
        correct: j['c'] as int,
        wrong: j['w'] as int,
        bestStreak: j['s'] as int,
      );
}

/// Всё состояние приложения: настройки, профиль и статистика.
/// Хранится локально на устройстве.
class AppState extends ChangeNotifier {
  SharedPreferences? _prefs;

  ThemeMode themeMode = ThemeMode.system;
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

  int _index(int? value, int length) =>
      (value == null || value < 0 || value >= length) ? 0 : value;

  Future<void> load() async {
    final p = await SharedPreferences.getInstance();
    _prefs = p;
    themeMode = ThemeMode.values[_index(p.getInt('theme'), 3)];
    name = p.getString('name') ?? 'Игрок';
    difficulty = Difficulty.values[_index(p.getInt('difficulty'), 3)];
    xp = p.getInt('xp') ?? 0;
    games = p.getInt('games') ?? 0;
    correct = p.getInt('correct') ?? 0;
    wrong = p.getInt('wrong') ?? 0;
    bestStreak = p.getInt('bestStreak') ?? 0;

    final best = p.getStringList('best');
    if (best != null && best.length == 3) {
      bestScores = best.map((e) => int.tryParse(e) ?? 0).toList();
    }

    final raw = p.getStringList('history') ?? [];
    final parsed = <GameRecord>[];
    for (final s in raw) {
      try {
        parsed.add(GameRecord.fromJson(jsonDecode(s) as Map<String, dynamic>));
      } catch (_) {
        // Повреждённая запись — пропускаем.
      }
    }
    history = parsed;
  }

  Future<void> _save() async {
    final p = _prefs;
    if (p == null) return;
    await p.setInt('theme', themeMode.index);
    await p.setString('name', name);
    await p.setInt('difficulty', difficulty.index);
    await p.setInt('xp', xp);
    await p.setInt('games', games);
    await p.setInt('correct', correct);
    await p.setInt('wrong', wrong);
    await p.setInt('bestStreak', bestStreak);
    await p.setStringList('best', bestScores.map((e) => '$e').toList());
    await p.setStringList(
      'history',
      history.map((r) => jsonEncode(r.toJson())).toList(),
    );
  }

  void setThemeMode(ThemeMode mode) {
    themeMode = mode;
    notifyListeners();
    _save();
  }

  void setDifficulty(Difficulty d) {
    difficulty = d;
    notifyListeners();
    _save();
  }

  void setName(String value) {
    name = value;
    notifyListeners();
    _save();
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
