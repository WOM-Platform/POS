import 'package:dart_wom_connector/dart_wom_connector.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_maps_flutter_platform_interface/src/types/location.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:pos/src/blocs/authentication/authentication_bloc.dart';
import 'package:pos/src/model/payment_request.dart';
import 'package:pos/src/model/request_status_enum.dart';
import 'package:pos/src/my_logger.dart';
import 'package:pos/src/offers/application/offers.dart';
import 'package:pos/src/offers/domain/entities/offert_type.dart';
import 'package:pos/src/offers/ui/create_new_offer/bounds_selector_screen.dart';
import 'package:pos/src/offers/ui/offers_screen.dart';
import 'package:pos/src/screens/create_payment/pages/aim_selection/bloc.dart';
import 'package:pos/src/screens/request_confirm/bloc.dart';
import 'package:pos/src/services/aim_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'dart:math' as math;

import '../../db/app_database/app_database.dart';
import '../../db/payment_database/payment_database.dart';

part 'create_offer_notifier.freezed.dart';

part 'create_offer_notifier.g.dart';

@freezed
class MapPolygon with _$MapPolygon {
  const factory MapPolygon({
    required LatLng target,
    required List<LatLng> polygon,
    required double zoom,
  }) = _MapPolygon;
}

@freezed
class CreateOfferState with _$CreateOfferState {
  const factory CreateOfferState({
    required int activeStep,
    OfferType? type,
    String? title,
    int? wom,
    int? maxAge,
    String? aimCode,
    String? description,
    MapPolygon? mapPolygon,
  }) = _CreateOfferState;

  factory CreateOfferState.initial({required OfferType offerType}) =>
      CreateOfferState(activeStep: 0, type: offerType);
}

final titleControllerProvider =
    Provider.autoDispose<TextEditingController>((ref) {
  final c = TextEditingController();
  ref.onDispose(() {
    c.dispose();
  });
  return c;
});

final descControllerProvider =
    Provider.autoDispose<TextEditingController>((ref) {
  final c = TextEditingController();
  ref.onDispose(() {
    c.dispose();
  });
  return c;
});

final womControllerProvider =
    Provider.autoDispose<TextEditingController>((ref) {
  final c = TextEditingController();
  ref.onDispose(() {
    c.dispose();
  });
  return c;
});

final maxAgeControllerProvider =
    Provider.autoDispose<TextEditingController>((ref) {
  final c = TextEditingController();
  ref.onDispose(() {
    c.dispose();
  });
  return c;
});


final offerTypeProvider = Provider<OfferType>((ref){
  throw UnimplementedError();
});


@riverpod
class CreateOfferNotifier extends _$CreateOfferNotifier {
  CreateOfferState build() {
    ref.listen(titleControllerProvider, (_, __) {});
    ref.listen(descControllerProvider, (_, __) {});
    ref.listen(womControllerProvider, (_, __) {});
    ref.listen(maxAgeControllerProvider, (_, __) {});
    ref.listen(aimSelectionNotifierProvider, (_, next) {});
    final offerType = ref.watch(offersTabProvider);
    return CreateOfferState.initial(
      offerType: offerType,
    );
  }

  nextStep() {
    if (state.activeStep == 4 || !canGoNext()) return;
    var tmp = state.copyWith(
      activeStep: state.activeStep + 1,
    );
    if (state.activeStep == 1) {
      final title = ref.read(titleControllerProvider).text.trim();
      final desc = ref.read(descControllerProvider).text.trim();
      final wom = int.tryParse(ref.read(womControllerProvider).text);
      tmp = tmp.copyWith(
        title: title,
        description: desc,
        wom: wom,
      );
    } else if (state.activeStep == 2) {
      final maxAge = int.tryParse(ref.read(maxAgeControllerProvider).text);
      tmp = tmp.copyWith(maxAge: maxAge);
    }
    state = tmp;
  }

  backStep() {
    if (state.activeStep == 0) return;
    state = state.copyWith(activeStep: state.activeStep - 1);
  }

  void setOfferType(OfferType type) {
    state = state.copyWith(type: type);
  }

  void setAim(String aimCode) {
    state = state.copyWith(
      aimCode: aimCode,
    );
  }

