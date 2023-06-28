import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:location/location.dart' as locService;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pos/src/my_logger.dart';
import 'package:pos/src/offers/application/create_offer_notifier.dart';

const sliderSteps = <double>[
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

const cameraZoom = <double>[
  17,
  16.5,
  15,
  14,
  13,
  11.8,
  10.8,
  10,
  8.5,
  7.6,
  6.5,
  5,
  3.8
];

class PositionSelectionPage extends StatefulHookConsumerWidget {
  static const String path = 'positionSelection';
  @override
  _PositionSelectionPageState createState() => _PositionSelectionPageState();
}

class _PositionSelectionPageState extends ConsumerState<PositionSelectionPage> {
  MinMaxZoomPreference _minMaxZoomPreference = MinMaxZoomPreference.unbounded;
  final _locationService = locService.Location();
  final Completer<GoogleMapController> _controller = Completer();
  CameraPosition _currentCameraPosition =
      const CameraPosition(target: LatLng(0.0, 0.0), zoom: 17);

  String? positionProcess;

  @override
  initState() {
    super.initState();
    initPlatformState();
  }

  Future<bool> initPlatformState() async {
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
        _updateMyLocation();
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

  double currentZoom = 17.0;

  _onMapCreated(GoogleMapController mapController) {
    _controller.complete(mapController);
  }

  void _updateCameraPosition(CameraPosition position) {
    print(position.zoom);
    currentZoom = position.zoom;
  }

  _updateMyLocation() async {
    logger.i("_updateMyLocation");
    locService.LocationData? location;
    try {
      setState(() {
        positionProcess = 'acquiringPosition'.tr();
      });
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
        setState(() {
          positionProcess = null;
        });
        _updateCurrentLocation(target, sliderSteps[0].toDouble());
        controller.animateCamera(
            CameraUpdate.newCameraPosition(_currentCameraPosition));
      }
    } on PlatformException catch (e) {
      logger.i(e.toString());
      setState(() {
        positionProcess = null;
      });
      if (e.code == 'PERMISSION_DENIED') {
        logger.i('Permission denied');
      }
      location = null;
    }
  }

  //Add pin to tapped position
  _onTapMap(LatLng location, double radius) {
    _updateCurrentLocation(location, radius);
  }

  void _updateCurrentLocation(LatLng target, double radius) {
    ref
        .read(createOfferNotifierProvider.notifier)
        .updatePolygone(target, radius);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(createOfferNotifierProvider);
    final slider = useState(0.0);
    final radiusNotifier = useState(0.0);
    final radius = radiusNotifier.value;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          elevation: 0,
          title: Text(
            'what_are_interest'.tr(),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'bounding_box_help'.tr(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
            SliderTheme(
              data: Theme.of(context).sliderTheme.copyWith(
                    activeTrackColor: Colors.grey[100],
                    inactiveTrackColor: Theme.of(context).colorScheme.secondary,
                    activeTickMarkColor: Colors.grey,
                    inactiveTickMarkColor: Colors.white,
                    overlayColor: Colors.black12,
                    thumbColor: Theme.of(context).colorScheme.secondary,
                    valueIndicatorColor: Theme.of(context).colorScheme.secondary,
                    valueIndicatorTextStyle: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold),
                  ),
              child: Slider(
                value: slider.value,
                min: 0.0,
                max: sliderSteps.length.toDouble() - 1.0,
                divisions: sliderSteps.length - 1,
                label:
                    '${radius > 500 ? radius ~/ 1000 : radius.toInt()}${radius > 500 ? 'km' : 'm'}',
                activeColor: Theme.of(context).colorScheme.secondary,
                inactiveColor: Colors.white,
                onChanged: (value) {
                  slider.value = value;
                  radiusNotifier.value =
                      sliderSteps[slider.value.toInt()].toDouble();

                  if (state.mapPolygon == null) {
                    return;
                  }

                  if (currentZoom > cameraZoom[slider.value.toInt()]) {
                    _controller.future.then((value) => value.animateCamera(
                        CameraUpdate.newCameraPosition(CameraPosition(
                            target: state.mapPolygon!.target,
                            zoom:
                                cameraZoom[slider.value.toInt()].toDouble()))));
                  }
                  ref.read(createOfferNotifierProvider.notifier).updatePolygone(
                      state.mapPolygon!.target,
                      sliderSteps[slider.value.toInt()].toDouble());
                },
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: state.mapPolygon?.target ?? LatLng(0, 0),
                      zoom: 17.0,
                    ),
                    zoomControlsEnabled: false,
                    minMaxZoomPreference: _minMaxZoomPreference,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    onCameraMove: _updateCameraPosition,
                    polygons: {
                      if (state.mapPolygon != null &&
                          state.mapPolygon!.polygon.isNotEmpty)
                        Polygon(
                          polygonId: PolygonId('bounding_box'),
                          points: state.mapPolygon!.polygon,
                          fillColor: Colors.green.withOpacity(0.3),
                          strokeColor: Colors.green.withOpacity(0.7),
                          strokeWidth: 2,
                        )
                    },
                    onTap: (l) => _onTapMap(
                        l, sliderSteps[slider.value.toInt()].toDouble()),
                  ),
                  Positioned(
                    left: 16.0,
                    top: 16.0,
                    child: Card(
                      child: Container(
                        height: 50.0,
                        width: 50.0,
                        alignment: Alignment.center,
                        child: IconButton(
                          icon: const Icon(
                            Icons.my_location_rounded,
                            size: 30.0,
                          ),
                          onPressed: () => _updateMyLocation(),
                        ),
                      ),
                    ),
                  ),
                  if (positionProcess != null)
                    Positioned.fill(
                      child: Container(
                        color: Colors.black54,
                        alignment: Alignment.center,
                        child: Text(
                          positionProcess!,
                          style: TextStyle(color: Colors.white, fontSize: 30),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: const Key("positionHero"),
          child: const Icon(Icons.check),
          onPressed: () {
            context.pop();
          },
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
