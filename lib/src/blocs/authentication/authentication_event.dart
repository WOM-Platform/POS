import 'package:dart_wom_connector/dart_wom_connector.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class AuthenticationEvent extends Equatable {
  AuthenticationEvent([List props = const []]);
}

class AppStarted extends AuthenticationEvent {
  @override
  String toString() => 'AppStarted';

  @override
  List<Object> get props => [];
}

class LoggedIn extends AuthenticationEvent {
//  final String publicKey;
//  final String privateKey;
  final POSUser user;
  final String email;
  final String password;
  final String token;

  LoggedIn({
    required this.user,
    required this.email,
    required this.password,
    required this.token,
  }) : super([user]);

  @override
  String toString() => 'LoggedIn { name : ${user.name} }';

  @override
  List<Object> get props => [
        user,
        email,
        password,
        token,
      ];
}

class LoggedOut extends AuthenticationEvent {
  @override
  String toString() => 'LoggedOut';

  @override
  List<Object> get props => [];
}
