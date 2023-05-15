import 'package:dart_wom_connector/dart_wom_connector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pos/localization/app_localizations.dart';
import 'package:pos/src/model/flavor_enum.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' as math;

const String IS_FIRST_OPEN_KEY = 'isFirstOpen';

Future<bool> readIsFirstOpen() async {
  final mmkv = Hive.box('settings');
  return !(await mmkv.get(IS_FIRST_OPEN_KEY, defaultValue: true));
}

Future setIsFirstOpen(bool value) async {
  final mmkv = Hive.box('settings');
  await mmkv.put(IS_FIRST_OPEN_KEY, !value);
}

Future<DateTime> getLastAimCheckDateTime() async {
  final mmkv = Hive.box('settings');
  final timestamp = await mmkv.get('lastCheckAimDateTime');
  if (timestamp == null) return DateTime.fromMillisecondsSinceEpoch(0);
  return DateTime.fromMillisecondsSinceEpoch(timestamp);
}

Future setAimCheckDateTime(DateTime dateTime) async {
  final mmkv = Hive.box('settings');
  await mmkv.put('lastCheckAimDateTime', dateTime.millisecondsSinceEpoch);
}

Future launchUrl(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

measureDistanceBetween2Points(lat1, lon1, lat2, lon2) {
  var R = 6378.137;
  var dLat = lat2 * math.pi / 180 - lat1 * math.pi / 180;
  var dLon = lon2 * math.pi / 180 - lon1 * math.pi / 180;
  var a = math.sin(dLat / 2) * math.sin(dLat / 2) +
      math.cos(lat1 * math.pi / 180) *
          math.cos(lat2 * math.pi / 180) *
          math.sin(dLon / 2) *
          math.sin(dLon / 2);
  var c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
  var d = R * c;
  return d * 1000; // meters
}

double getRadiusFromBoundingBox(
    List<double> leftTop, List<double> rightBottom) {
  final distance = measureDistanceBetween2Points(
      leftTop[0], leftTop[1], rightBottom[0], leftTop[1]);
  return distance / 2;
}

onWidgetDidBuild(Function callback) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    callback();
  });
}

Future<String> getPublicKey(Flavor flavor) async {
  if (flavor == Flavor.DEVELOPMENT) {
    return await _loadKey('assets/registry_dev.pub');
  }
  return await _loadKey('assets/registry.pub');
}

Future<String> _loadKey(String path) async {
  return await rootBundle.loadString(path);
}

Future<POSUser> getAnonymousUser(PosClient pos) async {
  final anonymous = await pos.getAnonymousPos();
  return POSUser(
    id: '',
    name: 'Anonymous',
    surname: 'User',
    email: '',
    merchants: [
      Merchant(
        id: 'anonymousId',
        access: MerchantAccess.admin,
        posList: [
          PointOfSale(
            id: anonymous.posId,
            name: 'Anonymous POS',
            privateKey: anonymous.posPrivateKey,
            latitude: 0.0,
            longitude: 0.0,
            isActive: true,
          )
        ],
        fiscalCode: '',
        city: '',
        name: 'Anonymous Merchant',
        zipCode: '',
        country: '',
        address: '',
      )
    ],
  );
}

Future<bool> askChoice(BuildContext context, String title) async {
  final res = await Alert(
    context: context,
    title: title,
    buttons: [
      DialogButton(
        child: Text('No'),
        color: Colors.white,
        onPressed:() => Navigator.of(context).pop(false),
      ),
      DialogButton(
        child: Text(AppLocalizations.of(context)?.translate('yes') ?? '-'),
        onPressed: () => Navigator.of(context).pop(true),
      ),
    ],
  ).show();
  return res ?? false;
}
