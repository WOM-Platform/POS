import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos/src/screens/home/bloc.dart';
import 'package:pos/src/splash/splash.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: HomeBloc(),
      child: MaterialApp(
          theme: ThemeData(
            primaryColor: Colors.orange,
            backgroundColor: Colors.red,
//        canvasColor: backgroundColor,
          ),
          home: SplashScreen(),
          routes: {
//          '/': (context) => SplashScreen(),
//          '/home': (context) {
//            final homeProvider =
//                BlocProvider<HomeBloc>(child: HomeScreen(), bloc: HomeBloc());
//            return homeProvider;
//          },
//          '/generate': (context) {
//            return BlocProvider<CreatePaymentRequestBloc>(
//              child: GenerateWomScreen(),
//              bloc: CreatePaymentRequestBloc(),
//            );
//          },
//          '/intro': (context) {
//            return IntroScreen();
//          },
//          '/settings': (context) {
//            final settingsProvider = myBlocProvider.BlocProvider(
//                child: SettingsScreen(), bloc: SettingsBloc());
//            return settingsProvider;
//          },
          }),
    );
  }
}
