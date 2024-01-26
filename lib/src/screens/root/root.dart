import 'package:easy_localization/easy_localization.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pos/src/blocs/authentication/bloc.dart';
import 'package:pos/src/screens/login/login_screen.dart';
import 'package:pos/src/signup/ui/screens/create_merchant.dart';
import 'package:pos/src/signup/ui/screens/email_verification.dart';
import 'package:pos/src/splash/splash.dart';

import '../home/home.dart';

class RootScreen extends ConsumerWidget {
  static const String path = '/';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(authNotifierProvider);
    return switch (state) {
      AuthenticationUninitialized() => SplashScreen(),
      AuthenticationAuthenticated() when state.user.merchants.isEmpty =>
        CreateMerchantScreen(),
      AuthenticationAuthenticated() => FeatureDiscovery(child: HomeScreen()),
      AuthenticationEmailNotVerified(email: final email) =>
        EmailVerificationScreen(email: email),
      AuthenticationUnauthenticated() => LoginScreen(),
      _ => Center(
          child: Text(
            'error_screen_state'.tr(),
          ),
        )
    };
  }
}
