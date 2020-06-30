import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pos/localization/app_localizations.dart';
import 'package:pos/src/blocs/payment_request/payment_request_bloc.dart';

import 'package:location/location.dart';
import 'package:pos/src/screens/request_confirm/request_confirm.dart';
import '../../back_button_text.dart';

class PositionSelectionPage extends StatefulWidget {
  @override
  _PositionSelectionPageState createState() => _PositionSelectionPageState();
}

class _PositionSelectionPageState extends State<PositionSelectionPage> {
  CreatePaymentRequestBloc bloc;

//  static final CameraPosition _kInitialPosition = const CameraPosition(
//    target: LatLng(0, 0),
//    zoom: 12.0,
//  );

  MinMaxZoomPreference _minMaxZoomPreference = MinMaxZoomPreference.unbounded;

  Set<Marker> markers = Set();
  Set<Polyline> polylines = Set();

//  LocationData _startLocation;
//  LocationData _currentLocation;

  Location _locationService = new Location();
  bool _permission = false;

  Completer<GoogleMapController> _controller = Completer();
  CameraPosition _currentCameraPosition;

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

  double sliderValue = 0.0;

  @override
  void initState() {
    super.initState();
//    initPlatformState();
  }

  initPlatformState() async {
    await _locationService.changeSettings(
        accuracy: LocationAccuracy.HIGH, interval: 1000);

    LocationData location;
    try {
      bool serviceStatus = await _locationService.serviceEnabled();
      print("Service status: $serviceStatus");
      if (serviceStatus) {
        _permission = await _locationService.requestPermission();
        print("Permission: $_permission");
        if (_permission) {
//          location = await _locationService.getLocation();
//
//          _locationSubscription = _locationService
//              .onLocationChanged()
//              .listen((LocationData result) async {
//            _currentCameraPosition = CameraPosition(
//                target: LatLng(result.latitude, result.longitude), zoom: 16);
//
//            final GoogleMapController controller = await _controller.future;
//            controller.animateCamera(
//                CameraUpdate.newCameraPosition(_currentCameraPosition));
//
//            if (mounted) {
//              setState(() {
//                _currentLocation = result;
//              });
//            }
//          });
          _updateMyLocation();
        }
      } else {
        bool serviceStatusResult = await _locationService.requestService();
        print("Service status activated after request: $serviceStatusResult");
        if (serviceStatusResult) {
          initPlatformState();
        }
      }
    } on PlatformException catch (e) {
      print(e);
      if (e.code == 'PERMISSION_DENIED') {
        print(e.message);
      } else if (e.code == 'SERVICE_STATUS_ERROR') {
        print(e.message);
      }
      print("location = null");
      location = null;
    }

//    setState(() {
//      _startLocation = location;
//    });
  }

  _onMapCreated(GoogleMapController mapController) {
    _controller.complete(mapController);
  }

  void _updateCameraPosition(CameraPosition position) {}

  _updateMyLocation() async {
    print("_updateMyLocation");
    LocationData location;
    try {
      print("getLocation()");
      location = await _locationService.getLocation();
      print(location.latitude.toString());
      print(location.longitude.toString());
      final target = LatLng(location.latitude, location.longitude);
      _currentCameraPosition = CameraPosition(target: target, zoom: 17);

      final GoogleMapController controller = await _controller.future;

      if (mounted) {
        print("updateCurrentLocation()");
        _updateCurrentLocation(target);
        controller.animateCamera(
            CameraUpdate.newCameraPosition(_currentCameraPosition));
      }
    } on PlatformException catch (e) {
      print(e.toString());
      if (e.code == 'PERMISSION_DENIED') {
        print('Permission denied');
      }
      location = null;
    }
  }

  //Add pin to tapped position
  _onTapMap(LatLng location) {
    _updateCurrentLocation(location);
  }

