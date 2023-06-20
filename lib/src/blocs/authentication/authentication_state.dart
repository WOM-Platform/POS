import 'package:dart_wom_connector/dart_wom_connector.dart';
import 'package:equatable/equatable.dart';

abstract class AuthenticationState extends Equatable {}

class AuthenticationUninitialized extends AuthenticationState {
  @override
  String toString() => 'AuthenticationUninitialized';

  @override
  List<Object> get props => [];
}

class AuthenticationAuthenticated extends AuthenticationState {
  final POSUser user;
  final String token;
  final bool emailVerified;

  // final String password;

  AuthenticationAuthenticated(
    this.user,
    this.token,
    this.emailVerified,
  );

  @override
  String toString() => 'AuthenticationAuthenticated';

  @override
  List<Object> get props => [user, token];
}

class AuthenticationEmailNotVerified extends AuthenticationState {
  final String email;
  final String password;
  final String userId;
  final String token;

  AuthenticationEmailNotVerified(
      this.email, this.password, this.userId, this.token);

  @override
  String toString() => 'AuthenticationEmailNotVerified';

  @override
  List<Object> get props => [];
}

class AuthenticationUnauthenticated extends AuthenticationState {
  @override
  String toString() => 'AuthenticationUnauthenticated';

  @override
  List<Object> get props => [];
}

class AuthenticationLoading extends AuthenticationState {
  @override
  String toString() => 'AuthenticationLoading';

  @override
  List<Object> get props => [];
}
