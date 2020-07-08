import 'package:flutter/material.dart';
import 'package:wom_package/wom_package.dart' show Flavor, Config;
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:bloc/bloc.dart';
import 'main_common.dart';

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print('${bloc.runtimeType} -> $transition');
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    print('${bloc.runtimeType} -> $error');
  }

  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    print('${bloc.runtimeType} -> $event');
  }
}

void main() async {
  Config.appFlavor = Flavor.RELEASE;
  FlutterError.onError = Crashlytics.instance.recordFlutterError;
  BlocSupervisor.delegate = SimpleBlocDelegate();
  await mainCommon();
}
