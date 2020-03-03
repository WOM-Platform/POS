import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pos/src/db/payment_database/payment_database.dart';
import 'package:pos/src/model/payment_request.dart';
import 'package:mmkv_flutter/mmkv_flutter.dart';
import 'package:pos/src/screens/create_payment/pages/aim_selection/bloc.dart';
import 'package:wom_package/wom_package.dart';
import 'dart:math' as math;
import '../../../app.dart';
import '../../constants.dart';

enum RequestType {
  SINGLE,
  MULTIPLE,
}

class CreatePaymentRequestBloc extends Bloc {
  AimSelectionBloc aimSelectionBloc;

  TextEditingController nameController;
  TextEditingController amountController;
  TextEditingController maxAgeController;
  TextEditingController passwordController;

//  RequestType requestType = RequestType.SINGLE;
  bool persistentRequest = false;
  final PageController pageController = PageController();
  final String posId;
  LatLng currentPosition;
  LatLng lastPosition;
  List<LatLng> locationPoints = [];

  double radius = 100.0;
  bool maxAgeEnabled = false;
  bool boundingBoxEnabled = false;

  int get _amount => int.tryParse(amountController.text);

  int get _maxAge => int.tryParse(maxAgeController.text);

  final PaymentRequest draftRequest;

  final String languageCode;

  CreatePaymentRequestBloc({
    @required this.draftRequest,
    @required this.languageCode,
    @required this.posId,
  }) {
    print("CreatePaymentRequestBloc()");
    nameController = TextEditingController(text: draftRequest?.name ?? "");
    amountController =
        TextEditingController(text: draftRequest?.amount?.toString() ?? "");
    maxAgeController = TextEditingController(
        text: draftRequest?.simpleFilter?.maxAge?.toString() ?? "");
    passwordController =
        TextEditingController(text: draftRequest?.password ?? "");
    aimSelectionBloc = AimSelectionBloc(languageCode ?? 'en');
    if (draftRequest?.aimCode != null) {
      aimSelectionBloc.setAimCode(draftRequest.aimCode);
    }
    getLastPosition();
  }

  createModelForCreationRequest() async {
    final aim = await aimSelectionBloc.getAim();
//    final String password = passwordController.text;
    final String name = nameController.text;

    final SimpleFilters simpleFilter = SimpleFilters(
      aimCode: aim?.code,
      maxAge: maxAgeEnabled ? _maxAge : null,
      bounds: boundingBoxEnabled
          ? BoundingBox(leftTop: [
              locationPoints[0].latitude,
              locationPoints[0].longitude
            ], rightBottom: [
              locationPoints[2].latitude,
              locationPoints[2].longitude
            ])
          : null,
    );

    final PaymentRequest paymentRequest = PaymentRequest(
        posId: this.posId,
        dateTime: DateTime.now(),
        amount: _amount,
        aim: aim,
        aimCode: aim?.code,
        aimName: (aim?.titles ?? const {})[languageCode ?? 'en'],
        location: currentPosition,
        persistent: persistentRequest ?? false,
        name: name,
        status: RequestStatus.DRAFT,
        simpleFilter: simpleFilter,
        pocketAckUrl: "www.wom.social");

    if (draftRequest != null) {
      paymentRequest.id = draftRequest.id;
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

  bool get isValidPassword => _validatePassword();

  bool get isValidMaxAge => _validateMaxAge();

  saveCurrentPosition() async {
    if (boundingBoxEnabled) {
      print("saveCurrentPosition");
      MmkvFlutter mmkv = await MmkvFlutter.getInstance();
      mmkv.setDouble(LAST_LATITUDE, currentPosition.latitude);
      mmkv.setDouble(LAST_LONGITUDE, currentPosition.longitude);
      print("currentPositionSaved");
    }
  }

  getLastPosition() async {
    print("getLastPosition");
    MmkvFlutter mmkv = await MmkvFlutter.getInstance();
    final latitude = await mmkv.getDouble(LAST_LATITUDE);
    final longitude = await mmkv.getDouble(LAST_LONGITUDE);

    if (latitude == null || longitude == null) {
      lastPosition = null;
    }
    print("lastPosition = $latitude, $longitude");
    lastPosition = LatLng(latitude, longitude);
  }

  _validatePassword() {
    final password = passwordController.text;
    if (password != null && password.length == 4) {
      return true;
    }
    return false;
  }

  _validatePosition() {
    print("_validatePosition");
    print(currentPosition);
    if (currentPosition != null || !boundingBoxEnabled) {
      return true;
    }
    return false;
  }

  _validateAim() {
    final aimCode = aimSelectionBloc.getAimCode();
    if (aimCode != null || !aimSelectionBloc.aimEnabled) {
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
    print("saveDraftRequest");
    final db = PaymentDatabase.get();
    final paymentRequest = await createModelForCreationRequest();
    try {
      if (draftRequest == null) {
        await db.insertRequest(paymentRequest);
      } else {
        await db.updateRequest(paymentRequest);
      }
    } catch (ex) {
      print(ex.toString());
    }
  }

  @override
  get initialState => null;

  @override
  Stream mapEventToState(event) {
    return null;
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
  }

  @override
  void dispose() {
    pageController.dispose();
    nameController.dispose();
    passwordController.dispose();
    amountController.dispose();
    aimSelectionBloc.dispose();
    maxAgeController.dispose();
//    _streamPage.close();
    super.dispose();
  }
}
