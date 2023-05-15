import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pos/src/model/flavor_enum.dart';
import 'package:pos/src/my_logger.dart';
import 'package:pos/src/utils.dart';
import 'package:pos/app.dart';
import 'package:stack_trace/stack_trace.dart' as stack_trace;
import 'src/constants.dart';

bool isFirstOpen = false;

Future<void> mainCommon(Flavor f, String d) async {
  FlutterError.demangleStackTrace = (StackTrace stack) {
    if (stack is stack_trace.Trace) return stack.vmTrace;
    if (stack is stack_trace.Chain) return stack.toTrace().vmTrace;
    return stack;
  };

  flavor = f;
  domain = d;
  logger.i('FLAVOR: $f');
  logger.i('DOMAIN: $d');
  registryKey = await getPublicKey(f);
  isFirstOpen = await readIsFirstOpen();
  if (isFirstOpen) {
    await setIsFirstOpen(true);
  }
  runApp(
    ProviderScope(
      child: App(
        isFirstOpen: isFirstOpen,
      ),
    ),
  );
}
