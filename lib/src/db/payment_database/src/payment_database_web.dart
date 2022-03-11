import 'dart:html';
import 'package:pos/src/model/payment_request.dart';

import '../../../my_logger.dart';
import 'payment_database_base.dart';

class PaymentDatabase extends PaymentDatabaseBase {
  static late PaymentDatabase _instance;

//  static Future<PaymentDatabase> get get async {
//    if (_instance == null) {
//      _instance = PaymentDatabase();
//    }
//    return _instance;
//  }

  static PaymentDatabase get() {
    if (_instance == null) {
      _instance = PaymentDatabase();
    }
    return _instance;
  }

  Future getDb() async {
    return null;
  }

  Future<List<PaymentRequest>> getRequests() async {
    logger.i("getRequests_web");
    return [];
  }

  Future<PaymentRequest> getRequest(int id) async {
    throw Exception("getRequest for Web not implemented");
  }

  insertRequest(PaymentRequest paymentRequest) async {
    throw Exception("insertRequest for Web not implemented");
  }

  updateRequest(PaymentRequest paymentRequest) async {
    throw Exception("updateRequest for Web not implemented");
  }

  Future<int> deleteRequest(int id) async {
    throw Exception("deleteRequest for Web not implemented");
  }
}
