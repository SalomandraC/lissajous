import 'package:flutter/material.dart';
import 'package:lissajous/app/state/app_model_provider.dart';
import 'package:lissajous/core/global_widgets/gradient_appbar.dart';
import 'package:lissajous/settings/presentation/components/small_switch_list_tile.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = true;
  bool biometricEnabled = false;

  final Map<String, String> languageOptions = {
    'ru': 'Русский',
    'en': 'English',
  };

  @override
  Widget build(BuildContext context) {
    final appModel = AppModelProvider.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: GradientAppBar(
        title: _getLocalizedTitle(appModel.languageCode),
        isDarkTheme: appModel.isDarkTheme,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSectionHeader(theme,
              _getLocalizedString('basic_settings', appModel.languageCode)),
          _buildSettingsCard(
            children: [
              SmallSwitchListTile(
                title: Text(
                  _getLocalizedString('dark_theme', appModel.languageCode),
                  style: theme.textTheme.bodyMedium,
                ),
                value: appModel.isDarkTheme,
                onChanged: (value) async {
                  await appModel.setAppTheme(value);
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.language),
                title: Text(
                  _getLocalizedString('language', appModel.languageCode),
                  style: theme.textTheme.bodyMedium,
                ),
                subtitle: Text(
                  _getLocalizedString('choose_language', appModel.languageCode),
                  style: theme.textTheme.bodySmall,
                ),
                trailing: DropdownButton<String>(
                  value: appModel.languageCode,
                  onChanged: (String? newValue) async {
                    if (newValue != null) {
                      await appModel.setLanguage(newValue);
                      if (mounted) setState(() {});
                    }
                  },
                  items: [
                    DropdownMenuItem(
                      value: 'ru',
                      child: Text(languageOptions['ru']!),
                    ),
                    DropdownMenuItem(
                      value: 'en',
                      child: Text(languageOptions['en']!),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSectionHeader(
              theme, _getLocalizedString('about_app', appModel.languageCode)),
          _buildSettingsCard(
            children: [
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: Text(
                  _getLocalizedString('app_version', appModel.languageCode),
                  style: theme.textTheme.bodyMedium,
                ),
                subtitle: Text(
                  "1.0.0",
                  style: theme.textTheme.bodySmall,
                ),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.help_outline),
                title: Text(
                  _getLocalizedString('help', appModel.languageCode),
                  style: theme.textTheme.bodyMedium,
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  String _getLocalizedTitle(String languageCode) {
    return languageCode == 'ru' ? 'Настройки' : 'Settings';
  }

  String _getLocalizedString(String key, String languageCode) {
    final ruTranslations = {
      'basic_settings': 'Основные',
      'dark_theme': 'Тёмная тема',
      'language': 'Язык',
      'choose_language': 'Выберите язык интерфейса',
      'notifications': 'Уведомления',
      'biometric_auth': 'Биометрическая аутентификация',
      'about_app': 'О приложении',
      'app_version': 'Версия приложения',
      'help': 'Помощь',
    };

    final enTranslations = {
      'basic_settings': 'Basic',
      'dark_theme': 'Dark theme',
      'language': 'Language',
      'choose_language': 'Choose interface language',
      'notifications': 'Notifications',
      'biometric_auth': 'Biometric authentication',
      'about_app': 'About app',
      'app_version': 'App version',
      'help': 'Help',
    };

    return languageCode == 'ru'
        ? ruTranslations[key] ?? key
        : enTranslations[key] ?? key;
  }

  Widget _buildSectionHeader(ThemeData theme, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSettingsCard({required List<Widget> children}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSwitchListTile({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return _buildSettingsCard(
      children: [
        SwitchListTile(
          title: Text(title),
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
