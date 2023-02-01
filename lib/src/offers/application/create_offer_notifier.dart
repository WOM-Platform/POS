import 'package:dart_wom_connector/dart_wom_connector.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_maps_flutter_platform_interface/src/types/location.dart';
import 'package:pos/src/my_logger.dart';
import 'package:pos/src/offers/application/offers.dart';
import 'package:pos/src/offers/domain/entities/offert_type.dart';
import 'package:pos/src/offers/ui/create_new_offer/bounds_selector_screen.dart';
import 'package:pos/src/screens/create_payment/pages/aim_selection/bloc.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'dart:math' as math;

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

  factory CreateOfferState.initial() => CreateOfferState(activeStep: 0);
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

@riverpod
class CreateOfferNotifier extends _$CreateOfferNotifier {
  CreateOfferState build() {
    ref.listen(titleControllerProvider, (_, __) {});
    ref.listen(descControllerProvider, (_, __) {});
    ref.listen(womControllerProvider, (_, __) {});
    ref.listen(aimSelectionNotifierProvider, (_, next) {});
    return CreateOfferState.initial();
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
        return state.type != null;
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
        return true;
      default:
        return false;
    }
  }

  createOffer() async {
    final posId = ref.read(selectedPosProvider)?.pos?.id;
    if (posId == null) {
      return;
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
    final res = await ref
        .read(getPosProvider)
        .createOffer(posId, request, email, password);
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
}
