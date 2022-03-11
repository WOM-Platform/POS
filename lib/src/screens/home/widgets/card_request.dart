import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pos/localization/app_localizations.dart';
import 'package:pos/src/model/payment_request.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:pos/src/model/request_status_enum.dart';
import '../../../../custom_icons.dart';

class MyRichText extends StatelessWidget {
  final String t1;
  final String t2;

  const MyRichText({Key? key, required this.t1, required this.t2})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AutoSizeText.rich(
      TextSpan(
        text: t1,
        children: <TextSpan>[
          TextSpan(
            text: t2,
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
      maxLines: 1,
      style: TextStyle(fontSize: 17.0, color: Colors.grey),
    );
  }
}

class CardRequest extends StatelessWidget {
  final PaymentRequest request;
  final Function onDelete;
  final Function onEdit;
  final Function onDuplicate;
  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();

  CardRequest({
    Key? key,
    required this.request,
    required this.onDelete,
    required this.onEdit,
    required this.onDuplicate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final languageCode = AppLocalizations.of(context)?.locale.languageCode;
    return Container(
//      height: 275,
      padding: const EdgeInsets.all(4.0),
      child: FlipCard(
        key: cardKey,
        flipOnTouch: false,
        front: Card(
          elevation: 8.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    const SizedBox(
                      width: 8.0,
                    ),
                    Expanded(
                      child: AutoSizeText(
                        '${request.name}',
                        maxLines: 1,
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      width: 8.0,
                    ),
                    const Spacer(),
                    Tooltip(
                      child: Icon(
                          request.onCloud ? Icons.cloud_done : Icons.cloud_off),
                      message: request.onCloud ? 'In cloud' : 'In locale',
                    ),
                    const SizedBox(
                      width: 8.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Tooltip(
                        message: request.status == RequestStatus.COMPLETE
                            ? 'Completa'
                            : 'Bozza',
                        child: CircleAvatar(
                          radius: 10,
                          backgroundColor:
                              request.status == RequestStatus.COMPLETE
                                  ? Colors.green
                                  : Colors.orange,
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(
                  height: 2,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          ItemRow2(
                            tooltip: 'Request ID',
                            icon: MdiIcons.identifier,
                            text: request.id.toString(),
                          ),
                          ItemRow2(
                            tooltip: 'Persistent',
                            icon: MdiIcons.infinity,
                            text: request.persistent
                                ? AppLocalizations.of(context)
                                        ?.translate('yes') ??
                                    ''
                                : 'No',
                          ),
                          ItemRow2(
                            tooltip: 'Aim',
                            icon: MdiIcons.shapeOutline,
                            text: (request.aim?.titles ??
                                    const {})[languageCode ?? 'en'] ??
                                '-',
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          ItemRow2(
                            tooltip: 'Pin',
                            icon: request.password != null
                                ? MdiIcons.lockOutline
                                : MdiIcons.lockOpenOutline,
                            text: request.password ?? '-',
                          ),
                          ItemRow2(
                            tooltip: 'Max age',
                            icon: request.simpleFilter?.maxAge != null
                                ? MdiIcons.timerSand
                                : MdiIcons.timerSandEmpty,
                            text:
                                request.simpleFilter?.maxAge?.toString() ?? '-',
                          ),
                          ItemRow2(
                            tooltip: 'Bounding Box',
                            onPressed: () {
                              if ((request.location != null &&
                                  request.simpleFilter?.bounds != null)) {
                                cardKey.currentState?.toggleCard();
                              }
                            },
                            icon: request.simpleFilter?.bounds != null
                                ? MdiIcons.mapCheckOutline
                                : MdiIcons.mapOutline,
                            text:
                                request.simpleFilter?.bounds?.toString() ?? '-',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(
                  height: 2,
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Spacer(),
                    Tooltip(
                      message: 'WOM',
                      child: Container(
                        padding: const EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1.0,
                                color: Theme.of(context).primaryColor),
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            )),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              '${request.amount}',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.bold),
                            ),
                            Icon(
                              CustomIcons.wom_logo,
                              color: Theme.of(context).primaryColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        back: (request.location != null && request.simpleFilter?.bounds != null)
            ? Container(
                height: 250,
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  elevation: 8.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: GoogleMap(
                    onTap: (lat) => cardKey.currentState?.toggleCard(),
                    onMapCreated: (controller) {},
                    cameraTargetBounds: CameraTargetBounds(
                      LatLngBounds(
                        southwest: LatLng(
                          request.simpleFilter!.bounds!.rightBottom![0],
                          request.simpleFilter!.bounds!.leftTop![1],
                        ),
                        northeast: LatLng(
                          request.simpleFilter!.bounds!.leftTop![0],
                          request.simpleFilter!.bounds!.rightBottom![1],
                        ),
                      ),
                    ),
                    initialCameraPosition: CameraPosition(
                      target: LatLng(request.location!.latitude,
                          request.location!.longitude),
                      zoom: 12,
                    ),
                    rotateGesturesEnabled: false,
                    scrollGesturesEnabled: false,
                    zoomGesturesEnabled: false,
                    tiltGesturesEnabled: false,
                    compassEnabled: false,
                    myLocationButtonEnabled: false,
                    myLocationEnabled: false,
                    mapToolbarEnabled: false,
//                    circles: {
//                      Circle(
//                        circleId: CircleId('bb'),
//                        radius: getRadiusFromBoundingBox(
//                            request.simpleFilter.bounds.leftTop,
//                            request.simpleFilter.bounds.rightBottom),
//                        strokeColor: Colors.green,
//                        strokeWidth: 1,
//                        center: request.location,
//                        fillColor: Colors.green.withOpacity(0.3),
//                      )
//                    },
                    markers: {
                      if (request.location != null)
                        Marker(
                          markerId: MarkerId(request.id.toString()),
                          position: request.location!,
                        ),
                    },
                    polygons: {
                      Polygon(
                        polygonId: PolygonId('bounding_box'),
                        points: request.bbPoints,
                        fillColor: Colors.green.withOpacity(0.3),
                        strokeColor: Colors.green.withOpacity(0.7),
                        strokeWidth: 2,
                      )
                    },
                  ),
                ),
              )
            : Container(),
      ),
    );
  }
}

class ItemRow extends StatelessWidget {
  final String t1;
  final String t2;

  const ItemRow({Key? key, required this.t1, required this.t2})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(
          child: AutoSizeText(
            ' $t1',
            style: TextStyle(color: Colors.grey),
            maxLines: 1,
            textAlign: TextAlign.end,
          ),
        ),
        Expanded(
          child: AutoSizeText(
            ' $t2',
            maxLines: 1,
            minFontSize: 9,
            stepGranularity: 0.1,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

class ItemRow2 extends StatelessWidget {
  final String text;
  final String tooltip;
  final IconData icon;
  final Function()? onPressed;

  const ItemRow2(
      {Key? key,
      required this.text,
      required this.icon,
      required this.tooltip,
      this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        IconButton(
          tooltip: tooltip,
          icon: Icon(icon),
          onPressed: onPressed,
        ),
        Expanded(
          child: AutoSizeText(
            text,
            maxLines: 2,
            minFontSize: 8,
            stepGranularity: 0.1,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
