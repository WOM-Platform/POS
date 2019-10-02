//import 'package:pos/src/model/payment_request.dart';
//import 'package:sqflite/sqflite.dart';
//import 'app_database/app_database.dart';
//
//class PaymentRequestDb {
//  static final PaymentRequestDb _requestDb =
//      new PaymentRequestDb._internal(AppDatabase.get());
//
//  AppDatabase _appDatabase;
//
//  PaymentRequestDb._internal(this._appDatabase);
//
//  static PaymentRequestDb get() {
//    return _requestDb;
//  }
//
//  Future<List<PaymentRequest>> getRequests() async {
//    print("getRequests");
//    var db = await _appDatabase.getDb();
//    try {
////      List<Map> maps = await db.query(
////        PaymentRequest.TABLE,
////        orderBy: "${PaymentRequest.DATE} DESC",
////      );
////    LEFT OUTER JOIN ${Aim.TABLE_NAME} ON ${PaymentRequest.AIM_CODE} = ${Aim.CODE}
//      List<Map> maps = await db.rawQuery(
//          'SELECT * FROM ${PaymentRequest.TABLE} ORDER BY ${PaymentRequest.DATE} DESC');
//      print("requests: ${maps.length}");
//      return maps.map((a) {
//        return PaymentRequest.fromMap(a);
//      }).toList();
//    } catch (e) {
//      print(e.toString());
//      return List<PaymentRequest>();
//    }
//  }
//
//  Future<PaymentRequest> getRequest(int id) async {
//    var db = await _appDatabase.getDb();
//    try {
//      List<Map> maps = await db.query(
//        PaymentRequest.TABLE,
//        columns: null,
//        where: "${PaymentRequest.ID} = ?",
//        whereArgs: [id],
//      );
//      return PaymentRequest.fromMap(maps.first);
//    } catch (e) {
//      print(e.toString());
//      throw Exception("PaymentRequest not find: ${e.toString()}");
//    }
//  }
//
//  insertRequest(PaymentRequest paymentRequest) async {
//    var db = await _appDatabase.getDb();
//    int result;
//    try {
//      await db.transaction((Transaction txn) async {
//        result = await txn.insert(
//          PaymentRequest.TABLE,
//          paymentRequest.toMap(),
//        );
//      });
//      return result;
//    } catch (ex) {
//      print(ex.toString());
//      throw Exception(ex);
//    }
//  }
//
//  updateRequest(PaymentRequest paymentRequest) async {
//    var db = await _appDatabase.getDb();
//    int result;
//    try {
//      await db.transaction((Transaction txn) async {
//        result = await txn.update(
//          PaymentRequest.TABLE,
//          paymentRequest.toMap(),
//          where: "${PaymentRequest.ID} = ?",
//          whereArgs: [paymentRequest.id],
//          conflictAlgorithm: ConflictAlgorithm.replace,
//        );
//      });
//      return result;
//    } catch (ex) {
//      print(ex.toString());
//      throw Exception(ex);
//    }
//  }
//
//  Future<int> deleteRequest(int id) async {
//    var db = await _appDatabase.getDb();
//    return await db.delete(PaymentRequest.TABLE,
//        where: '${PaymentRequest.ID} = ?', whereArgs: [id]);
//  }
//}
