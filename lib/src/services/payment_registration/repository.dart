import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:pos/src/model/payment_request.dart';
import 'package:simple_rsa/simple_rsa.dart';
import 'package:wom_package/wom_package.dart';

import '../../../app.dart';
import '../../constants.dart';

class PaymentRegistrationRepository {
//  HttpHelper _apiProvider;

  PaymentRegistrationRepository() {
//    _apiProvider = HttpHelper();
  }

  Future generateNewPaymentRequest(PaymentRequest paymentRequest) async {
    try {
      final payloadMap = paymentRequest.toPayloadMap();

      print(payloadMap);

      //encode map to json string
      final payloadMapEncoded = json.encode(payloadMap);

//      final privateKeyString1 = await _loadKey('assets/pos.pem');
      final privateKeyString = user.privateKey;
      final String publicKeyString = await getPublicKey();
//      final publicKeyString1 = user.publicKey;

//      assert(publicKeyString == publicKeyString1);
//      assert(privateKeyString == privateKeyString1);

      final encrypted = await encryptString(payloadMapEncoded, publicKeyString);

      final Map<String, dynamic> map = {
        "PosId": paymentRequest.posId,
        "Nonce": paymentRequest.nonce,
        "Payload": encrypted,
      };
      print("generateNewPaymentRequest");
      print(map);

      final responseBody =
          await HttpHelper.genericHttpPost(URL_PAYMENT_REGISTRATION, map);

      //decode response body into json
      final jsonResponse = json.decode(responseBody);

      final decryptedPayload =
          await decryptString(jsonResponse["payload"], privateKeyString);

      //decode decrypted paylod into json
      final Map<String, dynamic> jsonDecrypted = json.decode(decryptedPayload);
      print(jsonDecrypted.toString());
      return RequestVerificationResponse.fromMap(jsonDecrypted);
    } catch (ex) {
      return RequestVerificationResponse(ex.toString());
    }
  }

  Future<bool> verifyPaymentRequest(
      RequestVerificationResponse response) async {
    final Map<String, String> payloadMap = {
      "Otc": response.otc,
    };

    print(payloadMap);

    try {
      final String payloadMapEncoded = json.encode(payloadMap);
      final String publicKeyString = await getPublicKey();
//      final publicKeyString = user.publicKey;
      final String payloadEncrypted =
          await encryptString(payloadMapEncoded, publicKeyString);

      final Map<String, dynamic> map = {
        "Payload": payloadEncrypted,
      };

      return await HttpHelper.genericHttpPost(URL_PAYMENT_VERIFICATION, map) !=
          null;
    } catch (ex) {
      print(ex.toString());
      return false;
    }
  }

  Future<String> _loadKey(String path) async {
    return await rootBundle.loadString(path);
  }

  Future<String> getPublicKey() async {
    if (Config.appFlavor == Flavor.DEVELOPMENT) {
      return await _loadKey('assets/registry_dev.pub');
    }
    return await _loadKey('assets/registry.pub');
  }
}
