import 'dart:async';

import 'package:dart_wom_connector/dart_wom_connector.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pos/src/blocs/authentication/bloc.dart';
import 'package:pos/src/blocs/login/bloc.dart';
import 'package:pos/src/services/user_repository.dart';
import '../../my_logger.dart';
import '../../utils.dart';
import 'login_event.dart';
import 'login_state.dart';

final loginProvider = StateNotifierProvider.autoDispose<LoginBloc, LoginState>((ref) {
  return LoginBloc(ref: ref);
});

class LoginBloc extends StateNotifier<LoginState> {
  final Ref ref;
  POSUser? user;

  // final usernameController = TextEditingController();
  // final passwordController = TextEditingController();

  LoginBloc({
    required this.ref,
  })  : super(LoginInitial()) {
    ref.read(userRepositoryProvider).readEmail().then((value) {
      // usernameController.text = value ?? '';
    });
  }

  anonymousLogin() async {
    print('anonymousLogin');
    // if (user == null) return;/**/
    logger.i('anonimo');
    final key = await getAnonymousPrivateKey();
    user = POSUser(
      name: 'Anonymous',
      surname: 'Anonymous',
      email: '',
      merchants: [
        Merchant(
          id: 'anonymousId',
          posList: [
            PointOfSale(
              id: '5f69a60698e66631aaf79929',
              name: 'Anonymous',
              privateKey: key,
              latitude: 0.0,
              longitude: 0.0,
              isActive: true,
            )
          ],
          fiscalCode: '',
          city: '',
          name: '',
          zipCode: '',
          country: '',
          address: '',
        )
      ],
    );
    ref.read(authNotifierProvider.notifier)
        .logIn(LoggedIn(user: user!, email: user!.email, password: 'password'));
    state = LoginSuccessfull();
  }

  login(LoginButtonPressed event) async {
    print('login');
    state = LoginLoading();
    try {
      user = await ref.read(userRepositoryProvider).authenticate(
        username: event.username,
        password: event.password,
      );

      if (user == null) return;

      logger.i(user?.name);
      logger.i(user?.merchants.length);
      if (user!.merchants.isEmpty ||
          user!.merchants.fold<int>(
                  0,
                  (int previousValue, Merchant element) =>
                      previousValue + (element.posList.length)) ==
              0) {
        state = InsufficientPos();
      } else {
        ref.read(authNotifierProvider.notifier).logIn(LoggedIn(
            user: user!, email: event.username, password: event.password));
        state = LoginSuccessfull();
      }
    } catch (ex, stack) {
      logger.e(ex);
      logger.e(stack);
      state = LoginFailure(error: "Username e/o password non validi!");
    }
  }
}
