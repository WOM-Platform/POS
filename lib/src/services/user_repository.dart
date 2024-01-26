import 'dart:io';
import 'package:dart_wom_connector/dart_wom_connector.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pos/src/offers/application/offers.dart';

import 'package:pos/src/services/auth_local_data_sources.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository(ref.watch(getPosProvider), AuthLocalDataSourcesImpl());
});

class UserRepository {
  final PosClient pos;
  final AuthLocalDataSources authLocalDataSources;
  final secureStorage = FlutterSecureStorage();

  UserRepository(this.pos, this.authLocalDataSources);

  Future<AuthResponse> authenticate({
    required String username,
    required String password,
  }) async {
    final authResponse = await pos.authenticate(
      username,
      password,
      '${Platform.localeName}Pos/1',
    );
    return authResponse;
  }

  Future<POSUser> getUser(String token) async {
    final user = await pos.getUser(token);
    return user;
  }

  Future<String?> getToken() async {
    final email = await secureStorage.read(key: 'token');
    return email;
  }

  Future<String?> getSavedEmail() async {
    final email = await secureStorage.read(key: 'email');
    return email;
  }

  // Future<String?> getSavedPassword() async {
  //   final email = await secureStorage.read(key: 'password');
  //   return email;
  // }

  Future<void> deleteToken() async {
    final box = Hive.box('settings');
    await box.clear();
    await secureStorage.delete(key: 'token');
  }

  // Future<void> persistToken(POSUser user, String email, String password) async {
  //   await secureStorage.write(key: 'email', value: email);
  //   await secureStorage.write(key: 'password', value: password);
  // }

  Future<void> persistJWTToken(String token) async {
    await secureStorage.write(key: 'token', value: token);
  }

  Future<void> sendEmailVerification(String email) async {
    await pos.sendVerificationEmail(email);
  }

  /* Future<POSUser?> readUser() async {
    final mmkv = Hive.box('settings');
    final name = await mmkv.get(User.dbName);
    final surname = await mmkv.get(User.dbSurname);
    final email = await mmkv.get(User.dbEmail);
    if (name == null || surname == null || email == null) {
      return null;
    }

    final lastLogin =
        DateTime.fromMillisecondsSinceEpoch(await mmkv.get('lastLogin'));

    if (DateTime.now().difference(lastLogin).inMinutes > 3600) {
      final password = await secureStorage.read(key: 'password');
      if (password == null) return null;
      return authenticate(username: email, password: password);
    }
    return readPosUser(name, surname, email);
  }*/

  // Future<POSUser?> autoLogin() async {
  //   final token = await secureStorage.read(key: 'token');
  //   if (token == null) {
  //     return null;
  //   }
  //   if (JwtDecoder.isExpired(token)) {
  //     return null;
  //   }
  //   return pos.authenticateV2(token);
  // }

  Future<void> saveMerchantAndPosIdUsed(String posId, String merchantId) async {
    final mmkv = Hive.box('settings');
    await mmkv.put('lastPosId', posId);
    await mmkv.put('lastMerchantId', merchantId);
  }

  Future<List<String>?> readLastMerchantIdAndPosIdUsed() async {
    print('readLastMerchantIdAndPosIdUsed');
    final mmkv = Hive.box('settings');
    final merchantId = await mmkv.get('lastMerchantId');
    final posId = await mmkv.get('lastPosId');
    if (merchantId == null || posId == null) {
      return null;
    }
    print(merchantId);
    print(posId);
    return [merchantId, posId];
  }

/*  Future<POSUser> readPosUser(String name, String surname, String email) async {
    final actorsJsonArray = await secureStorage.read(key: 'actors');
    final actorsArray = json.decode(actorsJsonArray ?? '[]');
    final merchants = List<Merchant>.from(
        actorsArray.map<Merchant>((m) => Merchant.fromJson(m)));
    return POSUser(
        name: name, surname: surname, email: email, merchants: merchants);
  }*/

// Future<bool> hasToken() async {
//   final box = Hive.box('settings');
//   final name = await box.get(User.dbName);
//   final surname = await box.get(User.dbSurname);
//   return name != null && surname != null;
// }
}
