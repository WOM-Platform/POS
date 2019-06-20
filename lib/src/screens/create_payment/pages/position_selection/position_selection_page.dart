import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pos/src/screens/create_payment/bloc.dart';
import 'package:location/location.dart';
import 'package:pos/src/screens/request_confirm/request_confirm.dart';
import '../../back_button_text.dart';

class PositionSelectionPage extends StatefulWidget {
  @override
  _PositionSelectionPageState createState() => _PositionSelectionPageState();
}

class _PositionSelectionPageState extends State<PositionSelectionPage> {
  CreatePaymentRequestBloc bloc;

  static final CameraPosition _kInitialPosition = const CameraPosition(
    target: LatLng(0, 0),
    zoom: 11.0,
  );

  MinMaxZoomPreference _minMaxZoomPreference = MinMaxZoomPreference.unbounded;

  Set<Marker> markers = Set();
  Set<Polyline> polylines = Set();

//  LocationData _startLocation;
//  LocationData _currentLocation;

  Location _locationService = new Location();
  bool _permission = false;

  Completer<GoogleMapController> _controller = Completer();
  CameraPosition _currentCameraPosition;

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
      _currentCameraPosition = CameraPosition(target: target, zoom: 16);

      final GoogleMapController controller = await _controller.future;

      if (mounted) {
        print("updateCurrentLocation()");
        _updateCurrentLocation(target);
        controller.animateCamera(
            CameraUpdate.newCameraPosition(_currentCameraPosition));
//        setState(() {
//          _currentLocation = location;
//        });
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
        target: bloc.lastPosition ?? LatLng(0, 0),
        zoom: 11.0,
      ),
      minMaxZoomPreference: _minMaxZoomPreference,
      myLocationEnabled: true,
      onCameraMove: _updateCameraPosition,
//      markers: {marker},
      circles: {circle},
      polylines: polylines,
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
            Container(
              height: 140.0,
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.bottomLeft,
              child: Text(
                "Seleziona un'area sulla mappa",
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold),
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
            Slider(
              value: bloc.radius,
              min: 5000,
              max: 500000,
              onChanged: (double value) {
                bloc.radius = value;
                addSquare(bloc.currentPosition, value);
              },
            ),
            Expanded(
              child: Stack(
                children: [
                  googleMap,
                  Container(
                    color: !bloc.boundingBoxEnabled
                        ? Colors.grey.withOpacity(0.5)
                        : null,
                  ),
                  !bloc.boundingBoxEnabled
                      ? Center(
                          child: Text(
                          "Abilitare la mappa",
                          style:
                              TextStyle(color: Colors.yellow, fontSize: 30.0),
                        ))
                      : Container(),
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

  void _updateCurrentLocation(LatLng target) {
    bloc.currentPosition = target;
    addSquare(target, bloc.radius);
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
    bloc.updatePolylines();

    final Polyline polyline = Polyline(
      polylineId: PolylineId("polyline1"),
      consumeTapEvents: true,
      color: Colors.orange,
      width: 15,
      points: bloc.locationPoints,
    );

    polylines.clear();
    setState(() {
      polylines.add(polyline);
    });
  }

  @override
  void dispose() {
    print("dispose map page");
    super.dispose();
  }
}
