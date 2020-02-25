import 'package:flutter/material.dart';
import 'package:pos/src/utils.dart';
import 'package:wom_package/wom_package.dart';
import 'package:pos/app.dart';

bool isFirstOpen = false;

Future<void> mainCommon() async {
  WidgetsFlutterBinding.ensureInitialized();
  isFirstOpen = await readIsFirstOpen();
  if (isFirstOpen) {
    await setIsFirstOpen(false);
  }
  runApp(App(userRepository: UserRepository(UserType.POS)));
}
