import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pos/src/utils.dart';
import 'package:pos/app.dart';

bool isFirstOpen = false;

Future<void> mainCommon() async {
  WidgetsFlutterBinding.ensureInitialized();
  isFirstOpen = await readIsFirstOpen();
  if (isFirstOpen) {
    await setIsFirstOpen(false);
  }
  runApp(DevicePreview(
    enabled: !kReleaseMode,
    builder: (BuildContext context) => App(isFirstOpen: isFirstOpen),
  ));
}
