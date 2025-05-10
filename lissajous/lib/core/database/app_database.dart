import 'package:hive_flutter/hive_flutter.dart';

class AppDatabase {
  static const _boxName = 'appBox';
  static Box<bool>? _box; // Используем nullable вместо late

  // Проверка инициализации Box
  static Future<Box<bool>> _ensureBox() async {
    if (_box == null || !_box!.isOpen) {
      _box = await Hive.openBox<bool>(_boxName);
    }
    return _box!;
  }

  // Инициализация Hive
  static Future<void> init() async {
    await Hive.initFlutter();
    await _ensureBox(); // Открываем Box при инициализации
  }

  // Получить текущую тему
  static Future<bool> getAppTheme() async {
    final box = await _ensureBox();
    return box.get('theme', defaultValue: false) ?? false;
  }

  // Сохранить тему
  static Future<void> setAppTheme(bool isDarkTheme) async {
    final box = await _ensureBox();
    await box.put('theme', isDarkTheme);
  }

  // Закрыть Box
  static Future<void> closeBox() async {
    if (_box != null && _box!.isOpen) {
      await _box!.close();
    }
  }
}
