import 'dart:math';

enum Difficulty { easy, medium, hard }

extension DifficultyInfo on Difficulty {
  String get label => switch (this) {
        Difficulty.easy => 'Лёгкий',
        Difficulty.medium => 'Средний',
        Difficulty.hard => 'Сложный',
      };

  /// Очки за один верный ответ.
  int get points => switch (this) {
        Difficulty.easy => 10,
        Difficulty.medium => 20,
        Difficulty.hard => 30,
      };

  String get description => switch (this) {
        Difficulty.easy => 'Сложение и вычитание небольших чисел',
        Difficulty.medium =>
          'Сложение и вычитание двузначных чисел, таблица умножения',
        Difficulty.hard =>
          'Трёхзначные числа, умножение двузначных на однозначные, деление',
      };
}

class Problem {
  const Problem(this.text, this.answer);

  final String text;
  final int answer;
}

/// Генератор примеров. Ответ всегда целое неотрицательное число.
class ProblemGenerator {
  final Random _rnd = Random();
  String _last = '';

  int _between(int min, int max) => min + _rnd.nextInt(max - min + 1);

  Problem next(Difficulty difficulty) {
    Problem p;
    do {
      p = switch (difficulty) {
        Difficulty.easy => _easy(),
        Difficulty.medium => _medium(),
        Difficulty.hard => _hard(),
      };
    } while (p.text == _last);
    _last = p.text;
    return p;
  }

  Problem _easy() {
    if (_rnd.nextBool()) {
      final a = _between(1, 15);
      final b = _between(1, 15);
      return Problem('$a + $b', a + b);
    }
    final a = _between(5, 20);
    final b = _between(1, a);
    return Problem('$a − $b', a - b);
  }

  Problem _medium() {
    final kind = _rnd.nextInt(3);
    if (kind == 0) {
      final a = _between(10, 99);
      final b = _between(10, 99);
      return Problem('$a + $b', a + b);
    }
    if (kind == 1) {
      final a = _between(20, 99);
      final b = _between(10, a);
      return Problem('$a − $b', a - b);
    }
    final a = _between(2, 12);
    final b = _between(2, 12);
    return Problem('$a × $b', a * b);
  }

  Problem _hard() {
    final kind = _rnd.nextInt(4);
    if (kind == 0) {
      final a = _between(100, 999);
      final b = _between(100, 999);
      return Problem('$a + $b', a + b);
    }
    if (kind == 1) {
      final a = _between(200, 999);
      final b = _between(100, a);
      return Problem('$a − $b', a - b);
    }
    if (kind == 2) {
      final a = _between(12, 30);
      final b = _between(3, 9);
      return Problem('$a × $b', a * b);
    }
    final b = _between(3, 12);
    final q = _between(3, 20);
    return Problem('${b * q} ÷ $b', q);
  }
}
