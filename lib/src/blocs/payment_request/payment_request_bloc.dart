import 'dart:async';

import 'package:dart_wom_connector/dart_wom_connector.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pos/src/db/payment_database/payment_database.dart';
import 'package:pos/src/model/payment_request.dart';

import 'package:pos/src/model/request_status_enum.dart';
import 'package:pos/src/screens/create_payment/pages/aim_selection/bloc.dart';
import 'dart:math' as math;
import '../../constants.dart';
import '../../my_logger.dart';

enum RequestType {
  SINGLE,
  MULTIPLE,
}

final createPaymentNotifierProvider = Provider<CreatePaymentRequestBloc>((ref) {
  throw UnimplementedError();
});

class CreatePaymentRequestBloc {

  late TextEditingController nameController;
  late TextEditingController amountController;
  late TextEditingController maxAgeController;

  bool persistentRequest = false;
  final PageController pageController = PageController();
  final String posId;
  LatLng currentPosition = LatLng(0.0, 0.0);
  LatLng? lastPosition;
  List<LatLng> locationPoints = [];

  double radius = 100.0;
  bool maxAgeEnabled = false;
  bool boundingBoxEnabled = false;

  int? get _amount => int.tryParse(amountController.text.trim());

  int? get _maxAge => int.tryParse(maxAgeController.text.trim());

  final PaymentRequest? draftRequest;

  final Ref ref;
  final String? languageCode;

  CreatePaymentRequestBloc({
    required this.ref,
    required this.draftRequest,
    required this.languageCode,
    required this.posId,
  }) {
    logger.i("CreatePaymentRequestBloc()");
    nameController = TextEditingController(text: draftRequest?.name ?? "");
    amountController =
        TextEditingController(text: draftRequest?.amount.toString() ?? "");
    maxAgeController = TextEditingController(
        text: draftRequest?.simpleFilter?.maxAge?.toString() ?? "");
    // passwordController =
    //     TextEditingController(text: draftRequest?.password ?? "");
    // aimSelectionBloc = AimSelectionBloc(ref, languageCode ?? 'en');
    if (draftRequest?.aimCode != null) {
      ref.read(aimSelectionNotifierProvider.notifier).setAimCode(draftRequest!.aimCode!);
    }
    updatePolylines();
    getLastPosition();
  }

  Future<PaymentRequest> createModelForCreationRequest() async {
    final aim = await ref.read(aimSelectionNotifierProvider.notifier).getAim();

    if (_amount == null) {
      throw Exception('PaymentRequestloc amount or aim are null');
    }

    final String name = nameController.text;

    final SimpleFilter simpleFilter = SimpleFilter(
      aim: aim?.code,
      maxAge: maxAgeEnabled ? _maxAge : null,
      bounds: boundingBoxEnabled
          ? Bounds(leftTop: [
              locationPoints[0].latitude,
              locationPoints[0].longitude
            ], rightBottom: [
              locationPoints[2].latitude,
              locationPoints[2].longitude
            ])
          : null,
    );

    final paymentRequest = PaymentRequest(
      posId: posId,
      amount: _amount!,
      aim: aim,
      aimCode: aim?.code,
      aimName: aim != null ? aim.title(languageCode: 'en') ?? '' : '',
      location: currentPosition,
      persistent: persistentRequest,
      name: name,
      status: RequestStatus.DRAFT,
      simpleFilter: simpleFilter,
      pocketAckUrl: null,
      nonce: CoreUtils.generateGUID(),
    );

    if (draftRequest != null) {
      paymentRequest.id = draftRequest!.id;
    }

    return paymentRequest;
  }

  goToNextPage() {
    pageController.nextPage(
      duration: Duration(milliseconds: 100),
      curve: Curves.linear,
    );
  }

  goToPreviousPage() {
    pageController.previousPage(
      duration: Duration(milliseconds: 100),
      curve: Curves.linear,
    );
  }

  bool get isValidName => _validateName();

  bool get isValidAmount => _validateAmount();

  bool get isValidAim => _validateAim();

  bool get isValidPosition => _validatePosition();

  // bool get isValidPassword => _validatePassword();

  bool get isValidMaxAge => _validateMaxAge();

  saveCurrentPosition() async {
    if (boundingBoxEnabled) {
      logger.i("saveCurrentPosition");
      final mmkv = Hive.box('settings');
      mmkv.put(LAST_LATITUDE, currentPosition.latitude);
      mmkv.put(LAST_LONGITUDE, currentPosition.longitude);
      logger.i("currentPositionSaved");
    }
  }

  getLastPosition() async {
    logger.i("getLastPosition");
    final mmkv = Hive.box('settings');
    final latitude = await mmkv.get(LAST_LATITUDE);
    final longitude = await mmkv.get(LAST_LONGITUDE);

    if (latitude == null || longitude == null) {
      lastPosition = null;
      return;
    }
    logger.i("lastPosition = $latitude, $longitude");
    lastPosition = LatLng(latitude, longitude);
  }

/*  _validatePassword() {
    final password = passwordController.text;
    if (password != null && password.length == 4) {
      return true;
    }
    return false;
  }*/

  _validatePosition() {
    logger.i("_validatePosition");
    logger.i(currentPosition);
    if (currentPosition != null || !boundingBoxEnabled) {
      return true;
    }
    return false;
  }

  _validateAim() {
    final aimCode = ref.read(aimSelectionNotifierProvider.notifier).getAimCode();
    if (aimCode != null) {
      return true;
    }
    return false;
  }

  _validateAmount() {
    final amount = _amount;
    if (amount != null && amount > 0 && amount <= 1000) {
      return true;
    }
    return false;
  }

  _validateMaxAge() {
    final maxAge = _maxAge;
    if ((maxAge != null && maxAge > 0 && maxAge <= 1000) || !maxAgeEnabled) {
      return true;
    }
    return false;
  }

  _validateName() {
    final name = nameController.text;
    if (name.isNotEmpty && name.length > 4) {
      return true;
    }
    return false;
  }

  saveDraftRequest() async {
    logger.i("saveDraftRequest");
    try {
      final db = PaymentDatabase.get();
      final paymentRequest = await createModelForCreationRequest();

      if (draftRequest == null) {
        await db.insertRequest(paymentRequest);
      } else {
        await db.updateRequest(paymentRequest);
      }
    } catch (ex) {
      logger.i(ex.toString());
    }
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

  updatePolylines() {
    LatLng no = getBoundingBoxFromCircle(currentPosition, radius, -radius);
    LatLng ne = getBoundingBoxFromCircle(currentPosition, radius, radius);
    LatLng se = getBoundingBoxFromCircle(currentPosition, -radius, radius);
    LatLng so = getBoundingBoxFromCircle(currentPosition, -radius, -radius);
    locationPoints = [no, ne, se, so, no];
    // locationPoints.forEach(print);
  }

  // void close() {
  //   nameController.dispose();
  //   amountController.dispose();
  //   maxAgeController.dispose();
  // }
}
