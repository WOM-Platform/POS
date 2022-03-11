import 'package:dart_wom_connector/dart_wom_connector.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class WomCreationState extends Equatable {
  WomCreationState([List props = const []]);
}

class WomCreationRequestEmpty extends WomCreationState {
  @override
  List<Object> get props => [];
}

class WomCreationRequestLoading extends WomCreationState {
  @override
  List<Object> get props => [];
}

class WomCreationRequestComplete extends WomCreationState {
  @override
  List<Object> get props => [];
}

class WomCreationRequestError extends WomCreationState {
  final String? error;
  WomCreationRequestError({this.error});

  @override
  List<Object?> get props => [error];
}

class WomVerifyCreationRequestLoading extends WomCreationState {
  @override
  List<Object> get props => [];
}

class WomVerifyCreationRequestComplete extends WomCreationState {
  final PaymentRequestResponse response;

  WomVerifyCreationRequestComplete({required this.response})
      : assert(response != null),
        super([response]);
  @override
  String toString() => 'WomVerifyCreationRequestComplete';

  @override
  List<Object> get props => [response];
}

class WomVerifyCreationRequestError extends WomCreationState {
  final String error;
  WomVerifyCreationRequestError({required this.error});
  @override
  String toString() => 'WomVerifyCreationRequestError';

  @override
  List<Object> get props => [error];
}

class WomCreationRequestNoDataConnectionState extends WomCreationState {
  @override
  String toString() => 'WomCreationRequestNoDataConnectionState';
  @override
  List<Object> get props => [];
}
