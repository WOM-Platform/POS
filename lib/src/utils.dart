import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'package:mmkv_flutter/mmkv_flutter.dart';

const String IS_FIRST_OPEN_KEY = 'isFirstOpen';
const String lorem =
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod "
    "tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim "
    "veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea "
    "commodo consequat. Duis aute irure dolor in reprehenderit in voluptate "
    "velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat "
    "cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id "
    "est laborum.";

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
  mmkv.setBool(IS_FIRST_OPEN_KEY, !value);
}
