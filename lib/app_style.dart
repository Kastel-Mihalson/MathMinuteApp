/// Стили оформления приложения. У каждого есть светлая и тёмная версия.
enum AppStyle { classic, neon, forest, space }

extension AppStyleInfo on AppStyle {
  String get label => switch (this) {
        AppStyle.classic => 'Классика',
        AppStyle.neon => 'Неон',
        AppStyle.forest => 'Лес',
        AppStyle.space => 'Космос',
      };

  String get description => switch (this) {
        AppStyle.classic => 'Фиолетовый градиент',
        AppStyle.neon => 'Свечение и аркада',
        AppStyle.forest => 'Спокойные природные тона',
        AppStyle.space => 'Тёмно-синий и золото',
      };
}
