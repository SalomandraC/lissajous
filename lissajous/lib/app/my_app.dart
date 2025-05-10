import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:lissajous/app/models/app_model.dart';
import 'package:lissajous/app/state/app_model_provider.dart';
import 'package:lissajous/nav_bar/domain/presentation/widgets/main_navigation.dart';

class LissajousApp extends StatelessWidget {
  final AppModel appModel;

  const LissajousApp({super.key, required this.appModel});

  @override
  Widget build(BuildContext context) {
    return AppModelProvider(
      notifier: appModel,
      child: Builder(
        builder: (context) {
          final model = AppModelProvider.of(context);

          return MaterialApp(
            title: 'Lissajous App',
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: model.isDarkTheme ? ThemeMode.dark : ThemeMode.light,
            locale: model.locale,
            supportedLocales: const [
              Locale('ru', 'RU'),
              Locale('en', 'US'),
            ],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: const MainNavigation(),
          );
        },
      ),
    );
  }
}
