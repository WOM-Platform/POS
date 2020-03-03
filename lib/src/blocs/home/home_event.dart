import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  HomeEvent([List props = const []]) : super(props);
}

class LoadRequest extends HomeEvent {
//  final String id;
//
//  LoadRequest(this.id);

  @override
  String toString() => 'LoadRequest';
}

class LoadPos extends HomeEvent {
//  final User user;
//
//  LoadPos(this.user);

  @override
  String toString() => 'LoadPos';
}
