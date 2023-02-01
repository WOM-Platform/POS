import 'package:dart_wom_connector/dart_wom_connector.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:pos/src/blocs/home/bloc.dart';
import 'package:pos/src/blocs/home/home_state.dart';
import 'package:pos/src/db/app_database/app_database.dart';
import 'package:pos/src/db/payment_database/payment_database.dart';
import 'package:pos/src/model/payment_request.dart';
import 'package:pos/src/services/aim_repository.dart';
import 'package:pos/src/services/user_repository.dart';
import 'package:pos/src/utils.dart';
import 'package:collection/collection.dart';
import '../../../app.dart';
import '../../my_logger.dart';

import '../../extensions.dart';

final homeNotifierProvider = StateNotifierProvider<HomeBloc, HomeState>((ref) {
  return HomeBloc(ref: ref);
});

class HomeBloc extends StateNotifier<HomeState> {
  TextEditingController amountController = TextEditingController();
  late AimRepository _aimRepository;
  late PaymentDatabase _requestDb;
  final Ref ref;

  HomeBloc({required this.ref}) : super(RequestLoading()) {
    _aimRepository = AimRepository();
    _requestDb = PaymentDatabase.get();
    //TODO spostare aggiornamento aim in appBloc
    _aimRepository.updateAim(database: AppDatabase.get().getDb()).then((aims) {
      logger.i("HomeBloc: updateAim in costructor: $aims");
    });
  }

  clear() {
    _selectedPosId = null;
    _selectedMerchantId = null;
  }

  String? _selectedPosId;
  String? _selectedMerchantId;

  // List<Merchant> get merchants => globalUser?.merchants ?? <Merchant>[];

  // List<PointOfSale> get posList => selectedMerchant?.posList ?? <PointOfSale>[];

  // bool get isOnlyOneMerchantAndPos =>
  //     merchants.length == 1 && posList.length <= 1;

  // bool get posSelectionEnabled =>
  //     merchants.isNotEmpty && !isOnlyOneMerchantAndPos;

  // Merchant? get selectedMerchant => _selectedMerchantId.isNotNullAndNotEmpty
  //     ? merchants.firstWhereOrNull((m) => m.id == _selectedMerchantId)
  //     : merchants.isNotEmpty
  //         ? merchants.first
  //         : null;

  // PointOfSale? get selectedPos => _selectedPosId.isNotNullAndNotEmpty
  //     ? posList.firstWhereOrNull((p) => p.id == _selectedPosId)
  //     : posList.isNotEmpty
  //         ? posList.first
  //         : null;

  Future<void> checkAndSetPreviousSelectedMerchantAndPos() async {
    //Check previous merchant and pos selected
    final lastMerchantAndPosIdUsed =
        await ref.read(userRepositoryProvider).readLastMerchantIdAndPosIdUsed();
    if (lastMerchantAndPosIdUsed != null &&
        lastMerchantAndPosIdUsed.length == 2) {
      final merchantId = lastMerchantAndPosIdUsed[0];
      final posId = lastMerchantAndPosIdUsed[1];
      if (merchantId.isNotNullAndNotEmpty) {
        _selectedMerchantId = merchantId;
        if (posId.isNotNullAndNotEmpty) {
          _selectedPosId = posId;
        }
      }
    }
  }

  // void setMerchantAndPosId(String merchantId, String posId) {
  //   if (posId != _selectedPosId) {
  //     ref
  //         .read(userRepositoryProvider)
  //         .saveMerchantAndPosIdUsed(posId, merchantId);
  //     _selectedMerchantId = merchantId;
  //     _selectedPosId = posId;
  //     loadRequest();
  //   }
  // }

  /*loadRequest() async {
    if (merchants.isEmpty) {
      state = NoMerchantState();
      return;
    } else if (posList.isEmpty) {
      state = NoPosState();
      return;
    }

    var aims = await _aimRepository.getFlatAimList(
        database: AppDatabase.get().getDb());

    try {
      final lastCheck = await getLastAimCheckDateTime();
      final aimsAreOld = DateTime.now().difference(lastCheck).inHours > 5;
      //Se non ho gli aim salvati nel db o sono vecchi li scarico da internet
      if (aims == null || aims.isEmpty || aimsAreOld) {
        if (await InternetConnectionChecker().hasConnection) {
          // final repo = AppRepository();
          logger.i("HomeBloc: trying to update Aim from internet");
          aims = await _aimRepository.updateAim(
              database: AppDatabase.get().getDb());
          await setAimCheckDateTime(DateTime.now());
        } else {
          logger.i("Aims null or empty and No internet connection");
          state = NoDataConnectionState();
          return;
        }
      }

      logger.i('aim letti : ${aims.length}');

      if (selectedPos != null) {
        final List<PaymentRequest> requests =
            await _requestDb.getRequestsByPosId(selectedPos!.id);
        for (PaymentRequest r in requests) {
          final aim = aims.firstWhereOrNull((a) {
            return a.code == r.aimCode;
          });
          if (aim != null) {
            r.aim = aim;
          }
        }
        state = RequestLoaded(requests: requests);
      } else {
        state = NoPosState();
      }
    } catch (ex) {
      logger.i(ex.toString());
      state = RequestsLoadingErrorState('somethings_wrong');
    }
  }*/

  Future<int> deleteRequest(int id) async {
    return await _requestDb.deleteRequest(id);
  }
}
