import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pos/localization/app_localizations.dart';
import 'package:pos/src/blocs/authentication/bloc.dart';
import 'package:pos/src/blocs/login/bloc.dart';
import 'package:pos/src/screens/login/login_screen.dart';
import 'package:pos/src/services/user_repository.dart';
import 'package:pos/src/splash/splash.dart';

import '../../../app.dart';
import '../home/home.dart';

class RootScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(authNotifierProvider);
    if (state is AuthenticationUninitialized) {
      return SplashScreen();
    } else if (state is AuthenticationAuthenticated) {
//          user.merchants = List.generate(
//            4,
//            (i) => Merchant(
//              id: 'id_$i',
//              name: 'name_$i',
//              address: 'address_$i',
//              zipCode: 'cap_$i',
//              city: 'city_$i',
//              fiscalCode: 'vat_$i',
//              profileImgUrl: 'img_$i',
//              posList: List.generate(
//                5,
//                (index) => Pos('id_$index', 'm_$i: name_$index', 'url_$index',
//                    'privateKey_$index', [12.2, 10.3]),
//              ),
//            ),
//          );

      return FeatureDiscovery(child: HomeScreen());
      /*  return Navigator(
            initialRoute: HomeScreen.routeName,
            onGenerateRoute: (RouteSettings settings) {
              final route = settings.name;
              if (route == HomeScreen.routeName) {
                return MaterialPageRoute(builder: (BuildContext context) {
                  return FeatureDiscovery(child: HomeScreen());
                });
              } else {
                return MaterialPageRoute(builder: (BuildContext context) {
                  return PosSelectionPage();
                });
              }
            },
          );*/
    } else if (state is AuthenticationUnauthenticated) {
      return LoginScreen();
    }
    return Center(
      child: Text(
          AppLocalizations.of(context)?.translate('error_screen_state') ?? ''),
    );
  }
}
