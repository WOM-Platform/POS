import 'package:dart_wom_connector/dart_wom_connector.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pos/src/blocs/home/home_state.dart';

import 'package:pos/src/constants.dart';
import 'package:pos/src/my_logger.dart';
import 'package:pos/src/services/aim_repository.dart';
import 'package:pos/src/services/user_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:collection/collection.dart';
import '../../db/payment_database/payment_database.dart';
import '../../model/payment_request.dart';

part 'offers.g.dart';

@Riverpod(keepAlive: true)
PosClient getPos(GetPosRef ref) {
  return PosClient(domain, registryKey);
}

@riverpod
FlutterSecureStorage getSecureStorage(GetSecureStorageRef ref) {
  return FlutterSecureStorage();
}

@riverpod
class CloudOffersNotifier extends _$CloudOffersNotifier {
  String? posId;
  // String? email;
  String? token;

  Future<List<Offer>> build(String? posId) async {
    final selectedPos = ref.watch(selectedPosProvider);
    // final mmkv = Hive.box('settings');
    // final posId = await mmkv.get('lastPosId');
    // await mmkv.get('lastMerchantId');

    posId = selectedPos?.pos?.id;
    if (posId == null) {
      throw Exception('posId is null');
    }
    final repo = ref.watch(userRepositoryProvider);
    // email = await repo.getSavedEmail();
    token = await repo.getToken();
    final pos = ref.watch(getPosProvider);
    if (token == null) {
      throw Exception('Token is null');
    }
    return pos.getOffers(posId, token!);
  }

  refreshList() async {
    try {
      if (posId == null) return;
      state = AsyncLoading();
      final list = await ref.read(getPosProvider).getOffers(
            posId!,
            token!,
          );
      state = AsyncData(list);
    } catch (ex, st) {
      logger.e(ex);
      logger.e(st);
      state = AsyncError(ex, st);
    }
  }

  deleteOffer(String offerId) async {
    if (posId == null || token == null) return;
    await ref.read(getPosProvider).deleteOffer(posId!, offerId, token!);
    refreshList();
  }
}

// @riverpod
// Future<List<Offer>> getOffers(GetOffersRef ref, {String? posId}) async {
//   final mmkv = Hive.box('settings');
//   final posId = await mmkv.get('lastPosId');
//   await mmkv.get('lastMerchantId');
//
//   if (posId == null) {
//     throw Exception();
//   }
//   final secureStorage = ref.watch(userRepositoryProvider).secureStorage;
//   final email = await secureStorage.read(key: 'email');
//   final password = await secureStorage.read(key: 'password');
//   final pos = ref.watch(getPosProvider);
//   if (email == null || password == null) {
//     throw Exception();
//   }
//   return pos.getOffers(posId, email, password);
// }

final selectedPosProvider = StateProvider<SelectedPos?>((ref) {
  ref.listenSelf((previous, next) {
    if (next?.pos?.id == null) return;
    ref
        .read(userRepositoryProvider)
        .saveMerchantAndPosIdUsed(next!.pos!.id, next.merchant.id);
  });

  return null;
});

class SelectedPos {
  final Merchant merchant;
  final PointOfSale? pos;

  SelectedPos(this.merchant, this.pos);
}

@Riverpod(keepAlive: true)
class RequestNotifier extends _$RequestNotifier {
  FutureOr<HomeState> build() async {
    final selectedPos = ref.watch(selectedPosProvider);
    if (selectedPos?.pos == null) return NoPosState();

    try {
      // final lastCheck = await getLastAimCheckDateTime();
      // final aimsAreOld = DateTime.now().difference(lastCheck).inMinutes > 1;
      //
      // //Se non ho gli aim salvati nel db o sono vecchi li scarico da internet
      // if (aims == null || aims.isEmpty || aimsAreOld) {
      //   if (await InternetConnectionChecker().hasConnection) {
      //     logger.i("HomeBloc: trying to update Aim from internet");
      //     aims = await ref
      //         .watch(aimRepositoryProvider)
      //         .updateAim(database: AppDatabase.get().getDb());
      //     await setAimCheckDateTime(DateTime.now());
      //   } else {
      //     logger.i("Aims null or empty and No internet connection");
      //     return NoDataConnectionState();
      //   }
      // }

      final aims = await ref.read(aimFlatListFutureProvider.future);
      logger.i('aim letti : ${aims.length}');

      final List<PaymentRequest> requests =
          await PaymentDatabase.get().getRequestsByPosId(selectedPos!.pos!.id);
      for (PaymentRequest r in requests) {
        final aim = aims.firstWhereOrNull((a) {
          return a.code == r.aimCode;
        });
        if (aim != null) {
          r.aim = aim;
        }
      }
      return RequestLoaded(requests: requests);
    } catch (ex, st) {
      logger.e(ex);
      logger.e(st);
      return RequestsLoadingErrorState('somethings_wrong');
    }
  }
}