  void _updateCurrentLocation(LatLng target) {
    bloc.currentPosition = target;
    bloc.updatePolylines();
    setState(() {});
//    addSquare(target, bloc.radius);
//    final MarkerId markerId = MarkerId('Request Position');
//
//    Marker marker = Marker(
//      markerId: markerId,
//      position: target,
//      infoWindow: InfoWindow(title: 'Request Location', snippet: '*'),
//    );

    //TODO setState per aggiornare il marker
//    setState(() {
////      markers.clear();
////      markers.add(marker);
//    });
  }

  void addSquare(LatLng location, radius) {
//    final Polyline polyline = Polyline(
//      polylineId: PolylineId("polyline1"),
//      consumeTapEvents: true,
//      color: Colors.orange,
//      width: 15,
//      points: bloc.locationPoints,
//    );
//
//    polylines.clear();
//    setState(() {
//      polylines.add(polyline);
//    });
  }

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<CreatePaymentRequestBloc>(context);
    final isValid = bloc.isValidPosition;

    Marker marker = Marker(
      markerId: MarkerId("my_position"),
      position: bloc.currentPosition ?? bloc.lastPosition,
      infoWindow: InfoWindow(title: 'Request Location', snippet: '*'),
    );

    Circle circle = Circle(
        radius: bloc.radius,
        strokeColor: Colors.red,
        center: bloc.currentPosition ?? bloc.lastPosition,
        fillColor: Colors.red.withOpacity(0.3),
        circleId: CircleId("circle2"));

    final GoogleMap googleMap = GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: bloc.currentPosition ?? bloc.lastPosition ?? LatLng(0, 0),
        zoom: 17.0,
      ),
      minMaxZoomPreference: _minMaxZoomPreference,
      myLocationEnabled: true,
      onCameraMove: _updateCameraPosition,
//      markers: {marker},
      circles: {circle},
//      polylines: polylines,
      onTap: _onTapMap,
//      compassEnabled: _compassEnabled,
//      cameraTargetBounds: _cameraTargetBounds,
//      mapType: _mapType,
//      rotateGesturesEnabled: _rotateGesturesEnabled,
//      scrollGesturesEnabled: _scrollGesturesEnabled,
//      tiltGesturesEnabled: _tiltGesturesEnabled,
//      zoomGesturesEnabled: _zoomGesturesEnabled,
    );

    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 30.0,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      AppLocalizations.of(context)
                          .translate('what_are_interest'),
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Switch(
                  value: bloc.boundingBoxEnabled,
                  onChanged: (value) {
                    if (value) {
                      initPlatformState();
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

//                label: '${(bloc.radius / 1000).floor()}km',
                label:
                    '${bloc.radius > 500 ? bloc.radius ~/ 1000 : bloc.radius.toInt()}${bloc.radius > 500 ? 'km' : 'm'}',
                activeColor: Theme.of(context).accentColor,
                inactiveColor: Colors.white,
//                onChangeEnd: (value) {
//                  _controller.future.then((c) {
//                    c.animateCamera(CameraUpdate.zoomBy((bloc.radius/1000)/0.12));
//                  });
//                },
                onChanged: bloc.boundingBoxEnabled
                    ? (value) {
                        sliderValue = value;
//                        addSquare(bloc.currentPosition, value);
                        setState(() {
                          bloc.radius =
                              sliderSteps[sliderValue.toInt()].toDouble();
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
                            initPlatformState();
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
                                AppLocalizations.of(context)
                                    .translate('touch_to_enable_filter_map'),
                                style: TextStyle(
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
                          icon: Icon(
                            Icons.update,
                            size: 21.0,
                          ),
                          onPressed: _updateMyLocation,
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
                heroTag: Key("positionHero"),
                child: Icon(Icons.arrow_forward_ios),
                onPressed: () {
                  bloc.saveCurrentPosition();
                  goToRequestScreen();
                },
              )
            : null,
      ),
    );
  }

  goToRequestScreen() async {
    final womRequest = await bloc.createModelForCreationRequest();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (ctx) => RequestConfirmScreen(
          paymentRequest: womRequest,
        ),
      ),
    );
  }

  @override
  void dispose() {
    print("dispose map page");
    super.dispose();
  }
}
