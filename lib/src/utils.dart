import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:pos/src/model/flavor_enum.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import 'package:mmkv_flutter/mmkv_flutter.dart';
import 'dart:math' as math;

const String IS_FIRST_OPEN_KEY = 'isFirstOpen';

String generateGUID() {
  var uuid = new Uuid();
  final guid = uuid.v1buffer(List(16));
  return Base64Encoder().convert(guid);
}

Future<bool> readIsFirstOpen() async {
  final mmkv = await MmkvFlutter.getInstance();
  return !(await mmkv.getBool(IS_FIRST_OPEN_KEY));
}

Future setIsFirstOpen(bool value) async {
  final mmkv = await MmkvFlutter.getInstance();
  await mmkv.setBool(IS_FIRST_OPEN_KEY, !value);
}

Future<DateTime> getLastAimCheckDateTime() async {
  final mmkv = await MmkvFlutter.getInstance();
  final timestamp = await mmkv.getLong('lastCheckAimDateTime');
  if (timestamp == null) return DateTime.fromMillisecondsSinceEpoch(0);
  return DateTime.fromMillisecondsSinceEpoch(timestamp);
}

Future setAimCheckDateTime(DateTime dateTime) async {
  final mmkv = await MmkvFlutter.getInstance();
  await mmkv.setLong('lastCheckAimDateTime', dateTime.millisecondsSinceEpoch);
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

Future<String> getAnonymousPrivateKey() async {
  return await _loadKey('assets/anonymous.pem');
}

Future<String> _loadKey(String path) async {
  return await rootBundle.loadString(path);
}
