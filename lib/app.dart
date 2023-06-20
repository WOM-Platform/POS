import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pos/src/offers/ui/create_new_offer/new_offer.dart';
import 'package:pos/src/pos_handler/ui/screens/pos_manager.dart';
import 'package:pos/src/screens/create_payment/pages/position_selection/position_selection_page.dart';

import 'package:pos/src/screens/root/root.dart';
import 'package:pos/src/screens/settings/settings.dart';
import 'package:pos/src/services/aim_repository.dart';
import 'package:pos/src/signup/ui/screens/create_merchant.dart';
import 'package:pos/src/signup/ui/screens/email_verification.dart';
import 'package:pos/src/signup/ui/screens/sign_up.dart';

final _router = GoRouter(
  debugLogDiagnostics: kDebugMode,
  routes: [
    GoRoute(
      path: RootScreen.path,
      builder: (context, state) => RootScreen(),
      routes: [
        GoRoute(
          path: SignUpScreen.path,
          builder: (context, state) => SignUpScreen(),
        ),
        GoRoute(
          path: EmailVerificationScreen.path,
          builder: (context, state) => EmailVerificationScreen(),
        ),
        GoRoute(
          path: NewOfferScreen.path,
          builder: (context, state) => NewOfferScreen(),
        ),
        GoRoute(
          path: SettingsScreen.path,
          builder: (context, state) => SettingsScreen(),
          routes: [
            GoRoute(
              path: POSManagerScreen.path,
              builder: (context, state) => POSManagerScreen(),
              routes: [
                GoRoute(
                  path: CreateMerchantScreen.path,
                  builder: (context, state) => CreateMerchantScreen(),
                ),
              ]
            ),
          ]
        ),

        GoRoute(
          path: PositionSelectionPage.path,
          builder: (context, state) => PositionSelectionPage(),
        ),
      ]
    ),
  ],
);

class App extends ConsumerWidget {
  final bool isFirstOpen;

  const App({Key? key, this.isFirstOpen = false}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(aimFlatListFutureProvider, (previous, next) {});
    return MaterialApp.router(
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      localeResolutionCallback: (locale, supportedLocales) {
        if (locale == null) {
          Intl.defaultLocale = supportedLocales.first.toString();
          return supportedLocales.first;
        }

        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode &&
              supportedLocale.countryCode == locale.countryCode) {
            Intl.defaultLocale = supportedLocale.toString();
            return supportedLocale;
          }
        }
        Intl.defaultLocale = supportedLocales.first.toString();
        return supportedLocales.first;
      },
      theme: ThemeData(
        primaryColor: Colors.blue,
        // accentColor: Colors.yellow,
      ),
      // home: isFirstOpen ? IntroScreen() : RootScreen(),
    );
  }
}
