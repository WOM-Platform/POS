import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:wom_package/wom_package.dart';

abstract class WomCreationEvent extends Equatable {
  WomCreationEvent([List props = const []]) : super(props);
}

class CreateWomRequest extends WomCreationEvent {}

class VerifyWomCreationRequest extends WomCreationEvent {
  final RequestVerificationResponse response;

  VerifyWomCreationRequest({@required this.response})
      : assert(response != null),
        super([response]);
}
