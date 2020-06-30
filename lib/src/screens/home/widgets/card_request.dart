import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pos/localization/app_localizations.dart';
import 'package:pos/src/model/payment_request.dart';
import 'package:wom_package/wom_package.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'dart:math' as math;
import 'package:vector_math/vector_math.dart' as vec_math;
import '../../../../custom_icons.dart';
import '../../../utils.dart';

class CardRequest extends StatelessWidget {
  final PaymentRequest request;
  final Function onDelete;
  final Function onEdit;
  final Function onDuplicate;

  const CardRequest(
      {Key key, this.request, this.onDelete, this.onEdit, this.onDuplicate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      clipBehavior: Clip.antiAlias,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 10.0,
            color: request.status == RequestStatus.COMPLETE
                ? Colors.green
                : request.status == RequestStatus.DRAFT
                    ? Colors.orange
                    : Colors.red,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  MyRichText(
                    t1: 'ID: ',
                    t2: '${request.id.toString()}',
                  ),
                  MyRichText(
                    t1: 'Name: ',
                    t2: request.name,
                  ),
                  MyRichText(
                    t1: 'Date: ',
                    t2: request.dateString,
                  ),
                  MyRichText(
                    t1: 'Amount:',
                    t2: request.amount.toString(),
                  ),
                  MyRichText(
                    t1: "Aim: ",
                    t2: request.aimName,
                  ),
                  MyRichText(
                    t1: "Password: ",
                    t2: request.password,
                  ),
                  MyRichText(
                    t1: "MaxAge: ",
                    t2: "${request?.simpleFilter?.maxAge}",
                  ),
                  MyRichText(
                    t1: "Bounding Box: ",
                    t2: "${request?.simpleFilter?.bounds.toString()}",
                  ),
                ],
              ),
            ),
          ),
//          Spacer(),
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              IconButton(icon: Icon(Icons.share), onPressed: null),
              IconButton(
                  icon: Icon(request.status == RequestStatus.COMPLETE
                      ? Icons.control_point_duplicate
                      : Icons.edit),
                  onPressed: request.status == RequestStatus.COMPLETE
                      ? onDuplicate
                      : onEdit),
              IconButton(icon: Icon(Icons.delete), onPressed: onDelete),
            ],
          )
        ],
      ),
    );
  }
}

class MyRichText extends StatelessWidget {
  final String t1;
  final String t2;

  const MyRichText({Key key, this.t1, this.t2}) : super(key: key);

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

class CardRequest2 extends StatelessWidget {
  final PaymentRequest request;
  final Function onDelete;
  final Function onEdit;
  final Function onDuplicate;
  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();
  CardRequest2(
      {Key key, this.request, this.onDelete, this.onEdit, this.onDuplicate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final languageCode = AppLocalizations.of(context).locale.languageCode;
    return Container(
      height: 275,
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
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          '${request.name}',
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Spacer(),
                    Tooltip(
                      child: Icon(
                          request.onCloud ? Icons.cloud_done : Icons.cloud_off),
                      message: request.onCloud ? 'In cloud' : 'In locale',
                    ),
                    SizedBox(
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
                Divider(
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
                                ? AppLocalizations.of(context).translate('yes')
                                : 'No',
                          ),
                          ItemRow2(
                            tooltip: 'Aim',
                            icon: MdiIcons.shapeOutline,
                            text: (request?.aim?.titles ??
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
                            icon: request?.password != null
                                ? MdiIcons.lockOutline
                                : MdiIcons.lockOpenOutline,
                            text: request?.password ?? '-',
                          ),
                          ItemRow2(
                            tooltip: 'Max age',
                            icon: request?.simpleFilter?.maxAge != null
                                ? MdiIcons.timerSand
                                : MdiIcons.timerSandEmpty,
                            text: request?.simpleFilter?.maxAge?.toString() ??
                                '-',
                          ),
                          ItemRow2(
                            tooltip: 'Bounding Box',
                            onPressed: () {
                              if (request.location != null) {
                                cardKey.currentState.toggleCard();
                              }
                            },
                            icon: request?.simpleFilter?.bounds != null
                                ? MdiIcons.mapCheckOutline
                                : MdiIcons.mapOutline,
                            text: request?.simpleFilter?.bounds?.toString() ??
                                '-',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Divider(
                  height: 2,
                ),
                SizedBox(
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
        back: request.location != null
            ? Container(
                height: 275,
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  elevation: 8.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: GoogleMap(
                    onTap: (lat) => cardKey.currentState.toggleCard(),
                    initialCameraPosition: CameraPosition(
                      target: LatLng(request.location.latitude,
                          request.location.longitude),
                      zoom: 16,
                    ),
                    rotateGesturesEnabled: false,
                    scrollGesturesEnabled: false,
                    zoomGesturesEnabled: false,
                    tiltGesturesEnabled: false,
                    compassEnabled: false,
                    myLocationButtonEnabled: false,
                    myLocationEnabled: false,
                    mapToolbarEnabled: false,
                    circles: {
                      Circle(
                        circleId: CircleId('bb'),
                        radius: getRadiusFromBoundingBox(
                            request.simpleFilter.bounds.leftTop,
                            request.simpleFilter.bounds.rightBottom),
                        strokeColor: Colors.green,
                        strokeWidth: 1,
                        center: request.location,
                        fillColor: Colors.green.withOpacity(0.3),
                      )
                    },
                    markers: {
                      Marker(
                          markerId: MarkerId(request.id.toString()),
                          position: request.location),
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

  const ItemRow({Key key, this.t1, this.t2}) : super(key: key);

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
  final Function onPressed;
  const ItemRow2({Key key, this.text, this.icon, this.tooltip, this.onPressed})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        IconButton(
          tooltip: tooltip,
          icon: Icon(icon),
          onPressed: onPressed ?? () {},
        ),
        Expanded(
          child: AutoSizeText(
            text,
            maxLines: 2,
            minFontSize: 9,
            stepGranularity: 0.1,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
