import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dart_wom_connector/dart_wom_connector.dart';
import 'package:flutter/material.dart';
import 'package:pos/src/blocs/authentication/bloc.dart';
import 'package:pos/src/services/user_repository.dart';
import '../../my_logger.dart';
import '../../utils.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Cubit<LoginState> {
  final UserRepository userRepository;
  final AuthenticationBloc authenticationBloc;
  POSUser? user;

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  LoginBloc({
    required this.userRepository,
    required this.authenticationBloc,
  })  : super(LoginInitial()) {
    userRepository.readEmail().then((value) {
      usernameController.text = value ?? '';
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
    authenticationBloc
        .logIn(LoggedIn(user: user!, email: user!.email, password: 'password'));
    emit(LoginSuccessfull());
  }

  login(LoginButtonPressed event) async {
    print('login');
    emit(LoginLoading());
    try {
      user = await userRepository.authenticate(
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
        emit(InsufficientPos());
      } else {
        authenticationBloc.logIn(LoggedIn(
            user: user!, email: event.username, password: event.password));
        emit(LoginSuccessfull());
      }
    } catch (ex, stack) {
      logger.e(ex);
      logger.e(stack);
      emit(LoginFailure(error: "Username e/o password non validi!"));
    }
  }

  @override
  Future<void> close() {
    usernameController.dispose();
    passwordController.dispose();
    return super.close();
  }
}
