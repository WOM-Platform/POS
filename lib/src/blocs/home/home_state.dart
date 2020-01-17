import 'package:equatable/equatable.dart';
import 'package:pos/src/model/payment_request.dart';
import 'package:meta/meta.dart';

abstract class HomeState extends Equatable {
  HomeState([List props = const []]) : super(props);
}

class RequestLoading extends HomeState {}

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
}

class RequestsLoadingErrorState extends HomeState {
  final String error;

  RequestsLoadingErrorState(this.error) : super([error]);

  @override
  String toString() => "RequestsLoadingErrorState";
}

class NoDataConnectionState extends HomeState {
  @override
  String toString() => 'NoDataConnectionState';
}
