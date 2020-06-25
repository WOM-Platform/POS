import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pos/src/blocs/home/bloc.dart';
import 'package:pos/src/screens/root/root.dart';
import 'package:wom_package/wom_package.dart';
import 'localization/app_localizations.dart';
import 'src/screens/intro/intro.dart';
import 'package:provider/provider.dart';

User user;

class App extends StatelessWidget {
  final bool isFirstOpen;
  final UserRepository userRepository;
  const App({Key key, this.isFirstOpen, this.userRepository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        RepositoryProvider(
          create: (BuildContext context) => UserRepository(UserType.POS),
        ),
        BlocProvider<AuthenticationBloc>(
          create: (context) => AuthenticationBloc(
            userRepository: RepositoryProvider.of<UserRepository>(context),
          )..add(AppStarted()),
        ),
        BlocProvider<HomeBloc>(
          create: (context) => HomeBloc(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        localeResolutionCallback: (locale, supportedLocales) {
          if (locale == null) {
            return supportedLocales.first;
          }

          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale.languageCode &&
                supportedLocale.countryCode == locale.countryCode) {
              return supportedLocale;
            }
          }
          return supportedLocales.first;
        },
        supportedLocales: [
          const Locale('en', 'US'),
          const Locale('it', 'IT'),
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
