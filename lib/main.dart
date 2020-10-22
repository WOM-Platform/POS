import 'package:flutter/material.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:bloc/bloc.dart';
import 'package:pos/src/model/flavor_enum.dart';
import 'package:pos/src/my_logger.dart';
import 'main_common.dart';

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    logger.i('${bloc.runtimeType} -> $transition');
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    logger.i('${bloc.runtimeType} -> $error');
  }

  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    logger.i('${bloc.runtimeType} -> $event');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterError.onError = Crashlytics.instance.recordFlutterError;
  BlocSupervisor.delegate = SimpleBlocDelegate();
  await mainCommon(Flavor.RELEASE, 'wom.social');
}
