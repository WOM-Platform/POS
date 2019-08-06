import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pos/app.dart';
import 'package:wom_package/wom_package.dart'
    show Flavor, Config, UserRepository, UserType;
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

void main() {
  Config.appFlavor = Flavor.RELEASE;
  FlutterError.onError = Crashlytics.instance.recordFlutterError;
  runApp(App(userRepository: UserRepository(UserType.POS)));
}
