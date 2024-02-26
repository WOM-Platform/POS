import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pos/src/create_new_pos/ui/create_pos_screen.dart';
import 'package:pos/src/offers/ui/create_new_offer/bounds_selector_screen.dart';
import 'package:pos/src/offers/ui/create_new_offer/new_offer.dart';
import 'package:pos/src/pos_handler/ui/screens/pos_manager.dart';
import 'package:pos/src/screens/password/request_reset_password.dart';
import 'package:pos/src/screens/password/reset_password.dart';

import 'package:pos/src/screens/root/root.dart';
import 'package:pos/src/screens/settings/settings.dart';
import 'package:pos/src/services/aim_repository.dart';
import 'package:pos/src/signup/ui/screens/create_merchant.dart';
import 'package:pos/src/signup/ui/screens/email_verification.dart';
import 'package:pos/src/signup/ui/screens/sign_up.dart';

//wompos://process/verify?email=d.ifrancescogianmarco@gmail.com&token=T0YDD4P9
final _router = GoRouter(
  debugLogDiagnostics: kDebugMode,
  routes: [
    GoRoute(
      path: RootScreen.path,
      builder: (context, state) => RootScreen(),
      routes: [
        GoRoute(
          path: RequestResetPasswordScreen.path,
          builder: (context, state) => RequestResetPasswordScreen(),
        ),
        GoRoute(
          path: 'password/:code',
          builder: (context, state) => Container(
            child: Text('No'),
          ),
        ),
        // GoRoute(
        //     path: ResetPasswordScreen.path,
        //     builder: (context, state) => ResetPasswordScreen(),
        //     routes: [
        //       GoRoute(
        //         path: 'password/:code',
        //         builder: (context, state) =>
        //             ResetPasswordScreen(code:state.pathParameters['code']),
        //       ),
        //     ]),
        GoRoute(
          path: ResetPasswordScreen.path,
          builder: (context, state) => ResetPasswordScreen(
              email: state.queryParameters['email'] as String,
              code: state.queryParameters['token']),
        ),
        GoRoute(
          path: SignUpScreen.path,
          builder: (context, state) => SignUpScreen(),
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
                    path: '${CreatePOSScreen.path}/:merchantId',
                    builder: (context, state) => CreatePOSScreen(
                        merchantId: state.pathParameters['merchantId'] as String),
                  ),
                ],
              ),
            ]),
        GoRoute(
          path: PositionSelectionPage.path,
          builder: (context, state) => PositionSelectionPage(),
        ),
      ],
    ),
    GoRoute(
      path: '/${EmailVerificationScreen.path}',
      builder: (context, state) => EmailVerificationScreen(
        email: state.queryParameters['email'],
        code: state.queryParameters['token'],
      ),
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
        useMaterial3: false,
        primaryColor: Colors.blue,
        // accentColor: Colors.yellow,
      ),
      // home: isFirstOpen ? IntroScreen() : RootScreen(),
    );
  }
}
