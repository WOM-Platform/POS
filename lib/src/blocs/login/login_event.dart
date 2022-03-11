import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  LoginEvent([List props = const []]);
}

class LoginButtonPressed extends LoginEvent {
  final String username;
  final String password;

  LoginButtonPressed({
    required this.username,
    required this.password,
  }) : super([username, password]);

  @override
  String toString() =>
      'LoginButtonPressed { username: $username, password: $password }';

  @override
  List<Object> get props => [username, password];
}

class AnonymousLogin extends LoginEvent {
  @override
  String toString() => 'AnonymousLogin { }';

  @override
  List<Object> get props => [];
}
