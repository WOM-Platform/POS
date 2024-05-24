import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization_loader/easy_localization_loader.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:pos/src/model/flavor_enum.dart';
import 'package:pos/src/my_logger.dart';
import 'package:pos/src/utils.dart';
import 'package:pos/app.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
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

  // If in debug mode, start the app without Sentry
  if (kDebugMode) {
    // Override the default error handling to prevent silent errors
    // from being displayed in the console.
    //
    // In debug mode, we mimic the behavior of not reporting silent errors
    // to Sentry by customizing the error handling process.
    FlutterError.onError = (details) {
      if (details.silent) return;
      FlutterError.presentError(details);
    };

    return startApp();
  }

  Logger.addLogListener((event) {
    if (event.level == Level.error) {
      Sentry.captureException(
        event.error,
        stackTrace: event.stackTrace,
      );
    }
  });

  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://74c982bb694757ca6f4323a667e94f68@o1180190.ingest.us.sentry.io/4506858126311424';
      // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
      // We recommend adjusting this value in production.
      options.tracesSampleRate = 1.0;
      options.debug = !kReleaseMode;
      options.tracesSampler = (_) => 1.0;
      options.environment = f.name;
    },
    appRunner: () => startApp(),
  );
}

startApp() {
  runApp(
    ProviderScope(
      child: EasyLocalization(
        child: App(
          isFirstOpen: isFirstOpen,
        ),
        supportedLocales: [
          Locale('en'),
          Locale('it'),
        ],
        path: 'assets/translations',
        assetLoader: JsonAssetLoader(),
      ),
    ),
  );
}
