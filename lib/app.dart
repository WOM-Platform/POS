import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:pos/src/screens/root/root.dart';
import 'localization/app_localizations.dart';
import 'src/screens/intro/intro.dart';


class App extends StatelessWidget {
  final bool isFirstOpen;

  const App({Key? key, this.isFirstOpen = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        localeResolutionCallback: (locale, supportedLocales) {
          if (locale == null) {
            Intl.defaultLocale = supportedLocales.first.toString();
            return supportedLocales.first;
          }

          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale.languageCode &&
                supportedLocale.countryCode == locale.countryCode) {
              Intl.defaultLocale = supportedLocale.toString();
              return supportedLocale;
            }
          }
          Intl.defaultLocale = supportedLocales.first.toString();
          return supportedLocales.first;
        },
        supportedLocales: const [
          Locale('en', 'US'),
          Locale('it', 'IT'),
        ],
        theme: ThemeData(
          primaryColor: Colors.blue,
          accentColor: Colors.yellow,
        ),
        home: isFirstOpen ? IntroScreen() : RootScreen(),
      ),
    );
  }
}
