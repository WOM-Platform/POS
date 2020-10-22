import 'package:flutter/material.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:pos/src/model/flavor_enum.dart';

import 'src/constants.dart';
import 'src/screens/home/home.dart';

void main() {
  flavor = Flavor.RELEASE;
  FlutterError.onError = Crashlytics.instance.recordFlutterError;
  runApp(MaterialApp(
    home: HomeScreen(),
  ));
}
