import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pos/src/blocs/home/bloc.dart';
import 'package:pos/src/screens/home/home.dart';
import 'package:pos/src/screens/pos_selection/pos_selection_page.dart';
import 'package:pos/src/splash/splash.dart';
import 'package:wom_package/wom_package.dart';
import 'localization/app_localizations.dart';

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
    authenticationBloc.add(AppStarted());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
            create: (context) => authenticationBloc),
        BlocProvider<HomeBloc>(
          create: (context) => homeBloc,
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
        home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          bloc: authenticationBloc,
          builder: (BuildContext context, AuthenticationState state) {
            if (state is AuthenticationUninitialized) {
              return SplashScreen();
            } else if (state is AuthenticationAuthenticated) {
              user = state.user;
              user.merchants = List.generate(
                4,
                (i) => Merchant(
                  id: 'id_$i',
                  name: 'name_$i',
                  address: 'address_$i',
                  cap: 'cap_$i',
                  city: 'city_$i',
                  vatNumber: 'vat_$i',
                  profileImgUrl: 'img_$i',
                  posList: List.generate(
                    5,
                    (index) => Pos('id_$index', 'm_$i: name_$index',
                        'url_$index', 'privateKey_$index', [12.2, 10.3]),
                  ),
                ),
              );
              homeBloc.user = user;
//              homeBloc.add(LoadPos())

              return Navigator(
                initialRoute: PosSelectionPage.routeName,
                onGenerateRoute: (RouteSettings settings) {
                  final route = settings.name;
                  if (route == HomeScreen.routeName) {
                    return MaterialPageRoute(builder: (BuildContext context) {
                      return FeatureDiscovery(child: HomeScreen());
                    });
                  } else {
                    return MaterialPageRoute(builder: (BuildContext context) {
                      return PosSelectionPage();
                    });
                  }
                },
              );
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
