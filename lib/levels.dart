import 'dart:math';

/// Титулы по уровням. Уровень 1 — «Первооткрыватель», 10 — «Непоколебимый».
const List<String> kTitles = [
  'Первооткрыватель', // 1
  'Любопытный', // 2
  'Ученик', // 3
  'Счетовод', // 4
  'Внимательный', // 5
  'Быстрый ум', // 6
  'Упорный', // 7
  'Стратег', // 8
  'Вычислитель', // 9
  'Непоколебимый', // 10
  'Мастер счёта', // 11
  'Молниеносный', // 12
  'Аналитик', // 13
  'Виртуоз', // 14
  'Хладнокровный', // 15
  'Гроссмейстер', // 16
  'Математик', // 17
  'Мудрец', // 18
  'Феномен', // 19
  'Легенда', // 20 и выше
];

/// Сколько всего опыта (XP) нужно, чтобы достичь уровня [level].
/// 1 → 0, 2 → 200, 3 → 600, 10 → 9000, 20 → 38000.
int xpForLevel(int level) => 100 * (level - 1) * level;

int levelFromXp(int xp) {
  var level = 1;
  while (xp >= xpForLevel(level + 1)) {
    level++;
  }
  return level;
}

String titleForLevel(int level) {
  final index = max(1, min(level, kTitles.length));
  return kTitles[index - 1];
}

/// Доля прохождения текущего уровня, от 0.0 до 1.0.
double levelProgress(int xp) {
  final level = levelFromXp(xp);
  final start = xpForLevel(level);
  final end = xpForLevel(level + 1);
  return (xp - start) / (end - start);
}
