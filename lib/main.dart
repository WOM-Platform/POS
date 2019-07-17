import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pos/app.dart';
import 'package:wom_package/wom_package.dart'
    show Flavor, Config, UserRepository, UserType;

void main() {
  Config.appFlavor = Flavor.RELEASE;
  runApp(App(userRepository: UserRepository(UserType.POS)));
}
