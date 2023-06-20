import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pos/src/model/flavor_enum.dart';
import 'main_common.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  // FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  await Hive.initFlutter();
  await Hive.openBox('settings');
  await mainCommon(Flavor.RELEASE, 'wom.social');
}
