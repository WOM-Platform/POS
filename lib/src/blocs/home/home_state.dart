import 'package:pos/src/model/payment_request.dart';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_state.freezed.dart';

@freezed
class HomeState with _$HomeState {

  const factory HomeState.requestLoading() = RequestLoading;
  const factory HomeState.noDataConnectionState() = NoDataConnectionState;
  const factory HomeState.noPosState() = NoPosState;
  const factory HomeState.noMerchantState() = NoMerchantState;

  const factory HomeState.requestLoaded(
      {required List<PaymentRequest> requests}) = RequestLoaded;

  const factory HomeState.requestsLoadingErrorState(String error) = RequestsLoadingErrorState;
  const factory HomeState.error(Object error, StackTrace st) = HomeStateError;
}

