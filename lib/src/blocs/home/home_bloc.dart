import 'package:bloc/bloc.dart';
import 'package:dart_wom_connector/dart_wom_connector.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:pos/src/blocs/home/home_event.dart';
import 'package:pos/src/blocs/home/home_state.dart';
import 'package:pos/src/db/app_database/app_database.dart';
import 'package:pos/src/db/payment_database/payment_database.dart';
import 'package:pos/src/model/payment_request.dart';
import 'package:pos/src/services/aim_repository.dart';
import 'package:pos/src/services/user_repository.dart';
import 'package:pos/src/utils.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  TextEditingController amountController = TextEditingController();
  User user;
  AimRepository _aimRepository;
  PaymentDatabase _requestDb;
  UserRepository userRepository;
  HomeBloc({this.userRepository}) {
    _aimRepository = AimRepository();
    _requestDb = PaymentDatabase.get();
    //TODO spostare aggiornamento aim in appBloc
    _aimRepository.updateAim(database: AppDatabase.get().getDb()).then((aims) {
      print("HomeBloc: updateAim in costructor: $aims");
    });
  }

  clear() {
    _selectedPosId = null;
    _selectedMerchantId = null;
  }

  String _selectedPosId;
  String get selectedPosId => _selectedPosId;
  String _selectedMerchantId;

  void setMerchantAndPosId(String merchantId, String posId) {
    if (posId != _selectedPosId) {
      userRepository.saveLastPosId(posId, merchantId);
      _selectedMerchantId = merchantId;
      _selectedPosId = posId;
      add(LoadRequest());
    }
  }

  List<Merchant> get merchants => user?.merchants ?? [];

  bool get isOnlyOneMerchantAndPos =>
      merchants.length == 1 && selectedMerchant.posList.length == 1;

  Merchant get selectedMerchant =>
      _selectedMerchantId != null && _selectedMerchantId.isNotEmpty
          ? merchants.firstWhere((m) => m.id == _selectedMerchantId,
              orElse: () => null)
          : merchants.first;

  PointOfSale get selectedPos =>
      _selectedPosId != null && _selectedPosId.isNotEmpty
          ? selectedMerchant.posList.firstWhere((p) => p.id == _selectedPosId)
          : selectedMerchant.posList.first;

//String get selectedPosId => selectedPos.id;

  @override
  HomeState get initialState => RequestLoading();

  @override
  Stream<HomeState> mapEventToState(event) async* {
    if (event is LoadRequest) {
      List<Aim> aims = await _aimRepository.getFlatAimList(
          database: AppDatabase.get().getDb());

      try {
        final lastCheck = await getLastAimCheckDateTime();
        final aimsAreOld = DateTime.now().difference(lastCheck).inHours > 5;
        //Se non ho gli aim salvati nel db o sono vecchi li scarico da internet
        if (aims == null || aims.isEmpty || aimsAreOld) {
          if (await DataConnectionChecker().hasConnection) {
            // final repo = AppRepository();
            print("HomeBloc: trying to update Aim from internet");
            aims = await _aimRepository.updateAim(
                database: AppDatabase.get().getDb());
            await setAimCheckDateTime(DateTime.now());
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
  Future<void> close() {
    amountController.dispose();
    return super.close();
  }
}
