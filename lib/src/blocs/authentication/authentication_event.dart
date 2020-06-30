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
  final User user;
  final String email;
  final String password;

  LoggedIn({
    @required this.user,
    @required this.email,
    @required this.password,
  }) : super([user]);

  @override
  String toString() => 'LoggedIn { name : ${user.name} }';

  @override
  List<Object> get props => [user, email, password];
}

class LoggedOut extends AuthenticationEvent {
  @override
  String toString() => 'LoggedOut';

  @override
  List<Object> get props => [];
}
