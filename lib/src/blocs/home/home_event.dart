import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  HomeEvent([List props = const []]);
}

class LoadRequest extends HomeEvent {
  @override
  String toString() => 'LoadRequest';

  @override
  List<Object> get props => [];
}
