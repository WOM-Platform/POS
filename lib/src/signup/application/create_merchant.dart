import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pos/src/blocs/authentication/authentication_bloc.dart';
import 'package:pos/src/offers/application/offers.dart';
import 'package:pos/src/services/user_repository.dart';
import 'package:pos/src/signup/data/remote/api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_merchant.freezed.dart';

part 'create_merchant.g.dart';

@freezed
class CreateMerchantState with _$CreateMerchantState {
  const factory CreateMerchantState.data(
    List<String> items,
    int totalItemsCount, {
    @Default(true) bool hasReachedMax,
  }) = CreateMerchantStateData;

  const factory CreateMerchantState.initial() = CreateMerchantStateInitial;

  const factory CreateMerchantState.emailVerification(String userId) =
      CreateMerchantStateEmailVerification;

  const factory CreateMerchantState.loading() = CreateMerchantStateLoading;

  const factory CreateMerchantState.error(Object error, StackTrace st) =
      CreateMerchantStateError;
}

@riverpod
class CreateMerchantNotifier extends _$CreateMerchantNotifier {
  @override
  CreateMerchantState build() {
    return CreateMerchantStateInitial();
  }

  Future createMerchant({
    required String name,
    required String fiscalCode,
    required String address,
    required String primaryActivity,
    required String zipCode,
    required String city,
    required String country,
    required double lat,
    required double long,
    String? streetName,
    String? streetNumber,
    String? formattedAddress,
    String? googleMapsPlaceId,
    String? description,
    String? url,
  }) async {
    final token = await ref.read(userRepositoryProvider).getToken();
    if (token == null) return;

    final ownerMerchantId = await ref.read(getPosProvider).createMerchant(
          name: name,
          fiscalCode: fiscalCode,
          address: address,
          formattedAddress: formattedAddress,
          googleMapsPlaceId: googleMapsPlaceId,
          streetNumber: streetNumber,
          primaryActivity: primaryActivity,
          zipCode: zipCode,
          city: city,
          country: country,
          description: description,
          url: url,
          token: token,
        );

    await ref.read(getPosProvider).createPOS(
          ownerMerchantId: ownerMerchantId,
          name: name,
          description: description,
          url: url,
          token: token,
          latitude: lat,
          longitude: long,
          formattedAddress: formattedAddress,
          googleMapsPlaceId: googleMapsPlaceId,
          streetNumber: streetNumber,
          streetName: streetName,
          city: city,
          country: country,
        );
    await ref.read(authNotifierProvider.notifier).refresh();
  }

/*POST /v1/pos/ (autenticata)
- OwnerMerchantId (ID da richiesta precedente)
- Name (min 4, max 128)
- Description (opzionale, max 4096)
- Latitude (opzionale)
- Longitude (opzionale)
- Url (opzionale)*/
}
