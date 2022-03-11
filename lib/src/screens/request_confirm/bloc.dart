import 'package:bloc/bloc.dart';
import 'package:dart_wom_connector/dart_wom_connector.dart';
import 'package:flutter/foundation.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:pos/src/db/payment_database/payment_database.dart';
import 'package:pos/src/model/payment_request.dart';
import 'package:pos/src/model/request_status_enum.dart';
import 'package:pos/src/screens/request_confirm/wom_creation_event.dart';
import 'package:pos/src/screens/request_confirm/wom_creation_state.dart';
import 'package:meta/meta.dart';

import '../../constants.dart';
import '../../my_logger.dart';

class RequestConfirmBloc extends Cubit<WomCreationState> {
  PaymentRequest paymentRequest;

  final PosClient pos;
  late PaymentDatabase _requestDb;

  final PointOfSale pointOfSale;

  RequestConfirmBloc({
    required this.pointOfSale,
    required this.paymentRequest,
    required this.pos,
  }) : super(WomCreationRequestEmpty()) {
    // _repository = PaymentRegistrationRepository();
    _requestDb = PaymentDatabase.get();
    createWomRequest(CreateWomRequest());
  }

  insertRequestOnDb() async {
    try {
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
    emit(WomCreationRequestLoading());
    if (await InternetConnectionChecker().hasConnection) {
      // final RequestVerificationResponse response = await _repository
      //     .generateNewPaymentRequest(paymentRequest, pointOfSale);
      try {
        final response =
            await pos.requestPayment(paymentRequest, pointOfSale.privateKey);

        paymentRequest.deepLink =
            DeepLinkBuilder(response.otc, TransactionType.PAYMENT).build();
        paymentRequest.status = RequestStatus.COMPLETE;
        // paymentRequest.registryUrl = response.registryUrl;
        paymentRequest = paymentRequest.copyFrom(password: response.password);
        await insertRequestOnDb();
        emit(WomVerifyCreationRequestComplete(
          response: response,
        ));
      } on ServerException catch (ex, stack) {
        logger.e('${ex.url}: ${ex.statusCode} => ${ex.error}');
        logger.e(stack);
        paymentRequest.status = RequestStatus.DRAFT;
        insertRequestOnDb();
        emit(WomCreationRequestError(error: ex.error));
      } catch (ex) {
        logger.e(ex);
        paymentRequest.status = RequestStatus.DRAFT;
        insertRequestOnDb();
        emit(WomCreationRequestError());
      }
    } else {
      emit(WomCreationRequestNoDataConnectionState());
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
