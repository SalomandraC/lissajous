import 'package:flutter/material.dart';
import 'package:lissajous/nav_bar/domain/state/navbar_model.dart';
import 'package:lissajous/nav_bar/domain/state/navbar_model_provider.dart';
import 'package:lissajous/app/state/app_model_provider.dart';

class CurrentAppScreenWidget extends StatelessWidget {
  const CurrentAppScreenWidget({super.key});

  String _getLocalizedString(String key, String languageCode) {
    final ruTranslations = {
      'home': 'Информация',
      'task': 'Построение фигур',
      'settings': 'Настройки',
    };

    final enTranslations = {
      'home': 'Info',
      'task': 'Create a figure',
      'settings': 'Settings',
    };

    return languageCode == 'ru'
        ? ruTranslations[key] ?? key
        : enTranslations[key] ?? key;
  }

  @override
  Widget build(BuildContext context) {
    final NavbarModel model = NavbarModelProvider.of(context)!.model;
    final appModel = AppModelProvider.of(context);
    final languageCode = appModel.languageCode;

    return Scaffold(
      bottomNavigationBar: NavigationBar(
        height: 70,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.info_outlined),
            label: _getLocalizedString('home', languageCode),
          ),
          NavigationDestination(
            icon: const Icon(Icons.create),
            label: _getLocalizedString('task', languageCode),
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings),
            label: _getLocalizedString('settings', languageCode),
          ),
        ],
        onDestinationSelected: (value) => model.changeItem(value),
        selectedIndex: model.currentIndex,
      ),
      body: model.getCurrentPage(),
    );
  }
}
