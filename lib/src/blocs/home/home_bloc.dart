import 'package:bloc/bloc.dart';
import 'package:dart_wom_connector/dart_wom_connector.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:pos/src/blocs/home/home_event.dart';
import 'package:pos/src/blocs/home/home_state.dart';
import 'package:pos/src/db/app_database/app_database.dart';
import 'package:pos/src/db/payment_database/payment_database.dart';
import 'package:pos/src/model/payment_request.dart';
import 'package:wom_package/wom_package.dart' as womPack;

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  TextEditingController amountController = TextEditingController();
  User user;
  womPack.AimRepository _aimRepository;
  PaymentDatabase _requestDb;

  HomeBloc() {
    _aimRepository = womPack.AimRepository();
    _requestDb = PaymentDatabase.get();
    //TODO spostare aggiornamento aim in appBloc
    _aimRepository.updateAim(database: AppDatabase.get().getDb()).then((aims) {
      print("HomeBloc: updateAim in costructor: $aims");
      add(LoadRequest());
    });
  }

  String _selectedPosId;
  String get selectedPosId => _selectedPosId;
  String selectedMerchantId;

  set selectedPosId(String id) {
    if (id != _selectedPosId) {
      _selectedPosId = id;
      add(LoadRequest());
    }
  }

  List<Merchant> get merchants => user?.merchants ?? [];

  Merchant get selectedMerchant => selectedMerchantId != null
      ? merchants.firstWhere((m) => m.id == selectedMerchantId,
          orElse: () => null)
      : merchants.first;

  PointOfSale get selectedPos => selectedPosId != null
      ? selectedMerchant.posList.firstWhere((p) => p.id == selectedPosId)
      : selectedMerchant.posList.first;

//String get selectedPosId => selectedPos.id;

  @override
  HomeState get initialState => RequestLoading();

  @override
  Stream<HomeState> mapEventToState(event) async* {
    if (event is LoadRequest) {
      List<womPack.Aim> aims = await _aimRepository.getFlatAimList(
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

        final List<PaymentRequest> requests =
            await _requestDb.getRequestsByPosId(selectedPos.id);
        for (PaymentRequest r in requests) {
          final womPack.Aim aim = aims.firstWhere((a) {
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
  Future<void> close() {
    amountController.dispose();
    return super.close();
  }
}
