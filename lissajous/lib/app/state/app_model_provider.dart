import 'package:flutter/material.dart';
import 'package:lissajous/app/models/app_model.dart';

class AppModelProvider extends InheritedNotifier<AppModel> {
  const AppModelProvider({
    super.key,
    required super.notifier,
    required super.child,
  });

  /// Получает [AppModel] из контекста.
  ///
  /// Кидает [FlutterError], если [AppModelProvider] не найден выше по дереву.
  static AppModel of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<AppModelProvider>();
    assert(provider != null, 'No AppModelProvider found in context');
    return provider!.notifier!;
  }
}
