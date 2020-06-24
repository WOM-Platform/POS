import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:wom_package/wom_package.dart' show RequestVerificationResponse;

abstract class WomCreationEvent extends Equatable {
  WomCreationEvent([List props = const []]);
}

class CreateWomRequest extends WomCreationEvent {
  @override
  List<Object> get props => [];
}

class VerifyWomCreationRequest extends WomCreationEvent {
  final RequestVerificationResponse response;

  VerifyWomCreationRequest({@required this.response})
      : assert(response != null),
        super([response]);

  @override
  List<Object> get props => [response];
}
