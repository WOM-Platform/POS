import 'package:dart_wom_connector/dart_wom_connector.dart'
    show POSUser, PosClient;
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:pos/src/blocs/authentication/bloc.dart';
import 'package:pos/src/blocs/home/bloc.dart';
import 'package:pos/src/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos/src/screens/root/root.dart';
import 'package:pos/src/services/auth_local_data_sources.dart';
import 'localization/app_localizations.dart';
import 'src/screens/intro/intro.dart';

import 'src/services/user_repository.dart';

POSUser? globalUser;

class App extends StatelessWidget {
  final bool isFirstOpen;

  const App({Key? key, this.isFirstOpen = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<PosClient>(
          create: (BuildContext context) => PosClient(domain, registryKey),
        ),
        RepositoryProvider<UserRepository>(
          create: (BuildContext context) => UserRepository(
              context.read<PosClient>(), AuthLocalDataSourcesImpl()),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<HomeBloc>(
            create: (context) => HomeBloc(
              userRepository: context.read<UserRepository>(),
            ),
          ),
          BlocProvider<AuthenticationBloc>(
            create: (context) => AuthenticationBloc(
              homeBloc: context.read<HomeBloc>(),
              userRepository: context.read<UserRepository>(),
            )..startApp(),
          ),
        ],
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
      ),
    );
  }
}
