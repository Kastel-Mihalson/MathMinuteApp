import 'package:flutter/material.dart';

/// Цвет верного ответа.
const Color kGreen = Color(0xFF2FBF71);

/// Цвет ошибки.
const Color kRed = Color(0xFFEF4B4B);

/// Светлая и тёмная темы строятся из одного базового цвета.
ThemeData buildTheme(Brightness brightness) {
  final scheme = ColorScheme.fromSeed(
    seedColor: const Color(0xFF5B5BD6),
    brightness: brightness,
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: scheme.surface,
    appBarTheme: AppBarTheme(
      backgroundColor: scheme.surface,
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
  );
}
