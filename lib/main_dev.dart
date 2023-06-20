import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pos/src/model/flavor_enum.dart';
import 'package:pos/src/my_logger.dart';
import 'main_common.dart';

// class SimpleBlocDelegate extends BlocDelegate {
//   @override
//   void onTransition(Bloc bloc, Transition transition) {
//     super.onTransition(bloc, transition);
//     logger.i(transition);
//   }
// }

void main() async {
  logger.i("DEV VERSION");
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
    statusBarColor: Colors.red,
  ));
  await Hive.initFlutter();
  await Hive.openBox('settings');
  // BlocSupervisor.delegate = SimpleBlocDelegate();
  await mainCommon(Flavor.DEVELOPMENT, 'dev.wom.social');
}
