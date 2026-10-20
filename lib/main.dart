import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_state.dart';
import 'screens/home_screen.dart';
import 'sound.dart';
import 'theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Если при построении экрана случится ошибка, показываем её текстом,
  // а не пустой/чёрный экран.
  ErrorWidget.builder = (details) => Directionality(
        textDirection: TextDirection.ltr,
        child: Material(
          color: Colors.white,
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Ошибка: ${details.exceptionAsString()}',
                style: const TextStyle(color: Colors.red, fontSize: 14),
              ),
            ),
          ),
        ),
      );

  // Не ждём результат: запуск приложения не должен зависеть от этого вызова.
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Окно появляется сразу, данные профиля загружаются уже внутри него.
  runApp(const MinutkaApp());
}

class MinutkaApp extends StatefulWidget {
  const MinutkaApp({super.key});

  @override
  State<MinutkaApp> createState() => _MinutkaAppState();
}

class _MinutkaAppState extends State<MinutkaApp> {
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _boot();
  }

  Future<void> _boot() async {
    try {
      await appState.load().timeout(const Duration(seconds: 5));
    } catch (_) {
      // Не удалось прочитать сохранённые данные: стартуем с настройками
      // по умолчанию, приложение при этом работает как обычно.
    }
    if (mounted) setState(() => _ready = true);
    // Готовим звуки заранее, чтобы первый сигнал не запаздывал.
    Sfx.warmUp();
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: buildTheme(Brightness.light),
        darkTheme: buildTheme(Brightness.dark),
        home: const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }
    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) => MaterialApp(
        title: 'Минутка',
        debugShowCheckedModeBanner: false,
        theme: buildTheme(Brightness.light),
        darkTheme: buildTheme(Brightness.dark),
        themeMode: appState.themeMode,
        home: const HomeScreen(),
      ),
    );
  }
}
