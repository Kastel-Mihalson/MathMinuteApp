import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app_state.dart';
import '../game/problem.dart';
import '../sound.dart';
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
    final isRecord =
        record.score > appState.bestScores[record.difficulty.index];
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
    Sfx.correct();
    setState(() {
      _locked = true;
      _correct++;
      _streak++;
      if (_streak > _bestStreak) _bestStreak = _streak;
      _flash = kGreen;
    });
    _flashTimer = Timer(const Duration(milliseconds: 220), () {
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
    Sfx.wrong();
    setState(() {
      _locked = true;
      _wrong++;
      _streak = 0;
      _flash = kRed;
    });
    _flashTimer = Timer(const Duration(milliseconds: 420), () {
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
        padding: const EdgeInsets.all(6),
        child: _KeyButton(
          label: label,
          icon: icon,
          onTap: onTap ?? () => _onDigit(label),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final secs = (_remainingMs / 1000).ceil();
    final low = _running && secs <= 10;
    final flash = _flash;
    final exprColor = flash ?? cs.onSurface;
    final answerColor = flash ?? (_input.isEmpty ? cs.outline : cs.primary);

    return AppBackground(
      child: Scaffold(
      backgroundColor: Colors.transparent,
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
                    icon: const Icon(Icons.close_rounded),
                  ),
                  const Spacer(),
                  Text(
                    '$secs',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w800,
                      color: low ? kRed : cs.onSurface,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    constraints: const BoxConstraints(minWidth: 48),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: kGreen.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      '$_correct',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: kGreen,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: _remainingMs / totalMs,
                  minHeight: 8,
                  color: low ? kRed : cs.primary,
                  backgroundColor: cs.primary.withValues(alpha: 0.12),
                ),
              ),
              Expanded(
                flex: 4,
                child: Center(
                  child: _countdown > 0
                      ? Text(
                          '$_countdown',
                          style: TextStyle(
                            fontSize: 120,
                            fontWeight: FontWeight.w800,
                            color: cs.primary,
                          ),
                        )
                      : _buildProblemCard(exprColor, answerColor),
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
      ),
    );
  }

  Widget _buildProblemCard(Color exprColor, Color answerColor) {
    final flash = _flash;
    final card = cardColorOf(context);

    // Тряска при ошибке: ключ меняется с каждой ошибкой и запускает анимацию.
    return TweenAnimationBuilder<double>(
      key: ValueKey<int>(_wrong),
      tween: Tween<double>(begin: _wrong == 0 ? 1 : 0, end: 1),
      duration: const Duration(milliseconds: 380),
      builder: (context, t, child) {
        final dx = sin(t * pi * 5) * 12 * (1 - t);
        return Transform.translate(offset: Offset(dx, 0), child: child);
      },
      child: AnimatedScale(
        scale: flash == kGreen ? 1.05 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 28),
          decoration: BoxDecoration(
            color: flash == null ? card : flash.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: flash ?? Colors.transparent,
              width: 2.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_streak >= 3)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(
                    '🔥 серия $_streak',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  '${_problem.text} =',
                  style: TextStyle(
                    fontSize: 62,
                    fontWeight: FontWeight.w800,
                    color: exprColor,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                _input.isEmpty ? '?' : _input,
                style: TextStyle(
                  fontSize: 46,
                  fontWeight: FontWeight.w700,
                  color: answerColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Круглая клавиша цифрового набора.
class _KeyButton extends StatelessWidget {
  const _KeyButton({required this.label, required this.onTap, this.icon});

  final String label;
  final IconData? icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Material(
      color: cardColorOf(context),
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.18),
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Center(
          child: icon != null
              ? Icon(icon, size: 28, color: cs.onSurfaceVariant)
              : Text(
                  label,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                    color: cs.onSurface,
                  ),
                ),
        ),
      ),
    );
  }
}
