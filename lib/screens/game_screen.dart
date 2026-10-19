import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app_state.dart';
import '../game/problem.dart';
import '../theme.dart';
import 'result_screen.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key, required this.difficulty});

  final Difficulty difficulty;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  /// Длительность игры всегда одна минута.
  static const int totalMs = 60000;

  final ProblemGenerator _gen = ProblemGenerator();
  final Stopwatch _watch = Stopwatch();
  late Problem _problem;

  String _input = '';
  int _correct = 0;
  int _wrong = 0;
  int _streak = 0;
  int _bestStreak = 0;
  int _countdown = 3;
  int _remainingMs = totalMs;

  bool _running = false;
  bool _locked = false;
  bool _finished = false;

  /// Цвет подсветки выражения: зелёный — верно, красный — ошибка.
  Color? _flash;

  Timer? _ticker;
  Timer? _flashTimer;

  @override
  void initState() {
    super.initState();
    _problem = _gen.next(widget.difficulty);
    _ticker = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_countdown > 1) {
        setState(() => _countdown--);
      } else {
        t.cancel();
        _begin();
      }
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _flashTimer?.cancel();
    _watch.stop();
    super.dispose();
  }

  void _begin() {
    setState(() {
      _countdown = 0;
      _running = true;
    });
    _watch.start();
    _ticker = Timer.periodic(const Duration(milliseconds: 100), (_) {
      final left = totalMs - _watch.elapsedMilliseconds;
      if (left <= 0) {
        _finish();
      } else {
        setState(() => _remainingMs = left);
      }
    });
  }

  Future<void> _finish() async {
    if (_finished) return;
    _finished = true;
    _ticker?.cancel();
    _flashTimer?.cancel();
    _watch.stop();

    final record = GameRecord(
      date: DateTime.now(),
      difficulty: widget.difficulty,
      correct: _correct,
      wrong: _wrong,
      bestStreak: _bestStreak,
    );
    final oldLevel = appState.level;
    final isRecord = record.score > appState.bestScores[record.difficulty.index];
    await appState.addGame(record);
    if (!mounted) return;

    HapticFeedback.mediumImpact();
    await Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => ResultScreen(
          record: record,
          oldLevel: oldLevel,
          isRecord: isRecord,
        ),
      ),
    );
  }

  void _onDigit(String digit) {
    if (!_running || _locked || _finished) return;
    final next = _input == '0' ? digit : _input + digit;
    final answer = '${_problem.answer}';
    setState(() => _input = next);
    if (next.length < answer.length) return;
    if (next == answer) {
      _onCorrect();
    } else {
      _onWrong();
    }
  }

  void _onBackspace() {
    if (!_running || _locked || _finished || _input.isEmpty) return;
    setState(() => _input = _input.substring(0, _input.length - 1));
  }

  void _onCorrect() {
    HapticFeedback.lightImpact();
    setState(() {
      _locked = true;
      _correct++;
      _streak++;
      if (_streak > _bestStreak) _bestStreak = _streak;
      _flash = kGreen;
    });
    _flashTimer = Timer(const Duration(milliseconds: 150), () {
      if (!mounted || _finished) return;
      setState(() {
        _problem = _gen.next(widget.difficulty);
        _input = '';
        _flash = null;
        _locked = false;
      });
    });
  }

  void _onWrong() {
    HapticFeedback.heavyImpact();
    setState(() {
      _locked = true;
      _wrong++;
      _streak = 0;
      _flash = kRed;
    });
    _flashTimer = Timer(const Duration(milliseconds: 350), () {
      if (!mounted || _finished) return;
      setState(() {
        _input = '';
        _flash = null;
        _locked = false;
      });
    });
  }

  Widget _key(String label, {IconData? icon, VoidCallback? onTap}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: FilledButton.tonal(
          style: FilledButton.styleFrom(
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          onPressed: onTap ?? () => _onDigit(label),
          child: icon != null
              ? Icon(icon, size: 30)
              : Text(
                  label,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final secs = (_remainingMs / 1000).ceil();
    final low = _running && secs <= 10;
    final exprColor = _flash ?? cs.onSurface;
    final answerColor =
        _flash ?? (_input.isEmpty ? cs.outline : cs.primary);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    tooltip: 'Выйти',
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                  const Spacer(),
                  Text(
                    '$secs',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: low ? kRed : cs.onSurface,
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: 48,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        '$_correct',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: kGreen,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: _remainingMs / totalMs,
                  minHeight: 8,
                  color: low ? kRed : cs.primary,
                ),
              ),
              Expanded(
                flex: 4,
                child: Center(
                  child: _countdown > 0
                      ? Text(
                          '$_countdown',
                          style: TextStyle(
                            fontSize: 110,
                            fontWeight: FontWeight.w800,
                            color: cs.primary,
                          ),
                        )
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                '${_problem.text} =',
                                style: TextStyle(
                                  fontSize: 64,
                                  fontWeight: FontWeight.w800,
                                  color: exprColor,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              _input.isEmpty ? '?' : _input,
                              style: TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.w700,
                                color: answerColor,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Column(
                  children: [
                    for (final row in const [
                      ['1', '2', '3'],
                      ['4', '5', '6'],
                      ['7', '8', '9'],
                    ])
                      Expanded(
                        child: Row(children: [for (final k in row) _key(k)]),
                      ),
                    Expanded(
                      child: Row(
                        children: [
                          _key('', icon: Icons.backspace_outlined, onTap: _onBackspace),
                          _key('0'),
                          const Expanded(child: SizedBox()),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
