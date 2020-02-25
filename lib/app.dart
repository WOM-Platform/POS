import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pos/src/blocs/home/bloc.dart';
import 'package:pos/src/splash/splash.dart';
import 'package:pos/src/utils.dart';
import 'package:wom_package/wom_package.dart';
import 'localization/app_localizations.dart';
import 'src/screens/home/home.dart';

//class App extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return BlocProvider(
//      bloc: HomeBloc(),
//      child: MaterialApp(
//          theme: ThemeData(
//            primaryColor: Colors.orange,
//            backgroundColor: Colors.red,
////        canvasColor: backgroundColor,
//          ),
//          home: SplashScreen(),
//          routes: {
////          '/': (context) => SplashScreen(),
////          '/home': (context) {
////            final homeProvider =
////                BlocProvider<HomeBloc>(child: HomeScreen(), bloc: HomeBloc());
////            return homeProvider;
////          },
////          '/generate': (context) {
////            return BlocProvider<CreatePaymentRequestBloc>(
////              child: GenerateWomScreen(),
////              bloc: CreatePaymentRequestBloc(),
////            );
////          },
////          '/intro': (context) {
////            return IntroScreen();
////          },
////          '/settings': (context) {
////            final settingsProvider = myBlocProvider.BlocProvider(
////                child: SettingsScreen(), bloc: SettingsBloc());
////            return settingsProvider;
////          },
//          }),
//    );
//  }
//}

User user;

class App extends StatefulWidget {
  final UserRepository userRepository;

  App({Key key, @required this.userRepository}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  AuthenticationBloc authenticationBloc;
  HomeBloc homeBloc;

  UserRepository get userRepository => widget.userRepository;

  @override
  void initState() {
    homeBloc = HomeBloc();
    authenticationBloc = AuthenticationBloc(userRepository: userRepository);
    authenticationBloc.dispatch(AppStarted());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProviderTree(
      blocProviders: [
        BlocProvider<AuthenticationBloc>(
            builder: (context) => authenticationBloc),
        BlocProvider<HomeBloc>(
          builder: (context) => homeBloc,
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
        home: BlocBuilder<AuthenticationEvent, AuthenticationState>(
          bloc: authenticationBloc,
          builder: (BuildContext context, AuthenticationState state) {
            if (state is AuthenticationUninitialized) {
              return SplashScreen();
            } else if (state is AuthenticationAuthenticated) {
              userRepository.readUser().then((res) => user = res);
              return FeatureDiscovery(child: HomeScreen());
            } else if (state is AuthenticationUnauthenticated) {
              user = null;
              return LoginScreen(userRepository: userRepository);
            }
            return Container(
              child: Center(
                child: Text(AppLocalizations.of(context)
                    .translate('error_screen_state')),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
