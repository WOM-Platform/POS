import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pos/src/model/flavor_enum.dart';
import 'package:pos/src/my_logger.dart';
import 'package:pos/src/utils.dart';
import 'package:pos/app.dart';

import 'src/constants.dart';

bool isFirstOpen = false;

Future<void> mainCommon(Flavor f, String d) async {
  flavor = f;
  domain = d;
  logger.i('FLAVOR: $f');
  logger.i('DOMAIN: $d');
  registryKey = await getPublicKey(f);
  isFirstOpen = await readIsFirstOpen();
  if (isFirstOpen) {
    await setIsFirstOpen(false);
  }
  runApp(App(isFirstOpen: isFirstOpen));
}