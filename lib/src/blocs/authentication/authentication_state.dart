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
  final String email;
  final String password;

  AuthenticationAuthenticated(this.user, this.email, this.password);
  @override
  String toString() => 'AuthenticationAuthenticated';
  @override
  List<Object> get props => [user, email, password];
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
