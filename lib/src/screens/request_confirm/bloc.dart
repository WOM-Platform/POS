
import 'package:dart_wom_connector/dart_wom_connector.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:pos/src/db/payment_database/payment_database.dart';
import 'package:pos/src/model/payment_request.dart';
import 'package:pos/src/model/request_status_enum.dart';
import 'package:pos/src/screens/request_confirm/wom_creation_event.dart';
import 'package:pos/src/screens/request_confirm/wom_creation_state.dart';
import 'package:meta/meta.dart';

import '../../constants.dart';
import '../../my_logger.dart';

final requestConfirmNotifierProvider =
    StateNotifierProvider<RequestConfirmBloc, WomCreationState>((ref) {
  throw UnimplementedError();
});

final paymentRequestProvider = Provider<PaymentRequest>((ref) {
  throw UnimplementedError();
});

class RequestConfirmBloc extends StateNotifier<WomCreationState> {
  final PosClient pos;
  late PaymentDatabase _requestDb;

  final Ref ref;
  final PointOfSale pointOfSale;

  RequestConfirmBloc({
    required this.pointOfSale,
    required this.ref,
    required this.pos,
  }) : super(WomCreationRequestEmpty()) {
    // _repository = PaymentRegistrationRepository();
    _requestDb = PaymentDatabase.get();
    createWomRequest(CreateWomRequest());
  }

  insertRequestOnDb(PaymentRequest paymentRequest) async {
    try {
      final paymentRequest = ref.read(paymentRequestProvider);
      if (paymentRequest.id == null) {
        int id = await _requestDb.insertRequest(paymentRequest);
        paymentRequest.id = id;
        logger.i(paymentRequest.id);
      } else {
        await _requestDb.updateRequest(paymentRequest);
      }
    } catch (ex) {
      logger.i("insertRequestOnDb $ex");
    }
  }

  createWomRequest(CreateWomRequest createWomRequest) async {
    state = WomCreationRequestLoading();
    final paymentRequest = ref.read(paymentRequestProvider);
    if (await InternetConnectionChecker().hasConnection) {
      // final RequestVerificationResponse response = await _repository
      //     .generateNewPaymentRequest(paymentRequest, pointOfSale);
      try {
        final response = await pos.requestPayment(
            paymentRequest.toPayload(), pointOfSale.privateKey);

        paymentRequest.deepLink =
            DeepLinkBuilder(response.otc, TransactionType.PAYMENT).build();
        paymentRequest.status = RequestStatus.COMPLETE;
        // paymentRequest.registryUrl = response.registryUrl;
        await insertRequestOnDb(paymentRequest.copyFrom(password: response.password));
        state = WomVerifyCreationRequestComplete(response: response);
      } on ServerException catch (ex, stack) {
        logger.e('${ex.url}: ${ex.statusCode} => ${ex.error}');
        logger.e(stack);
        paymentRequest.status = RequestStatus.DRAFT;
        insertRequestOnDb(paymentRequest);
        state = WomCreationRequestError(error: ex.error);
      } catch (ex) {
        logger.e(ex);
        paymentRequest.status = RequestStatus.DRAFT;
        insertRequestOnDb(paymentRequest);
        state = WomCreationRequestError();
      }
    } else {
      state = WomCreationRequestNoDataConnectionState();
    }
  }
}

class DeepLinkBuilder {
  final String otc;
  final TransactionType type;

//  final String baseUrl;

  DeepLinkBuilder(this.otc, this.type);

  String build() {
    final link =
        "https://$domain/${type.toString().toLowerCase().replaceAll("transactiontype.", "")}/$otc";
    logger.i(link);
    return link;
  }
}
