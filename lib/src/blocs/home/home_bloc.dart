import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pos/src/blocs/home/home_event.dart';
import 'package:pos/src/blocs/home/home_state.dart';
import 'package:pos/src/db/app_db.dart';
import 'package:pos/src/db/payment_request_db.dart';
import 'package:pos/src/model/payment_request.dart';
import 'package:wom_package/wom_package.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  TextEditingController amountController = TextEditingController();

  AimRepository _aimRepository;
  PaymentRequestDb _requestDb;

  HomeBloc() {
    _aimRepository = AimRepository();
    _aimRepository.updateAim(AppDatabase.get().getDb());
    _requestDb = PaymentRequestDb.get();
    dispatch(LoadRequest());
  }

  @override
  get initialState => RequestLoading();

  @override
  Stream<HomeState> mapEventToState(event) async* {
    if (event is LoadRequest) {
      final List<PaymentRequest> requests = await _requestDb.getRequests();
      debugPrint("requests: ${requests.length}");
      yield RequestLoaded(requests: requests);
    }
  }

  Future<int> deleteRequest(int id) async {
    return await _requestDb.deleteRequest(id);
  }

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }
}