  bool canGoNext() {
    switch (state.activeStep) {
      case 0:
        final isAnonymous = ref.read(isAnonymousUserProvider);
        return isAnonymous
            ? state.type == OfferType.ephemeral
            : state.type != null;
      case 1:
        final title = ref.read(titleControllerProvider).text.trim();
        // final desc = ref.read(descControllerProvider).text.trim();
        final wom = int.tryParse(ref.read(womControllerProvider).text);
        final canGo = title.length > 5 && wom != null;
        // if (canGo) {
        //   state = state.copyWith(
        //     title: title,
        //     desc: desc,
        //     wom: wom,
        //   );
        // }
        return canGo;
      case 2:
        final maxAge =
            int.tryParse(ref.read(maxAgeControllerProvider).text.trim());
        return true;
      default:
        return false;
    }
  }

  createOffer() async {
    final isAnonymous = ref.read(isAnonymousUserProvider);
    final posId = ref.read(selectedPosProvider)?.pos?.id;
    final privateKey = ref.read(selectedPosProvider)?.pos?.privateKey;
    if (posId == null || privateKey == null) {
      throw Exception('Pos id or private key are null');
    }

    if (isAnonymous && state.type == OfferType.persistent) {
      throw Exception('Anonymous user cant use persistent offers');
    }

    final request = CreateOfferRequestDTO(
      title: state.title!,
      cost: state.wom!,
      description: state.description,
      filter: SimpleFilter(
        maxAge: state.maxAge,
        bounds: state.mapPolygon != null
            ? Bounds(
                leftTop: [
                  state.mapPolygon!.polygon[0].latitude,
                  state.mapPolygon!.polygon[0].longitude
                ],
                rightBottom: [
                  state.mapPolygon!.polygon[2].latitude,
                  state.mapPolygon!.polygon[2].longitude
                ],
              )
            : null,
        aim: state.aimCode,
      ),
    );
    final secureStorage = ref.read(getSecureStorageProvider);
    final email = await secureStorage.read(key: 'email');
    final password = await secureStorage.read(key: 'password');
    if (email == null || password == null) {
      logger.i('username or password are null');
      return;
    }
    if (state.type == OfferType.persistent) {
      await createCloudOffer(
        request,
        posId,
        email,
        password,
      );
    } else {
      await createLocalOffer(request, posId, privateKey);
    }
  }

  createCloudOffer(
    CreateOfferRequestDTO request,
    String posId,
    String email,
    String password,
  ) async {
    final res = await ref.read(getPosProvider).createOffer(
          posId,
          request,
          email,
          password,
        );
    ref.invalidate(cloudOffersNotifierProvider(posId));
    ref.read(offersTabProvider.notifier).state = OfferType.persistent;
  }

  createLocalOffer(
    CreateOfferRequestDTO request,
    String posId,
    String privateKey,
  ) async {
    if (await InternetConnectionChecker().hasConnection) {
      // final RequestVerificationResponse response = await _repository
      //     .generateNewPaymentRequest(paymentRequest, pointOfSale);
      try {
        final payload = RequestPaymentPayload(
          amount: state.wom!,
          nonce: CoreUtils.generateGUID(),
          posId: posId,
          persistent: true,
          // pocketAckUrl: 'pocketAckUrl',
          // posAckUrl: 'posAckUrl',
          simpleFilter: request.filter,
        );
        final response =
            await ref.read(getPosProvider).requestPayment(payload, privateKey);
        Aim? aim;
        if (request.filter?.aim != null) {
          aim = await ref.read(aimRepositoryProvider).getAim(
                database: AppDatabase.get().getDb(),
                aimCode: request.filter!.aim!,
              );
        }
        final paymentRequest = PaymentRequest(
          password: response.password,
          name: request.title,
          posId: posId,
          amount: request.cost,
          aimCode: request.filter?.aim,
          persistent: true,
          simpleFilter: request.filter,
          location: state.mapPolygon?.target,
          dateTime: DateTime.now(),
          // pocketAckUrl: 'pocketAckUrl',
          // posAckUrl: 'posAckUrl',
          deepLink:
              DeepLinkBuilder(response.otc, TransactionType.PAYMENT).build(),
          nonce: payload.nonce,
          status: RequestStatus.COMPLETE,
          aim: aim,
          aimName: aim?.title(languageCode: 'en') ?? '-',
        );
        await insertRequestOnDb(paymentRequest);
        ref.invalidate(requestNotifierProvider);
        final isAnonymous = ref.read(isAnonymousUserProvider);
        if (!isAnonymous) {
          ref.read(offersTabProvider.notifier).state = OfferType.ephemeral;
        }
      } on ServerException catch (ex, stack) {
        logger.e('${ex.url}: ${ex.statusCode} => ${ex.error}');
        logger.e(stack);
        // paymentRequest.status = RequestStatus.DRAFT;
        // insertRequestOnDb(paymentRequest);
        // state = WomCreationRequestError(error: ex.error);
      } catch (ex) {
        logger.e(ex);
        // paymentRequest.status = RequestStatus.DRAFT;
        // insertRequestOnDb(paymentRequest);
        // state = WomCreationRequestError();
      }
    }
  }

