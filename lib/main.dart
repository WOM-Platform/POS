import 'package:flutter/material.dart';
import 'package:wom_package/wom_package.dart' show Flavor, Config;
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:bloc/bloc.dart';
import 'main_common.dart';

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }
}

void main() async {
  Config.appFlavor = Flavor.RELEASE;
  FlutterError.onError = Crashlytics.instance.recordFlutterError;
  BlocSupervisor.delegate = SimpleBlocDelegate();
  await mainCommon();
}
