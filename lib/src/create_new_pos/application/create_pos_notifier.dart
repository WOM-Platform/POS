import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pos/src/blocs/authentication/authentication_bloc.dart';
import 'package:pos/src/my_logger.dart';
import 'package:pos/src/offers/application/offers.dart';
import 'package:pos/src/services/user_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_pos_notifier.freezed.dart';

part 'create_pos_notifier.g.dart';

@freezed
class CreatePOSState with _$CreatePOSState {
  const factory CreatePOSState.initial() = CreatePOSStateInitial;

  const factory CreatePOSState.complete() = CreatePOSStateComplete;

  const factory CreatePOSState.loading() = CreatePOSStateLoading;

  const factory CreatePOSState.error(Object error, StackTrace st) =
      CreatePOSStateError;
}

@riverpod
class CreatePOSNotifier extends _$CreatePOSNotifier {
  @override
  CreatePOSState build(String merchantId) {
    return CreatePOSState.initial();
  }

  Future createPOS({
    required String name,
    required double lat,
    required double long,
    required String city,
    required String country,
    String? streetName,
    String? streetNumber,
    String? formattedAddress,
    String? googleMapsPlaceId,
    String? description,
    String? url,
  }) async {
    state = CreatePOSState.loading();

    try {
      final token = await ref.read(userRepositoryProvider).getToken();
      if (token == null) return;

      await ref.read(getPosProvider).createPOS(
            ownerMerchantId: merchantId,
            token: token,
            name: name,
            description: description,
            url: url,
            latitude: lat,
            longitude: long,
            formattedAddress: formattedAddress,
            googleMapsPlaceId: googleMapsPlaceId,
            streetNumber: streetNumber,
            streetName: streetName,
            city: city,
            country: country,
          );

      state = CreatePOSState.complete();
      ref.read(authNotifierProvider.notifier).refresh();
    } catch (ex, st) {
      logger.e(st);
      state = CreatePOSState.error(ex, st);
    }
  }
}
