import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AppModel extends ChangeNotifier {
  static const _boxName = 'settings';
  late final Box _box;

  bool _isDarkTheme = false;
  String _languageCode = 'ru';

  bool get isDarkTheme => _isDarkTheme;
  String get languageCode => _languageCode;
  Locale get locale => Locale(_languageCode);

  Future<void> init() async {
    _box = await Hive.openBox(_boxName);
    _isDarkTheme = _box.get('isDarkTheme', defaultValue: false);
    _languageCode = _box.get('languageCode', defaultValue: 'ru');
    notifyListeners();
  }

  Future<void> setAppTheme(bool isDark) async {
    _isDarkTheme = isDark;
    await _box.put('isDarkTheme', isDark);
    notifyListeners();
  }

  Future<void> setLanguage(String languageCode) async {
    _languageCode = languageCode;
    await _box.put('languageCode', languageCode);
    notifyListeners();
  }

  Future<void> close() async {
    await _box.close();
  }
}
