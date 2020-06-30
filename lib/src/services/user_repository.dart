import 'dart:convert';
import 'package:dart_wom_connector/dart_wom_connector.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mmkv_flutter/mmkv_flutter.dart';
import 'package:pos/src/services/auth_local_data_sources.dart';

class UserRepository {
  final AuthRemoteDataSources authRemoteDataSources;
  final AuthLocalDataSources authLocalDataSources;
  final secureStorage = FlutterSecureStorage();

  UserRepository(this.authRemoteDataSources, this.authLocalDataSources);

  Future<User> authenticate({
    String username,
    String password,
  }) async {
    return authRemoteDataSources.authenticate(
        username: username, password: password);
  }

  Future<void> deleteToken() async {
    final mmkv = await MmkvFlutter.getInstance();
    await mmkv.clear();
    await secureStorage.delete(key: 'actors');
  }

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

  Future<User> readUser() async {
    final mmkv = await MmkvFlutter.getInstance();
    final name = await mmkv.getString(User.dbName);
    final surname = await mmkv.getString(User.dbSurname);
    final email = await mmkv.getString(User.dbEmail);
    if (name == null || surname == null || email == null) {
      return null;
    }

    final lastLogin =
        DateTime.fromMillisecondsSinceEpoch(await mmkv.getLong('lastLogin'));

    if (DateTime.now().difference(lastLogin).inMinutes > 3600) {
      final password = await secureStorage.read(key: 'password');
      if (password == null) return null;
      return authenticate(username: email, password: password);
    }
    return readPosUser(name, surname, email);
  }

  Future<User> readPosUser(String name, String surname, String email) async {
    final actorsJsonArray = await secureStorage.read(key: 'actors');
    final actorsArray = json.decode(actorsJsonArray);
    final merchants = List<Merchant>.from(
        actorsArray.map<Merchant>((m) => Merchant.fromMap(m)));
    return User(
        name: name, surname: surname, email: email, merchants: merchants);
  }

  Future<String> readEmail() async {
    final mmkv = await MmkvFlutter.getInstance();
    final email = await mmkv.getString('email');
    return email;
  }

  Future<bool> hasToken() async {
    final mmkv = await MmkvFlutter.getInstance();
    final name = await mmkv.getString(User.dbName);
    final surname = await mmkv.getString(User.dbSurname);
    return name != null && surname != null;
  }
}
