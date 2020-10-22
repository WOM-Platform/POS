import 'dart:convert';

import 'package:dart_wom_connector/dart_wom_connector.dart';
import 'package:mmkv_flutter/mmkv_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class AuthLocalDataSources {
  Future<void> persistToken(User user, String email, String password);
  Future<User> readUser();
  Future<bool> hasToken();
  Future<void> deleteToken();
}

class AuthLocalDataSourcesImpl implements AuthLocalDataSources {
  final secureStorage = FlutterSecureStorage();

  @override
  Future<void> deleteToken() async {
    final mmkv = await MmkvFlutter.getInstance();
    await mmkv.clear();
    await secureStorage.delete(key: 'actors');
  }

  @override
  Future<bool> hasToken() async {
    final mmkv = await MmkvFlutter.getInstance();
    final name = await mmkv.getString(User.dbName);
    final surname = await mmkv.getString(User.dbSurname);
    return name != null && surname != null;
  }

  @override
  Future<void> persistToken(User user, String email, String password) async {
    final mmkv = await MmkvFlutter.getInstance();
    await mmkv.setString(User.dbName, user.name);
    await mmkv.setString(User.dbSurname, user.surname);
    await mmkv.setString(User.dbEmail, user.email);

    final array = user.merchants.map((merchant) => merchant.toMap()).toList();

    final jsonArray = json.encode(array);
    await secureStorage.write(key: 'actors', value: jsonArray);
    await secureStorage.write(key: 'password', value: password);
    await mmkv.setLong('lastLogin', DateTime.now().millisecondsSinceEpoch);
  }

  @override
  Future<User> readUser() async {
    throw UnimplementedError();
  }
}
