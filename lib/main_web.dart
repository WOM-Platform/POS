import 'package:flutter/material.dart';
import 'package:pos/app.dart';
import 'package:wom_package/wom_package.dart'
    show Flavor, Config, UserRepository, UserType;
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import 'src/screens/home/home.dart';

void main() {
  Config.appFlavor = Flavor.RELEASE;
  FlutterError.onError = Crashlytics.instance.recordFlutterError;
  runApp(MaterialApp(
    home: HomeScreen(),
  ));
}
