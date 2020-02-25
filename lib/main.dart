import 'package:flutter/material.dart';
import 'package:wom_package/wom_package.dart' show Flavor, Config;
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import 'main_common.dart';

void main() async {
  Config.appFlavor = Flavor.RELEASE;
  FlutterError.onError = Crashlytics.instance.recordFlutterError;
  await mainCommon();
}
