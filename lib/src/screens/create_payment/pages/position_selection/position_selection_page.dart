import 'dart:async';
import 'package:dart_wom_connector/dart_wom_connector.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pos/localization/app_localizations.dart';
import 'package:pos/src/blocs/home/bloc.dart';
import 'package:pos/src/blocs/payment_request/payment_request_bloc.dart';

import 'package:location/location.dart' as locService;
import 'package:pos/src/offers/application/offers.dart';
import 'package:pos/src/screens/request_confirm/bloc.dart';
import 'package:pos/src/screens/request_confirm/request_confirm.dart';
import '../../../../my_logger.dart';
import '../../back_button_text.dart';

class PositionSelectionPage extends ConsumerStatefulWidget {
  @override
  _PositionSelectionPageState createState() => _PositionSelectionPageState();
}

class _PositionSelectionPageState extends ConsumerState<PositionSelectionPage> {
  MinMaxZoomPreference _minMaxZoomPreference = MinMaxZoomPreference.unbounded;
  Set<Marker> markers = <Marker>{};
  final _locationService = locService.Location();
  double sliderValue = 0.0;
  final Completer<GoogleMapController> _controller = Completer();
  CameraPosition _currentCameraPosition =
      const CameraPosition(target: LatLng(0.0, 0.0), zoom: 17);

  final sliderSteps = [
    100,
    200,
    500,
    1000,
    2000,
    5000,
    10000,
    20000,
    50000,
    100000,
    200000,
    500000,
    1000000
  ];

  Future<bool> initPlatformState(CreatePaymentRequestBloc bloc) async {
    locService.LocationData? location;
    try {
      bool serviceStatus = await _locationService.serviceEnabled();
      logger.i("Service status: $serviceStatus");
      if (!serviceStatus) {
        bool serviceStatusResult = await _locationService.requestService();
        if (!serviceStatusResult) {
          return false;
        }
      }
      final permissionStatus = await _locationService.requestPermission();
      logger.i("Permission: $permissionStatus");
      if (permissionStatus == locService.PermissionStatus.granted) {
        await _locationService.changeSettings(
            accuracy: locService.LocationAccuracy.high, interval: 1000);
        _updateMyLocation(bloc);
        return true;
      }
      return false;
    } on PlatformException catch (e) {
      logger.i(e);
      if (e.code == 'PERMISSION_DENIED') {
        logger.i(e.message);
      } else if (e.code == 'SERVICE_STATUS_ERROR') {
        logger.i(e.message);
      }
      logger.i("location = null");
      return false;
    }
  }

  _onMapCreated(GoogleMapController mapController) {
    _controller.complete(mapController);
  }

  void _updateCameraPosition(CameraPosition position) {}

  _updateMyLocation(CreatePaymentRequestBloc bloc) async {
    logger.i("_updateMyLocation");
    locService.LocationData? location;
    try {
      logger.i("getLocation()");
      location = await _locationService.getLocation();
      logger.i(location.latitude.toString());
      logger.i(location.longitude.toString());
      final target =
          LatLng(location.latitude ?? 0.0, location.longitude ?? 0.0);
      _currentCameraPosition = CameraPosition(target: target, zoom: 17);

      final GoogleMapController controller = await _controller.future;

      if (mounted) {
        logger.i("updateCurrentLocation()");
        _updateCurrentLocation(bloc, target);
        controller.animateCamera(
            CameraUpdate.newCameraPosition(_currentCameraPosition));
      }
    } on PlatformException catch (e) {
      logger.i(e.toString());
      if (e.code == 'PERMISSION_DENIED') {
        logger.i('Permission denied');
      }
      location = null;
    }
  }

  //Add pin to tapped position
  _onTapMap(CreatePaymentRequestBloc bloc, LatLng location) {
    _updateCurrentLocation(bloc, location);
  }

