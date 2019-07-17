import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wom_package/wom_package.dart'
    show UserRepository, UserType, Config, Flavor;

import 'app.dart';

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }
}

void main() {
  Config.appFlavor = Flavor.DEVELOPMENT;

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
    statusBarColor: Colors.red,
  ));

  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(App(
    userRepository: UserRepository(UserType.POS),
  ));
}
