import 'dart:async';

import 'package:dart_wom_connector/dart_wom_connector.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pos/src/blocs/authentication/bloc.dart';
import 'package:pos/src/blocs/login/bloc.dart';
import 'package:pos/src/offers/application/offers.dart';
import 'package:pos/src/services/user_repository.dart';
import '../../my_logger.dart';
import '../../utils.dart';
import 'login_event.dart';
import 'login_state.dart';

final loginProvider =
    StateNotifierProvider.autoDispose<LoginBloc, LoginState>((ref) {
  return LoginBloc(ref: ref);
});

const anonymousEmail = 'anonymous@email.com';
const anonymousPassword = 'password';

class LoginBloc extends StateNotifier<LoginState> {
  final Ref ref;
  POSUser? user;

  LoginBloc({
    required this.ref,
  }) : super(LoginInitial());

  Future anonymousLogin() async {
    logger.i('anonimo');
    user = await getAnonymousUser(ref.read(getPosProvider));
    await ref.read(authNotifierProvider.notifier).logIn(
          LoggedIn(
            user: user!,
            email: anonymousEmail,
            password: anonymousPassword,
            token:anonymousToken,
          ),
        );
    state = LoginSuccessfull();
  }

  Future login(LoginButtonPressed event) async {
    logger.i('login');
    state = LoginLoading();
    try {
      final token = await ref.read(userRepositoryProvider).authenticate(
            username: event.username,
            password: event.password,
          );

      user = await ref.read(userRepositoryProvider).getUser(token);
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
        await ref.read(authNotifierProvider.notifier).logIn(
              LoggedIn(
                user: user!,
                email: event.username,
                password: event.password,
                token: token
              ),
            );
        state = LoginSuccessfull();
      }
    } catch (ex, stack) {
      logger.e(ex);
      logger.e(stack);
      state = LoginFailure(error: "Username e/o password non validi!");
    }
  }
}
