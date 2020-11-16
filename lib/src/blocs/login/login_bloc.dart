import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dart_wom_connector/dart_wom_connector.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:pos/src/blocs/authentication/bloc.dart';
import 'package:pos/src/services/user_repository.dart';
import '../../my_logger.dart';
import '../../utils.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository userRepository;
  final AuthenticationBloc authenticationBloc;
  User user;

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  LoginBloc({
    @required this.userRepository,
    @required this.authenticationBloc,
  })  : assert(userRepository != null),
        assert(authenticationBloc != null) {
    userRepository.readEmail().then((value) {
      usernameController.text = value ?? '';
    });
  }

  LoginState get initialState => LoginInitial();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginButtonPressed) {
      yield LoginLoading();
      try {
        user = await userRepository.authenticate(
          username: event.username,
          password: event.password,
        );
        logger.i(user?.name);
        yield InsufficientPos();
        // if (user.merchants.isEmpty ||
        //     user.merchants.fold<int>(
        //             0,
        //             (previousValue, element) =>
        //                 previousValue + element.posList?.length ?? 0) ==
        //         0) {
        //   yield InsufficientPos();
        // } else {
        //   authenticationBloc.add(LoggedIn(
        //       user: user, email: event.username, password: event.password));
        //   yield LoginSuccessfull();
        // }
      } catch (ex) {
        logger.e(ex);
        yield LoginFailure(error: "Username e/o password non validi!");
      }
    } else if (event is AnonymousLogin) {
      logger.i('anonimo');
      final key = await getAnonymousPrivateKey();
      user = User(
        name: 'Anonymous',
        surname: 'Anonymous',
        email: '',
        merchants: [
          Merchant(
            id: 'anonymousId',
            posList: [
              PointOfSale(
                '5f69a60698e66631aaf79929',
                'Anonymous',
                '-',
                key,
                [0.0, 0.0],
              )
            ],
          )
        ],
      );
      authenticationBloc
          .add(LoggedIn(user: user, email: user.email, password: 'password'));
      yield LoginSuccessfull();
    }
  }

  @override
  Future<void> close() {
    usernameController.dispose();
    passwordController.dispose();
    return super.close();
  }
}
