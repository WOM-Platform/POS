import 'package:equatable/equatable.dart';
import 'package:pos/src/model/payment_request.dart';
import 'package:meta/meta.dart';

abstract class HomeState extends Equatable {
  HomeState([List props = const []]);
}

class RequestLoading extends HomeState {
  @override
  List<Object> get props => [];
}

class RequestLoaded extends HomeState {
  final List<PaymentRequest> requests;

  RequestLoaded({@required this.requests}) : super([requests]);

  RequestLoaded copyWith({
    List<PaymentRequest> requests,
  }) {
    return RequestLoaded(
      requests: requests ?? this.requests,
    );
  }

  @override
  List<Object> get props => [requests];
}

class RequestsLoadingErrorState extends HomeState {
  final String error;

  RequestsLoadingErrorState(this.error) : super([error]);

  @override
  String toString() => "RequestsLoadingErrorState";

  @override
  List<Object> get props => [error];
}

class NoDataConnectionState extends HomeState {
  @override
  String toString() => 'NoDataConnectionState';

  @override
  List<Object> get props => [];
}

class NoPosState extends HomeState {
  @override
  String toString() => 'NoPosState';

  @override
  List<Object> get props => [];
}
