import 'package:bloc/bloc.dart';
import 'package:dart_wom_connector/dart_wom_connector.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/foundation.dart';
import 'package:pos/src/db/payment_database/payment_database.dart';
import 'package:pos/src/model/payment_request.dart';
import 'package:pos/src/model/request_status_enum.dart';
import 'package:pos/src/screens/request_confirm/wom_creation_event.dart';
import 'package:pos/src/screens/request_confirm/wom_creation_state.dart';
import 'package:meta/meta.dart';

import '../../constants.dart';

class RequestConfirmBloc extends Bloc<WomCreationEvent, WomCreationState> {
  // PaymentRegistrationRepository _repository;
  PaymentRequest paymentRequest;

  final Pos pos;
  PaymentDatabase _requestDb;

  final PointOfSale pointOfSale;
  RequestConfirmBloc(
      {@required this.pointOfSale,
      @required this.paymentRequest,
      @required this.pos}) {
    // _repository = PaymentRegistrationRepository();
    _requestDb = PaymentDatabase.get();
    add(CreateWomRequest());
  }

  @override
  get initialState => WomCreationRequestEmpty();

  @override
  Stream<WomCreationState> mapEventToState(event) async* {
    if (event is CreateWomRequest) {
      yield WomCreationRequestLoading();
      if (await DataConnectionChecker().hasConnection) {
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
          yield WomVerifyCreationRequestComplete(
            response: response,
          );
        } on ServerException catch (ex) {
          print(ex.error);
          paymentRequest.status = RequestStatus.DRAFT;
          insertRequestOnDb();
          yield WomCreationRequestError(error: ex.error);
        } catch (ex) {
          print(ex);
          paymentRequest.status = RequestStatus.DRAFT;
          insertRequestOnDb();
          yield WomCreationRequestError(error: ex.toString());
        }
      } else {
        yield WomCreationRequestNoDataConnectionState();
      }
    }
  }

  insertRequestOnDb() async {
    try {
      if (paymentRequest.id == null) {
        int id = await _requestDb.insertRequest(paymentRequest);
        paymentRequest.id = id;
        print(paymentRequest.id);
      } else {
        await _requestDb.updateRequest(paymentRequest);
      }
    } catch (ex) {
      print("insertRequestOnDb $ex");
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
        "http://$domain/${type.toString().toLowerCase().replaceAll("transactiontype.", "")}/$otc";
    print(link);
    return link;
  }
}
