import 'package:bloc/bloc.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
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
    //TODO spostare aggiornamento aim in appBloc
    _aimRepository.updateAim(database: AppDatabase.get().getDb()).then((aims) {
      print("HomeBloc: updateAim in costructor: $aims");
      dispatch(LoadRequest());
    });
  }

  @override
  get initialState => RequestLoading();

  @override
  Stream<HomeState> mapEventToState(event) async* {
    if (event is LoadRequest) {
      List<Aim> aims = await _aimRepository.getFlatAimList(
          database: AppDatabase.get().getDb());

      try {
        //Se non ho gli aim salvati nel db li scarico da internet
        if (aims == null || aims.isEmpty) {
          if (await DataConnectionChecker().hasConnection) {
            // final repo = AppRepository();
            print("HomeBloc: trying to update Aim from internet");
            aims = await _aimRepository.updateAim(
                database: AppDatabase.get().getDb());
          } else {
            print("Aims null or empty and No internet connection");
            yield NoDataConnectionState();
            return;
          }
        }

        print('aim letti : ${aims.length}');

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
      } catch (ex) {
        print(ex.toString());
        yield RequestsLoadingErrorState('somethings_wrong');
      }
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
