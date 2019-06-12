import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:wom_package/wom_package.dart';

abstract class WomCreationState extends Equatable {
  WomCreationState([List props = const []]) : super(props);
}

class WomCreationRequestEmpty extends WomCreationState {}

class WomCreationRequestLoading extends WomCreationState {}

class WomCreationRequestComplete extends WomCreationState {
}

class WomCreationRequestError extends WomCreationState {
  final String error;
  WomCreationRequestError({this.error});
}

class WomVerifyCreationRequestLoading extends WomCreationState {}

class WomVerifyCreationRequestComplete extends WomCreationState {
  final RequestVerificationResponse response;

  WomVerifyCreationRequestComplete({@required this.response})
      : assert(response != null),
        super([response]);
}

class WomVerifyCreationRequestError extends WomCreationState {
  final String error;
  WomVerifyCreationRequestError({this.error});
}
