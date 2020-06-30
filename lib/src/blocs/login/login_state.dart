import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  LoginState([List props = const []]);
}

class LoginInitial extends LoginState {
  @override
  String toString() => 'LoginInitial';

  @override
  List<Object> get props => [];
}

class LoginLoading extends LoginState {
  @override
  String toString() => 'LoginLoading';
  @override
  List<Object> get props => [];
}

class LoginSuccessfull extends LoginState {
  @override
  String toString() => 'LoginSuccessfull';

  @override
  List<Object> get props => [];
}

class LoginFailure extends LoginState {
  final String error;

  LoginFailure({@required this.error}) : super([error]);

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'LoginFailure { error: $error }';
}