  insertRequestOnDb(PaymentRequest paymentRequest) async {
    try {
      if (paymentRequest.id == null) {
        int id = await PaymentDatabase.get().insertRequest(paymentRequest);
        paymentRequest.id = id;
        logger.i(paymentRequest.id);
      } else {
        await PaymentDatabase.get().updateRequest(paymentRequest);
      }
    } catch (ex) {
      logger.i("insertRequestOnDb $ex");
    }
  }

  validateState() {
    if (state.title == null || state.wom == null || state.wom == 0) {
      return false;
    }
    return true;
  }

  void updatePolygone(LatLng target, double radius) {
    LatLng no = getBoundingBoxFromCircle(target, radius, -radius);
    LatLng ne = getBoundingBoxFromCircle(target, radius, radius);
    LatLng se = getBoundingBoxFromCircle(target, -radius, radius);
    LatLng so = getBoundingBoxFromCircle(target, -radius, -radius);
    state = state.copyWith(
      mapPolygon: MapPolygon(
        polygon: [no, ne, se, so, no],
        target: target,
        zoom: cameraZoom[sliderSteps.indexOf(radius)],
      ),
    );
  }

  LatLng getBoundingBoxFromCircle(LatLng location, double nOff, double eOff) {
    //Earth’s radius, sphere
    int earthRadius = 6378137;

    //Coordinate offsets in radians
    double dLat = nOff / earthRadius;
    double dLon =
        eOff / (earthRadius * math.cos(math.pi * location.latitude / 180));

    //OffsetPosition, decimal degrees
    double latO = location.latitude + dLat * 180 / math.pi;
    double lonO = location.longitude + dLon * 180 / math.pi;
    return LatLng(latO, lonO);
  }

  // saveDraftRequest() async {
  //   logger.i("saveDraftRequest");
  //   try {
  //     final db = PaymentDatabase.get();
  //     final paymentRequest = await createModelForCreationRequest();
  //
  //     if (draftRequest == null) {
  //       await db.insertRequest(paymentRequest);
  //     } else {
  //       await db.updateRequest(paymentRequest);
  //     }
  //   } catch (ex) {
  //     logger.i(ex.toString());
  //   }
  // }

  CreateOfferRequestDTO createOfferRequest() {
    final request = CreateOfferRequestDTO(
      title: state.title!,
      cost: state.wom!,
      description: state.description,
      filter: SimpleFilter(
        maxAge: state.maxAge,
        bounds: state.mapPolygon != null
            ? Bounds(
                leftTop: [
                  state.mapPolygon!.polygon[0].latitude,
                  state.mapPolygon!.polygon[0].longitude
                ],
                rightBottom: [
                  state.mapPolygon!.polygon[2].latitude,
                  state.mapPolygon!.polygon[2].longitude
                ],
              )
            : null,
        aim: state.aimCode,
      ),
    );
    return request;
  }

  void resetPolygon() {
    state = state.copyWith(mapPolygon: null);
  }

  void resetMaxAge() {
    state = state.copyWith(maxAge: null);
  }

  void resetAim() {
    state = state.copyWith(aimCode: null);
  }
}
