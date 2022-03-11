import 'dart:convert';

import 'package:dart_wom_connector/dart_wom_connector.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class AuthLocalDataSources {
  Future<void> persistToken(POSUser user, String email, String password);
  Future<User> readUser();
  Future<bool> hasToken();
  Future<void> deleteToken();
}

class AuthLocalDataSourcesImpl implements AuthLocalDataSources {
  final secureStorage = FlutterSecureStorage();

  @override
  Future<void> deleteToken() async {
    final mmkv = Hive.box('settings');
    await mmkv.clear();
    await secureStorage.delete(key: 'actors');
  }

  @override
  Future<bool> hasToken() async {
    final mmkv = Hive.box('settings');
    final name = await mmkv.get(User.dbName);
    final surname = await mmkv.get(User.dbSurname);
    return name != null && surname != null;
  }

  @override
  Future<void> persistToken(POSUser user, String email, String password) async {
    // final mmkv = Hive.box('settings');
    // await mmkv.put(User.dbName, user.name);
    // await mmkv.put(User.dbSurname, user.surname);
    // await mmkv.put(User.dbEmail, user.email);

    // final array = user.merchants.map((merchant) => merchant.toMap()).toList();

    // final jsonArray = json.encode(array);
    // await secureStorage.write(key: 'actors', value: jsonArray);
    await secureStorage.write(key: 'email', value: email);
    await secureStorage.write(key: 'password', value: password);
    // await mmkv.put('lastLogin', DateTime.now().millisecondsSinceEpoch);
  }

  @override
  Future<User> readUser() async {
    throw UnimplementedError();
  }
}