  void _updateCurrentLocation(CreatePaymentRequestBloc bloc, LatLng target) {
    bloc.currentPosition = target;
    bloc.updatePolylines();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final bloc = ref.watch(createPaymentNotifierProvider);
    final isValid = bloc.isValidPosition;
    final square = Polygon(
      polygonId: PolygonId('bounding_box'),
      points: bloc.locationPoints,
      fillColor: Colors.green.withOpacity(0.3),
      strokeColor: Colors.green.withOpacity(0.7),
      strokeWidth: 2,
    );

    final GoogleMap googleMap = GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: bloc.currentPosition, //?? bloc.lastPosition ?? LatLng(0, 0),
        zoom: 17.0,
      ),
      minMaxZoomPreference: _minMaxZoomPreference,
      myLocationEnabled: true,
      onCameraMove: _updateCameraPosition,
//      circles: {circle},
      polygons: {square},
      onTap: (l) => _onTapMap(bloc, l),
    );

    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 30.0),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 8.0),
              child: Text(
                AppLocalizations.of(context)?.translate('what_are_interest') ??
                    '',
                textAlign: TextAlign.start,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  AppLocalizations.of(context)
                          ?.translate('enable_disable_filter') ??
                      '',
                  style: const TextStyle(color: Colors.white),
                ),
                Switch(
                  value: bloc.boundingBoxEnabled,
                  onChanged: (value) {
                    if (value) {
                      initPlatformState(bloc);
                    }
                    setState(
                      () {
                        bloc.boundingBoxEnabled = value;
                      },
                    );
                  },
                ),
              ],
            ),
            SliderTheme(
              data: Theme.of(context).sliderTheme.copyWith(
                    activeTrackColor: Colors.grey[100],
                    inactiveTrackColor: Theme.of(context).accentColor,
                    activeTickMarkColor: Colors.grey,
                    inactiveTickMarkColor: Colors.white,
                    overlayColor: Colors.black12,
                    thumbColor: Theme.of(context).accentColor,
                    valueIndicatorColor: Theme.of(context).accentColor,
                    valueIndicatorTextStyle: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold),
                  ),
              child: Slider(
                value: sliderValue,
                min: 0.0,
                max: sliderSteps.length.toDouble() - 1.0,
                divisions: sliderSteps.length - 1,
                label:
                    '${bloc.radius > 500 ? bloc.radius ~/ 1000 : bloc.radius.toInt()}${bloc.radius > 500 ? 'km' : 'm'}',
                activeColor: Theme.of(context).accentColor,
                inactiveColor: Colors.white,
                onChanged: bloc.boundingBoxEnabled
                    ? (value) {
                        sliderValue = value;
                        setState(() {
                          bloc.radius =
                              sliderSteps[sliderValue.toInt()].toDouble();
                          bloc.updatePolylines();
                        });
                      }
                    : null,
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  googleMap,
                  GestureDetector(
                    onTap: bloc.boundingBoxEnabled
                        ? null
                        : () {
                            initPlatformState(bloc);
                            setState(
                              () {
                                bloc.boundingBoxEnabled = true;
                              },
                            );
                          },
                    child: Container(
                      color: !bloc.boundingBoxEnabled
                          ? Colors.grey.withOpacity(0.5)
                          : null,
                      child: !bloc.boundingBoxEnabled
                          ? Center(
                              child: Text(
                                AppLocalizations.of(context)?.translate(
                                        'touch_to_enable_filter_map') ??
                                    '',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            )
                          : Container(),
                    ),
                  ),
                  Positioned(
                    left: 5.0,
                    top: 5.0,
                    child: Card(
                      child: Container(
                        height: 37.0,
                        width: 37.0,
                        alignment: Alignment.center,
                        child: IconButton(
                          icon: const Icon(
                            Icons.update,
                            size: 21.0,
                          ),
                          onPressed: () => _updateMyLocation(bloc),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 20.0,
            ),
            BackButtonText(
              onTap: () => bloc.goToPreviousPage(),
            ),
          ],
        ),
        floatingActionButton: isValid
            ? FloatingActionButton(
                heroTag: const Key("positionHero"),
                child: const Icon(Icons.arrow_forward_ios),
                onPressed: () {
                  bloc.saveCurrentPosition();
                  goToRequestScreen(bloc);
                },
              )
            : null,
      ),
    );
  }

  goToRequestScreen(CreatePaymentRequestBloc bloc) async {
    final womRequest = await bloc.createModelForCreationRequest();
    final pos = ref.read(selectedPosProvider)?.pos;
    if (pos == null) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (ctx) => ProviderScope(
          // parent:  ProviderScope.containerOf(context),
          overrides: [
            paymentRequestProvider.overrideWith((ref) => womRequest),
            requestConfirmNotifierProvider.overrideWith(
              (ref) => RequestConfirmBloc(
                ref: ref,
                pos: ref.read(getPosProvider),
                pointOfSale: pos,
              ),
            ),
          ],
          child: const RequestConfirmScreen(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    logger.i("dispose map page");
    super.dispose();
  }
}
