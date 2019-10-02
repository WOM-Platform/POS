import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:pos/src/blocs/home/home_event.dart';
import 'package:pos/src/blocs/home/home_state.dart';
import 'package:pos/src/db/app_database/app_database.dart';
import 'package:pos/src/db/payment_database/payment_database.dart';
import 'package:pos/src/model/payment_request.dart';
import 'package:wom_package/wom_package.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  TextEditingController amountController = TextEditingController();

  AimRepository _aimRepository;
  PaymentDatabase _requestDb;

  HomeBloc() {
    _aimRepository = AimRepository();
    _requestDb = PaymentDatabase.get();
    _aimRepository.updateAim(database: AppDatabase.get().getDb()).then((_) {
      dispatch(LoadRequest());
    });
  }

  @override
  get initialState => RequestLoading();

  @override
  Stream<HomeState> mapEventToState(event) async* {
    if (event is LoadRequest) {
      final List<Aim> aims = await _aimRepository.getFlatAimList(
          database: AppDatabase.get().getDb());
      final List<PaymentRequest> requests = await _requestDb.getRequests();
      for (PaymentRequest r in requests) {
        final Aim aim = aims.firstWhere((a) {
          return a.code == r.aimCode;
        }, orElse: () {
          return null;
        });
        r.aim = aim;
      }
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
